From: akpm@linux-foundation.org
Subject: [patch 068/119] x86/mm: provide pmdp_establish() helper
Date: Wed, 31 Jan 2018 16:18:13 -0800
Message-ID: <20180201001813.g-xfs7Dni%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755795AbeBAASO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:18:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: x86/mm: provide pmdp_establish() helper

We need an atomic way to setup pmd page table entry, avoiding races with
CPU setting dirty/accessed bits.  This is required to implement
pmdp_invalidate() that doesn't lose these bits.

On PAE we can avoid expensive cmpxchg8b for cases when new page table
entry is not present.  If it's present, fallback to cpmxchg loop.

[akpm@linux-foundation.org: add missing `do' to do-while loop]
Link: http://lkml.kernel.org/r/20171213105756.69879-10-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-3level.h |   37 +++++++++++++++++++++++-
 arch/x86/include/asm/pgtable.h        |   15 +++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgtable-3level.h~x86-mm-provide-pmdp_establish-helper arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-mm-provide-pmdp_establish-helper
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -158,7 +158,6 @@ static inline pte_t native_ptep_get_and_
 #define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
 #endif
 
-#ifdef CONFIG_SMP
 union split_pmd {
 	struct {
 		u32 pmd_low;
@@ -166,6 +165,8 @@ union split_pmd {
 	};
 	pmd_t pmd;
 };
+
+#ifdef CONFIG_SMP
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
 {
 	union split_pmd res, *orig = (union split_pmd *)pmdp;
@@ -181,6 +182,40 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+#ifndef pmdp_establish
+#define pmdp_establish pmdp_establish
+static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	pmd_t old;
+
+	/*
+	 * If pmd has present bit cleared we can get away without expensive
+	 * cmpxchg64: we can update pmdp half-by-half without racing with
+	 * anybody.
+	 */
+	if (!(pmd_val(pmd) & _PAGE_PRESENT)) {
+		union split_pmd old, new, *ptr;
+
+		ptr = (union split_pmd *)pmdp;
+
+		new.pmd = pmd;
+
+		/* xchg acts as a barrier before setting of the high bits */
+		old.pmd_low = xchg(&ptr->pmd_low, new.pmd_low);
+		old.pmd_high = ptr->pmd_high;
+		ptr->pmd_high = new.pmd_high;
+		return old.pmd;
+	}
+
+	do {
+		old = *pmdp;
+	} while (cmpxchg64(&pmdp->pmd, old.pmd, pmd.pmd) != old.pmd);
+
+	return old;
+}
+#endif
+
 #ifdef CONFIG_SMP
 union split_pud {
 	struct {
diff -puN arch/x86/include/asm/pgtable.h~x86-mm-provide-pmdp_establish-helper arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-mm-provide-pmdp_establish-helper
+++ a/arch/x86/include/asm/pgtable.h
@@ -1109,6 +1109,21 @@ static inline int pud_write(pud_t pud)
 	return pud_flags(pud) & _PAGE_RW;
 }
 
+#ifndef pmdp_establish
+#define pmdp_establish pmdp_establish
+static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	if (IS_ENABLED(CONFIG_SMP)) {
+		return xchg(pmdp, pmd);
+	} else {
+		pmd_t old = *pmdp;
+		*pmdp = pmd;
+		return old;
+	}
+}
+#endif
+
 /*
  * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
  *
_
