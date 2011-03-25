From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:26 -0700
Message-ID: <201103250724.p2P7OKkr025851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933644Ab1CYHYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix ugly initialization of return value is in caller
has been removed from the -mm tree.  Its filename was
     memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix ugly initialization of return value is in caller
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Remove initialization of vaiable in caller of memory cgroup function. 
Actually, it's return value of memcg function but it's initialized in
caller.

Some memory cgroup uses following style to bring the result of start
function to the end function for avoiding races.

   mem_cgroup_start_A(&(*ptr))
   /* Something very complicated can happen here. */
   mem_cgroup_end_A(*ptr)

In some calls, *ptr should be initialized to NULL be caller.  But it's
ugly.  This patch fixes that *ptr is initialized by _start function.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 mm/memory.c     |    2 +-
 mm/migrate.c    |    2 +-
 mm/swapfile.c   |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller
+++ a/mm/memcontrol.c
@@ -2475,7 +2475,7 @@ int mem_cgroup_cache_charge(struct page 
 
 	/* shmem */
 	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem = NULL;
+		struct mem_cgroup *mem;
 
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
 		if (!ret)
@@ -2501,6 +2501,8 @@ int mem_cgroup_try_charge_swapin(struct 
 	struct mem_cgroup *mem;
 	int ret;
 
+	*ptr = NULL;
+
 	if (mem_cgroup_disabled())
 		return 0;
 
@@ -2916,6 +2918,8 @@ int mem_cgroup_prepare_migration(struct 
 	enum charge_type ctype;
 	int ret = 0;
 
+	*ptr = NULL;
+
 	VM_BUG_ON(PageTransHuge(page));
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3058,7 +3062,7 @@ int mem_cgroup_shmem_charge_fallback(str
 			    struct mm_struct *mm,
 			    gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	int ret;
 
 	if (mem_cgroup_disabled())
diff -puN mm/memory.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller mm/memory.c
--- a/mm/memory.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller
+++ a/mm/memory.c
@@ -2767,7 +2767,7 @@ static int do_swap_page(struct mm_struct
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	int exclusive = 0;
 	int ret = 0;
 
diff -puN mm/migrate.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller mm/migrate.c
--- a/mm/migrate.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller
+++ a/mm/migrate.c
@@ -633,7 +633,7 @@ static int unmap_and_move(new_page_t get
 	struct page *newpage = get_new_page(page, private, &result);
 	int remap_swapcache = 1;
 	int charge = 0;
-	struct mem_cgroup *mem = NULL;
+	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
 	if (!newpage)
diff -puN mm/swapfile.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller mm/swapfile.c
--- a/mm/swapfile.c~memcg-fix-ugly-initialization-of-return-value-is-in-caller
+++ a/mm/swapfile.c
@@ -880,7 +880,7 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	struct mem_cgroup *ptr = NULL;
+	struct mem_cgroup *ptr;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

