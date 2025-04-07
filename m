Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12B32744D
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743989505; cv=none; b=pBfz8XXb4ob2ZXphrk7dxwkOS0LtAK3uvoVODa2Z7ynC6dEt/e/k5dWJ1+Sf8MU5aGLk1JVgw5gNrXE9r1xh+Ck/Te+gpJFV1Re2lL/AWlUVJKfPVfkE2GG4O8+UEIAGNFSuUjpe8iOEW6xqm4vs0pDgrf10CjJE1ft9JVFzaAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743989505; c=relaxed/simple;
	bh=4JoekJscsdt+7jjHxIja1JGAgFFhFNKmPe/tyIuxQmM=;
	h=Date:To:From:Subject:Message-Id; b=e1ia3zXbMjybq2SytbYtSJ2sny9IaAJyfFA2868P/AkMQdgu0YuHM6Nvjw8Pglp6gscjaglCsNU4w9rauQZhCRsi5zWwtTdCTGnx2MZIEJSlS6I/FkT1TLCpUycZOnpeQFwIrre5UHeqE9IoRgz1UYMv2XjRDVHT5YEJASHzHJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OxNebagp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxNebagp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0C1C4CEE3;
	Mon,  7 Apr 2025 01:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743989505;
	bh=4JoekJscsdt+7jjHxIja1JGAgFFhFNKmPe/tyIuxQmM=;
	h=Date:To:From:Subject:From;
	b=OxNebagp925EIt22Hf5ggaOfPFtwO1yeVwP0u3nzm8vIAfuF7W0E1DVPr54++yxmT
	 ra/vWPQfdTtNVqKNAviabml9JykRXWWEjF/H58lilcLqWbp8E3P4G6RDxBd1y+dnS3
	 CW6gMaiLrbgTkwxoTrRZfHOJAZWbFGeUNagR+t68=
Date: Sun, 06 Apr 2025 18:31:44 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vapier@gentoo.org,tglx@linutronix.de,svens@linux.ibm.com,stefan.kristiansson@saunalahti.fi,shuah@kernel.org,shorne@gmail.com,richard@nod.at,renzo@cs.unibo.it,oleg@redhat.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,maddy@linux.ibm.com,macro@orcam.me.uk,linux@armlinux.org.uk,legion@kernel.org,kernel@xen0n.name,jonas@southpole.se,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,evgsyr@gmail.com,esyr@redhat.com,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,charlie@rivosinc.com,bp@alien8.de,borntraeger@linux.ibm.com,berardi.dav@gmail.com,bcain@quicinc.com,arnd@arndb.de,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,ldv@strace.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ptrace-introduce-ptrace_set_syscall_info-request.patch added to mm-new branch
Message-Id: <20250407013144.EE0C1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ptrace: introduce PTRACE_SET_SYSCALL_INFO request
has been added to the -mm mm-new branch.  Its filename is
     ptrace-introduce-ptrace_set_syscall_info-request.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptrace-introduce-ptrace_set_syscall_info-request.patch

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
Subject: ptrace: introduce PTRACE_SET_SYSCALL_INFO request
Date: Mon, 3 Mar 2025 13:20:44 +0200

PTRACE_SET_SYSCALL_INFO is a generic ptrace API that complements
PTRACE_GET_SYSCALL_INFO by letting the ptracer modify details of system
calls the tracee is blocked in.

This API allows ptracers to obtain and modify system call details in a
straightforward and architecture-agnostic way, providing a consistent way
of manipulating the system call number and arguments across architectures.

As in case of PTRACE_GET_SYSCALL_INFO, PTRACE_SET_SYSCALL_INFO also does
not aim to address numerous architecture-specific system call ABI
peculiarities, like differences in the number of system call arguments for
such system calls as pread64 and preadv.

The current implementation supports changing only those bits of system
call information that are used by strace system call tampering, namely,
syscall number, syscall arguments, and syscall return value.

Support of changing additional details returned by
PTRACE_GET_SYSCALL_INFO, such as instruction pointer and stack pointer,
could be added later if needed, by using struct ptrace_syscall_info.flags
to specify the additional details that should be set.  Currently, "flags"
and "reserved" fields of struct ptrace_syscall_info must be initialized
with zeroes; "arch", "instruction_pointer", and "stack_pointer" fields are
currently ignored.

