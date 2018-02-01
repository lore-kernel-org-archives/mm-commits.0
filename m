From: akpm@linux-foundation.org
Subject: [merged] arm-mm-provide-pmdp_establish-helper.patch
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:32:09 -0800
Message-ID: <20180201193209.TGZbtjzK5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58474 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753126AbeBATcK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: arm/mm: provide pmdp_establish() helper
has been removed from the -mm tree.  Its filename was
     arm-mm-provide-pmdp_establish-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm/mm: provide pmdp_establish() helper

ARM LPAE doesn't have hardware dirty/accessed bits.

generic_pmdp_establish() is the right implementation of pmdp_establish for
this case.

Link: http://lkml.kernel.org/r/20171213105756.69879-4-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-mm-provide-pmdp_establish-helper arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-mm-provide-pmdp_establish-helper
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -249,6 +249,9 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 #define pfn_pmd(pfn,prot)	(__pmd(((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot)))
 #define mk_pmd(page,prot)	pfn_pmd(page_to_pfn(page),prot)
 
+/* No hardware dirty/accessed bits -- generic_pmdp_establish() fits */
+#define pmdp_establish generic_pmdp_establish
+
 /* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
 static inline pmd_t pmd_mknotpresent(pmd_t pmd)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


