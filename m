From: akpm@linux-foundation.org
Subject: + mm-move-randomize_et_dyn-into-elf_et_dyn_base.patch added to
 -mm tree
Date: Mon, 02 Mar 2015 13:27:12 -0800
Message-ID: <54f4d5b0.VEXVSIdE6Y8QEDUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbbCBV1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 16:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.ryabinin@samsung.com, achandran@mvista.com, alex@alex-smith.me.uk, behanw@converseincode.com, ben@decadent.org.uk, benh@kernel.crashing.org, catalin.marinas@arm.com, dave.long@linaro.org, dl9pf@gmx.de, hecmargi@upv.es, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, iripoll@upv.es, jeffbailey@google.com, linux@arm.linux.org.uk, luto@amacapital.net, markos.chandras@imgtec.com, mingo@elte.hu, mpe@ellerman.id.au, oleg@redhat.com, orca.chen@gmail.com, paul.burton@imgtec.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, vvijayan@mvista.com, will.deacon@arm.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move randomize_et_dyn into ELF_ET_DYN_BASE
has been added to the -mm tree.  Its filename is
     mm-move-randomize_et_dyn-into-elf_et_dyn_base.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-randomize_et_dyn-into-elf_et_dyn_base.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-randomize_et_dyn-into-elf_et_dyn_base.patch

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
Subject: mm: move randomize_et_dyn into ELF_ET_DYN_BASE

This moves s390's randomize_et_dyn base into ELF_ET_DYN_BASE, and removes
an unused arm64 extern.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Arun Chandran <achandran@mvista.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Min-Hua Chen <orca.chen@gmail.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Alex Smith <alex@alex-smith.me.uk>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Cc: Vineeth Vijayan <vvijayan@mvista.com>
Cc: Jeff Bailey <jeffbailey@google.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Behan Webster <behanw@converseincode.com>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Jan-Simon Mller <dl9pf@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/elf.h |    1 -
 arch/s390/include/asm/elf.h  |    9 +++++----
 arch/s390/mm/mmap.c          |   11 -----------
 3 files changed, 5 insertions(+), 16 deletions(-)

diff -puN arch/arm64/include/asm/elf.h~mm-move-randomize_et_dyn-into-elf_et_dyn_base arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~mm-move-randomize_et_dyn-into-elf_et_dyn_base
+++ a/arch/arm64/include/asm/elf.h
@@ -125,7 +125,6 @@ typedef struct user_fpsimd_state elf_fpr
  * the loader.  We need to make sure that it is out of the way of the program
  * that it will "exec", and that there is sufficient room for the brk.
  */
-extern unsigned long randomize_et_dyn(unsigned long base);
 #define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
 
 /*
diff -puN arch/s390/include/asm/elf.h~mm-move-randomize_et_dyn-into-elf_et_dyn_base arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~mm-move-randomize_et_dyn-into-elf_et_dyn_base
+++ a/arch/s390/include/asm/elf.h
@@ -161,10 +161,11 @@ extern unsigned int vdso_enabled;
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-extern unsigned long randomize_et_dyn(void);
-#define ELF_ET_DYN_BASE		randomize_et_dyn()
+   that it will "exec", and that there is sufficient room for the brk. 64-bit
+   tasks are aligned to 4GB. */
+#define ELF_ET_DYN_BASE (arch_mmap_rnd() + (is_32bit_task() ? \
+				(STACK_TOP / 3 * 2) : \
+				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1)))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
diff -puN arch/s390/mm/mmap.c~mm-move-randomize_et_dyn-into-elf_et_dyn_base arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~mm-move-randomize_et_dyn-into-elf_et_dyn_base
+++ a/arch/s390/mm/mmap.c
@@ -179,17 +179,6 @@ arch_get_unmapped_area_topdown(struct fi
 	return addr;
 }
 
-unsigned long randomize_et_dyn(void)
-{
-	unsigned long base;
-
-	base = STACK_TOP / 3 * 2;
-	if (!is_32bit_task())
-		/* Align to 4GB */
-		base &= ~((1UL << 32) - 1);
-	return base + arch_mmap_rnd();
-}
