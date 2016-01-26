From: akpm@linux-foundation.org
Subject: +
 staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch added
 to -mm tree
Date: Tue, 26 Jan 2016 14:33:46 -0800
Message-ID: <56a7f44a.q4hVvMXavKy0kCPk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbcAZWdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, adilger.kernel@dilger.ca, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging/lustre: switch from is_compat_task to in_compat_syscall
has been added to the -mm tree.  Its filename is
     staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-lustre-switch-from-is_compat_task-to-in_compat_syscall.patch

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
Subject: staging/lustre: switch from is_compat_task to in_compat_syscall

AFAICT, lustre is trying to determine syscall bitness.  Use the new
accessor.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/llite_internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/lustre/lustre/llite/llite_internal.h~staging-lustre-switch-from-is_compat_task-to-in_compat_syscall drivers/staging/lustre/lustre/llite/llite_internal.h
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h~staging-lustre-switch-from-is_compat_task-to-in_compat_syscall
+++ a/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -647,7 +647,7 @@ static inline int ll_need_32bit_api(stru
 #if BITS_PER_LONG == 32
 	return 1;
 #elif defined(CONFIG_COMPAT)
-	return unlikely(is_compat_task() || (sbi->ll_flags & LL_SBI_32BIT_API));
+	return unlikely(in_compat_syscall() || (sbi->ll_flags & LL_SBI_32BIT_API));
 #else
 	return unlikely(sbi->ll_flags & LL_SBI_32BIT_API);
 #endif
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

