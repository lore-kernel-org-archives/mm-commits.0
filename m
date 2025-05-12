Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3671553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011040; cv=none; b=X/XpuXkDvnai9JXi2HmOE7ZvkCmOhF3JmnGtaUaRLg0XtI7DxZbTGZ/zOUIUwwBPZ5MTArTPJcbyoV2y5z0QVLWG/l6RPkqGdZban4FQCzK9HP0hUezaSEiBg62th1LwH7ndZanqsWrwtcwTKwNm3ejHZRsFjZPpQnBooEnS5zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011040; c=relaxed/simple;
	bh=3L/RKpHlLRnvJ92QepbGRPVenk6M25IZYyeNBvQ9zwU=;
	h=Date:To:From:Subject:Message-Id; b=lOZQt2BMwY1oTgj5RJ99w7I+RoLG+LAyLF7wpeW0cz+kf5cKhxNQdzIol4Bc5rdTA354rpX312/sgr5bNCy2fYEUcfCw1TrfXwpiFDj7oLoK1yezed5Z7K97XvnhiS86btUV/2ZjpcrcK2zBrHNLxP0uwSt2pqM5bpN9bIYIuwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ezw7+ztT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ezw7+ztT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ACDC4CEE4;
	Mon, 12 May 2025 00:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011040;
	bh=3L/RKpHlLRnvJ92QepbGRPVenk6M25IZYyeNBvQ9zwU=;
	h=Date:To:From:Subject:From;
	b=ezw7+ztTifuoENyX4q0N0bgKsUTLpOcvk9ga6ZeDDSzfG+wNMTXgshj2VvSmCcumk
	 LwARc5q7WYUK5KOBrLh3f/iwe7gqK/4vyca6bjVM3x3aBoj8IAO2QBM29fflHrMQDx
	 /9O6jtKInMs1KYL9hNKCmaPSo+5b8UO8ePqexmgk=
Date: Sun, 11 May 2025 17:50:40 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,will@kernel.org,vgupta@kernel.org,vapier@gentoo.org,tglx@linutronix.de,svens@linux.ibm.com,stefan.kristiansson@saunalahti.fi,shuah@kernel.org,shorne@gmail.com,richard@nod.at,renzo@cs.unibo.it,oleg@redhat.com,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,maddy@linux.ibm.com,macro@orcam.me.uk,linux@armlinux.org.uk,legion@kernel.org,kernel@xen0n.name,jonas@southpole.se,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hpa@zytor.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,evgsyr@gmail.com,esyr@redhat.com,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,dalias@libc.org,chris@zankel.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,charlie@rivosinc.com,bp@alien8.de,borntraeger@linux.ibm.com,berardi.dav@gmail.com,bcain@quicinc.com,arnd@arndb.de,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,ldv@strace.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hexagon-add-syscall_set_return_value.patch removed from -mm tree
Message-Id: <20250512005040.96ACDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: add syscall_set_return_value()
has been removed from the -mm tree.  Its filename was
     hexagon-add-syscall_set_return_value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


