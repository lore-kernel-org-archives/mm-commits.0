From: akpm@linux-foundation.org
Subject: + select-use-get-put_timespec64.patch added to -mm tree
Date: Wed, 09 Aug 2017 15:11:48 -0700
Message-ID: <598b88a4.VZxYGizcfo9QbsBE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbdHIWLu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 18:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, bcrl@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: select: use get/put_timespec64
has been added to the -mm tree.  Its filename is
     select-use-get-put_timespec64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/select-use-get-put_timespec64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/select-use-get-put_timespec64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: select: use get/put_timespec64

Usage of these apis and their compat versions makes the syscalls: select
family of syscalls and their compat implementations simpler.

This is a preparatory patch to isolate data conversions to struct
timespec64 at userspace boundaries.  This helps contain the changes needed
to transition to new y2038 safe types.

Link: http://lkml.kernel.org/r/20170805041232.20875-2-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   60 ++++++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff -puN fs/select.c~select-use-get-put_timespec64 fs/select.c
--- a/fs/select.c~select-use-get-put_timespec64
+++ a/fs/select.c
@@ -291,8 +291,7 @@ static int poll_select_copy_remaining(st
 				      void __user *p,
 				      int timeval, int ret)
 {
-	struct timespec64 rts64;
-	struct timespec rts;
+	struct timespec64 rts;
 	struct timeval rtv;
 
 	if (!p)
@@ -305,23 +304,22 @@ static int poll_select_copy_remaining(st
 	if (!end_time->tv_sec && !end_time->tv_nsec)
 		return ret;
 
-	ktime_get_ts64(&rts64);
-	rts64 = timespec64_sub(*end_time, rts64);
-	if (rts64.tv_sec < 0)
-		rts64.tv_sec = rts64.tv_nsec = 0;
+	ktime_get_ts64(&rts);
+	rts = timespec64_sub(*end_time, rts);
+	if (rts.tv_sec < 0)
+		rts.tv_sec = rts.tv_nsec = 0;
 
-	rts = timespec64_to_timespec(rts64);
 
 	if (timeval) {
 		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
 			memset(&rtv, 0, sizeof(rtv));
-		rtv.tv_sec = rts64.tv_sec;
-		rtv.tv_usec = rts64.tv_nsec / NSEC_PER_USEC;
+		rtv.tv_sec = rts.tv_sec;
+		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
 		if (!copy_to_user(p, &rtv, sizeof(rtv)))
 			return ret;
 
-	} else if (!copy_to_user(p, &rts, sizeof(rts)))
+	} else if (!put_timespec64(&rts, p))
 		return ret;
 
 	/*
@@ -704,17 +702,15 @@ static long do_pselect(int n, fd_set __u
 		       const sigset_t __user *sigmask, size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts;
-	struct timespec64 ts64, end_time, *to = NULL;
+	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (copy_from_user(&ts, tsp, sizeof(ts)))
+		if (get_timespec64(&ts, tsp))
 			return -EFAULT;
-		ts64 = timespec_to_timespec64(ts);
 
 		to = &end_time;
-		if (poll_select_set_timeout(to, ts64.tv_sec, ts64.tv_nsec))
+		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
 			return -EINVAL;
 	}
 
@@ -1051,12 +1047,11 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 		size_t, sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts;
-	struct timespec64 end_time, *to = NULL;
+	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (copy_from_user(&ts, tsp, sizeof(ts)))
+		if (get_timespec64(&ts, tsp))
 			return -EFAULT;
 
 		to = &end_time;
@@ -1102,10 +1097,10 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
 static
-int compat_poll_select_copy_remaining(struct timespec *end_time, void __user *p,
+int compat_poll_select_copy_remaining(struct timespec64 *end_time, void __user *p,
 				      int timeval, int ret)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 
 	if (!p)
 		return ret;
@@ -1117,8 +1112,8 @@ int compat_poll_select_copy_remaining(st
 	if (!end_time->tv_sec && !end_time->tv_nsec)
 		return ret;
 
-	ktime_get_ts(&ts);
-	ts = timespec_sub(*end_time, ts);
+	ktime_get_ts64(&ts);
+	ts = timespec64_sub(*end_time, ts);
 	if (ts.tv_sec < 0)
 		ts.tv_sec = ts.tv_nsec = 0;
 
@@ -1131,12 +1126,7 @@ int compat_poll_select_copy_remaining(st
 		if (!copy_to_user(p, &rtv, sizeof(rtv)))
 			return ret;
 	} else {
-		struct compat_timespec rts;
-
-		rts.tv_sec = ts.tv_sec;
-		rts.tv_nsec = ts.tv_nsec;
-
-		if (!copy_to_user(p, &rts, sizeof(rts)))
+		if (!compat_put_timespec64(&ts, p))
 			return ret;
 	}
 	/*
@@ -1198,7 +1188,7 @@ int compat_set_fd_set(unsigned long nr,
  */
 static int compat_core_sys_select(int n, compat_ulong_t __user *inp,
 	compat_ulong_t __user *outp, compat_ulong_t __user *exp,
-	struct timespec *end_time)
+	struct timespec64 *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -1271,7 +1261,7 @@ COMPAT_SYSCALL_DEFINE5(select, int, n, c
 	compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
 	struct compat_timeval __user *, tvp)
 {
-	struct timespec end_time, *to = NULL;
+	struct timespec64 end_time, *to = NULL;
 	struct compat_timeval tv;
 	int ret;
 
@@ -1317,12 +1307,11 @@ static long do_compat_pselect(int n, com
 {
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
-	struct compat_timespec ts;
-	struct timespec end_time, *to = NULL;
+	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (copy_from_user(&ts, tsp, sizeof(ts)))
+		if (compat_get_timespec64(&ts, tsp))
 			return -EFAULT;
 
 		to = &end_time;
@@ -1386,12 +1375,11 @@ COMPAT_SYSCALL_DEFINE5(ppoll, struct pol
 {
 	compat_sigset_t ss32;
 	sigset_t ksigmask, sigsaved;
-	struct compat_timespec ts;
-	struct timespec end_time, *to = NULL;
+	struct timespec64 ts, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
-		if (copy_from_user(&ts, tsp, sizeof(ts)))
+		if (compat_get_timespec64(&ts, tsp))
 			return -EFAULT;
 
 		to = &end_time;
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

select-use-get-put_timespec64.patch
io_getevents-use-timespec64-to-represent-timeouts.patch

