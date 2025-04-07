Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEC9225D7
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743989492; cv=none; b=M4FjF0Pw4xzEEaenhGZSdvdAjIinHZTfTN4iNaAUfuedVEahLwRoMjmZuP9NWRUC9gQjV6rlK8yDWGCVJNGHxViFbTtYOAv+eKLWQBysix3OIqTR9qLZZAee+6qoEjUojWJpS8yey/BArVe/uCqKEu2YfNyNQ7Clb3bzoNeJVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743989492; c=relaxed/simple;
	bh=LYZP7fXJE5p+au7cTzLt6nLTtOXtnGNy4pyea7Hc5/Q=;
	h=Date:To:From:Subject:Message-Id; b=FYKuQo3jiVqGJsvsqCAYc1brDo8ZiHKkagrcSjq1C3RP7l0DyVcy8ijsdqFBEmb45SlulLdPl8jdrXa8ZiQPndN4QKtd0DVuul2U3DCD6MToFDwjz8Nvq/oSz6OKwtnSnP24eXzcEn5VcXSdUYgsN9BVpn5SyHYhQuFVbKToEM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AM+oMGbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AM+oMGbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D195C4CEE3;
	Mon,  7 Apr 2025 01:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743989492;
	bh=LYZP7fXJE5p+au7cTzLt6nLTtOXtnGNy4pyea7Hc5/Q=;
	h=Date:To:From:Subject:From;
	b=AM+oMGbZctQ3Q8w98hV2OOo2g6R/lCMdWiumbGoN+iGE0bGO0G6kTkRIdr9XBvAlH
	 EXkTIc8QJD+Rklj1u6uox4tjhdIefS1KM/DnfHc0BMRCD2n0lnzdiSas7UxP4yKtGP
	 ytayfuLAqAEMgMiMTPgDfTj91jZvtl0CCHwU5xu8=
Date: Sun, 06 Apr 2025 18:31:31 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vapier@gentoo.org,tglx@linutronix.de,svens@linux.ibm.com,stefan.kristiansson@saunalahti.fi,shuah@kernel.org,shorne@gmail.com,richard@nod.at,renzo@cs.unibo.it,oleg@redhat.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,maddy@linux.ibm.com,macro@orcam.me.uk,linux@armlinux.org.uk,legion@kernel.org,kernel@xen0n.name,jonas@southpole.se,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,evgsyr@gmail.com,esyr@redhat.com,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,charlie@rivosinc.com,bp@alien8.de,borntraeger@linux.ibm.com,berardi.dav@gmail.com,bcain@quicinc.com,arnd@arndb.de,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,ldv@strace.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + syscallh-introduce-syscall_set_nr.patch added to mm-new branch
Message-Id: <20250407013132.1D195C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: syscall.h: introduce syscall_set_nr()
has been added to the -mm mm-new branch.  Its filename is
     syscallh-introduce-syscall_set_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/syscallh-introduce-syscall_set_nr.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Dmitry V. Levin" <ldv@strace.io>
Subject: syscall.h: introduce syscall_set_nr()
Date: Mon, 3 Mar 2025 13:20:20 +0200

Similar to syscall_set_arguments() that complements
syscall_get_arguments(), introduce syscall_set_nr() that complements
syscall_get_nr().

syscall_set_nr() is going to be needed along with syscall_set_arguments()
on all HAVE_ARCH_TRACEHOOK architectures to implement
PTRACE_SET_SYSCALL_INFO API.

Link: https://lkml.kernel.org/r/20250303112020.GD24170@strace.io
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Acked-by: Helge Deller <deller@gmx.de> # parisc
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk> # mips
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexey Gladkov (Intel) <legion@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: anton ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Zankel <chris@zankel.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davide Berardi <berardi.dav@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Eugene Syromyatnikov <evgsyr@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Renzo Davoi <renzo@cs.unibo.it>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/syscall.h        |   11 +++++++++++
 arch/arm/include/asm/syscall.h        |   24 ++++++++++++++++++++++++
 arch/arm64/include/asm/syscall.h      |   16 ++++++++++++++++
 arch/hexagon/include/asm/syscall.h    |    7 +++++++
 arch/loongarch/include/asm/syscall.h  |    7 +++++++
 arch/m68k/include/asm/syscall.h       |    7 +++++++
 arch/microblaze/include/asm/syscall.h |    7 +++++++
 arch/mips/include/asm/syscall.h       |   15 +++++++++++++++
 arch/nios2/include/asm/syscall.h      |    5 +++++
 arch/openrisc/include/asm/syscall.h   |    6 ++++++
 arch/parisc/include/asm/syscall.h     |    7 +++++++
 arch/powerpc/include/asm/syscall.h    |   10 ++++++++++
 arch/riscv/include/asm/syscall.h      |    7 +++++++
 arch/s390/include/asm/syscall.h       |   12 ++++++++++++
 arch/sh/include/asm/syscall_32.h      |   12 ++++++++++++
 arch/sparc/include/asm/syscall.h      |   12 ++++++++++++
 arch/um/include/asm/syscall-generic.h |    5 +++++
 arch/x86/include/asm/syscall.h        |    7 +++++++
 arch/xtensa/include/asm/syscall.h     |    7 +++++++
 include/asm-generic/syscall.h         |   14 ++++++++++++++
 20 files changed, 198 insertions(+)

