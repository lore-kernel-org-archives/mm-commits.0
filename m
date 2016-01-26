From: akpm@linux-foundation.org
Subject: + sparc-syscall-fix-syscall_get_arch.patch added to -mm tree
Date: Tue, 26 Jan 2016 14:33:38 -0800
Message-ID: <56a7f442.vqItrSJvNyQ/vfqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcAZWdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, davem@davemloft.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/syscall: fix syscall_get_arch
has been added to the -mm tree.  Its filename is
     sparc-syscall-fix-syscall_get_arch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-syscall-fix-syscall_get_arch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-syscall-fix-syscall_get_arch.patch

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
Subject: sparc/syscall: fix syscall_get_arch

Sparc's syscall_get_arch was buggy: it returned the task arch, not the
syscall arch.  This could confuse seccomp and audit.

I don't think this is as bad for seccomp as it looks: sparc's 32-bit and
64-bit syscalls are numbered the same.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/syscall.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/sparc/include/asm/syscall.h~sparc-syscall-fix-syscall_get_arch arch/sparc/include/asm/syscall.h
--- a/arch/sparc/include/asm/syscall.h~sparc-syscall-fix-syscall_get_arch
+++ a/arch/sparc/include/asm/syscall.h
@@ -3,6 +3,7 @@
 
 #include <uapi/linux/audit.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/sched.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
@@ -128,7 +129,13 @@ static inline void syscall_set_arguments
 
 static inline int syscall_get_arch(void)
 {
-	return is_32bit_task() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
+#if defined(CONFIG_SPARC64) && defined(CONFIG_COMPAT)
+	return in_compat_syscall() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
+#elif defined(CONFIG_SPARC64)
+	return AUDIT_ARCH_SPARC64;
+#else
+	return AUDIT_ARCH_SPARC;
+#endif
 }
 
 #endif /* __ASM_SPARC_SYSCALL_H */
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

