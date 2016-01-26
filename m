From: akpm@linux-foundation.org
Subject: +
 sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:33:34 -0800
Message-ID: <56a7f43e.PcXI0RC/IkroHqt3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcAZWdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/compat: rrovide an accurate in_compat_syscall implementation
has been added to the -mm tree.  Its filename is
     sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-compat-provide-an-accurate-in_compat_syscall-implementation.patch

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
Subject: sparc/compat: rrovide an accurate in_compat_syscall implementation

On sparc64 compat-enabled kernels, any task can make 32-bit and 64-bit
syscalls.  is_compat_task returns true in 32-bit tasks, which does not
necessarily imply that the current syscall is 32-bit.

Provide an in_compat_syscall implementation that checks whether the
current syscall is compat.

As far as I know, sparc is the only architecture on which is_compat_task
checks the compat status of the task and on which the compat status of a
syscall can differ from the compat status of the task.  On x86,
is_compat_task checks the syscall type, not the task type.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/compat.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation arch/sparc/include/asm/compat.h
--- a/arch/sparc/include/asm/compat.h~sparc-compat-provide-an-accurate-in_compat_syscall-implementation
+++ a/arch/sparc/include/asm/compat.h
@@ -307,4 +307,10 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_32BIT);
 }
 
+static inline bool in_compat_syscall(void)
+{
+	return pt_regs_trap_type(current_pt_regs()) == 0x110;
+}
+#define in_compat_syscall in_compat_syscall
+
 #endif /* _ASM_SPARC64_COMPAT_H */
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

