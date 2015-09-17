From: akpm@linux-foundation.org
Subject: + mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch added to -mm tree
Date: Thu, 17 Sep 2015 14:19:45 -0700
Message-ID: <55fb2e71.NwyUPElZEwmteQwW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50253 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbIQVTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mhocko@suse.cz, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: add HugetlbPages field to /proc/PID/status
has been added to the -mm tree.  Its filename is
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/task_mmu.c                 |    1 +
 include/linux/hugetlb.h            |   19 +++++++++++++++++++
 include/linux/mm_types.h           |    3 +++
 mm/hugetlb.c                       |    9 +++++++++
 mm/rmap.c                          |    4 +++-
 6 files changed, 37 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/Documentation/filesystems/proc.txt
@@ -174,6 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
+  HugetlbPages:          0 kB
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -237,6 +238,7 @@ Table 1-2: Contents of the status files
  VmPTE                       size of page table entries
  VmPMD                       size of second level page tables
  VmSwap                      size of swap usage (the number of referred swapents)
+ HugetlbPages                size of hugetlb memory portions
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
@@ -483,6 +483,17 @@ static inline spinlock_t *huge_pte_lockp
 #define hugepages_supported() (HPAGE_SHIFT != 0)
 #endif
 
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
+
+static inline void hugetlb_count_add(long l, struct mm_struct *mm)
+{
+	atomic_long_add(l, &mm->hugetlb_usage);
+}
+
+static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
+{
+	atomic_long_sub(l, &mm->hugetlb_usage);
+}
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -519,6 +530,14 @@ static inline spinlock_t *huge_pte_lockp
 {
 	return &mm->page_table_lock;
 }
+
+static inline void hugetlb_report_usage(struct seq_file *f, struct mm_struct *m)
+{
+}
+
+static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/include/linux/mm_types.h
@@ -486,6 +486,9 @@ struct mm_struct {
 	/* address of the bounds directory */
 	void __user *bd_addr;
 #endif
+#ifdef CONFIG_HUGETLB_PAGE
+	atomic_long_t hugetlb_usage;
+#endif
 };
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status
+++ a/mm/hugetlb.c
@@ -2790,6 +2790,12 @@ void hugetlb_show_meminfo(void)
 				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
+void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
+{
+	seq_printf(m, "HugetlbPages:\t%8lu kB\n",
+		   atomic_long_read(&mm->hugetlb_usage) << (PAGE_SHIFT - 10));
+}
+
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
@@ -3025,6 +3031,7 @@ int copy_hugetlb_page_range(struct mm_st
 			get_page(ptepage);
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
+			hugetlb_count_add(pages_per_huge_page(h), dst);
 		}
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -3105,6 +3112,7 @@ again:
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
 
+		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
 		if (force_flush) {
@@ -3501,6 +3509,7 @@ retry:
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
 
+	hugetlb_count_add(pages_per_huge_page(h), mm);
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
+			hugetlb_count_sub(1 << compound_order(page), mm);
+		} else {
 			if (PageAnon(page))
 				dec_mm_counter(mm, MM_ANONPAGES);
 			else
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-migrate-hugetlb-putback-destination-hugepage-to-active-list.patch
mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

