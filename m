From: akpm@linux-foundation.org
Subject: + arm64-provide-pmdp_establish-helper.patch added to -mm tree
Date: Wed, 13 Dec 2017 16:11:13 -0800
Message-ID: <5a31c1a1.lUjyqcqpBkEEy8su%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbdLNALP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 19:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: provide pmdp_establish() helper
has been added to the -mm tree.  Its filename is
     arm64-provide-pmdp_establish-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-provide-pmdp_establish-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-provide-pmdp_establish-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: provide pmdp_establish() helper

We need an atomic way to setup pmd page table entry, avoiding races with
CPU setting dirty/accessed bits.  This is required to implement
pmdp_invalidate() that doesn't lose these bits.

Link: http://lkml.kernel.org/r/20171213105756.69879-5-kirill.shutemov@linux.intel.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/arm64/include/asm/pgtable.h~arm64-provide-pmdp_establish-helper arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~arm64-provide-pmdp_establish-helper
+++ a/arch/arm64/include/asm/pgtable.h
@@ -676,6 +676,13 @@ static inline void pmdp_set_wrprotect(st
 {
 	ptep_set_wrprotect(mm, address, (pte_t *)pmdp);
 }
+
+#define pmdp_establish pmdp_establish
+static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
+}
 #endif
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

arm64-provide-pmdp_establish-helper.patch

