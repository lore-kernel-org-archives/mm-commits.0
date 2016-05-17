From: akpm@linux-foundation.org
Subject: + signal-move-the-sig-sigrtmin-check-into-siginmasksig.patch
 added to -mm tree
Date: Tue, 17 May 2016 16:03:08 -0700
Message-ID: <573ba32c.cDBHHmA6PYq1zYX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcEQXDK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 19:03:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mroos@linux.ee, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: move the "sig < SIGRTMIN" check into siginmask(sig)
has been added to the -mm tree.  Its filename is
     signal-move-the-sig-sigrtmin-check-into-siginmasksig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-move-the-sig-sigrtmin-check-into-siginmasksig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-move-the-sig-sigrtmin-check-into-siginmasksig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: move the "sig < SIGRTMIN" check into siginmask(sig)

All the users of siginmask() must ensure that sig < SIGRTMIN.  sig_fatal()
doesn't and this is wrong:

	[  211.406327] UBSAN: Undefined behaviour in kernel/signal.c:911:6
	[  211.406365] shift exponent 32 is too large for 32-bit type 'long unsigned int'

the patch doesn't add the neccesary check to sig_fatal(), it moves the
check into siginmask() and updates other callers.

Link: http://lkml.kernel.org/r/20160517195052.GA15187@redhat.com
Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/signal.h~signal-move-the-sig-sigrtmin-check-into-siginmasksig include/linux/signal.h
--- a/include/linux/signal.h~signal-move-the-sig-sigrtmin-check-into-siginmasksig
+++ a/include/linux/signal.h
@@ -385,7 +385,9 @@ int unhandled_signal(struct task_struct
 #else
 #define rt_sigmask(sig)	sigmask(sig)
 #endif
-#define siginmask(sig, mask) (rt_sigmask(sig) & (mask))
+
+#define siginmask(sig, mask) \
+	((sig) < SIGRTMIN && (rt_sigmask(sig) & (mask)))
 
 #define SIG_KERNEL_ONLY_MASK (\
 	rt_sigmask(SIGKILL)   |  rt_sigmask(SIGSTOP))
@@ -406,14 +408,10 @@ int unhandled_signal(struct task_struct
         rt_sigmask(SIGCONT)   |  rt_sigmask(SIGCHLD)   | \
 	rt_sigmask(SIGWINCH)  |  rt_sigmask(SIGURG)    )
 
-#define sig_kernel_only(sig) \
-	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_ONLY_MASK))
-#define sig_kernel_coredump(sig) \
-	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_COREDUMP_MASK))
-#define sig_kernel_ignore(sig) \
-	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_IGNORE_MASK))
-#define sig_kernel_stop(sig) \
-	(((sig) < SIGRTMIN) && siginmask(sig, SIG_KERNEL_STOP_MASK))
+#define sig_kernel_only(sig)		siginmask(sig, SIG_KERNEL_ONLY_MASK)
+#define sig_kernel_coredump(sig)	siginmask(sig, SIG_KERNEL_COREDUMP_MASK)
+#define sig_kernel_ignore(sig)		siginmask(sig, SIG_KERNEL_IGNORE_MASK)
+#define sig_kernel_stop(sig)		siginmask(sig, SIG_KERNEL_STOP_MASK)
 
 #define sig_user_defined(t, signr) \
 	(((t)->sighand->action[(signr)-1].sa.sa_handler != SIG_DFL) &&	\
_

Patches currently in -mm which might be from oleg@redhat.com are

userfaultfd-dont-pin-the-user-memory-in-userfaultfd_file_create.patch
wait-ptrace-assume-__wall-if-the-child-is-traced.patch
wait-allow-sys_waitid-to-accept-__wnothread-__wclone-__wall.patch
signal-move-the-sig-sigrtmin-check-into-siginmasksig.patch

