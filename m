From: akpm@linux-foundation.org
Subject: [patch 033/124] mm: fix get_user_pages() vs device-dax pud
 mappings
Date: Fri, 24 Feb 2017 14:57:12 -0800
Message-ID: <58b0ba48.euUSDv77zeDYU/pi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38004 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdBXW5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.j.williams@intel.com, dave.jiang@intel.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, nilesh.choudhury@oracle.com, ross.zwisler@linux.intel.com

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