PTRACE_SET_SYSCALL_INFO currently supports only PTRACE_SYSCALL_INFO_ENTRY,
PTRACE_SYSCALL_INFO_EXIT, and PTRACE_SYSCALL_INFO_SECCOMP operations. 
Other operations could be added later if needed.

Ideally, PTRACE_SET_SYSCALL_INFO should have been introduced along with
PTRACE_GET_SYSCALL_INFO, but it didn't happen.  The last straw that
convinced me to implement PTRACE_SET_SYSCALL_INFO was apparent failure to
provide an API of changing the first system call argument on riscv
architecture.

ptrace(2) man page:

long ptrace(enum __ptrace_request request, pid_t pid, void *addr, void *data);
...
PTRACE_SET_SYSCALL_INFO
       Modify information about the system call that caused the stop.
       The "data" argument is a pointer to struct ptrace_syscall_info
       that specifies the system call information to be set.
       The "addr" argument should be set to sizeof(struct ptrace_syscall_info)).

Link: https://lore.kernel.org/all/59505464-c84a-403d-972f-d4b2055eeaac@gmail.com/
Link: https://lkml.kernel.org/r/20250303112044.GF24170@strace.io
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Eugene Syromiatnikov <esyr@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 include/uapi/linux/ptrace.h |    7 +
 kernel/ptrace.c             |  121 +++++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/ptrace.h~ptrace-introduce-ptrace_set_syscall_info-request
+++ a/include/uapi/linux/ptrace.h
@@ -74,6 +74,7 @@ struct seccomp_metadata {
 };
 
 #define PTRACE_GET_SYSCALL_INFO		0x420e
+#define PTRACE_SET_SYSCALL_INFO		0x4212
 #define PTRACE_SYSCALL_INFO_NONE	0
 #define PTRACE_SYSCALL_INFO_ENTRY	1
 #define PTRACE_SYSCALL_INFO_EXIT	2
@@ -81,7 +82,8 @@ struct seccomp_metadata {
 
 struct ptrace_syscall_info {
 	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
-	__u8 pad[3];
+	__u8 reserved;
+	__u16 flags;
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 stack_pointer;
@@ -98,6 +100,7 @@ struct ptrace_syscall_info {
 			__u64 nr;
 			__u64 args[6];
 			__u32 ret_data;
+			__u32 reserved2;
 		} seccomp;
 	};
 };
@@ -142,6 +145,8 @@ struct ptrace_sud_config {
 	__u64 len;
 };
 
+/* 0x4212 is PTRACE_SET_SYSCALL_INFO */
+
 /*
  * These values are stored in task->ptrace_message
  * by ptrace_stop to describe the current syscall-stop.
--- a/kernel/ptrace.c~ptrace-introduce-ptrace_set_syscall_info-request
+++ a/kernel/ptrace.c
@@ -944,7 +944,10 @@ ptrace_get_syscall_info_seccomp(struct t
 	ptrace_get_syscall_info_entry(child, regs, info);
 	info->seccomp.ret_data = child->ptrace_message;
 
-	/* ret_data is the last field in struct ptrace_syscall_info.seccomp */
+	/*
+	 * ret_data is the last non-reserved field
+	 * in struct ptrace_syscall_info.seccomp
+	 */
 	return offsetofend(struct ptrace_syscall_info, seccomp.ret_data);
 }
 
@@ -1016,6 +1019,118 @@ ptrace_get_syscall_info(struct task_stru
 	write_size = min(actual_size, user_size);
 	return copy_to_user(datavp, &info, write_size) ? -EFAULT : actual_size;
 }
