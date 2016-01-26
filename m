From: akpm@linux-foundation.org
Subject: + efivars-use-in_compat_syscall-to-check-for-compat-callers.patch added to -mm tree
Date: Tue, 26 Jan 2016 14:33:56 -0800
Message-ID: <56a7f454.DIXCZYL7x0R3TOT6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbcAZWd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, matt@codeblueprint.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/efi/efivars.c: use in_compat_syscall() to check for compat callers
has been added to the -mm tree.  Its filename is
     efivars-use-in_compat_syscall-to-check-for-compat-callers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efivars-use-in_compat_syscall-to-check-for-compat-callers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efivars-use-in_compat_syscall-to-check-for-compat-callers.patch

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
Subject: drivers/firmware/efi/efivars.c: use in_compat_syscall() to check for compat callers

This should make no difference on any architecture, as x86's historical
is_compat_task behavior really did check whether the calling syscall was a
compat syscall.  x86's is_compat_task is going away, though.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/firmware/efi/efivars.c~efivars-use-in_compat_syscall-to-check-for-compat-callers drivers/firmware/efi/efivars.c
--- a/drivers/firmware/efi/efivars.c~efivars-use-in_compat_syscall-to-check-for-compat-callers
+++ a/drivers/firmware/efi/efivars.c
@@ -231,7 +231,7 @@ sanity_check(struct efi_variable *var, e
 
 static inline bool is_compat(void)
 {
-	if (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())
+	if (IS_ENABLED(CONFIG_COMPAT) && in_compat_syscall())
 		return true;
 
 	return false;
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

