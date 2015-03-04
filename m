From: akpm@linux-foundation.org
Subject: + s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch added
 to -mm tree
Date: Wed, 04 Mar 2015 13:40:23 -0800
Message-ID: <54f77bc7.HcMX6bctgPp77C7/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbbCDVkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, heiko.carstens@de.ibm.com, mingo@kernel.org, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: redefine randomize_et_dyn for ELF_ET_DYN_BASE
has been added to the -mm tree.  Its filename is
     s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch

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
Subject: s390: redefine randomize_et_dyn for ELF_ET_DYN_BASE

In preparation for moving ET_DYN randomization into the ELF loader (which
requires a static ELF_ET_DYN_BASE), this redefines s390's existing ET_DYN
randomization in a call to arch_mmap_rnd(). This refactoring results in
the same ET_DYN randomization on s390.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
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

