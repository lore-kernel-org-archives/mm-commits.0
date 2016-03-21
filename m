From: akpm@linux-foundation.org
Subject: [merged]
 arc-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Mon, 21 Mar 2016 11:39:13 -0700
Message-ID: <56f03fd1.y9vUatQetUF8rsR9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbcCUT4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, kirill.shutemov@linux.intel.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARC, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     arc-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: ARC, thp: remove infrastructure for handling splitting PMDs

With THP refcounting work, no need to mark PMDs splitting.

(ARC got missed under the sweeping arch change as THP support was likely
not present in orig baseline)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/hugepage.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/arc/include/asm/hugepage.h~arc-thp-remove-infrastructure-for-handling-splitting-pmds arch/arc/include/asm/hugepage.h
--- a/arch/arc/include/asm/hugepage.h~arc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arc/include/asm/hugepage.h
@@ -30,19 +30,16 @@ static inline pmd_t pte_pmd(pte_t pte)
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkhuge(pmd)		pte_pmd(pte_mkhuge(pmd_pte(pmd)))
 #define pmd_mknotpresent(pmd)	pte_pmd(pte_mknotpresent(pmd_pte(pmd)))
-#define pmd_mksplitting(pmd)	pte_pmd(pte_mkspecial(pmd_pte(pmd)))
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_pfn(pmd)		pte_pfn(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
-#define pmd_special(pmd)	pte_special(pmd_pte(pmd))
 
 #define mk_pmd(page, prot)	pte_pmd(mk_pte(page, prot))
 
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) & _PAGE_HW_SZ)
-#define pmd_trans_splitting(pmd)	(pmd_trans_huge(pmd) && pmd_special(pmd))
 
 #define pfn_pmd(pfn, prot)	(__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are


