From: akpm@linux-foundation.org
Subject: [patch 36/84] signal: move the "sig < SIGRTMIN" check into
 siginmask(sig)
Date: Mon, 23 May 2016 16:24:02 -0700
Message-ID: <57439112.5aM7uPFpiXrQS0Ac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbcEWXYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com, mroos@linux.ee

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
@@ -400,7 +400,9 @@ int unhandled_signal(struct task_struct
 #else
 #define rt_sigmask(sig)	sigmask(sig)
 #endif
-#define siginmask(sig, mask) (rt_sigmask(sig) & (mask))
+
+#define siginmask(sig, mask) \
+	((sig) < SIGRTMIN && (rt_sigmask(sig) & (mask)))
 
 #define SIG_KERNEL_ONLY_MASK (\
 	rt_sigmask(SIGKILL)   |  rt_sigmask(SIGSTOP))
@@ -421,14 +423,10 @@ int unhandled_signal(struct task_struct
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