+
+static int
+ptrace_set_syscall_info_entry(struct task_struct *child, struct pt_regs *regs,
+			      struct ptrace_syscall_info *info)
+{
+	unsigned long args[ARRAY_SIZE(info->entry.args)];
+	int nr = info->entry.nr;
+	int i;
+
+	/*
+	 * Check that the syscall number specified in info->entry.nr
+	 * is either a value of type "int" or a sign-extended value
+	 * of type "int".
+	 */
+	if (nr != info->entry.nr)
+		return -ERANGE;
+
+	for (i = 0; i < ARRAY_SIZE(args); i++) {
+		args[i] = info->entry.args[i];
+		/*
+		 * Check that the syscall argument specified in
+		 * info->entry.args[i] is either a value of type
+		 * "unsigned long" or a sign-extended value of type "long".
+		 */
+		if (args[i] != info->entry.args[i])
+			return -ERANGE;
+	}
+
+	syscall_set_nr(child, regs, nr);
+	/*
+	 * If the syscall number is set to -1, setting syscall arguments is not
+	 * just pointless, it would also clobber the syscall return value on
+	 * those architectures that share the same register both for the first
+	 * argument of syscall and its return value.
+	 */
+	if (nr != -1)
+		syscall_set_arguments(child, regs, args);
+
+	return 0;
+}
+
+static int
+ptrace_set_syscall_info_seccomp(struct task_struct *child, struct pt_regs *regs,
+				struct ptrace_syscall_info *info)
+{
+	/*
+	 * info->entry is currently a subset of info->seccomp,
+	 * info->seccomp.ret_data is currently ignored.
+	 */
+	return ptrace_set_syscall_info_entry(child, regs, info);
+}
+
+static int
+ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
+			     struct ptrace_syscall_info *info)
+{
+	long rval = info->exit.rval;
+
+	/*
+	 * Check that the return value specified in info->exit.rval
+	 * is either a value of type "long" or a sign-extended value
+	 * of type "long".
+	 */
+	if (rval != info->exit.rval)
+		return -ERANGE;
+
+	if (info->exit.is_error)
+		syscall_set_return_value(child, regs, rval, 0);
+	else
+		syscall_set_return_value(child, regs, 0, rval);
+
+	return 0;
+}
+
+static int
+ptrace_set_syscall_info(struct task_struct *child, unsigned long user_size,
+			const void __user *datavp)
+{
+	struct pt_regs *regs = task_pt_regs(child);
+	struct ptrace_syscall_info info;
+
+	if (user_size < sizeof(info))
+		return -EINVAL;
+
+	/*
+	 * The compatibility is tracked by info.op and info.flags: if user-space
+	 * does not instruct us to use unknown extra bits from future versions
+	 * of ptrace_syscall_info, we are not going to read them either.
+	 */
+	if (copy_from_user(&info, datavp, sizeof(info)))
+		return -EFAULT;
+
+	/* Reserved for future use. */
+	if (info.flags || info.reserved)
+		return -EINVAL;
+
+	/* Changing the type of the system call stop is not supported yet. */
+	if (ptrace_get_syscall_info_op(child) != info.op)
+		return -EINVAL;
+
+	switch (info.op) {
+	case PTRACE_SYSCALL_INFO_ENTRY:
+		return ptrace_set_syscall_info_entry(child, regs, &info);
+	case PTRACE_SYSCALL_INFO_EXIT:
+		return ptrace_set_syscall_info_exit(child, regs, &info);
+	case PTRACE_SYSCALL_INFO_SECCOMP:
+		return ptrace_set_syscall_info_seccomp(child, regs, &info);
+	default:
+		/* Other types of system call stops are not supported yet. */
+		return -EINVAL;
+	}
+}
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
 int ptrace_request(struct task_struct *child, long request,
@@ -1234,6 +1349,10 @@ int ptrace_request(struct task_struct *c
 	case PTRACE_GET_SYSCALL_INFO:
 		ret = ptrace_get_syscall_info(child, addr, datavp);
 		break;
+
+	case PTRACE_SET_SYSCALL_INFO:
+		ret = ptrace_set_syscall_info(child, addr, datavp);
+		break;
 #endif
 
 	case PTRACE_SECCOMP_GET_FILTER:
_

Patches currently in -mm which might be from ldv@strace.io are

hexagon-add-syscall_set_return_value.patch
syscallh-add-syscall_set_arguments.patch
syscallh-introduce-syscall_set_nr.patch
ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op.patch
ptrace-introduce-ptrace_set_syscall_info-request.patch
selftests-ptrace-add-a-test-case-for-ptrace_set_syscall_info.patch

