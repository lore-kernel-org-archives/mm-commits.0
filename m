From: akpm@linux-foundation.org
Subject: + memcg-fix-swap-accounting.patch added to -mm tree
Date: Fri, 29 May 2009 14:56:27 -0700
Message-ID: <200905292156.n4TLuRne018671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbZE2V5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 17:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: fix swap accounting
has been added to the -mm tree.  Its filename is
     memcg-fix-swap-accounting.patch

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
Subject: memcg: fix swap accounting
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch fixes mis-accounting of swap usage in memcg.

In the current implementation, memcg's swap account is uncharged only when
swap is completely freed.  But there are several cases where swap cannot
be freed cleanly.  For handling that, this patch changes that memcg
uncharges swap account when swap has no references other than cache.

By this, memcg's swap entry accounting can be fully synchronous with the
application's behavior.

This patch also changes memcg's hooks for swap-out.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/memcontrol.c      |   17 ++++++++++++-----
 mm/swapfile.c        |   14 ++++++++++----
 3 files changed, 25 insertions(+), 11 deletions(-)

diff -puN include/linux/swap.h~memcg-fix-swap-accounting include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-swap-accounting
+++ a/include/linux/swap.h
@@ -319,10 +319,11 @@ static inline void disable_swap_token(vo
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
+extern void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout);
 #else
 static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
 {
 }
 #endif
diff -puN mm/memcontrol.c~memcg-fix-swap-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-swap-accounting
+++ a/mm/memcontrol.c
@@ -189,6 +189,7 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
+	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
 	NR_CHARGE_TYPE,
 };
 
@@ -1493,6 +1494,7 @@ __mem_cgroup_uncharge_common(struct page
 
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		if (page_mapped(page))
 			goto unlock_out;
 		break;
@@ -1556,18 +1558,23 @@ void mem_cgroup_uncharge_cache_page(stru
  * called after __delete_from_swap_cache() and drop "page" account.
  * memcg information is recorded to swap_cgroup of "ent"
  */
-void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, int swapout)
 {
 	struct mem_cgroup *memcg;
+	int ctype = MEM_CGROUP_CHARGE_TYPE_SWAPOUT;
+
+	if (!swapout) /* this was a swap cache but the swap is unused ! */
+		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
+
+	memcg = __mem_cgroup_uncharge_common(page, ctype);
 
-	memcg = __mem_cgroup_uncharge_common(page,
-					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
 	/* record memcg information */
-	if (do_swap_account && memcg) {
+	if (do_swap_account && swapout && memcg) {
 		swap_cgroup_record(ent, css_id(&memcg->css));
 		mem_cgroup_get(memcg);
 	}
-	if (memcg)
+	if (swapout && memcg)
 		css_put(&memcg->css);
 }
 #endif
diff -puN mm/swapfile.c~memcg-fix-swap-accounting mm/swapfile.c
--- a/mm/swapfile.c~memcg-fix-swap-accounting
+++ a/mm/swapfile.c
@@ -566,8 +566,9 @@ static int swap_entry_free(struct swap_i
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
-		mem_cgroup_uncharge_swap(ent);
 	}
+	if (!swap_count(count))
+		mem_cgroup_uncharge_swap(ent);
 	return count;
 }
 
@@ -592,12 +593,17 @@ void swap_free(swp_entry_t entry)
 void swapcache_free(swp_entry_t entry, struct page *page)
 {
 	struct swap_info_struct *p;
+	int ret;
 
-	if (page)
-		mem_cgroup_uncharge_swapcache(page, entry);
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, entry, 1);
+		ret = swap_entry_free(p, entry, 1);
+		if (page) {
+			if (ret)
+				mem_cgroup_uncharge_swapcache(page, entry, 1);
+			else
+				mem_cgroup_uncharge_swapcache(page, entry, 0);
+		}
 		spin_unlock(&swap_lock);
 	}
 	return;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
migration-only-migrate_prep-once-per-move_pages.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
mm-add-swap-cache-interface-for-swap-reference.patch
mm-modify-swap_map-and-add-swap_has_cache-flag.patch
mm-reuse-unused-swap-entry-if-necessary.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch

