From: akpm@linux-foundation.org
Subject: + firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:33:54 -0800
Message-ID: <56a7f452.LkG7TzfA0GWSmyTI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbcAZWdz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     Subject: firewire: Use in_compat_syscall to check ioctl compatness
has been added to the -mm tree.  Its filename is
     firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firewire-use-in_compat_syscall-to-check-ioctl-compatness.patch

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
Subject: firewire: Use in_compat_syscall to check ioctl compatness

Firewire was using is_compat_task to check whether it was in a
compat ioctl or a non-compat ioctl.  Use is_compat_syscall instead
so it works properly on all architectures.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firewire/core-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firewire/core-cdev.c~firewire-use-in_compat_syscall-to-check-ioctl-compatness drivers/firewire/core-cdev.c
--- a/drivers/firewire/core-cdev.c~firewire-use-in_compat_syscall-to-check-ioctl-compatness
+++ a/drivers/firewire/core-cdev.c
@@ -221,7 +221,7 @@ struct inbound_phy_packet_event {
 #ifdef CONFIG_COMPAT
 static void __user *u64_to_uptr(u64 value)
 {
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return compat_ptr(value);
 	else
 		return (void __user *)(unsigned long)value;
@@ -229,7 +229,7 @@ static void __user *u64_to_uptr(u64 valu
 
 static u64 uptr_to_u64(void __user *ptr)
 {
-	if (is_compat_task())
+	if (in_compat_syscall())
 		return ptr_to_compat(ptr);
 	else
 		return (u64)(unsigned long)ptr;
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

