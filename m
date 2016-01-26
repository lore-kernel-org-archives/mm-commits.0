From: akpm@linux-foundation.org
Subject: + amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:33:58 -0800
Message-ID: <56a7f456.ITc1k/yOTlJMK+cP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbcAZWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, airlied@linux.ie, oded.gabbay@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/amd/amdkfd: use in_compat_syscall to check open() caller type
has been added to the -mm tree.  Its filename is
     amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/amdkfd-use-in_compat_syscall-to-check-open-caller-type.patch

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
Subject: drivers/gpu/drm/amd/amdkfd: use in_compat_syscall to check open() caller type

amdkfd wants to know syscall type, not task type.  Check directly.

Unfortunately, amdkfd is making nasty assumptions that a process' bitness
is a well-defined constant thing.  This isn't the case on x86.  I don't
know how much this matters, but this patch has no effect on generated code
on x86, so amdkfd is equally broken with and without this patch.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpu/drm/amd/amdkfd/kfd_chardev.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -107,7 +107,7 @@ static int kfd_open(struct inode *inode,
 	if (iminor(inode) != 0)
 		return -ENODEV;
 
-	is_32bit_user_mode = is_compat_task();
+	is_32bit_user_mode = in_compat_syscall();
 
 	if (is_32bit_user_mode == true) {
 		dev_warn(kfd_device,
diff -puN drivers/gpu/drm/amd/amdkfd/kfd_process.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type drivers/gpu/drm/amd/amdkfd/kfd_process.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~amdkfd-use-in_compat_syscall-to-check-open-caller-type
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -311,7 +311,7 @@ static struct kfd_process *create_proces
 		goto err_process_pqm_init;
 
 	/* init process apertures*/
-	process->is_32bit_user_mode = is_compat_task();
+	process->is_32bit_user_mode = in_compat_syscall();
 	if (kfd_init_apertures(process) != 0)
 		goto err_init_apretures;
 
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

