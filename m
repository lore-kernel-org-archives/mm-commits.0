From: akpm@linux-foundation.org
Subject: + mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch added
 to -mm tree
Date: Wed, 30 Dec 2015 13:12:58 -0800
Message-ID: <568448da.ksEwVlrKetubpVqm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbbL3VM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Dec 2015 16:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix pmd_devmap compile error
has been added to the -mm tree.  Its filename is
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix pmd_devmap compile error

The kbuild robot reports the following with an i386 randconfig:

In file included from arch/x86/include/asm/atomic.h:4:0,
	from include/linux/atomic.h:4,
	from include/linux/crypto.h:20,
	from arch/x86/kernel/asm-offsets.c:8:
include/linux/huge_mm.h: In function 'pmd_trans_huge_lock':
>>	include/linux/huge_mm.h:128:30: error: implicit declaration of function 'pmd_devmap' [-Werror=implicit-function-declaration]
	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
                                    ^

Fix by moving the fallback definition of pmd_devmap() earlier in mm.h,
before it include huge_mm.h.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix
+++ a/include/linux/mm.h
@@ -336,6 +336,13 @@ struct inode;
 #include <linux/page-flags.h>
 #include <linux/huge_mm.h>
 
+#if !defined(__HAVE_ARCH_PTE_DEVMAP) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return 0;
+}
+#endif
+
 /*
  * Methods to modify the page usage count.
  *
@@ -1459,13 +1466,6 @@ static inline int __pud_alloc(struct mm_
 int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
 #endif
 
-#if !defined(__HAVE_ARCH_PTE_DEVMAP) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline int pmd_devmap(pmd_t pmd)
-{
-	return 0;
-}
-#endif
-
 #if defined(__PAGETABLE_PMD_FOLDED) || !defined(CONFIG_MMU)
 static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
 						unsigned long address)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-skip-memory-block-registration-for-zone_device.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch
mm-x86-get_user_pages-for-dax-mappings.patch
mm-x86-get_user_pages-for-dax-mappings-v5.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch
a.patch

