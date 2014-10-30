From: akpm@linux-foundation.org
Subject: [alternative-merged]
 smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page.patch removed from -mm tree
Date: Thu, 30 Oct 2014 14:23:59 -0700
Message-ID: <5452ac6f.DrfK3xR3bIzqMBsx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934857AbaJ3VX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yfw.kernel@gmail.com, dave.hansen@intel.com, fengguang.wu@intel.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: smaps should deal with huge zero page exactly same as normal zero page
has been removed from the -mm tree.  Its filename was
     smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Fengwei Yin <yfw.kernel@gmail.com>
Subject: mm: smaps should deal with huge zero page exactly same as normal zero page

We could see following memory info in /proc/xxxx/smaps with THP enabled.

  7bea458b3000-7fea458b3000 r--p 00000000 00:13 39989  /dev/zero
  Size:           4294967296 kB
  Rss:            10612736 kB
  Pss:            10612736 kB
  Shared_Clean:          0 kB
  Shared_Dirty:          0 kB
  Private_Clean:  10612736 kB
  Private_Dirty:         0 kB
  Referenced:     10612736 kB
  Anonymous:             0 kB
  AnonHugePages:  10612736 kB
  Swap:                  0 kB
  KernelPageSize:        4 kB
  MMUPageSize:           4 kB
  Locked:                0 kB
  VmFlags: rd mr mw me

which is wrong becuase just huge_zero_page/normal_zero_page is used for
/dev/zero.  Most of the value should be 0.

This patch detects huge_zero_page (original implementation just detect
normal_zero_page) and avoids to update the wrong value for huge_zero_page.

Signed-off-by: Fengwei Yin <yfw.kernel@gmail.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    6 ++++--
 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |    5 +++++
 mm/memory.c             |    4 ++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page
+++ a/fs/proc/task_mmu.c
@@ -474,8 +474,11 @@ static void smaps_pte_entry(pte_t ptent,
 	if (!page)
 		return;
 
-	if (PageAnon(page))
+	if (PageAnon(page)) {
 		mss->anonymous += ptent_size;
+		if (PageTransHuge(page))
+			mss->anonymous_thp += HPAGE_PMD_SIZE;
+	}
 
 	if (page->index != pgoff)
 		mss->nonlinear += ptent_size;
@@ -511,7 +514,6 @@ static int smaps_pte_range(pmd_t *pmd, u
 	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(ptl);
-		mss->anonymous_thp += HPAGE_PMD_SIZE;
 		return 0;
 	}
 
diff -puN include/linux/huge_mm.h~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page
+++ a/include/linux/huge_mm.h
@@ -34,6 +34,8 @@ extern int change_huge_pmd(struct vm_are
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
 
+extern bool is_huge_zero_pfn(unsigned long pfn);
+
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
diff -puN mm/huge_memory.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page
+++ a/mm/huge_memory.c
@@ -183,6 +183,11 @@ static inline bool is_huge_zero_pmd(pmd_
 	return is_huge_zero_page(pmd_page(pmd));
 }
 
+bool is_huge_zero_pfn(unsigned long pfn)
+{
+	return is_huge_zero_page(pfn_to_page(pfn));
+}
+
 static struct page *get_huge_zero_page(void)
 {
 	struct page *zero_page;
diff -puN mm/memory.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page mm/memory.c
--- a/mm/memory.c~smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page
+++ a/mm/memory.c
@@ -41,6 +41,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
+#include <linux/huge_mm.h>
 #include <linux/mman.h>
 #include <linux/swap.h>
 #include <linux/highmem.h>
@@ -787,6 +788,9 @@ check_pfn:
 		return NULL;
 	}
 
+	if (is_huge_zero_pfn(pfn))
+		return NULL;
+
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
_

Patches currently in -mm which might be from yfw.kernel@gmail.com are

smaps-should-deal-with-huge-zero-page-exactly-same-as-normal-zero-page-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch

