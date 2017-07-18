From: akpm@linux-foundation.org
Subject: + mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
 added to -mm tree
Date: Tue, 18 Jul 2017 15:27:03 -0700
Message-ID: <596e8b37.ZjSTZTgIB17EiI20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbdGRW1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: x86: move _PAGE_SWP_SOFT_DIRTY from bit 7 to bit 1
has been added to the -mm tree.  Its filename is
     mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch

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
Subject: mm: x86: move _PAGE_SWP_SOFT_DIRTY from bit 7 to bit 1

_PAGE_PSE is used to distinguish between a truly non-present
(_PAGE_PRESENT=0) PMD, and a PMD which is undergoing a THP split and
should be treated as present.

But _PAGE_SWP_SOFT_DIRTY currently uses the _PAGE_PSE bit, which would
cause confusion between one of those PMDs undergoing a THP split, and a
soft-dirty PMD.  Dropping _PAGE_PSE check in pmd_present() does not work
well, because it can hurt optimization of tlb handling in thp split.

Thus, we need to move the bit.

In the current kernel, bits 1-4 are not used in non-present format since
commit 00839ee3b299 ("x86/mm: Move swap offset/type up in PTE to work
around erratum").  So let's move _PAGE_SWP_SOFT_DIRTY to bit 1.  Bit 7 is
used as reserved (always clear), so please don't use it for other purpose.

Link: http://lkml.kernel.org/r/20170717193955.20207-3-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_64.h    |   12 +++++++++---
 arch/x86/include/asm/pgtable_types.h |   10 +++++-----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff -puN arch/x86/include/asm/pgtable_64.h~mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1 arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -180,15 +180,21 @@ static inline int pgd_large(pgd_t pgd) {
 /*
  * Encode and de-code a swap entry
  *
- * |     ...            | 11| 10|  9|8|7|6|5| 4| 3|2|1|0| <- bit number
- * |     ...            |SW3|SW2|SW1|G|L|D|A|CD|WT|U|W|P| <- bit names
- * | OFFSET (14->63) | TYPE (9-13)  |0|X|X|X| X| X|X|X|0| <- swp entry
+ * |     ...            | 11| 10|  9|8|7|6|5| 4| 3|2| 1|0| <- bit number
+ * |     ...            |SW3|SW2|SW1|G|L|D|A|CD|WT|U| W|P| <- bit names
+ * | OFFSET (14->63) | TYPE (9-13)  |0|0|X|X| X| X|X|SD|0| <- swp entry
  *
  * G (8) is aliased and used as a PROT_NONE indicator for
  * !present ptes.  We need to start storing swap entries above
  * there.  We also need to avoid using A and D because of an
  * erratum where they can be incorrectly set by hardware on
  * non-present PTEs.
+ *
+ * SD (1) in swp entry is used to store soft dirty bit, which helps us
+ * remember soft dirty over page migration
+ *
+ * Bit 7 in swp entry should be 0 because pmd_present checks not only P,
+ * but also L and G.
  */
 #define SWP_TYPE_FIRST_BIT (_PAGE_BIT_PROTNONE + 1)
 #define SWP_TYPE_BITS 5
diff -puN arch/x86/include/asm/pgtable_types.h~mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1 arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -97,15 +97,15 @@
 /*
  * Tracking soft dirty bit when a page goes to a swap is tricky.
  * We need a bit which can be stored in pte _and_ not conflict
- * with swap entry format. On x86 bits 6 and 7 are *not* involved
- * into swap entry computation, but bit 6 is used for nonlinear
- * file mapping, so we borrow bit 7 for soft dirty tracking.
+ * with swap entry format. On x86 bits 1-4 are *not* involved
+ * into swap entry computation, but bit 7 is used for thp migration,
+ * so we borrow bit 1 for soft dirty tracking.
  *
  * Please note that this bit must be treated as swap dirty page
- * mark if and only if the PTE has present bit clear!
+ * mark if and only if the PTE/PMD has present bit clear!
  */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define _PAGE_SWP_SOFT_DIRTY	_PAGE_PSE
+#define _PAGE_SWP_SOFT_DIRTY	_PAGE_RW
 #else
 #define _PAGE_SWP_SOFT_DIRTY	(_AT(pteval_t, 0))
 #endif
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-mempolicy-add-queue_pages_required.patch
mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
mm-thp-introduce-config_arch_enable_thp_migration.patch
mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch
mm-mempolicy-mbind-and-migrate_pages-support-thp-migration.patch
mm-migrate-move_pages-supports-thp-migration.patch
mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

