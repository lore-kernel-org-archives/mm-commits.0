From: akpm@linux-foundation.org
Subject: + pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:54:24 -0800
Message-ID: <20130107215425.52823100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:61966 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3AGVy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:54:26 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so2138595yhr.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:54:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, andi@firstfloor.org, hpa@linux.intel.com, hughd@google.com, mgorman@suse.de, mingo@elte.hu, shaohua.li@intel.com, tglx@linutronix.de


The patch titled
     Subject: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge
has been added to the -mm tree.  Its filename is
     pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_present and pmd_huge

Without this patch any kernel code that reads kernel memory in non
present kernel pte/pmds (as set by pageattr.c) will crash.

With this kernel code:

static struct page *crash_page;
static unsigned long *crash_address;
[..]
	crash_page = alloc_pages(GFP_KERNEL, 9);
	crash_address = page_address(crash_page);
	if (set_memory_np((unsigned long)crash_address, 1))
		printk("set_memory_np failure\n");
[..]

The kernel will crash if inside the "crash tool" one would try to read
the memory at the not present address.

crash> p crash_address
crash_address = $8 = (long unsigned int *) 0xffff88023c000000
crash> rd 0xffff88023c000000
[ *lockup* ]

The lockup happens because _PAGE_GLOBAL and _PAGE_PROTNONE shares the
same bit, and pageattr leaves _PAGE_GLOBAL set on a kernel pte which
is then mistaken as _PAGE_PROTNONE (so pte_present returns true by
mistake and the kernel fault then gets confused and loops).

With THP the same can happen after we taught pmd_present to check
_PAGE_PROTNONE and _PAGE_PSE in commit 027ef6c87853b0a9df5317 ("mm: thp:
fix pmd_present for split_huge_page and PROT_NONE with THP").  THP has the
same problem with _PAGE_GLOBAL as the 4k pages, but it also has a problem
with _PAGE_PSE, which must be cleared too.

After the patch is applied copy_user correctly returns -EFAULT and
doesn't lockup anymore.

crash> p crash_address
crash_address = $9 = (long unsigned int *) 0xffff88023c000000
crash> rd 0xffff88023c000000
rd: read error: kernel virtual address: ffff88023c000000  type: "64-bit KVADDR"

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr.c |   50 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/pageattr.c~pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge
+++ a/arch/x86/mm/pageattr.c
@@ -445,6 +445,19 @@ try_preserve_large_page(pte_t *kpte, uns
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
 	/*
+	 * Set the PSE and GLOBAL flags only if the PRESENT flag is
+	 * set otherwise pmd_present/pmd_huge will return true even on
+	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
+	 * for the ancient hardware that doesn't support it.
+	 */
+	if (pgprot_val(new_prot) & _PAGE_PRESENT)
+		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
+	else
+		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
+
+	new_prot = canon_pgprot(new_prot);
+
+	/*
 	 * old_pte points to the large page base address. So we need
 	 * to add the offset of the virtual address:
 	 */
@@ -489,7 +502,7 @@ try_preserve_large_page(pte_t *kpte, uns
 		 * The address is aligned and the number of pages
 		 * covers the full page.
 		 */
-		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
+		new_pte = pfn_pte(pte_pfn(old_pte), new_prot);
 		__set_pmd_pte(kpte, address, new_pte);
 		cpa->flags |= CPA_FLUSHTLB;
 		do_split = 0;
@@ -540,16 +553,35 @@ static int split_large_page(pte_t *kpte,
 #ifdef CONFIG_X86_64
 	if (level == PG_LEVEL_1G) {
 		pfninc = PMD_PAGE_SIZE >> PAGE_SHIFT;
-		pgprot_val(ref_prot) |= _PAGE_PSE;
+		/*
+		 * Set the PSE flags only if the PRESENT flag is set
+		 * otherwise pmd_present/pmd_huge will return true
+		 * even on a non present pmd.
+		 */
+		if (pgprot_val(ref_prot) & _PAGE_PRESENT)
+			pgprot_val(ref_prot) |= _PAGE_PSE;
+		else
+			pgprot_val(ref_prot) &= ~_PAGE_PSE;
 	}
 #endif
 
 	/*
+	 * Set the GLOBAL flags only if the PRESENT flag is set
+	 * otherwise pmd/pte_present will return true even on a non
+	 * present pmd/pte. The canon_pgprot will clear _PAGE_GLOBAL
+	 * for the ancient hardware that doesn't support it.
+	 */
+	if (pgprot_val(ref_prot) & _PAGE_PRESENT)
+		pgprot_val(ref_prot) |= _PAGE_GLOBAL;
+	else
+		pgprot_val(ref_prot) &= ~_PAGE_GLOBAL;
+
+	/*
 	 * Get the target pfn from the original entry:
 	 */
 	pfn = pte_pfn(*kpte);
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
-		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
+		set_pte(&pbase[i], pfn_pte(pfn, canon_pgprot(ref_prot)));
 
 	if (address >= (unsigned long)__va(0) &&
 		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
@@ -660,6 +692,18 @@ repeat:
 		new_prot = static_protections(new_prot, address, pfn);
 
 		/*
+		 * Set the GLOBAL flags only if the PRESENT flag is
+		 * set otherwise pte_present will return true even on
+		 * a non present pte. The canon_pgprot will clear
+		 * _PAGE_GLOBAL for the ancient hardware that doesn't
+		 * support it.
+		 */
+		if (pgprot_val(new_prot) & _PAGE_PRESENT)
+			pgprot_val(new_prot) |= _PAGE_GLOBAL;
+		else
+			pgprot_val(new_prot) &= ~_PAGE_GLOBAL;
+
+		/*
 		 * We need to keep the pfn from the existing PTE,
 		 * after all we're only going to change it's attributes
 		 * not the memory it points to
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-migrate-check-page_count-of-thp-before-migrating.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
audit-create-explicit-audit_seccomp-event-type.patch
audit-catch-possible-null-audit-buffers.patch
mm-huge_memory-use-new-hashtable-implementation.patch

