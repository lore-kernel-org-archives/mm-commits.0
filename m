From: akpm@linux-foundation.org
Subject: + x86-fix-whitespace-issues.patch added to -mm tree
Date: Tue, 29 Mar 2016 14:08:18 -0700
Message-ID: <56faeec2.oJwu5zHI0f46QY++%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbcC2VIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: Fix whitespace issues
has been added to the -mm tree.  Its filename is
     x86-fix-whitespace-issues.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-fix-whitespace-issues.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-fix-whitespace-issues.patch

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
Subject: x86: Fix whitespace issues

checkpatch whines about these whitespace issues.  No code changes.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
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

 arch/x86/include/asm/pgtable-2level.h |    2 +-
 arch/x86/include/asm/pgtable.h        |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~x86-fix-whitespace-issues arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~x86-fix-whitespace-issues
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -11,7 +11,7 @@
  * within a page table are directly modified.  Thus, the following
  * hook is made available.
  */
-static inline void native_set_pte(pte_t *ptep , pte_t pte)
+static inline void native_set_pte(pte_t *ptep, pte_t pte)
 {
 	*ptep = pte;
 }
diff -puN arch/x86/include/asm/pgtable.h~x86-fix-whitespace-issues arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-fix-whitespace-issues
+++ a/arch/x86/include/asm/pgtable.h
@@ -752,13 +752,13 @@ static inline pmd_t native_local_pmdp_ge
 #endif
 
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
-				     pte_t *ptep , pte_t pte)
+				     pte_t *ptep, pte_t pte)
 {
 	native_set_pte(ptep, pte);
 }
 
 static inline void native_set_pmd_at(struct mm_struct *mm, unsigned long addr,
-				     pmd_t *pmdp , pmd_t pmd)
+				     pmd_t *pmdp, pmd_t pmd)
 {
 	native_set_pmd(pmdp, pmd);
 }
@@ -858,8 +858,8 @@ static inline int pmd_write(pmd_t pmd)
 }
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
-static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmdp)
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					unsigned long addr, pmd_t *pmdp)
 {
 	return native_pmdp_get_and_clear(pmdp);
 }
@@ -883,7 +883,7 @@ static inline void pmdp_set_wrprotect(st
  */
 static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
 {
-       memcpy(dst, src, count * sizeof(pgd_t));
+	memcpy(dst, src, count * sizeof(pgd_t));
 }
 
 #define PTE_SHIFT ilog2(PTRS_PER_PTE)
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

