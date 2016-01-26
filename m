From: akpm@linux-foundation.org
Subject: + input-redefine-input_compat_test-as-in_compat_syscall.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:34:00 -0800
Message-ID: <56a7f458.MeHbrrvwxGFqrou2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbcAZWeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: input: redefine INPUT_COMPAT_TEST as in_compat_syscall()
has been added to the -mm tree.  Its filename is
     input-redefine-input_compat_test-as-in_compat_syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-redefine-input_compat_test-as-in_compat_syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-redefine-input_compat_test-as-in_compat_syscall.patch

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
Subject: input: redefine INPUT_COMPAT_TEST as in_compat_syscall()

The input compat code should work like all other compat code: for 32-bit
syscalls, use the 32-bit ABI and for 64-bit syscalls, use the 64-bit ABI. 
We have a helper for that (in_compat_syscall()): just use it.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input-compat.h |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/input/input-compat.h~input-redefine-input_compat_test-as-in_compat_syscall drivers/input/input-compat.h
--- a/drivers/input/input-compat.h~input-redefine-input_compat_test-as-in_compat_syscall
+++ a/drivers/input/input-compat.h
@@ -17,17 +17,7 @@
 
 #ifdef CONFIG_COMPAT
 
-/* Note to the author of this code: did it ever occur to
-   you why the ifdefs are needed? Think about it again. -AK */
-#if defined(CONFIG_X86_64) || defined(CONFIG_TILE)
-#  define INPUT_COMPAT_TEST is_compat_task()
-#elif defined(CONFIG_S390)
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_31BIT)
-#elif defined(CONFIG_MIPS)
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT_ADDR)
-#else
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT)
-#endif
+#define INPUT_COMPAT_TEST in_compat_syscall()
 
 struct input_event_compat {
 	struct compat_timeval time;
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

