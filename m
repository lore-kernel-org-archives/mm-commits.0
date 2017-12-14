From: akpm@linux-foundation.org
Subject: + arm-mm-provide-pmdp_establish-helper.patch added to -mm tree
Date: Wed, 13 Dec 2017 16:11:10 -0800
Message-ID: <5a31c19e.mojqrXsNK+2ToxeA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdLNALM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, catalin.marinas@arm.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arm/mm: provide pmdp_establish() helper
has been added to the -mm tree.  Its filename is
     arm-mm-provide-pmdp_establish-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mm-provide-pmdp_establish-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-provide-pmdp_establish-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

asm-generic-provide-generic_pmdp_establish.patch
arc-use-generic_pmdp_establish-as-pmdp_establish.patch
arm-mm-provide-pmdp_establish-helper.patch
mips-use-generic_pmdp_establish-as-pmdp_establish.patch
x86-mm-provide-pmdp_establish-helper.patch
mm-do-not-lose-dirty-and-access-bits-in-pmdp_invalidate.patch
mm-use-updated-pmdp_invalidate-interface-to-track-dirty-accessed-bits.patch

