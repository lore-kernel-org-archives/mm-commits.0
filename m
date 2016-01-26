From: akpm@linux-foundation.org
Subject: +
 compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 14:33:30 -0800
Message-ID: <56a7f43a.PW3p/NpTg9FM3ckY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbcAZWdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 17:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, adilger.kernel@dilger.ca, airlied@linux.ie, clemens@ladisch.de, davem@davemloft.net, dh.herrmann@googlemail.com, dmitry.torokhov@gmail.com, eparis@redhat.com, herbert@gondor.apana.org.au, hpa@zytor.com, jikos@kernel.org, matt@codeblueprint.co.uk, mingo@elte.hu, nhorman@tuxdriver.com, oded.gabbay@gmail.com, oleg.drokin@intel.com, oleg@redhat.com, paul@paul-moore.com, sam@ravnborg.org, steffen.klassert@secunet.com, tglx@linutronix.de, tytso@mit.edu, vyasevich@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: add in_compat_syscall to ask whether we're in a compat syscall
has been added to the -mm tree.  Its filename is
     compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall.patch

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
Subject: compat: add in_compat_syscall to ask whether we're in a compat syscall

A lot of code currently abuses is_compat_task to determine this.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: David Herrmann <dh.herrmann@googlemail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/compat.h~compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall include/linux/compat.h
--- a/include/linux/compat.h~compat-add-in_compat_syscall-to-ask-whether-were-in-a-compat-syscall
+++ a/include/linux/compat.h
@@ -5,6 +5,8 @@
  * syscall compatibility layer.
  */
 
+#include <linux/types.h>
+
 #ifdef CONFIG_COMPAT
 
 #include <linux/stat.h>
@@ -713,9 +715,22 @@ asmlinkage long compat_sys_sched_rr_get_
 
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
+
+/*
+ * For most but not all architectures, "am I in a compat syscall?" and
+ * "am I a compat task?" are the same question.  For architectures on which
+ * they aren't the same question, arch code can override in_compat_syscall.
+ */
+
+#ifndef in_compat_syscall
+static inline bool in_compat_syscall(void) { return is_compat_task(); }
+#endif
+
 #else
 
 #define is_compat_task() (0)
+static inline bool in_compat_syscall(void) { return false; }
 
 #endif /* CONFIG_COMPAT */
+
 #endif /* _LINUX_COMPAT_H */
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

