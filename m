From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch removed from -mm tree
Date: Thu, 17 Sep 2015 14:13:16 -0700
Message-ID: <55fb2cec.plqQl9Ws8O00Jzes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbIQVNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, joern@logfs.org, mhocko@suse.cz, mike.kravetz@oracle.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: hugetlb: proc: add hugetlb-related fields to /proc/PID/smaps

Currently /proc/PID/smaps provides no usage info for vma(VM_HUGETLB), which
is inconvenient when we want to know per-task or per-vma base hugetlb usage.
To solve this, this patch adds new fields for hugetlb usage like below:

  Size:              20480 kB
  Rss:                   0 kB
  Pss:                   0 kB
  Shared_Clean:          0 kB
  Shared_Dirty:          0 kB
  Private_Clean:         0 kB
  Private_Dirty:         0 kB
  Referenced:            0 kB
  Anonymous:             0 kB
  AnonHugePages:         0 kB
  Shared_Hugetlb:    18432 kB
  Private_Hugetlb:     2048 kB
  Swap:                  0 kB
  KernelPageSize:     2048 kB
  MMUPageSize:        2048 kB
  Locked:                0 kB
  VmFlags: rd wr mr mw me de ht

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Joern Engel <joern@logfs.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   33 ++++++++++++++++++---------
 fs/proc/task_mmu.c                 |   29 +++++++++++++++++++++++
 2 files changed, 52 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps
+++ a/Documentation/filesystems/proc.txt
@@ -423,6 +423,8 @@ Private_Clean:         0 kB
 Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
+AnonHugePages:         0 kB
+HugetlbPages:          0 kB
 Swap:                  0 kB
 SwapPss:               0 kB
 KernelPageSize:        4 kB
@@ -440,20 +442,31 @@ The "proportional set size" (PSS) of a p
 in memory, where each page is divided by the number of processes sharing it.
 So if a process has 1000 pages all to itself, and 1000 shared with one other
 process, its PSS will be 1500.
+
 Note that even a page which is part of a MAP_SHARED mapping, but has only
-a single pte mapped, i.e.  is currently used by only one process, is accounted
-as private and not as shared.
+a single pte mapped, i.e.  is currently used by only one process, is
+accounted as private and not as shared.
+
 "Referenced" indicates the amount of memory currently marked as referenced or
 accessed.
-"Anonymous" shows the amount of memory that does not belong to any file.  Even
-a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
-and a page is modified, the file page is replaced by a private anonymous copy.
+
+"Anonymous" shows the amount of memory that does not belong to any file.
+Even a mapping associated with a file may contain anonymous pages: when
+MAP_PRIVATE and a page is modified, the file page is replaced by a private
+anonymous copy.
+
+"AnonHugePages" shows the ammount of memory backed by transparent hugepage.
+
+"HugetlbPages" shows the ammount of memory backed by hugetlbfs page (which is
+not counted in "Rss" or "Pss" field for historical reasons.)
+
 "Swap" shows how much would-be-anonymous memory is also used, but out on
-swap.
-"SwapPss" shows proportional swap share of this mapping.
-"VmFlags" field deserves a separate description. This member represents the kernel
-flags associated with the particular virtual memory area in two letter encoded
-manner. The codes are the following:
+swap.  SwapPss" shows proportional swap share of this mapping.
+
+"VmFlags" field deserves a separate description.  This member represents
+the kernel flags associated with the particular virtual memory area in two
+letter encoded manner.  The codes are the following:
+
     rd  - readable
     wr  - writeable
     ex  - executable
diff -puN fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -446,6 +446,7 @@ struct mem_size_stats {
 	unsigned long anonymous;
 	unsigned long anonymous_thp;
 	unsigned long swap;
+	unsigned long hugetlb;
 	u64 pss;
 	u64 swap_pss;
 };
@@ -625,12 +626,38 @@ static void show_smap_vma_flags(struct s
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
+				 unsigned long addr, unsigned long end,
+				 struct mm_walk *walk)
+{
+	struct mem_size_stats *mss = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page = NULL;
+
+	if (pte_present(*pte)) {
+		page = vm_normal_page(vma, addr, *pte);
+	} else if (is_swap_pte(*pte)) {
+		swp_entry_t swpent = pte_to_swp_entry(*pte);
+
+		if (is_migration_entry(swpent))
+			page = migration_entry_to_page(swpent);
+	}
+	if (page)
+		mss->hugetlb += huge_page_size(hstate_vma(vma));
+	return 0;
+}
+#endif /* HUGETLB_PAGE */
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss;
 	struct mm_walk smaps_walk = {
 		.pmd_entry = smaps_pte_range,
+#ifdef CONFIG_HUGETLB_PAGE
+		.hugetlb_entry = smaps_hugetlb_range,
+#endif
 		.mm = vma->vm_mm,
 		.private = &mss,
 	};
@@ -652,6 +679,7 @@ static int show_smap(struct seq_file *m,
 		   "Referenced:     %8lu kB\n"
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
+		   "HugetlbPages:   %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
@@ -667,6 +695,7 @@ static int show_smap(struct seq_file *m,
 		   mss.referenced >> 10,
 		   mss.anonymous >> 10,
 		   mss.anonymous_thp >> 10,
+		   mss.hugetlb >> 10,
 		   mss.swap >> 10,
 		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
 		   vma_kernel_pagesize(vma) >> 10,
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-migrate-hugetlb-putback-destination-hugepage-to-active-list.patch
mm-hugetlb-proc-add-hugetlb-related-fields-to-proc-pid-smaps-v6.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status.patch
mm-hugetlb-proc-add-hugetlbpages-field-to-proc-pid-status-v6.patch

