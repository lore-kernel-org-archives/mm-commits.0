Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10184188A0E
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011046; cv=none; b=AOcjF34j9SNC+L1ToVv43TO/WeOu+pAPrRxw/E7tnbEVpXTZU8x2MlK4hjKa43h5qhp4c8R9ZxcJSYab6jjifvhcoi84POR66QMHY/Od5wGIa1/U9wq2t4gdUf/s+KE8M8O1TIgQ7UpMCIMOxWBcKmvyKfGADRSd7cf7eYvUd+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011046; c=relaxed/simple;
	bh=QOhV5m7TCCwVySNMLOEswqflUySPXYcDXk0QPnmKPAI=;
	h=Date:To:From:Subject:Message-Id; b=LGYjlZh5DyfYcdwbCJk2p0pwGuqo/MsFrZy+xoCTgPiMGYKwgpUsDBrflG0LCH00m/auFiO3Gp6cIQvz+LhSs6sCd9aVx6exj5S+cMftb7YiuBE00jY/x0FA+s1xxeB++64BIBcWjbuf0ej3kkv0RGRJR6ssqzGaHZcXFilP9uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QBYO0OLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QBYO0OLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41ACC4CEE4;
	Mon, 12 May 2025 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011045;
	bh=QOhV5m7TCCwVySNMLOEswqflUySPXYcDXk0QPnmKPAI=;
	h=Date:To:From:Subject:From;
	b=QBYO0OLCLeHXnPCLb2Tla0CLg9k0XA9x82+MCnqKMYbuo9/8EVnwQYx3YgoBOYXCH
	 wHlm2GjsUGr2QZ7e03SBtD/pw3yuAhlM9faHINLDN1ciShjzQ0J2DcfDbcf1dgf/Bo
	 mr2B5XPwQel/UwjTYLqTVUvOABNQ5wGTbFA357BM=
Date: Sun, 11 May 2025 17:50:45 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vapier@gentoo.org,tglx@linutronix.de,svens@linux.ibm.com,stefan.kristiansson@saunalahti.fi,shuah@kernel.org,shorne@gmail.com,richard@nod.at,renzo@cs.unibo.it,oleg@redhat.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,maddy@linux.ibm.com,macro@orcam.me.uk,linux@armlinux.org.uk,legion@kernel.org,kernel@xen0n.name,jonas@southpole.se,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,evgsyr@gmail.com,esyr@redhat.com,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,charlie@rivosinc.com,bp@alien8.de,borntraeger@linux.ibm.com,berardi.dav@gmail.com,bcain@quicinc.com,arnd@arndb.de,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,ldv@strace.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op.patch removed from -mm tree
Message-Id: <20250512005045.D41ACC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ptrace_get_syscall_info: factor out ptrace_get_syscall_info_op
has been removed from the -mm tree.  Its filename was
     ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Dmitry V. Levin" <ldv@strace.io>
Subject: ptrace_get_syscall_info: factor out ptrace_get_syscall_info_op
Date: Mon, 3 Mar 2025 13:20:38 +0200

Move the code that calculates the type of the system call stop out of
ptrace_get_syscall_info() into a separate function
ptrace_get_syscall_info_op() which is going to be used later to implement
PTRACE_SET_SYSCALL_INFO API.

Link: https://lkml.kernel.org/r/20250303112038.GE24170@strace.io
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexey Gladkov (Intel) <legion@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: anton ivanov <anton.ivanov@cambridgegreys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
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
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
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

 kernel/ptrace.c |   58 ++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

