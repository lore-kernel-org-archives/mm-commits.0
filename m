From: akpm@linux-foundation.org
Subject: + memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock.patch added to -mm tree
Date: Wed, 13 May 2009 11:56:31 -0700
Message-ID: <200905131856.n4DIuVe4002749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757985AbZEMS72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: fix deadlock between lock_page_cgroup and mapping tree_lock
has been added to the -mm tree.  Its filename is
     memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix deadlock between lock_page_cgroup and mapping tree_lock
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mapping->tree_lock can be acquired from interrupt context.  Then,
following dead lock can occur.

Assume "A" as a page.

 CPU0:
       lock_page_cgroup(A)
		interrupted
			-> take mapping->tree_lock.
 CPU1:
       take mapping->tree_lock
		-> lock_page_cgroup(A)

This patch tries to fix above deadlock by moving memcg's hook to out of
mapping->tree_lock.  charge/uncharge of pagecache/swapcache is protected
by page lock, not tree_lock.

After this patch, lock_page_cgroup() is not called under mapping->tree_lock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++++
 mm/filemap.c         |    6 +++---
 mm/memcontrol.c      |    4 +++-
 mm/swap_state.c      |    4 +---
 mm/truncate.c        |    1 +
 mm/vmscan.c          |    2 ++
 6 files changed, 15 insertions(+), 7 deletions(-)

diff -puN include/linux/swap.h~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/include/linux/swap.h
@@ -437,6 +437,11 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
+static inline void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+{
+}
+
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff -puN mm/filemap.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock mm/filemap.c
--- a/mm/filemap.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/mm/filemap.c
@@ -121,7 +121,6 @@ void __remove_from_page_cache(struct pag
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
-	mem_cgroup_uncharge_cache_page(page);
 
 	/*
 	 * Some filesystems seem to re-dirty the page even after
@@ -145,6 +144,7 @@ void remove_from_page_cache(struct page 
 	spin_lock_irq(&mapping->tree_lock);
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
 }
 
 static int sync_page(void *word)
@@ -476,13 +476,13 @@ int add_to_page_cache_locked(struct page
 		if (likely(!error)) {
 			mapping->nrpages++;
 			__inc_zone_page_state(page, NR_FILE_PAGES);
+			spin_unlock_irq(&mapping->tree_lock);
 		} else {
 			page->mapping = NULL;
+			spin_unlock_irq(&mapping->tree_lock);
 			mem_cgroup_uncharge_cache_page(page);
 			page_cache_release(page);
 		}
-
-		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
 	} else
 		mem_cgroup_uncharge_cache_page(page);
diff -puN mm/memcontrol.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/mm/memcontrol.c
@@ -1488,8 +1488,9 @@ void mem_cgroup_uncharge_cache_page(stru
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 
+#ifdef CONFIG_SWAP
 /*
- * called from __delete_from_swap_cache() and drop "page" account.
+ * called after __delete_from_swap_cache() and drop "page" account.
  * memcg information is recorded to swap_cgroup of "ent"
  */
 void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
@@ -1506,6 +1507,7 @@ void mem_cgroup_uncharge_swapcache(struc
 	if (memcg)
 		css_put(&memcg->css);
 }
+#endif
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /*
diff -puN mm/swap_state.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock mm/swap_state.c
--- a/mm/swap_state.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/mm/swap_state.c
@@ -109,8 +109,6 @@ int add_to_swap_cache(struct page *page,
  */
 void __delete_from_swap_cache(struct page *page)
 {
-	swp_entry_t ent = {.val = page_private(page)};
-
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageSwapCache(page));
 	VM_BUG_ON(PageWriteback(page));
@@ -121,7 +119,6 @@ void __delete_from_swap_cache(struct pag
 	total_swapcache_pages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
-	mem_cgroup_uncharge_swapcache(page, ent);
 }
 
 /**
@@ -191,6 +188,7 @@ void delete_from_swap_cache(struct page 
 	__delete_from_swap_cache(page);
 	spin_unlock_irq(&swapper_space.tree_lock);
 
+	mem_cgroup_uncharge_swapcache(page, entry);
 	swap_free(entry);
 	page_cache_release(page);
 }
diff -puN mm/truncate.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock mm/truncate.c
--- a/mm/truncate.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/mm/truncate.c
@@ -359,6 +359,7 @@ invalidate_complete_page2(struct address
 	BUG_ON(page_has_private(page));
 	__remove_from_page_cache(page);
 	spin_unlock_irq(&mapping->tree_lock);
+	mem_cgroup_uncharge_cache_page(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
 failed:
diff -puN mm/vmscan.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock
+++ a/mm/vmscan.c
@@ -470,10 +470,12 @@ static int __remove_mapping(struct addre
 		swp_entry_t swap = { .val = page_private(page) };
 		__delete_from_swap_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		mem_cgroup_uncharge_swapcache(page, swap);
 		swap_free(swap);
 	} else {
 		__remove_from_page_cache(page);
 		spin_unlock_irq(&mapping->tree_lock);
+		mem_cgroup_uncharge_cache_page(page);
 	}
 
 	return 1;
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-deadlock-between-lock_page_cgroup-and-mapping-tree_lock.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch

