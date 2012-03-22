From: akpm@linux-foundation.org
Subject: [merged] pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:00 -0700
Message-ID: <20120322201800.791DDA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:46778 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab2CVUSB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:01 -0400
Received: by mail-vx0-f202.google.com with SMTP id fk26so402092vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, ak@linux.intel.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap: avoid splitting thp when reading /proc/pid/pagemap
has been removed from the -mm tree.  Its filename was
     pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

 fs/proc/task_mmu.c |   52 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap
+++ a/fs/proc/task_mmu.c
@@ -608,6 +608,9 @@ struct pagemapread {
 	u64 *buffer;
 };
 
+#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
+#define PAGEMAP_WALK_MASK	(PMD_MASK)
+
 #define PM_ENTRY_BYTES      sizeof(u64)
 #define PM_STATUS_BITS      3
 #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
@@ -666,6 +669,27 @@ static u64 pte_to_pagemap_entry(pte_t pt
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
@@ -673,15 +697,37 @@ static int pagemap_pte_range(pmd_t *pmd,
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
+	u64 pfn = PM_NOT_PRESENT;
 
-	split_huge_page_pmd(walk->mm, pmd);
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
+	spin_lock(&walk->mm->page_table_lock);
+	if (pmd_trans_huge(*pmd)) {
+		if (pmd_trans_splitting(*pmd)) {
+			spin_unlock(&walk->mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			for (; addr != end; addr += PAGE_SIZE) {
+				unsigned long offset;
+
+				offset = (addr & ~PAGEMAP_WALK_MASK) >>
+						PAGE_SHIFT;
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
 	for (; addr != end; addr += PAGE_SIZE) {
-		u64 pfn = PM_NOT_PRESENT;
 
 		/* check to see if we've left 'vma' behind
 		 * and need a new, higher one */
@@ -764,8 +810,6 @@ static int pagemap_hugetlb_range(pte_t *
  * determine which areas of memory are actually mapped and llseek to
  * skip over unmapped regions.
  */
-#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
-#define PAGEMAP_WALK_MASK	(PMD_MASK)
 static ssize_t pagemap_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
linux-next.patch

