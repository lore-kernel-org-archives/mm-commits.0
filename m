From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch removed from
 -mm tree
Date: Fri, 13 Sep 2013 13:02:28 -0700
Message-ID: <52336f54.lp2RBU3G0to0H7hX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: [merged] mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch removed from -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:28 -0700


The patch titled
     Subject: mm: memcg: enable memcg OOM killer only for user faults
has been removed from the -mm tree.  Its filename was
     mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: enable memcg OOM killer only for user faults

System calls and kernel faults (uaccess, gup) can handle an out of memory
situation gracefully and just return -ENOMEM.

Enable the memcg OOM killer only for user faults, where it's really the
only option available.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   44 +++++++++++++++++++++++++++++++++++
 include/linux/sched.h      |    3 ++
 mm/filemap.c               |   11 +++++++-
 mm/memcontrol.c            |    2 -
 mm/memory.c                |   40 +++++++++++++++++++++++--------
 5 files changed, 88 insertions(+), 12 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcg-enable-memcg-oom-killer-only-for-user-faults include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-enable-memcg-oom-killer-only-for-user-faults
+++ a/include/linux/memcontrol.h
@@ -151,6 +151,37 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
+/**
+ * mem_cgroup_toggle_oom - toggle the memcg OOM killer for the current task
+ * @new: true to enable, false to disable
+ *
+ * Toggle whether a failed memcg charge should invoke the OOM killer
+ * or just return -ENOMEM.  Returns the previous toggle state.
+ */
+static inline bool mem_cgroup_toggle_oom(bool new)
+{
+	bool old;
+
+	old = current->memcg_oom.may_oom;
+	current->memcg_oom.may_oom = new;
+
+	return old;
+}
+
+static inline void mem_cgroup_enable_oom(void)
+{
+	bool old = mem_cgroup_toggle_oom(true);
+
+	WARN_ON(old == true);
+}
+
+static inline void mem_cgroup_disable_oom(void)
+{
+	bool old = mem_cgroup_toggle_oom(false);
+
+	WARN_ON(old == false);
+}
+
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
 #endif
@@ -383,6 +414,19 @@ static inline void mem_cgroup_end_update
 {
 }
 
+static inline bool mem_cgroup_toggle_oom(bool new)
+{
+	return false;
+}
+
+static inline void mem_cgroup_enable_oom(void)
+{
+}
+
+static inline void mem_cgroup_disable_oom(void)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_page_stat_item idx)
 {
diff -puN include/linux/sched.h~mm-memcg-enable-memcg-oom-killer-only-for-user-faults include/linux/sched.h
--- a/include/linux/sched.h~mm-memcg-enable-memcg-oom-killer-only-for-user-faults
+++ a/include/linux/sched.h
@@ -1393,6 +1393,9 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
+	struct memcg_oom_info {
+		unsigned int may_oom:1;
+	} memcg_oom;
 #endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
diff -puN mm/filemap.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults mm/filemap.c
--- a/mm/filemap.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults
+++ a/mm/filemap.c
@@ -1614,6 +1614,7 @@ int filemap_fault(struct vm_area_struct
 	struct inode *inode = mapping->host;
 	pgoff_t offset = vmf->pgoff;
 	struct page *page;
+	bool memcg_oom;
 	pgoff_t size;
 	int ret = 0;
 
@@ -1622,7 +1623,11 @@ int filemap_fault(struct vm_area_struct
 		return VM_FAULT_SIGBUS;
 
 	/*
-	 * Do we have something in the page cache already?
+	 * Do we have something in the page cache already?  Either
+	 * way, try readahead, but disable the memcg OOM killer for it
+	 * as readahead is optional and no errors are propagated up
+	 * the fault stack.  The OOM killer is enabled while trying to
+	 * instantiate the faulting page individually below.
 	 */
 	page = find_get_page(mapping, offset);
 	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
@@ -1630,10 +1635,14 @@ int filemap_fault(struct vm_area_struct
 		 * We found the page, so try async readahead before
 		 * waiting for the lock.
 		 */
+		memcg_oom = mem_cgroup_toggle_oom(false);
 		do_async_mmap_readahead(vma, ra, file, page, offset);
+		mem_cgroup_toggle_oom(memcg_oom);
 	} else if (!page) {
 		/* No page in the page cache at all */
+		memcg_oom = mem_cgroup_toggle_oom(false);
 		do_sync_mmap_readahead(vma, ra, file, offset);
+		mem_cgroup_toggle_oom(memcg_oom);
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
diff -puN mm/memcontrol.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults
+++ a/mm/memcontrol.c
@@ -2454,7 +2454,7 @@ static int mem_cgroup_do_charge(struct m
 		return CHARGE_RETRY;
 
 	/* If we don't need to call oom-killer at el, return immediately */
-	if (!oom_check)
+	if (!oom_check || !current->memcg_oom.may_oom)
 		return CHARGE_NOMEM;
 	/* check OOM */
 	if (!mem_cgroup_handle_oom(mem_over_limit, gfp_mask, get_order(csize)))
diff -puN mm/memory.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults mm/memory.c
--- a/mm/memory.c~mm-memcg-enable-memcg-oom-killer-only-for-user-faults
+++ a/mm/memory.c
@@ -3754,22 +3754,14 @@ unlock:
 /*
  * By the time we get here, we already hold the mm semaphore
  */
-int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags)
+static int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+			     unsigned long address, unsigned int flags)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	__set_current_state(TASK_RUNNING);
-
-	count_vm_event(PGFAULT);
-	mem_cgroup_count_vm_event(mm, PGFAULT);
-
-	/* do counter updates before entering really critical section. */
-	check_sync_rss_stat(current);
-
 	if (unlikely(is_vm_hugetlb_page(vma)))
 		return hugetlb_fault(mm, vma, address, flags);
 
@@ -3850,6 +3842,34 @@ retry:
 	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
+int handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+		    unsigned long address, unsigned int flags)
+{
+	int ret;
+
+	__set_current_state(TASK_RUNNING);
+
+	count_vm_event(PGFAULT);
+	mem_cgroup_count_vm_event(mm, PGFAULT);
+
+	/* do counter updates before entering really critical section. */
+	check_sync_rss_stat(current);
+
+	/*
+	 * Enable the memcg OOM handling for faults triggered in user
+	 * space.  Kernel faults are handled more gracefully.
+	 */
+	if (flags & FAULT_FLAG_USER)
+		mem_cgroup_enable_oom();
+
+	ret = __handle_mm_fault(mm, vma, address, flags);
+
+	if (flags & FAULT_FLAG_USER)
+		mem_cgroup_disable_oom();
+
+	return ret;
+}
+
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * Allocate page upper directory.
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

