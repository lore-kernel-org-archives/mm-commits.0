Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964177493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vE0cJTUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611CCC433C9;
	Mon, 11 Dec 2023 01:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257814;
	bh=MncEUAXNrOx+isBtUJVzTm66Y6HkmPr872nuQguAOsU=;
	h=Date:To:From:Subject:From;
	b=vE0cJTUeZ0jH46uOGY5vYHZqY96cgGYCF+FOVuROrOjZopQogE7OFuDTnJcVR3/n4
	 E7akBL36YsK4Jx7Nu5B/EJJvENr1ekyXpE+IYv3xR5S/64ASe3eqvffoZOvVGnVpBt
	 L3GlFyZznlkpe/Hb3Ey4/j977v5vzb/ZBCYmyLAI=
Date: Sun, 10 Dec 2023 17:23:33 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-add-missing-declarations-for-trap-handlers.patch removed from -mm tree
Message-Id: <20231211012334.611CCC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: add missing declarations for trap handlers
has been removed from the -mm tree.  Its filename was
     mips-add-missing-declarations-for-trap-handlers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: add missing declarations for trap handlers
Date: Mon, 4 Dec 2023 12:56:53 +0100

These exception handlers are all called from assembly code, so they don't
normally need a declaration, but without one we now get warnings:

arch/mips/mm/fault.c:323:17: error: no previous prototype for 'do_page_fault' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:447:17: error: no previous prototype for 'do_be' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:752:17: error: no previous prototype for 'do_ov' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:874:17: error: no previous prototype for 'do_fpe' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1027:17: error: no previous prototype for 'do_bp' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1114:17: error: no previous prototype for 'do_tr' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1151:17: error: no previous prototype for 'do_ri' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1402:17: error: no previous prototype for 'do_cpu' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1507:17: error: no previous prototype for 'do_msa_fpe' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1527:17: error: no previous prototype for 'do_msa' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1548:17: error: no previous prototype for 'do_mdmx' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1560:17: error: no previous prototype for 'do_watch' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1587:17: error: no previous prototype for 'do_mcheck' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1612:17: error: no previous prototype for 'do_mt' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1648:17: error: no previous prototype for 'do_dsp' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1656:17: error: no previous prototype for 'do_reserved' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1832:17: error: no previous prototype for 'cache_parity_error' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1880:17: error: no previous prototype for 'do_ftlb' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1909:17: error: no previous prototype for 'do_gsexc' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1944:6: error: no previous prototype for 'ejtag_exception_handler' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:1989:17: error: no previous prototype for 'nmi_exception_handler' [-Werror=missing-prototypes]
arch/mips/kernel/unaligned.c:1516:17: error: no previous prototype for 'do_ade' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-4-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/traps.h |   24 ++++++++++++++++++++++++
 arch/mips/kernel/r4k-bugs64.c |    1 +
 arch/mips/kernel/unaligned.c  |    1 +
 arch/mips/mm/fault.c          |    1 +
 4 files changed, 27 insertions(+)

--- a/arch/mips/include/asm/traps.h~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/include/asm/traps.h
@@ -39,4 +39,28 @@ extern char except_vec_nmi[];
 	register_nmi_notifier(&fn##_nb);				\
 })
 
+asmlinkage void do_ade(struct pt_regs *regs);
+asmlinkage void do_be(struct pt_regs *regs);
+asmlinkage void do_ov(struct pt_regs *regs);
+asmlinkage void do_fpe(struct pt_regs *regs, unsigned long fcr31);
+asmlinkage void do_bp(struct pt_regs *regs);
+asmlinkage void do_tr(struct pt_regs *regs);
+asmlinkage void do_ri(struct pt_regs *regs);
+asmlinkage void do_cpu(struct pt_regs *regs);
+asmlinkage void do_msa_fpe(struct pt_regs *regs, unsigned int msacsr);
+asmlinkage void do_msa(struct pt_regs *regs);
+asmlinkage void do_mdmx(struct pt_regs *regs);
+asmlinkage void do_watch(struct pt_regs *regs);
+asmlinkage void do_mcheck(struct pt_regs *regs);
+asmlinkage void do_mt(struct pt_regs *regs);
+asmlinkage void do_dsp(struct pt_regs *regs);
+asmlinkage void do_reserved(struct pt_regs *regs);
+asmlinkage void do_ftlb(void);
+asmlinkage void do_gsexc(struct pt_regs *regs, u32 diag1);
+asmlinkage void do_daddi_ov(struct pt_regs *regs);
+
+asmlinkage void cache_parity_error(void);
+asmlinkage void ejtag_exception_handler(struct pt_regs *regs);
+asmlinkage void __noreturn nmi_exception_handler(struct pt_regs *regs);
+
 #endif /* _ASM_TRAPS_H */
--- a/arch/mips/kernel/r4k-bugs64.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/kernel/r4k-bugs64.c
@@ -14,6 +14,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/setup.h>
+#include <asm/traps.h>
 
 static char bug64hit[] __initdata =
 	"reliable operation impossible!\n%s";
--- a/arch/mips/kernel/unaligned.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/kernel/unaligned.c
@@ -91,6 +91,7 @@
 #include <asm/inst.h>
 #include <asm/unaligned-emul.h>
 #include <asm/mmu_context.h>
+#include <asm/traps.h>
 #include <linux/uaccess.h>
 
 #include "access-helper.h"
--- a/arch/mips/mm/fault.c~mips-add-missing-declarations-for-trap-handlers
+++ a/arch/mips/mm/fault.c
@@ -26,6 +26,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
+#include <asm/traps.h>
 #include <linux/kdebug.h>
 
 int show_unhandled_signals = 1;
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

