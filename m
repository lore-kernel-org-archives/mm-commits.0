From: akpm@linux-foundation.org
Subject: - memcg-bad-page-if-page_cgroup-when-free.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:20 -0800
Message-ID: <200803050745.m257jKhH021586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759562AbYCEHqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: bad page if page_cgroup when free
has been removed from the -mm tree.  Its filename was
     memcg-bad-page-if-page_cgroup-when-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: bad page if page_cgroup when free
From: Hugh Dickins <hugh@veritas.com>

Replace free_hot_cold_page's VM_BUG_ON(page_get_page_cgroup(page)) by a "Bad
page state" and clear: most users don't have CONFIG_DEBUG_VM on, and if it
were set here, it'd likely cause corruption when the page is reused.

Don't use page_assign_page_cgroup to clear it: that should be private to
memcontrol.c, and always called with the lock taken; and memmap_init_zone
doesn't need it either - like page->mapping and other pointers throughout the
kernel, Linux assumes pointers in zeroed structures are NULL pointers.

Instead use page_reset_bad_cgroup, added to memcontrol.h for this only.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/memcontrol.c            |   27 ++++++++++++---------------
 mm/page_alloc.c            |   18 ++++++++++++------
 3 files changed, 28 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-bad-page-if-page_cgroup-when-free include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-bad-page-if-page_cgroup-when-free
+++ a/include/linux/memcontrol.h
@@ -29,8 +29,9 @@ struct mm_struct;
 
 extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
 extern void mm_free_cgroup(struct mm_struct *mm);
-extern void page_assign_page_cgroup(struct page *page,
-					struct page_cgroup *pc);
+
+#define page_reset_bad_cgroup(page)	((page)->page_cgroup = 0)
+
 extern struct page_cgroup *page_get_page_cgroup(struct page *page);
 extern int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
@@ -82,8 +83,7 @@ static inline void mm_free_cgroup(struct
 {
 }
 
-static inline void page_assign_page_cgroup(struct page *page,
-						struct page_cgroup *pc)
+static inline void page_reset_bad_cgroup(struct page *page)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-bad-page-if-page_cgroup-when-free mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-bad-page-if-page_cgroup-when-free
+++ a/mm/memcontrol.c
@@ -140,11 +140,17 @@ struct mem_cgroup {
 
 /*
  * We use the lower bit of the page->page_cgroup pointer as a bit spin
- * lock. We need to ensure that page->page_cgroup is atleast two
- * byte aligned (based on comments from Nick Piggin)
+ * lock.  We need to ensure that page->page_cgroup is at least two
+ * byte aligned (based on comments from Nick Piggin).  But since
+ * bit_spin_lock doesn't actually set that lock bit in a non-debug
+ * uniprocessor kernel, we should avoid setting it here too.
  */
 #define PAGE_CGROUP_LOCK_BIT 	0x0
-#define PAGE_CGROUP_LOCK 		(1 << PAGE_CGROUP_LOCK_BIT)
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+#define PAGE_CGROUP_LOCK 	(1 << PAGE_CGROUP_LOCK_BIT)
+#else
+#define PAGE_CGROUP_LOCK	0x0
+#endif
 
 /*
  * A page_cgroup page is associated with every page descriptor. The
@@ -271,19 +277,10 @@ static inline int page_cgroup_locked(str
 					&page->page_cgroup);
 }
 
-void page_assign_page_cgroup(struct page *page, struct page_cgroup *pc)
+static void page_assign_page_cgroup(struct page *page, struct page_cgroup *pc)
 {
-	int locked;
-
-	/*
-	 * While resetting the page_cgroup we might not hold the
-	 * page_cgroup lock. free_hot_cold_page() is an example
-	 * of such a scenario
-	 */
-	if (pc)
-		VM_BUG_ON(!page_cgroup_locked(page));
-	locked = (page->page_cgroup & PAGE_CGROUP_LOCK);
-	page->page_cgroup = ((unsigned long)pc | locked);
+	VM_BUG_ON(!page_cgroup_locked(page));
+	page->page_cgroup = ((unsigned long)pc | PAGE_CGROUP_LOCK);
 }
 
 struct page_cgroup *page_get_page_cgroup(struct page *page)
diff -puN mm/page_alloc.c~memcg-bad-page-if-page_cgroup-when-free mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-bad-page-if-page_cgroup-when-free
+++ a/mm/page_alloc.c
@@ -222,13 +222,19 @@ static inline int bad_range(struct zone 
 
 static void bad_page(struct page *page)
 {
-	printk(KERN_EMERG "Bad page state in process '%s'\n"
-		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
-		KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
-		KERN_EMERG "Backtrace:\n",
+	void *pc = page_get_page_cgroup(page);
+
+	printk(KERN_EMERG "Bad page state in process '%s'\n" KERN_EMERG
+		"page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
 		current->comm, page, (int)(2*sizeof(unsigned long)),
 		(unsigned long)page->flags, page->mapping,
 		page_mapcount(page), page_count(page));
+	if (pc) {
+		printk(KERN_EMERG "cgroup:%p\n", pc);
+		page_reset_bad_cgroup(page);
+	}
+	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
+		KERN_EMERG "Backtrace:\n");
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
@@ -454,6 +460,7 @@ static inline int free_pages_check(struc
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
+		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
 		(page->flags & (
 			1 << PG_lru	|
@@ -603,6 +610,7 @@ static int prep_new_page(struct page *pa
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
+		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
 		(page->flags & (
 			1 << PG_lru	|
@@ -989,7 +997,6 @@ static void free_hot_cold_page(struct pa
 
 	if (!PageHighMem(page))
 		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
-	VM_BUG_ON(page_get_page_cgroup(page));
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
@@ -2528,7 +2535,6 @@ void __meminit memmap_init_zone(unsigned
 		set_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		reset_page_mapcount(page);
-		page_assign_page_cgroup(page, NULL);
 		SetPageReserved(page);
 
 		/*
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

