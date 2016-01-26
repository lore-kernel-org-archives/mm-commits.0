From: akpm@linux-foundation.org
Subject: +
 seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:33:40 -0800
Message-ID: <56a7f444.m37qq4uVj95x3kYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcAZWdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: seccomp: check in_compat_syscall, not is_compat_task, in strict mode
has been added to the -mm tree.  Its filename is
     seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode.patch

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
Subject: seccomp: check in_compat_syscall, not is_compat_task, in strict mode

Seccomp wants to know the syscall bitness, not the caller task bitness,
when it selects the syscall whitelist.

As far as I know, this makes no difference on any architecture, so it's
not a security problem.  (It generates identical code everywhere except
sparc, and, on sparc, the syscall numbering is the same for both ABIs.)

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/seccomp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/seccomp.c~seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode kernel/seccomp.c
--- a/kernel/seccomp.c~seccomp-check-in_compat_syscall-not-is_compat_task-in-strict-mode
+++ a/kernel/seccomp.c
@@ -395,7 +395,7 @@ seccomp_prepare_user_filter(const char _
 	struct seccomp_filter *filter = ERR_PTR(-EFAULT);
 
 #ifdef CONFIG_COMPAT
-	if (is_compat_task()) {
+	if (in_compat_syscall()) {
 		struct compat_sock_fprog fprog32;
 		if (copy_from_user(&fprog32, user_filter, sizeof(fprog32)))
 			goto out;
@@ -529,7 +529,7 @@ static void __secure_computing_strict(in
 {
 	int *syscall_whitelist = mode1_syscalls;
 #ifdef CONFIG_COMPAT
-	if (is_compat_task())
+	if (in_compat_syscall())
 		syscall_whitelist = mode1_syscalls_32;
 #endif
 	do {
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

