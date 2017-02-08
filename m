From: akpm@linux-foundation.org
Subject: + mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch added to -mm tree
Date: Wed, 08 Feb 2017 14:18:15 -0800
Message-ID: <589b9927.r9juNv0Ugu5AXPM5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56406 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdBHW41 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2017 17:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.jiang@intel.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, nilesh.choudhury@oracle.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix get_user_pages() vs device-dax pud mappings
has been added to the -mm tree.  Its filename is
     mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

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
Subject: mm: fix get_user_pages() vs device-dax pud mappings

A new unit test for the device-dax 1GB enabling currently fails with this
warning before hanging the test thread:

 WARNING: CPU: 0 PID: 21 at lib/percpu-refcount.c:155 percpu_ref_switch_to_atomic_rcu+0x1e3/0x1f0
 percpu ref (dax_pmem_percpu_release [dax_pmem]) <= 0 (0) after switching to atomic
 [..]
 CPU: 0 PID: 21 Comm: rcuos/1 Tainted: G           O    4.10.0-rc7-next-20170207+ #944
 [..]
 Call Trace:
  dump_stack+0x86/0xc3
  __warn+0xcb/0xf0
  warn_slowpath_fmt+0x5f/0x80
  ? rcu_nocb_kthread+0x27a/0x510
  ? dax_pmem_percpu_exit+0x50/0x50 [dax_pmem]
  percpu_ref_switch_to_atomic_rcu+0x1e3/0x1f0
  ? percpu_ref_exit+0x60/0x60
  rcu_nocb_kthread+0x339/0x510
  ? rcu_nocb_kthread+0x27a/0x510
  kthread+0x101/0x140

The get_user_pages() path needs to arrange for references to be taken
against the dev_pagemap instance backing the pud mapping. Refactor the
existing __gup_device_huge_pmd() to also account for the pud case.

Link: http://lkml.kernel.org/r/148653181153.38226.9605457830505509385.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Nilesh Choudhury <nilesh.choudhury@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/gup.c~mm-fix-get_user_pages-vs-device-dax-pud-mappings arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-fix-get_user_pages-vs-device-dax-pud-mappings
+++ a/arch/x86/mm/gup.c
@@ -154,14 +154,12 @@ static inline void get_head_page_multipl
 	SetPageReferenced(page);
 }
 
-static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+static int __gup_device_huge(unsigned long pfn, unsigned long addr,
 		unsigned long end, struct page **pages, int *nr)
 {
 	int nr_start = *nr;
-	unsigned long pfn = pmd_pfn(pmd);
 	struct dev_pagemap *pgmap = NULL;
 
-	pfn += (addr & ~PMD_MASK) >> PAGE_SHIFT;
 	do {
 		struct page *page = pfn_to_page(pfn);
 
@@ -180,6 +178,24 @@ static int __gup_device_huge_pmd(pmd_t p
 	return 1;
 }
 
+static int __gup_device_huge_pmd(pmd_t pmd, unsigned long addr,
+		unsigned long end, struct page **pages, int *nr)
+{
+	unsigned long fault_pfn;
+
+	fault_pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+}
+
+static int __gup_device_huge_pud(pud_t pud, unsigned long addr,
+		unsigned long end, struct page **pages, int *nr)
+{
+	unsigned long fault_pfn;
+
+	fault_pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	return __gup_device_huge(fault_pfn, addr, end, pages, nr);
+}
+
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
@@ -251,9 +267,13 @@ static noinline int gup_huge_pud(pud_t p
 
 	if (!pte_allows_gup(pud_val(pud), write))
 		return 0;
+
+	VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
+	if (pud_devmap(pud))
+		return __gup_device_huge_pud(pud, addr, end, pages, nr);
+
 	/* hugepages are never "special" */
 	VM_BUG_ON(pud_flags(pud) & _PAGE_SPECIAL);
-	VM_BUG_ON(!pfn_valid(pud_pfn(pud)));
 
 	refs = 0;
 	head = pud_page(pud);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges-fix-2.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch
mm-fix-get_user_pages-vs-device-dax-pud-mappings.patch

