From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch removed
 from -mm tree
Date: Thu, 17 Sep 2015 14:03:53 -0700
Message-ID: <55fb2ab9.Yr8JNFQZXBf/MWSt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbIQVDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mhocko@kernel.org, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5.patch

This patch was dropped because it was folded into mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5

v4 -> v5:
- add (struct hugetlb_usage *) to struct mm_struct
- use %lu instead of %d for seq_printf()
- introduce hugetlb_fork

Cc: Joern Engel <joern@logfs.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 fs/hugetlbfs/inode.c               |   12 ++++++++++++
 include/linux/hugetlb.h            |   22 +++++++++++++++++++---
 include/linux/mm_types.h           |    7 ++-----
 kernel/fork.c                      |    3 +++
 mm/hugetlb.c                       |   25 ++++++++++++++++++++++---
 mm/mmap.c                          |    1 +
 7 files changed, 60 insertions(+), 12 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
+++ a/Documentation/filesystems/proc.txt
@@ -174,7 +174,7 @@ read the file /proc/PID/status:
   VmLib:      1412 kB
   VmPTE:        20 kb
   VmSwap:        0 kB
-  HugetlbPages:          0 kB (0x2048kB)
+  HugetlbPages:          0 kB (0*2048kB)
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
diff -puN fs/hugetlbfs/inode.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
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
diff -puN include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
+++ a/include/linux/hugetlb.h
@@ -483,18 +483,25 @@ static inline spinlock_t *huge_pte_lockp
 #define hugepages_supported() (HPAGE_SHIFT != 0)
 #endif
 
+struct hugetlb_usage {
+	atomic_long_t count[HUGE_MAX_HSTATE];
+};
+
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm);
+void exit_hugetlb_mmap(struct mm_struct *mm);
+int hugetlb_fork(struct mm_struct *new, struct mm_struct *old);
 
 static inline void inc_hugetlb_count(struct mm_struct *mm, struct hstate *h)
 {
-	atomic_long_inc(&mm->hugetlb_usage.count[hstate_index(h)]);
+	VM_BUG_ON_MM(!mm->hugetlb_usage, mm);
+	atomic_long_inc(&mm->hugetlb_usage->count[hstate_index(h)]);
 }
 
 static inline void dec_hugetlb_count(struct mm_struct *mm, struct hstate *h)
 {
-	atomic_long_dec(&mm->hugetlb_usage.count[hstate_index(h)]);
+	VM_BUG_ON_MM(!mm->hugetlb_usage, mm);
+	atomic_long_dec(&mm->hugetlb_usage->count[hstate_index(h)]);
 }
-
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -536,6 +543,15 @@ static inline void hugetlb_report_usage(
 {
 }
 
+static inline void exit_hugetlb_mmap(struct mm_struct *mm)
+{
+}
+
+static inline int hugetlb_fork(struct mm_struct *new, struct mm_struct *old)
+{
+	return 0;
+}
+
 static inline void dec_hugetlb_count(struct mm_struct *mm, struct hstate *h)
 {
 }
diff -puN include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
+++ a/include/linux/mm_types.h
@@ -367,9 +367,7 @@ struct mm_rss_stat {
 };
 
 #ifdef CONFIG_HUGETLB_PAGE
-struct hugetlb_usage {
-	atomic_long_t count[HUGE_MAX_HSTATE];
-};
+struct hugetlb_usage;
 #endif
 
 struct kioctx_table;
@@ -492,9 +490,8 @@ struct mm_struct {
 	/* address of the bounds directory */
 	void __user *bd_addr;
 #endif
-
 #ifdef CONFIG_HUGETLB_PAGE
-	struct hugetlb_usage hugetlb_usage;
+	struct hugetlb_usage *hugetlb_usage;
 #endif
 };
 
diff -puN kernel/fork.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 kernel/fork.c
--- a/kernel/fork.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
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
diff -puN mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
+++ a/mm/hugetlb.c
@@ -2790,13 +2790,20 @@ void hugetlb_show_meminfo(void)
 				1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
 }
 
+static unsigned long mm_hstate_usage(struct mm_struct *mm, int hs_idx)
+{
+	if (!mm->hugetlb_usage)
+		return 0;
+	return atomic_long_read(&mm->hugetlb_usage->count[hs_idx]);
+}
+
 void hugetlb_report_usage(struct seq_file *m, struct mm_struct *mm)
 {
 	int i;
 	unsigned long total_usage = 0;
 
 	for (i = 0; i < HUGE_MAX_HSTATE; i++) {
-		total_usage += atomic_long_read(&mm->hugetlb_usage.count[i]) *
+		total_usage += mm_hstate_usage(mm, i) *
 			(huge_page_size(&hstates[i]) >> 10);
 	}
 
@@ -2807,13 +2814,25 @@ void hugetlb_report_usage(struct seq_fil
 		if (i > 0)
 			seq_puts(m, " ");
 
-		seq_printf(m, "%ldx%dkB",
-			atomic_long_read(&mm->hugetlb_usage.count[i]),
+		seq_printf(m, "%ld*%lukB", mm_hstate_usage(mm, i),
 			huge_page_size(&hstates[i]) >> 10);
 	}
 	seq_puts(m, ")\n");
 }
 
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
diff -puN mm/mmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5 mm/mmap.c
--- a/mm/mmap.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v5
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
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch

