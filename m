From: akpm@linux-foundation.org
Subject: [patch 060/119] asm-generic: provide
 generic_pmdp_establish()
Date: Wed, 31 Jan 2018 16:17:43 -0800
Message-ID: <20180201001743.XJgYxkQbg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeBAARq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, davem@davemloft.net, david.daney@cavium.com, hpa@zytor.com, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nitin.m.gupta@oracle.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, vgupta@synopsys.com

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: asm-generic: provide generic_pmdp_establish()

Patch series "Do not lose dirty bit on THP pages", v4.

Vlastimil noted that pmdp_invalidate() is not atomic and we can lose
dirty and access bits if CPU sets them after pmdp dereference, but
before set_pmd_at().

The bug can lead to data loss, but the race window is tiny and I haven't
seen any reports that suggested that it happens in reality. So I don't
think it worth sending it to stable.

Unfortunately, there's no way to address the issue in a generic way. We need to
fix all architectures that support THP one-by-one.

All architectures that have THP supported have to provide atomic
pmdp_invalidate() that returns previous value.

If generic implementation of pmdp_invalidate() is used, architecture needs to
provide atomic pmdp_estabish().

pmdp_estabish() is not used out-side generic implementation of
pmdp_invalidate() so far, but I think this can change in the future.



This patch (of 12):

This is an implementation of pmdp_establish() that is only suitable for an
architecture that doesn't have hardware dirty/accessed bits.  In this case
we can't race with CPU which sets these bits and non-atomic approach is
fine.

Link: http://lkml.kernel.org/r/20171213105756.69879-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Daney <david.daney@cavium.com>
Cc: David Miller <davem@davemloft.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Nitin Gupta <nitin.m.gupta@oracle.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/asm-generic/pgtable.h~asm-generic-provide-generic_pmdp_establish include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~asm-generic-provide-generic_pmdp_establish
+++ a/include/asm-generic/pgtable.h
@@ -309,6 +309,21 @@ extern void pgtable_trans_huge_deposit(s
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * This is an implementation of pmdp_establish() that is only suitable for an
+ * architecture that doesn't have hardware dirty/accessed bits. In this case we
+ * can't race with CPU which sets these bits and non-atomic aproach is fine.
+ */
+static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	pmd_t old_pmd = *pmdp;
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
+	return old_pmd;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
 extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp);
_
