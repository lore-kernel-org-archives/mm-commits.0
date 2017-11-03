From: akpm@linux-foundation.org
Subject: + mm-account-pud-page-tables-fix-2.patch added to -mm tree
Date: Fri, 03 Nov 2017 10:54:25 -0700
Message-ID: <59fcad51.EFjMswJIgmkPX5vk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933729AbdKCRy0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 13:54:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: fix pud table accounting
has been added to the -mm tree.  Its filename is
     mm-account-pud-page-tables-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-account-pud-page-tables-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-account-pud-page-tables-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: s390/mm: fix pud table accounting

With "mm: account pud page tables" and "mm: consolidate page table
accounting" pud page table accounting was introduced which now results in
tons of warnings like this one on s390:

BUG: non-zero pgtables_bytes on freeing mm: -16384

Reason for this are our run-time folded page tables: by default new
processes start with three page table levels where the allocated pgd is
the same as the first pud.  In this case there won't ever be a pud
allocated and therefore mm_inc_nr_puds() will also never be called.

However when freeing the address space free_pud_range() will call exactly
once mm_dec_nr_puds() which leads to misaccounting.

Therefore call mm_inc_nr_puds() within init_new_context() to fix this. 
This is the same like we have it already for processes that run with two
page table levels (aka compat processes).

While at it also adjust the comment, since there is no "mm->nr_pmds"
anymore.

Link: http://lkml.kernel.org/r/20171103090551.18231-1-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/mmu_context.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/s390/include/asm/mmu_context.h~mm-account-pud-page-tables-fix-2 arch/s390/include/asm/mmu_context.h
--- a/arch/s390/include/asm/mmu_context.h~mm-account-pud-page-tables-fix-2
+++ a/arch/s390/include/asm/mmu_context.h
@@ -44,6 +44,8 @@ static inline int init_new_context(struc
 		mm->context.asce_limit = STACK_TOP_MAX;
 		mm->context.asce = __pa(mm->pgd) | _ASCE_TABLE_LENGTH |
 				   _ASCE_USER_BITS | _ASCE_TYPE_REGION3;
+		/* pgd_alloc() did not account this pud */
+		mm_inc_nr_puds(mm);
 		break;
 	case -PAGE_SIZE:
 		/* forked 5-level task, set new asce with new_mm->pgd */
@@ -59,7 +61,7 @@ static inline int init_new_context(struc
 		/* forked 2-level compat task, set new asce with new mm->pgd */
 		mm->context.asce = __pa(mm->pgd) | _ASCE_TABLE_LENGTH |
 				   _ASCE_USER_BITS | _ASCE_TYPE_SEGMENT;
-		/* pgd_alloc() did not increase mm->nr_pmds */
+		/* pgd_alloc() did not account this pmd */
 		mm_inc_nr_pmds(mm);
 	}
 	crst_table_init((unsigned long *) mm->pgd, pgd_entry_type(mm));
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

mm-account-pud-page-tables-fix-2.patch

