From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-timerfd-compat-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:12 -0700
Message-ID: <200705120535.l4C5ZBZl002270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbXELFfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal/timer/event: timerfd compat code
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-timerfd-compat-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: signal/timer/event: timerfd compat code
From: Davide Libenzi <davidel@xmailserver.org>

This patch implements the necessary compat code for the timerfd system call.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c            |   23 +++++++++++++++++++++++
 include/linux/compat.h |    5 +++++
 kernel/compat.c        |    8 ++++----
 3 files changed, 32 insertions(+), 4 deletions(-)

diff -puN fs/compat.c~signal-timer-event-fds-v9-timerfd-compat-code fs/compat.c
--- a/fs/compat.c~signal-timer-event-fds-v9-timerfd-compat-code
+++ a/fs/compat.c
@@ -2225,3 +2225,26 @@ asmlinkage long compat_sys_signalfd(int 
 
 #endif /* CONFIG_SIGNALFD */
 
+#ifdef CONFIG_TIMERFD
+
+asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
+				   const struct compat_itimerspec __user *utmr)
+{
+	long res;
+	struct itimerspec t;
+	struct itimerspec __user *ut;
+
+	res = -EFAULT;
+	if (get_compat_itimerspec(&t, utmr))
+		goto err_exit;
+	ut = compat_alloc_user_space(sizeof(*ut));
+	if (copy_to_user(ut, &t, sizeof(t)) )
+		goto err_exit;
+
+	res = sys_timerfd(ufd, clockid, flags, ut);
+err_exit:
+	return res;
+}
+
+#endif /* CONFIG_TIMERFD */
+
diff -puN include/linux/compat.h~signal-timer-event-fds-v9-timerfd-compat-code include/linux/compat.h
--- a/include/linux/compat.h~signal-timer-event-fds-v9-timerfd-compat-code
+++ a/include/linux/compat.h
@@ -225,6 +225,11 @@ static inline int compat_timespec_compar
 	return lhs->tv_nsec - rhs->tv_nsec;
 }
 
+extern int get_compat_itimerspec(struct itimerspec *dst,
+				 const struct compat_itimerspec __user *src);
+extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
+				 const struct itimerspec *src);
+
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
 extern int compat_printk(const char *fmt, ...);
diff -puN kernel/compat.c~signal-timer-event-fds-v9-timerfd-compat-code kernel/compat.c
--- a/kernel/compat.c~signal-timer-event-fds-v9-timerfd-compat-code
+++ a/kernel/compat.c
@@ -475,8 +475,8 @@ asmlinkage long compat_sys_sched_getaffi
 	return min_length;
 }
 
-static int get_compat_itimerspec(struct itimerspec *dst, 
-				 struct compat_itimerspec __user *src)
+int get_compat_itimerspec(struct itimerspec *dst,
+			  const struct compat_itimerspec __user *src)
 { 
 	if (get_compat_timespec(&dst->it_interval, &src->it_interval) ||
 	    get_compat_timespec(&dst->it_value, &src->it_value))
@@ -484,8 +484,8 @@ static int get_compat_itimerspec(struct 
 	return 0;
 } 
 
-static int put_compat_itimerspec(struct compat_itimerspec __user *dst, 
-				 struct itimerspec *src)
+int put_compat_itimerspec(struct compat_itimerspec __user *dst,
+			  const struct itimerspec *src)
 { 
 	if (put_compat_timespec(&src->it_interval, &dst->it_interval) ||
 	    put_compat_timespec(&src->it_value, &dst->it_value))
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
compat-signalfd-and-timerfd-are-cond-syscalls.patch
x86_64-use-signalfd-and-timerfd-compat-syscalls.patch
