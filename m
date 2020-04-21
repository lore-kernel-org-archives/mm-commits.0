From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-define-mm_p4d_folded.patch added to -mm tree
Date: Mon, 20 Apr 2020 19:48:29 -0700
Message-ID: <20200421024829.eEHGV9-LP%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgDUCsb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 22:48:31 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, kirill@shutemov.name, mingo@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: x86/mm: define mm_p4d_folded()
has been added to the -mm tree.  Its filename is
     x86-mm-define-mm_p4d_folded.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-define-mm_p4d_folded.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-define-mm_p4d_folded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: x86/mm: define mm_p4d_folded()

This just defines mm_p4d_folded() to check whether P4D page table level is
folded at runtime.

Link: http://lkml.kernel.org/r/1587436495-22033-2-git-send-email-anshuman.khandual@arm.com
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

powerpc-mm-drop-platform-defined-pmd_mknotpresent.patch
mm-thp-rename-pmd_mknotpresent-as-pmd_mknotvalid.patch
x86-mm-define-mm_p4d_folded.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-v17.patch
