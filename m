From: akpm@linux-foundation.org
Subject: [merged] arm64-standardize-mmap_rnd-usage.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:30:17 -0700
Message-ID: <552ebc49.OhFiDsOrWn39HdzT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, catalin.marinas@arm.com, linux@arm.linux.org.uk, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: standardize mmap_rnd() usage
has been removed from the -mm tree.  Its filename was
     arm64-standardize-mmap_rnd-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Ingo Molnar <mingo@kernel.org>
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
+static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
 
@@ -66,7 +65,7 @@ static unsigned long mmap_base(void)
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(STACK_TOP - gap - mmap_rnd());
+	return PAGE_ALIGN(STACK_TOP - gap - rnd);
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

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
seccomp-allow-compat-sigreturn-overrides.patch
arm-use-asm-generic-for-seccomph.patch
microblaze-use-asm-generic-for-seccomph.patch
mips-switch-to-using-asm-generic-for-seccomph.patch
parisc-switch-to-using-asm-generic-for-seccomph.patch
powerpc-switch-to-using-asm-generic-for-seccomph.patch
sparc-switch-to-using-asm-generic-for-seccomph.patch
x86-switch-to-using-asm-generic-for-seccomph.patch
linux-next.patch

