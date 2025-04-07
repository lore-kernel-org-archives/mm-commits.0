Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE9EC2EF
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743989480; cv=none; b=BF3nggW8qAYcC9zPXE+rMl2bFozwJZ0wl00qqpNaBkebxwKV3HxzLNzwJtdlLod9DP0RKoVz0C2eAFPJKe6b7HcyEi9fAVJjiMf6IPnOQwS9mJQUAVZB2TIeZMfyzH49xi7snO9EZL+cxNHNjkKeEKOz70VMTuqfIZK+DfE9Q+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743989480; c=relaxed/simple;
	bh=VweF+YOEAyMtWn902MahVjRjsyYNVIvV1ic++REmYYQ=;
	h=Date:To:From:Subject:Message-Id; b=j8fl/JCKJL3d2/XUV2FdhM/6MjHhF1v07KYjBtTAwX8mfWlGUMoM/Do6CdKsu7q46CL7fQzGS5Tqi7xGGosLESbHsEupmLvoytCIRYVPpvsL/JfZE3CXMS8VNQ9bqRuCOa816xoQXlWRjbImu5F98f2+hnoeFUTQx6kDePqmqrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZABCraAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZABCraAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484A8C4CEE3;
	Mon,  7 Apr 2025 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743989479;
	bh=VweF+YOEAyMtWn902MahVjRjsyYNVIvV1ic++REmYYQ=;
	h=Date:To:From:Subject:From;
	b=ZABCraAhy2hTFfSXjWmKOmmFIhCkJ/9GZ8DXs+hhQjMb0z4g5Cf4A9r7Adz0hQwOh
	 ZgJjeyJ/qMWoQd6MfbvqumvOWnrbjEbMi9tL5UGdVxGj0VJmTz+KYlIcLpdNnsmRAH
	 av2FfzhntTKp6ZfOvzEEapKw0aiEMDDl66nRlxLQ=
Date: Sun, 06 Apr 2025 18:31:18 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vapier@gentoo.org,tglx@linutronix.de,svens@linux.ibm.com,stefan.kristiansson@saunalahti.fi,shuah@kernel.org,shorne@gmail.com,richard@nod.at,renzo@cs.unibo.it,oleg@redhat.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,maddy@linux.ibm.com,macro@orcam.me.uk,linux@armlinux.org.uk,legion@kernel.org,kernel@xen0n.name,jonas@southpole.se,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,evgsyr@gmail.com,esyr@redhat.com,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,charlie@rivosinc.com,bp@alien8.de,borntraeger@linux.ibm.com,berardi.dav@gmail.com,bcain@quicinc.com,arnd@arndb.de,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,ldv@strace.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hexagon-add-syscall_set_return_value.patch added to mm-new branch
Message-Id: <20250407013119.484A8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hexagon: add syscall_set_return_value()
has been added to the -mm mm-new branch.  Its filename is
     hexagon-add-syscall_set_return_value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-add-syscall_set_return_value.patch

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
Subject: hexagon: add syscall_set_return_value()
Date: Mon, 3 Mar 2025 13:19:53 +0200

Patch series "ptrace: introduce PTRACE_SET_SYSCALL_INFO API", v7.

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
architecture [1].

ptrace(2) man page:

long ptrace(enum __ptrace_request request, pid_t pid, void *addr, void *data);
...
PTRACE_SET_SYSCALL_INFO
       Modify information about the system call that caused the stop.
       The "data" argument is a pointer to struct ptrace_syscall_info
       that specifies the system call information to be set.
       The "addr" argument should be set to sizeof(struct ptrace_syscall_info)).


This patch (of 6):

hexagon is the only architecture that provides HAVE_ARCH_TRACEHOOK but
doesn't define syscall_set_return_value().  Since this function is going
to be needed on all HAVE_ARCH_TRACEHOOK architectures to implement
PTRACE_SET_SYSCALL_INFO API, add it on hexagon, too.

Link: https://lore.kernel.org/all/59505464-c84a-403d-972f-d4b2055eeaac@gmail.com/ [1]
Link: https://lkml.kernel.org/r/20250303111953.GB24170@strace.io
Signed-off-by: Dmitry V. Levin <ldv@strace.io>
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
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/syscall.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/hexagon/include/asm/syscall.h~hexagon-add-syscall_set_return_value
+++ a/arch/hexagon/include/asm/syscall.h
@@ -45,6 +45,13 @@ static inline long syscall_get_return_va
 	return regs->r00;
 }
 
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->r00 = (long) error ?: val;
+}
+
 static inline int syscall_get_arch(struct task_struct *task)
 {
 	return AUDIT_ARCH_HEXAGON;
_

Patches currently in -mm which might be from ldv@strace.io are

hexagon-add-syscall_set_return_value.patch
syscallh-add-syscall_set_arguments.patch
syscallh-introduce-syscall_set_nr.patch
ptrace_get_syscall_info-factor-out-ptrace_get_syscall_info_op.patch
ptrace-introduce-ptrace_set_syscall_info-request.patch
selftests-ptrace-add-a-test-case-for-ptrace_set_syscall_info.patch

