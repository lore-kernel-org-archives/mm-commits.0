From: akpm@linux-foundation.org
Subject: [merged] x86-mm-define-mm_p4d_folded.patch removed from
 -mm tree
Date: Fri, 05 Jun 2020 13:17:07 -0700
Message-ID: <20200605201707.bgBF8uQhf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbgFEURI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, kirill@shutemov.name, mingo@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86/mm: define mm_p4d_folded()
has been removed from the -mm tree.  Its filename was
     x86-mm-define-mm_p4d_folded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: x86/mm: define mm_p4d_folded()

Patch series "mm/debug: Add tests validating architecture page table
helpers", v18.

This adds a test validation for architecture exported page table helpers. 
Patch adds basic transformation tests at various levels of the page table.

This test was originally suggested by Catalin during arm64 THP migration
RFC discussion earlier.  Going forward it can include more specific tests
with respect to various generic MM functions like THP, HugeTLB etc and
platform specific tests.

https://lore.kernel.org/linux-mm/20190628102003.GA56463@arrakis.emea.arm.com/


This patch (of 2):

This just defines mm_p4d_folded() to check whether P4D page table level is
folded at runtime.

Link: http://lkml.kernel.org/r/1587436495-22033-2-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1588564865-31160-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/include/asm/pgtable_64.h~x86-mm-define-mm_p4d_folded
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -53,6 +53,12 @@ static inline void sync_initial_page_tab
 
 struct mm_struct;
 
+#define mm_p4d_folded mm_p4d_folded
+static inline bool mm_p4d_folded(struct mm_struct *mm)
+{
+	return !pgtable_l5_enabled();
+}
+
 void set_pte_vaddr_p4d(p4d_t *p4d_page, unsigned long vaddr, pte_t new_pte);
 void set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte);
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vmstat-add-events-for-pmd-based-thp-migration-without-split.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-update.patch