--- a/kernel/ptrace.c~ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op
+++ a/kernel/ptrace.c
@@ -921,7 +921,6 @@ ptrace_get_syscall_info_entry(struct tas
 	unsigned long args[ARRAY_SIZE(info->entry.args)];
 	int i;
 
-	info->op = PTRACE_SYSCALL_INFO_ENTRY;
 	info->entry.nr = syscall_get_nr(child, regs);
 	syscall_get_arguments(child, regs, args);
 	for (i = 0; i < ARRAY_SIZE(args); i++)
@@ -943,7 +942,6 @@ ptrace_get_syscall_info_seccomp(struct t
 	 * diverge significantly enough.
 	 */
 	ptrace_get_syscall_info_entry(child, regs, info);
-	info->op = PTRACE_SYSCALL_INFO_SECCOMP;
 	info->seccomp.ret_data = child->ptrace_message;
 
 	/* ret_data is the last field in struct ptrace_syscall_info.seccomp */
@@ -954,7 +952,6 @@ static unsigned long
 ptrace_get_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
 			     struct ptrace_syscall_info *info)
 {
-	info->op = PTRACE_SYSCALL_INFO_EXIT;
 	info->exit.rval = syscall_get_error(child, regs);
 	info->exit.is_error = !!info->exit.rval;
 	if (!info->exit.is_error)
@@ -965,19 +962,8 @@ ptrace_get_syscall_info_exit(struct task
 }
 
 static int
-ptrace_get_syscall_info(struct task_struct *child, unsigned long user_size,
-			void __user *datavp)
+ptrace_get_syscall_info_op(struct task_struct *child)
 {
-	struct pt_regs *regs = task_pt_regs(child);
-	struct ptrace_syscall_info info = {
-		.op = PTRACE_SYSCALL_INFO_NONE,
-		.arch = syscall_get_arch(child),
-		.instruction_pointer = instruction_pointer(regs),
-		.stack_pointer = user_stack_pointer(regs),
-	};
-	unsigned long actual_size = offsetof(struct ptrace_syscall_info, entry);
-	unsigned long write_size;
-
 	/*
 	 * This does not need lock_task_sighand() to access
 	 * child->last_siginfo because ptrace_freeze_traced()
@@ -988,18 +974,42 @@ ptrace_get_syscall_info(struct task_stru
 	case SIGTRAP | 0x80:
 		switch (child->ptrace_message) {
 		case PTRACE_EVENTMSG_SYSCALL_ENTRY:
-			actual_size = ptrace_get_syscall_info_entry(child, regs,
-								    &info);
-			break;
+			return PTRACE_SYSCALL_INFO_ENTRY;
 		case PTRACE_EVENTMSG_SYSCALL_EXIT:
-			actual_size = ptrace_get_syscall_info_exit(child, regs,
-								   &info);
-			break;
+			return PTRACE_SYSCALL_INFO_EXIT;
+		default:
+			return PTRACE_SYSCALL_INFO_NONE;
 		}
-		break;
 	case SIGTRAP | (PTRACE_EVENT_SECCOMP << 8):
-		actual_size = ptrace_get_syscall_info_seccomp(child, regs,
-							      &info);
+		return PTRACE_SYSCALL_INFO_SECCOMP;
+	default:
+		return PTRACE_SYSCALL_INFO_NONE;
+	}
+}
+
+static int
+ptrace_get_syscall_info(struct task_struct *child, unsigned long user_size,
+			void __user *datavp)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	struct ptrace_syscall_info info = {
+		.op = ptrace_get_syscall_info_op(child),
+		.arch = syscall_get_arch(child),
+		.instruction_pointer = instruction_pointer(regs),
+		.stack_pointer = user_stack_pointer(regs),
+	};
+	unsigned long actual_size = offsetof(struct ptrace_syscall_info, entry);
+	unsigned long write_size;
+
+	switch (info.op) {
+	case PTRACE_SYSCALL_INFO_ENTRY:
+		actual_size = ptrace_get_syscall_info_entry(child, regs, &info);
+		break;
+	case PTRACE_SYSCALL_INFO_EXIT:
+		actual_size = ptrace_get_syscall_info_exit(child, regs, &info);
+		break;
+	case PTRACE_SYSCALL_INFO_SECCOMP:
+		actual_size = ptrace_get_syscall_info_seccomp(child, regs, &info);
 		break;
 	}
 
_

Patches currently in -mm which might be from ldv@strace.io are


