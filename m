From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-signalfd-compat-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:04 -0700
Message-ID: <200705120535.l4C5Z4f9002245@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbXELFfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: signalfd compat code
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-signalfd-compat-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: signalfd compat code
From: Davide Libenzi <davidel@xmailserver.org>

This patch implements the necessary compat code for the signalfd system call.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/compat.c~signal-timer-event-fds-v9-signalfd-compat-code fs/compat.c
--- a/fs/compat.c~signal-timer-event-fds-v9-signalfd-compat-code
+++ a/fs/compat.c
@@ -46,6 +46,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/security.h>
 #include <linux/highmem.h>
+#include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/eventpoll.h>
@@ -2199,3 +2200,28 @@ asmlinkage long compat_sys_epoll_pwait(i
 #endif /* TIF_RESTORE_SIGMASK */
 
 #endif /* CONFIG_EPOLL */
+
+#ifdef CONFIG_SIGNALFD
+
+asmlinkage long compat_sys_signalfd(int ufd,
+				    const compat_sigset_t __user *sigmask,
+				    compat_size_t sigsetsize)
+{
+	compat_sigset_t ss32;
+	sigset_t tmp;
+	sigset_t __user *ksigmask;
+
+	if (sigsetsize != sizeof(compat_sigset_t))
+		return -EINVAL;
+	if (copy_from_user(&ss32, sigmask, sizeof(ss32)))
+		return -EFAULT;
+	sigset_from_compat(&tmp, &ss32);
+	ksigmask = compat_alloc_user_space(sizeof(sigset_t));
+	if (copy_to_user(ksigmask, &tmp, sizeof(sigset_t)))
+		return -EFAULT;
+
+	return sys_signalfd(ufd, ksigmask, sizeof(sigset_t));
+}
+
+#endif /* CONFIG_SIGNALFD */
+
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
