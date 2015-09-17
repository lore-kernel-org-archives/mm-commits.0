From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch removed
 from -mm tree
Date: Thu, 17 Sep 2015 14:13:21 -0700
Message-ID: <55fb2cf1.4YT9ayDJqmzcsXKb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbIQVNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mhocko@kernel.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status

Currently there's no easy way to get per-process usage of hugetlb pages,
which is inconvenient because userspace applications which use hugetlb
typically want to control their processes on the basis of how much memory
(including hugetlb) they use.  So this patch simply provides easy access
to the info via /proc/PID/status.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Joern Engel <joern@logfs.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    3 +
 fs/hugetlbfs/inode.c               |   12 +++++++
 fs/proc/task_mmu.c                 |    1 
 include/linux/hugetlb.h            |   36 +++++++++++++++++++++
 include/linux/mm_types.h           |    7 ++++
 kernel/fork.c                      |    3 +
 mm/hugetlb.c                       |   46 +++++++++++++++++++++++++++
 mm/mmap.c                          |    1 
 mm/rmap.c                          |    4 +-
 9 files changed, 112 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -174,6 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
+  HugetlbPages:          0 kB (0*2048kB)
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -237,6 +238,8 @@ Table 1-2: Contents of the status files
  VmPTE                       size of page table entries
  VmPMD                       size of second level page tables
  VmSwap                      size of swap usage (the number of referred swapents)
+ HugetlbPages                size of hugetlb memory portions (with additional info
+                             about number of mapped hugepages for each page size)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
diff -puN fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/fs/proc/task_mmu.c
@@ -70,6 +70,7 @@ void task_mem(struct seq_file *m, struct
 		ptes >> 10,
 		pmds >> 10,
 		swap << (PAGE_SHIFT-10));
+	hugetlb_report_usage(m, mm);
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
diff -puN include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/include/linux/hugetlb.h
@@ -483,6 +483,25 @@ static inline spinlock_t *huge_pte_lockp
 #define hugepages_supported() (HPAGE_SHIFT != 0)
 #endif
 
+struct hugetlb_usage {
+	atomic_long_t count[HUGE_MAX_HSTATE];
+};
+
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
+void exit_hugetlb_mmap(struct mm_struct *mm);
+int hugetlb_fork(struct mm_struct *new, struct mm_struct *old);
+
+static inline void inc_hugetlb_count(struct mm_struct *mm, struct hstate *h)
+{
+	VM_BUG_ON_MM(!mm->hugetlb_usage, mm);
+	atomic_long_inc(&mm->hugetlb_usage->count[hstate_index(h)]);
+}
+
+static inline void dec_hugetlb_count(struct mm_struct *mm, struct hstate *h)
+{
+	VM_BUG_ON_MM(!mm->hugetlb_usage, mm);
+	atomic_long_dec(&mm->hugetlb_usage->count[hstate_index(h)]);
+}
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -519,6 +538,23 @@ static inline spinlock_t *huge_pte_lockp
 {
 	return &mm->page_table_lock;
 }
+
+static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
+{
+}
+
+static inline void exit_hugetlb_mmap(struct mm_struct *mm)
+{
+}
+
+static inline int hugetlb_fork(struct mm_struct *new, struct mm_struct *old)
+{
+	return 0;
+}
+
+static inline void dec_hugetlb_count(struct mm_struct *mm, struct hstate *h)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/include/linux/mm_types.h
@@ -366,6 +366,10 @@ struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
 
