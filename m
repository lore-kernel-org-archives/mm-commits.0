From: akpm@linux-foundation.org
Subject: + arm64-standardize-mmap_rnd-usage.patch added to -mm tree
Date: Wed, 04 Mar 2015 13:40:12 -0800
Message-ID: <54f77bbc.Hhmthu/95mgpnk2n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbbCDVkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, catalin.marinas@arm.com, linux@arm.linux.org.uk, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: standardize mmap_rnd() usage
has been added to the -mm tree.  Its filename is
     arm64-standardize-mmap_rnd-usage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-standardize-mmap_rnd-usage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-standardize-mmap_rnd-usage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: arm64: standardize mmap_rnd() usage

In preparation for splitting out ET_DYN ASLR, this refactors the use of
mmap_rnd() to be used similarly to arm and x86. This additionally enables
mmap ASLR on legacy mmap layouts, which appeared to be missing on arm64,
and was already supported on arm. Additionally removes a copy/pasted
declaration of an unused function.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |    1 -
 arch/arm64/mm/mmap.c         |   18 +++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN arch/arm64/include/asm/elf.h~arm64-standardize-mmap_rnd-usage arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~arm64-standardize-mmap_rnd-usage
+++ a/arch/arm64/include/asm/elf.h
@@ -125,7 +125,6 @@ typedef struct user_fpsimd_state elf_fpr
  * the loader.  We need to make sure that it is out of the way of the program
  * that it will "exec", and that there is sufficient room for the brk.
  */
-extern unsigned long randomize_et_dyn(unsigned long base);
 #define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
 
 /*
diff -puN arch/arm64/mm/mmap.c~arm64-standardize-mmap_rnd-usage arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~arm64-standardize-mmap_rnd-usage
+++ a/arch/arm64/mm/mmap.c
@@ -49,15 +49,14 @@ static int mmap_is_legacy(void)
 
 static unsigned long mmap_rnd(void)
 {
-	unsigned long rnd = 0;
+	unsigned long rnd;
 
-	if (current->flags & PF_RANDOMIZE)
-		rnd = (long)get_random_int() & STACK_RND_MASK;
+	rnd = (unsigned long)get_random_int() & STACK_RND_MASK;
 
 	return rnd << PAGE_SHIFT;
 }
 
-static unsigned long mmap_base(void)
+static unsigned long mmap_base(unsigned long base)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -66,7 +65,7 @@ static unsigned long mmap_base(void)
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(STACK_TOP - gap - mmap_rnd());
+	return PAGE_ALIGN(STACK_TOP - gap - base);
 }
 
 /*
@@ -75,15 +74,20 @@ static unsigned long mmap_base(void)
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
+	unsigned long random_factor = 0UL;
+
+	if (current->flags & PF_RANDOMIZE)
+		random_factor = mmap_rnd();
+
 	/*
 	 * Fall back to the standard layout if the personality bit is set, or
 	 * if the expected stack growth is unlimited:
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
-		mm->mmap_base = mmap_base();
+		mm->mmap_base = mmap_base(random_factor);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
_

Patches currently in -mm which might be from keescook@chromium.org are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
mips-extract-logic-for-mmap_rnd.patch
powerpc-standardize-mmap_rnd-usage.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

