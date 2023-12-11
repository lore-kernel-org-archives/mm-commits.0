Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637C77493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U5t7gVDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE24C433C7;
	Mon, 11 Dec 2023 01:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257825;
	bh=T9ymeHFuJKtlzhoDO3GCdX/Po1tc0Eb1UtBlvZ2pu2o=;
	h=Date:To:From:Subject:From;
	b=U5t7gVDNu7cfCwvR2xmxxU7JXMfnM7xkhET8RZvq+jdszI/5NpDc2y7UePabSm+by
	 oJMZm9AdW8o+RimFSfDSmood+VuNDdCDhrXij4qC6Bi5mujEYlc7YpajSRSDBf+/+U
	 pIIWHSeQQUC4Y5oLStZ00aMoCMdYRc6axlTudlPo=
Date: Sun, 10 Dec 2023 17:23:44 -0800
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,sfr@rothwell.id.au,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mips-add-missing-declarations.patch removed from -mm tree
Message-Id: <20231211012345.2FE24C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: add missing declarations
has been removed from the -mm tree.  Its filename was
     mips-add-missing-declarations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mips: add missing declarations
Date: Mon, 4 Dec 2023 12:57:03 +0100

These are three more functions that are only called from assembler and
only need a declaration to avoid the -Wmissing-prototypes warnings:

arch/mips/kernel/signal.c:904:17: error: no previous prototype for 'do_notify_resume' [-Werror=missing-prototypes]
arch/mips/kernel/traps.c:370:6: error: no previous prototype for 'show_registers' [-Werror=missing-prototypes]
arch/mips/kernel/smp.c:352:17: error: no previous prototype for 'start_secondary' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20231204115710.2247097-14-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/processor.h |    2 ++
 arch/mips/include/asm/signal.h    |    1 +
 arch/mips/include/asm/smp.h       |    2 ++
 3 files changed, 5 insertions(+)

--- a/arch/mips/include/asm/processor.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/processor.h
@@ -402,4 +402,6 @@ extern int mips_set_process_fp_mode(stru
 #define GET_FP_MODE(task)		mips_get_process_fp_mode(task)
 #define SET_FP_MODE(task,value)		mips_set_process_fp_mode(task, value)
 
+void show_registers(struct pt_regs *regs);
+
 #endif /* _ASM_PROCESSOR_H */
--- a/arch/mips/include/asm/signal.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/signal.h
@@ -31,5 +31,6 @@ extern struct mips_abi mips_abi_32;
 
 extern int protected_save_fp_context(void __user *sc);
 extern int protected_restore_fp_context(void __user *sc);
+void do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags);
 
 #endif /* _ASM_SIGNAL_H */
--- a/arch/mips/include/asm/smp.h~mips-add-missing-declarations
+++ a/arch/mips/include/asm/smp.h
@@ -63,6 +63,8 @@ extern asmlinkage void smp_bootstrap(voi
 
 extern void calculate_cpu_foreign_map(void);
 
+asmlinkage void start_secondary(void);
+
 /*
  * this function sends a 'reschedule' IPI to another CPU.
  * it goes straight through and wastes no time serializing
_

Patches currently in -mm which might be from arnd@arndb.de are

kexec-fix-kexec_file-dependencies.patch
kexec-fix-kexec_file-dependencies-fix.patch
kexec-select-crypto-from-kexec_file-instead-of-depending-on-it.patch
makefileextrawarn-turn-on-missing-prototypes-globally.patch