+#ifdef CONFIG_HUGETLB_PAGE
+struct hugetlb_usage;
+#endif
+
 struct kioctx_table;
 struct mm_struct {
 	struct vm_area_struct *mmap;		/* list of VMAs */
@@ -486,6 +490,9 @@ struct mm_struct {
 	/* address of the bounds directory */
 	void __user *bd_addr;
 #endif
+#ifdef CONFIG_HUGETLB_PAGE
+	struct hugetlb_usage *hugetlb_usage;
+#endif
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/mm/hugetlb.c
@@ -2790,6 +2790,49 @@ void hugetlb_show_meminfo(void)
 				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
+static unsigned long mm_hstate_usage(struct mm_struct *mm, int hs_idx)
+{
+	if (!mm->hugetlb_usage)
+		return 0;
+	return atomic_long_read(&mm->hugetlb_usage->count[hs_idx]);
+}
+
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
+{
+	int i;
+	unsigned long total_usage = 0;
+
+	for (i = 0; i < HUGE_MAX_HSTATE; i++) {
+		total_usage += mm_hstate_usage(mm, i) *
+			(huge_page_size(&hstates[i]) >> 10);
+	}
+
+	seq_printf(m, "HugetlbPages:\t%8lu kB (", total_usage);
+	for (i = 0; i < HUGE_MAX_HSTATE; i++) {
+		if (huge_page_order(&hstates[i]) == 0)
+			break;
+		if (i > 0)
+			seq_puts(m, " ");
+
+		seq_printf(m, "%ld*%lukB", mm_hstate_usage(mm, i),
+			huge_page_size(&hstates[i]) >> 10);
+	}
+	seq_puts(m, ")\n");
+}
+
+int hugetlb_fork(struct mm_struct *new, struct mm_struct *old)
+{
+	if (old->hugetlb_usage) {
+		new->hugetlb_usage = kmalloc(sizeof(struct hugetlb_usage),
+							GFP_KERNEL);
+		if (!new->hugetlb_usage)
+			return -ENOMEM;
+		memcpy(new->hugetlb_usage, old->hugetlb_usage,
+			sizeof(struct hugetlb_usage));
+	}
+	return 0;
+}
+
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
@@ -3025,6 +3068,7 @@ int copy_hugetlb_page_range(struct mm_st
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
+			inc_hugetlb_count(dst, h);
 		}
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -3105,6 +3149,7 @@ again:
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
+		dec_hugetlb_count(mm, h);
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
@@ -3501,6 +3546,7 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
 
+	inc_hugetlb_count(mm, h);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
 		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
diff -puN mm/rmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status mm/rmap.c
--- a/mm/rmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/mm/rmap.c
@@ -1352,7 +1352,9 @@ static int try_to_unmap_one(struct page
 	update_hiwater_rss(mm);
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (!PageHuge(page)) {
+		if (PageHuge(page)) {
+			dec_hugetlb_count(mm, page_hstate(page));
+		} else {
 			if (PageAnon(page))
 				dec_mm_counter(mm, MM_ANONPAGES);
 			else
diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/fs/hugetlbfs/inode.c
@@ -139,6 +139,13 @@ static int hugetlbfs_file_mmap(struct fi
 	if (vma->vm_pgoff & (~huge_page_mask(h) >> PAGE_SHIFT))
 		return -EINVAL;
 
+	if (!vma->vm_mm->hugetlb_usage) {
+		vma->vm_mm->hugetlb_usage = kzalloc(sizeof(struct hugetlb_usage),
+							GFP_KERNEL);
+		if (!vma->vm_mm->hugetlb_usage)
+			return -ENOMEM;
+	}
+
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
 	mutex_lock(&inode->i_mutex);
@@ -162,6 +169,11 @@ out:
 	return ret;
 }
 
+void exit_hugetlb_mmap(struct mm_struct *mm)
+{
+	kfree(mm->hugetlb_usage);
+}
+
 /*
  * Called under down_write(mmap_sem).
  */
diff -puN kernel/fork.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status kernel/fork.c
--- a/kernel/fork.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/kernel/fork.c
@@ -425,6 +425,9 @@ static int dup_mmap(struct mm_struct *mm
 	retval = khugepaged_fork(mm, oldmm);
 	if (retval)
 		goto out;
+	retval = hugetlb_fork(mm, oldmm);
+	if (retval)
+		goto out;
 
 	prev = NULL;
 	for (mpnt = oldmm->mmap; mpnt; mpnt = mpnt->vm_next) {
diff -puN mm/mmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status mm/mmap.c
--- a/mm/mmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/mm/mmap.c
@@ -2857,6 +2857,7 @@ void exit_mmap(struct mm_struct *mm)
 			nr_accounted += vma_pages(vma);
 		vma = remove_vma(vma);
 	}
+	exit_hugetlb_mmap(mm);
 	vm_unacct_memory(nr_accounted);
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-migrate-hugetlb-putback-destination-hugepage-to-active-list.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v6.patch

