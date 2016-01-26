From: akpm@linux-foundation.org
Subject: +
 auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch added to -mm tree
Date: Tue, 26 Jan 2016 14:33:44 -0800
Message-ID: <56a7f448.pmlxjhs6swhMZp3j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbcAZWdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, eparis@redhat.com, paul@paul-moore.com, mm-commits@vger.kernel.org


The patch titled
     Subject: auditsc: for seccomp events, log syscall compat state using in_compat_syscall
has been added to the -mm tree.  Its filename is
     auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall.patch

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
Subject: auditsc: for seccomp events, log syscall compat state using in_compat_syscall

Except on SPARC, this is what the code always did.  SPARC compat
seccomp was buggy, although the impact of the bug was limited
because SPARC 32-bit and 64-bit syscall numbers are the same.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/auditsc.c~auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall kernel/auditsc.c
--- a/kernel/auditsc.c~auditsc-for-seccomp-events-log-syscall-compat-state-using-in_compat_syscall
+++ a/kernel/auditsc.c
@@ -2412,8 +2412,8 @@ void __audit_seccomp(unsigned long sysca
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld arch=%x syscall=%ld compat=%d ip=0x%lx code=0x%x",
-			 signr, syscall_get_arch(), syscall, is_compat_task(),
-			 KSTK_EIP(current), code);
+			 signr, syscall_get_arch(), syscall,
+			 in_compat_syscall(), KSTK_EIP(current), code);
 	audit_log_end(ab);
 }
 
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

