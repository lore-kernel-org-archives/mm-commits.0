From: akpm@linux-foundation.org
Subject: + whitespace-fixes-compat-syscalls.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:58 -0700
Message-ID: <200707210018.l6L0IwAb023902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759166AbXGUAUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, arnd@arndb.de


The patch titled
     whitespace fixes: compat syscalls
has been added to the -mm tree.  Its filename is
     whitespace-fixes-compat-syscalls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: compat syscalls
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |   60 +++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff -puN kernel/compat.c~whitespace-fixes-compat-syscalls kernel/compat.c
--- a/kernel/compat.c~whitespace-fixes-compat-syscalls
+++ a/kernel/compat.c
@@ -247,8 +247,8 @@ asmlinkage long compat_sys_setrlimit(uns
 	int ret;
 	mm_segment_t old_fs = get_fs ();
 
-	if (resource >= RLIM_NLIMITS) 
-		return -EINVAL;	
+	if (resource >= RLIM_NLIMITS)
+		return -EINVAL;
 
 	if (!access_ok(VERIFY_READ, rlim, sizeof(*rlim)) ||
 	    __get_user(r.rlim_cur, &rlim->rlim_cur) ||
@@ -477,21 +477,21 @@ asmlinkage long compat_sys_sched_getaffi
 
 int get_compat_itimerspec(struct itimerspec *dst,
 			  const struct compat_itimerspec __user *src)
-{ 
+{
 	if (get_compat_timespec(&dst->it_interval, &src->it_interval) ||
 	    get_compat_timespec(&dst->it_value, &src->it_value))
 		return -EFAULT;
 	return 0;
-} 
+}
 
 int put_compat_itimerspec(struct compat_itimerspec __user *dst,
 			  const struct itimerspec *src)
-{ 
+{
 	if (put_compat_timespec(&src->it_interval, &dst->it_interval) ||
 	    put_compat_timespec(&src->it_value, &dst->it_value))
 		return -EFAULT;
 	return 0;
-} 
+}
 
 long compat_sys_timer_create(clockid_t which_clock,
 			struct compat_sigevent __user *timer_event_spec,
@@ -512,9 +512,9 @@ long compat_sys_timer_create(clockid_t w
 }
 
 long compat_sys_timer_settime(timer_t timer_id, int flags,
-			  struct compat_itimerspec __user *new, 
+			  struct compat_itimerspec __user *new,
 			  struct compat_itimerspec __user *old)
-{ 
+{
 	long err;
 	mm_segment_t oldfs;
 	struct itimerspec newts, oldts;
@@ -522,58 +522,58 @@ long compat_sys_timer_settime(timer_t ti
 	if (!new)
 		return -EINVAL;
 	if (get_compat_itimerspec(&newts, new))
-		return -EFAULT;	
+		return -EFAULT;
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
 	err = sys_timer_settime(timer_id, flags,
 				(struct itimerspec __user *) &newts,
 				(struct itimerspec __user *) &oldts);
-	set_fs(oldfs); 
+	set_fs(oldfs);
 	if (!err && old && put_compat_itimerspec(old, &oldts))
 		return -EFAULT;
 	return err;
-} 
+}
 
 long compat_sys_timer_gettime(timer_t timer_id,
 		struct compat_itimerspec __user *setting)
-{ 
+{
 	long err;
 	mm_segment_t oldfs;
-	struct itimerspec ts; 
+	struct itimerspec ts;
 
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
 	err = sys_timer_gettime(timer_id,
-				(struct itimerspec __user *) &ts); 
-	set_fs(oldfs); 
+				(struct itimerspec __user *) &ts);
+	set_fs(oldfs);
 	if (!err && put_compat_itimerspec(setting, &ts))
 		return -EFAULT;
 	return err;
-} 
+}
 
 long compat_sys_clock_settime(clockid_t which_clock,
 		struct compat_timespec __user *tp)
 {
 	long err;
 	mm_segment_t oldfs;
-	struct timespec ts; 
+	struct timespec ts;
 
 	if (get_compat_timespec(&ts, tp))
-		return -EFAULT; 
+		return -EFAULT;
 	oldfs = get_fs();
-	set_fs(KERNEL_DS);	
+	set_fs(KERNEL_DS);
 	err = sys_clock_settime(which_clock,
 				(struct timespec __user *) &ts);
 	set_fs(oldfs);
 	return err;
-} 
+}
 
 long compat_sys_clock_gettime(clockid_t which_clock,
 		struct compat_timespec __user *tp)
 {
 	long err;
 	mm_segment_t oldfs;
-	struct timespec ts; 
+	struct timespec ts;
 
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
@@ -581,16 +581,16 @@ long compat_sys_clock_gettime(clockid_t 
 				(struct timespec __user *) &ts);
 	set_fs(oldfs);
 	if (!err && put_compat_timespec(&ts, tp))
-		return -EFAULT; 
+		return -EFAULT;
 	return err;
-} 
+}
 
 long compat_sys_clock_getres(clockid_t which_clock,
 		struct compat_timespec __user *tp)
 {
 	long err;
 	mm_segment_t oldfs;
-	struct timespec ts; 
+	struct timespec ts;
 
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
@@ -598,9 +598,9 @@ long compat_sys_clock_getres(clockid_t w
 			       (struct timespec __user *) &ts);
 	set_fs(oldfs);
 	if (!err && tp && put_compat_timespec(&ts, tp))
-		return -EFAULT; 
+		return -EFAULT;
 	return err;
-} 
+}
 
 static long compat_clock_nanosleep_restart(struct restart_block *restart)
 {
@@ -632,10 +632,10 @@ long compat_sys_clock_nanosleep(clockid_
 {
 	long err;
 	mm_segment_t oldfs;
-	struct timespec in, out; 
+	struct timespec in, out;
 	struct restart_block *restart;
 
-	if (get_compat_timespec(&in, rqtp)) 
+	if (get_compat_timespec(&in, rqtp))
 		return -EFAULT;
 
 	oldfs = get_fs();
@@ -654,8 +654,8 @@ long compat_sys_clock_nanosleep(clockid_
 		restart->fn = compat_clock_nanosleep_restart;
 		restart->arg1 = (unsigned long) rmtp;
 	}
-	return err;	
-} 
+	return err;
+}
 
 /*
  * We currently only need the following fields from the sigevent
_

Patches currently in -mm which might be from dwalker@mvista.com are

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
