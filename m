From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-swap-accounting.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:05 -0700
Message-ID: <200906182246.n5IMk5aK005107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759031AbZFRWrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamot


The patch titled
     memcg: fix swap accounting
has been removed from the -mm tree.  Its filename was
     memcg-fix-swap-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/memcontrol.c      |   17 ++++++++++++-----
 mm/swapfile.c        |   16 ++++++++++++----
 3 files changed, 27 insertions(+), 11 deletions(-)

diff -puN include/linux/swap.h~memcg-fix-swap-accounting include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-swap-accounting
+++ a/include/linux/swap.h
@@ -319,10 +319,11 @@ static inline void disable_swap_token(vo
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
+extern void
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
 #else
 static inline void
-mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
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
+mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
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
@@ -583,8 +583,9 @@ static int swap_entry_free(struct swap_i
 			swap_list.next = p - swap_info;
 		nr_swap_pages++;
 		p->inuse_pages--;
-		mem_cgroup_uncharge_swap(ent);
 	}
+	if (!swap_count(count))
+		mem_cgroup_uncharge_swap(ent);
 	return count;
 }
 
@@ -609,12 +610,19 @@ void swap_free(swp_entry_t entry)
 void swapcache_free(swp_entry_t entry, struct page *page)
 {
 	struct swap_info_struct *p;
+	int ret;
 
-	if (page)
-		mem_cgroup_uncharge_swapcache(page, entry);
 	p = swap_info_get(entry);
 	if (p) {
-		swap_entry_free(p, entry, SWAP_CACHE);
+		ret = swap_entry_free(p, entry, SWAP_CACHE);
+		if (page) {
+			bool swapout;
+			if (ret)
+				swapout = true; /* the end of swap out */
+			else
+				swapout = false; /* no more swap users! */
+			mem_cgroup_uncharge_swapcache(page, entry, swapout);
+		}
 		spin_unlock(&swap_lock);
 	}
 	return;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

