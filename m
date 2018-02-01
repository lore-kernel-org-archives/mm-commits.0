From: akpm@linux-foundation.org
Subject: [patch 063/119] arm64: provide pmdp_establish() helper
Date: Wed, 31 Jan 2018 16:17:55 -0800
Message-ID: <20180201001755.zg3xuQzqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeBAAR4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, catalin.marinas@arm.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

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
@@ -706,6 +706,13 @@ static inline void pmdp_set_wrprotect(st
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
