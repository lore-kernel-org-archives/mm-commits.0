From: akpm@linux-foundation.org
Subject: + pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:00 -0800
Message-ID: <20120210002801.3DA9AA0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40787 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2BJA2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:07 -0500
Received: by yenm1 with SMTP id m1so258292yen.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, ak@linux.intel.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: pagemap: avoid splitting thp when reading /proc/pid/pagemap
has been added to the -mm tree.  Its filename is
     pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch

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
Subject: pagemap: avoid splitting thp when reading /proc/pid/pagemap

Thp split is not necessary if we explicitly check whether pmds are mapping
thps or not.  This patch introduces this check and adds code to generate
pagemap entries for pmds mapping thps, which results in less performance
impact of pagemap on thp.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   53 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 6 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap
+++ a/fs/proc/task_mmu.c
@@ -603,6 +603,9 @@ struct pagemapread {
 	u64 *buffer;
 };
 
+#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
+#define PAGEMAP_WALK_MASK	(PMD_MASK)
+
 #define PM_ENTRY_BYTES      sizeof(u64)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
@@ -661,6 +664,27 @@ static u64 pte_to_pagemap_entry(pte_t pt
 	return pme;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static u64 thp_pmd_to_pagemap_entry(pmd_t pmd, int offset)
+{
+	u64 pme = 0;
+	/*
+	 * Currently pmd for thp is always present because thp can not be
+	 * swapped-out, migrated, or HWPOISONed (split in such cases instead.)
+	 * This if-check is just to prepare for future implementation.
+	 */
+	if (pmd_present(pmd))
+		pme = PM_PFRAME(pmd_pfn(pmd) + offset)
+			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
+	return pme;
+}
+#else
+static inline u64 thp_pmd_to_pagemap_entry(pmd_t pmd, int offset)
+{
+	return 0;
+}
+#endif
+
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
@@ -668,14 +692,33 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
-
-	split_huge_page_pmd(walk->mm, pmd);
+	u64 pfn = PM_NOT_PRESENT;
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
-	for (; addr != end; addr += PAGE_SIZE) {
-		u64 pfn = PM_NOT_PRESENT;
 
+	spin_lock(&walk->mm->page_table_lock);
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			for (; addr != end; addr += PAGE_SIZE) {
+				unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
+					>> PAGE_SHIFT;
+				pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
+				err = add_to_pagemap(addr, pfn, pm);
+				if (err)
+					break;
+			}
+			spin_unlock(&walk->mm->page_table_lock);
+			return err;
+		}
+	} else {
+		spin_unlock(&walk->mm->page_table_lock);
+	}
+
+	for (; addr != end; addr += PAGE_SIZE) {
 		/* check to see if we've left 'vma' behind
 		 * and need a new, higher one */
 		if (vma && (addr >= vma->vm_end))
@@ -757,8 +800,6 @@ static int pagemap_hugetlb_range(pte_t *
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
-#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
-#define PAGEMAP_WALK_MASK	(PMD_MASK)
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
_
Subject: Subject: pagemap: avoid splitting thp when reading /proc/pid/pagemap

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