--- a/arch/arc/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/arc/include/asm/syscall.h
@@ -24,6 +24,17 @@ syscall_get_nr(struct task_struct *task,
 }
 
 static inline void
+syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr)
+{
+	/*
+	 * Unlike syscall_get_nr(), syscall_set_nr() can be called only when
+	 * the target task is stopped for tracing on entering syscall, so
+	 * there is no need to have the same check syscall_get_nr() has.
+	 */
+	regs->r8 = nr;
+}
+
+static inline void
 syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
 	regs->r0 = regs->orig_r0;
--- a/arch/arm64/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/arm64/include/asm/syscall.h
@@ -61,6 +61,22 @@ static inline void syscall_set_return_va
 	regs->regs[0] = val;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->syscallno = nr;
+	if (nr == -1) {
+		/*
+		 * When the syscall number is set to -1, the syscall will be
+		 * skipped.  In this case the syscall return value has to be
+		 * set explicitly, otherwise the first syscall argument is
+		 * returned as the syscall return value.
+		 */
+		syscall_set_return_value(task, regs, -ENOSYS, 0);
+	}
+}
+
 #define SYSCALL_MAX_ARGS 6
 
 static inline void syscall_get_arguments(struct task_struct *task,
--- a/arch/arm/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/arm/include/asm/syscall.h
@@ -68,6 +68,30 @@ static inline void syscall_set_return_va
 	regs->ARM_r0 = (long) error ? error : val;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	if (nr == -1) {
+		task_thread_info(task)->abi_syscall = -1;
+		/*
+		 * When the syscall number is set to -1, the syscall will be
+		 * skipped.  In this case the syscall return value has to be
+		 * set explicitly, otherwise the first syscall argument is
+		 * returned as the syscall return value.
+		 */
+		syscall_set_return_value(task, regs, -ENOSYS, 0);
+		return;
+	}
+	if ((IS_ENABLED(CONFIG_AEABI) && !IS_ENABLED(CONFIG_OABI_COMPAT))) {
+		task_thread_info(task)->abi_syscall = nr;
+		return;
+	}
+	task_thread_info(task)->abi_syscall =
+		(task_thread_info(task)->abi_syscall & ~__NR_SYSCALL_MASK) |
+		(nr & __NR_SYSCALL_MASK);
+}
+
 #define SYSCALL_MAX_ARGS 7
 
 static inline void syscall_get_arguments(struct task_struct *task,
--- a/arch/hexagon/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/hexagon/include/asm/syscall.h
@@ -26,6 +26,13 @@ static inline long syscall_get_nr(struct
 	return regs->r06;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->r06 = nr;
+}
+
 static inline void syscall_get_arguments(struct task_struct *task,
 					 struct pt_regs *regs,
 					 unsigned long *args)
--- a/arch/loongarch/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/loongarch/include/asm/syscall.h
@@ -26,6 +26,13 @@ static inline long syscall_get_nr(struct
 	return regs->regs[11];
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->regs[11] = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/m68k/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/m68k/include/asm/syscall.h
@@ -14,6 +14,13 @@ static inline int syscall_get_nr(struct
 	return regs->orig_d0;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->orig_d0 = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/microblaze/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/microblaze/include/asm/syscall.h
@@ -14,6 +14,13 @@ static inline long syscall_get_nr(struct
 	return regs->r12;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->r12 = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/mips/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/mips/include/asm/syscall.h
@@ -41,6 +41,21 @@ static inline long syscall_get_nr(struct
 	return task_thread_info(task)->syscall;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	/*
+	 * New syscall number has to be assigned to regs[2] because
+	 * it is loaded from there unconditionally after return from
+	 * syscall_trace_enter() invocation.
+	 *
+	 * Consequently, if the syscall was indirect and nr != __NR_syscall,
+	 * then after this assignment the syscall will cease to be indirect.
+	 */
+	task_thread_info(task)->syscall = regs->regs[2] = nr;
+}
+
 static inline void mips_syscall_update_nr(struct task_struct *task,
 					  struct pt_regs *regs)
 {
--- a/arch/nios2/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/nios2/include/asm/syscall.h
@@ -15,6 +15,11 @@ static inline int syscall_get_nr(struct
 	return regs->r2;
 }
 
+static inline void syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr)
+{
+	regs->r2 = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				struct pt_regs *regs)
 {
--- a/arch/openrisc/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/openrisc/include/asm/syscall.h
@@ -26,6 +26,12 @@ syscall_get_nr(struct task_struct *task,
 }
 
 static inline void
+syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr)
+{
+	regs->orig_gpr11 = nr;
+}
+
+static inline void
 syscall_rollback(struct task_struct *task, struct pt_regs *regs)
 {
 	regs->gpr[11] = regs->orig_gpr11;
--- a/arch/parisc/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/parisc/include/asm/syscall.h
@@ -17,6 +17,13 @@ static inline long syscall_get_nr(struct
 	return regs->gr[20];
 }
 
+static inline void syscall_set_nr(struct task_struct *tsk,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->gr[20] = nr;
+}
+
 static inline void syscall_get_arguments(struct task_struct *tsk,
 					 struct pt_regs *regs,
 					 unsigned long *args)
--- a/arch/powerpc/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/powerpc/include/asm/syscall.h
@@ -39,6 +39,16 @@ static inline int syscall_get_nr(struct
 		return -1;
 }
 
+static inline void syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr)
+{
+	/*
+	 * Unlike syscall_get_nr(), syscall_set_nr() can be called only when
+	 * the target task is stopped for tracing on entering syscall, so
+	 * there is no need to have the same check syscall_get_nr() has.
+	 */
+	regs->gpr[0] = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/riscv/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/riscv/include/asm/syscall.h
@@ -30,6 +30,13 @@ static inline int syscall_get_nr(struct
 	return regs->a7;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->a7 = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/s390/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/s390/include/asm/syscall.h
@@ -24,6 +24,18 @@ static inline long syscall_get_nr(struct
 		(regs->int_code & 0xffff) : -1;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	/*
+	 * Unlike syscall_get_nr(), syscall_set_nr() can be called only when
+	 * the target task is stopped for tracing on entering syscall, so
+	 * there is no need to have the same check syscall_get_nr() has.
+	 */
+	regs->int_code = (regs->int_code & ~0xffff) | (nr & 0xffff);
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/sh/include/asm/syscall_32.h~syscallh-introduce-syscall_set_nr
+++ a/arch/sh/include/asm/syscall_32.h
@@ -15,6 +15,18 @@ static inline long syscall_get_nr(struct
 	return (regs->tra >= 0) ? regs->regs[3] : -1L;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	/*
+	 * Unlike syscall_get_nr(), syscall_set_nr() can be called only when
+	 * the target task is stopped for tracing on entering syscall, so
+	 * there is no need to have the same check syscall_get_nr() has.
+	 */
+	regs->regs[3] = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/sparc/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/sparc/include/asm/syscall.h
@@ -25,6 +25,18 @@ static inline long syscall_get_nr(struct
 	return (syscall_p ? regs->u_regs[UREG_G1] : -1L);
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	/*
+	 * Unlike syscall_get_nr(), syscall_set_nr() can be called only when
+	 * the target task is stopped for tracing on entering syscall, so
+	 * there is no need to have the same check syscall_get_nr() has.
+	 */
+	regs->u_regs[UREG_G1] = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/um/include/asm/syscall-generic.h~syscallh-introduce-syscall_set_nr
+++ a/arch/um/include/asm/syscall-generic.h
@@ -21,6 +21,11 @@ static inline int syscall_get_nr(struct
 	return PT_REGS_SYSCALL_NR(regs);
 }
 
+static inline void syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr)
+{
+	PT_REGS_SYSCALL_NR(regs) = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/x86/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/x86/include/asm/syscall.h
@@ -38,6 +38,13 @@ static inline int syscall_get_nr(struct
 	return regs->orig_ax;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->orig_ax = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/arch/xtensa/include/asm/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/arch/xtensa/include/asm/syscall.h
@@ -28,6 +28,13 @@ static inline long syscall_get_nr(struct
 	return regs->syscall;
 }
 
+static inline void syscall_set_nr(struct task_struct *task,
+				  struct pt_regs *regs,
+				  int nr)
+{
+	regs->syscall = nr;
+}
+
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
--- a/include/asm-generic/syscall.h~syscallh-introduce-syscall_set_nr
+++ a/include/asm-generic/syscall.h
@@ -38,6 +38,20 @@ struct pt_regs;
 int syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
 
 /**
+ * syscall_set_nr - change the system call a task is executing
+ * @task:	task of interest, must be blocked
+ * @regs:	task_pt_regs() of @task
+ * @nr:		system call number
+ *
+ * Changes the system call number @task is about to execute.
+ *
+ * It's only valid to call this when @task is stopped for tracing on
+ * entry to a system call, due to %SYSCALL_WORK_SYSCALL_TRACE or
+ * %SYSCALL_WORK_SYSCALL_AUDIT.
+ */
+void syscall_set_nr(struct task_struct *task, struct pt_regs *regs, int nr);
+
+/**
  * syscall_rollback - roll back registers after an aborted system call
  * @task:	task of interest, must be in system call exit tracing
  * @regs:	task_pt_regs() of @task
_

Patches currently in -mm which might be from ldv@strace.io are

hexagon-add-syscall_set_return_value.patch
syscallh-add-syscall_set_arguments.patch
syscallh-introduce-syscall_set_nr.patch
ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op.patch
ptrace-introduce-ptrace_set_syscall_info-request.patch
selftests-ptrace-add-a-test-case-for-ptrace_set_syscall_info.patch

