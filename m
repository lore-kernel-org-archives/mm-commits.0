From: akpm@linux-foundation.org
Subject: + x86-unify-native__get_and_clear-smp-case.patch added to -mm
 tree
Date: Tue, 29 Mar 2016 14:08:16 -0700
Message-ID: <56faeec0.FTNhvH8t3khMDD1n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbcC2VIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, matthew.r.wilcox@intel.com, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: unify native_*_get_and_clear !SMP case
has been added to the -mm tree.  Its filename is
     x86-unify-native__get_and_clear-smp-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-unify-native__get_and_clear-smp-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-unify-native__get_and_clear-smp-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: x86: unify native_*_get_and_clear !SMP case

x86_32 and x86_64 had diverged slightly in their implementations of the
non-SMP cases for native_ptep_get_and_clear() and
native_pmdp_get_and_clear().  Unify the non-SMP cases in pgtable.h,
leaving only the SMP cases in the other three files.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |    6 ------
 arch/x86/include/asm/pgtable-3level.h |    7 +------
 arch/x86/include/asm/pgtable.h        |    5 +++++
 arch/x86/include/asm/pgtable_64.h     |   18 ++----------------
 4 files changed, 8 insertions(+), 28 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~x86-unify-native__get_and_clear-smp-case arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~x86-unify-native__get_and_clear-smp-case
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -42,17 +42,11 @@ static inline pte_t native_ptep_get_and_
 {
 	return __pte(xchg(&xp->pte_low, 0));
 }
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
 
-#ifdef CONFIG_SMP
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
 	return __pmd(xchg((pmdval_t *)xp, 0));
 }
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
 /* Bit manipulation helper on pte/pgoff entry */
diff -puN arch/x86/include/asm/pgtable-3level.h~x86-unify-native__get_and_clear-smp-case arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-unify-native__get_and_clear-smp-case
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -149,11 +149,7 @@ static inline pte_t native_ptep_get_and_
 
 	return res;
 }
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
 
-#ifdef CONFIG_SMP
 union split_pmd {
 	struct {
 		u32 pmd_low;
@@ -161,6 +157,7 @@ union split_pmd {
 	};
 	pmd_t pmd;
 };
+
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
 {
 	union split_pmd res, *orig = (union split_pmd *)pmdp;
@@ -172,8 +169,6 @@ static inline pmd_t native_pmdp_get_and_
 
 	return res.pmd;
 }
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
 /* Encode and de-code a swap entry */
diff -puN arch/x86/include/asm/pgtable.h~x86-unify-native__get_and_clear-smp-case arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-unify-native__get_and_clear-smp-case
+++ a/arch/x86/include/asm/pgtable.h
@@ -746,6 +746,11 @@ static inline pmd_t native_local_pmdp_ge
 	return res;
 }
 
+#ifndef CONFIG_SMP
+#define native_ptep_get_and_clear(p)	native_local_ptep_get_and_clear(p)
+#define native_pmdp_get_and_clear(p)	native_local_pmdp_get_and_clear(p)
+#endif
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
diff -puN arch/x86/include/asm/pgtable_64.h~x86-unify-native__get_and_clear-smp-case arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-unify-native__get_and_clear-smp-case
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -70,31 +70,17 @@ static inline void native_pmd_clear(pmd_
 	native_set_pmd(pmd, native_make_pmd(0));
 }
 
+#ifdef CONFIG_SMP
 static inline pte_t native_ptep_get_and_clear(pte_t *xp)
 {
-#ifdef CONFIG_SMP
 	return native_make_pte(xchg(&xp->pte, 0));
-#else
-	/* native_local_ptep_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pte_t ret = *xp;
-	native_pte_clear(NULL, 0, xp);
-	return ret;
-#endif
 }
 
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
-#ifdef CONFIG_SMP
 	return native_make_pmd(xchg(&xp->pmd, 0));
-#else
-	/* native_local_pmdp_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pmd_t ret = *xp;
-	native_pmd_clear(xp);
-	return ret;
-#endif
 }
+#endif
 
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
_

Patches currently in -mm which might be from willy@linux.intel.com are

mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-unify-native__get_and_clear-smp-case.patch
x86-fix-whitespace-issues.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch

