From: akpm@linux-foundation.org
Subject: + x86-compat-remove-is_compat_task.patch added to -mm tree
Date: Tue, 26 Jan 2016 14:34:04 -0800
Message-ID: <56a7f45c.j4P0yfsi+aJHJaui%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbcAZWeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/compat: remove is_compat_task()
has been added to the -mm tree.  Its filename is
     x86-compat-remove-is_compat_task.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-compat-remove-is_compat_task.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-compat-remove-is_compat_task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: x86/compat: remove is_compat_task()

x86's is_compat_task always checked the current syscall type, not the task
type.  It has no non-arch users any more, so just remove it to avoid
confusion.

On x86, nothing should really be checking the task ABI.  There are
legitimate users for the syscall ABI and for the mm ABI.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/compat.h |    3 ++-
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/process_64.c  |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/compat.h~x86-compat-remove-is_compat_task arch/x86/include/asm/compat.h
--- a/arch/x86/include/asm/compat.h~x86-compat-remove-is_compat_task
+++ a/arch/x86/include/asm/compat.h
@@ -316,9 +316,10 @@ static inline bool is_x32_task(void)
 	return false;
 }
 
-static inline bool is_compat_task(void)
+static inline bool in_compat_syscall(void)
 {
 	return is_ia32_task() || is_x32_task();
 }
+#define in_compat_syscall in_compat_syscall	/* override the generic impl */
 
 #endif /* _ASM_X86_COMPAT_H */
diff -puN arch/x86/include/asm/ftrace.h~x86-compat-remove-is_compat_task arch/x86/include/asm/ftrace.h
--- a/arch/x86/include/asm/ftrace.h~x86-compat-remove-is_compat_task
+++ a/arch/x86/include/asm/ftrace.h
@@ -58,7 +58,7 @@ int ftrace_int3_handler(struct pt_regs *
 #define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return true;
 	return false;
 }
diff -puN arch/x86/kernel/process_64.c~x86-compat-remove-is_compat_task arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~x86-compat-remove-is_compat_task
+++ a/arch/x86/kernel/process_64.c
@@ -476,7 +476,7 @@ void set_personality_ia32(bool x32)
 		if (current->mm)
 			current->mm->context.ia32_compat = TIF_X32;
 		current->personality &= ~READ_IMPLIES_EXEC;
-		/* is_compat_task() uses the presence of the x32
+		/* in_compat_syscall() uses the presence of the x32
 		   syscall bit flag to determine compat status */
 		current_thread_info()->status &= ~TS_COMPAT;
 	} else {
_

Patches currently in -mm which might be from luto@kernel.org are

compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch
sparc-syscall-fix-syscall_get_arch.patch
seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch
ptrace-in-peek_siginfo-check-syscall-bitness-not-task-bitness.patch
auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch
staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch
ext4-in-ext4_dir_llseek-check-syscall-bitness-directly.patch
net-sctp-use-in_compat_syscall-for-sctp_getsockopt_connectx3.patch
net-xfrm_user-use-in_compat_syscall-to-deny-compat-syscalls.patch
firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch
efivars-use-in_compat_syscall-to-check-for-compat-callers.patch
amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch
input-redefine-input_compat_test-as-in_compat_syscall.patch
uhid-check-write-bitness-using-in_compat_syscall.patch
x86-compat-remove-is_compat_task.patch

