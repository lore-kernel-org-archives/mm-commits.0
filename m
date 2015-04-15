From: akpm@linux-foundation.org
Subject: [merged] s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:30:30 -0700
Message-ID: <552ebc56.XtNMI/XGt6Ft8iqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbDOTZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, heiko.carstens@de.ibm.com, mingo@kernel.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: redefine randomize_et_dyn for ELF_ET_DYN_BASE
has been removed from the -mm tree.  Its filename was
     s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: s390: redefine randomize_et_dyn for ELF_ET_DYN_BASE

In preparation for moving ET_DYN randomization into the ELF loader (which
requires a static ELF_ET_DYN_BASE), this redefines s390's existing ET_DYN
randomization in a call to arch_mmap_rnd(). This refactoring results in
the same ET_DYN randomization on s390.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/elf.h |    8 +++++---
 arch/s390/mm/mmap.c         |   11 ++---------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN arch/s390/include/asm/elf.h~s390-redefine-randomize_et_dyn-for-elf_et_dyn_base arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~s390-redefine-randomize_et_dyn-for-elf_et_dyn_base
+++ a/arch/s390/include/asm/elf.h
@@ -161,10 +161,12 @@ extern unsigned int vdso_enabled;
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
+   that it will "exec", and that there is sufficient room for the brk. 64-bit
+   tasks are aligned to 4GB. */
 extern unsigned long randomize_et_dyn(void);
-#define ELF_ET_DYN_BASE		randomize_et_dyn()
+#define ELF_ET_DYN_BASE (randomize_et_dyn() + (is_32bit_task() ? \
+				(STACK_TOP / 3 * 2) : \
+				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1)))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
diff -puN arch/s390/mm/mmap.c~s390-redefine-randomize_et_dyn-for-elf_et_dyn_base arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~s390-redefine-randomize_et_dyn-for-elf_et_dyn_base
+++ a/arch/s390/mm/mmap.c
@@ -179,17 +179,10 @@ arch_get_unmapped_area_topdown(struct fi
 
 unsigned long randomize_et_dyn(void)
 {
-	unsigned long base;
-
-	base = STACK_TOP / 3 * 2;
-	if (!is_32bit_task())
-		/* Align to 4GB */
-		base &= ~((1UL << 32) - 1);
-
 	if (current->flags & PF_RANDOMIZE)
-		base += arch_mmap_rnd();
+		return arch_mmap_rnd();
 
-	return base;
+	return 0UL;
 }
 
 #ifndef CONFIG_64BIT
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

