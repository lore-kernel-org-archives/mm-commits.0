From: akpm@linux-foundation.org
Subject: [merged]
 fs-poll-select-recvmmsg-use-timespec64-for-timeout-events.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:02:22 -0700
Message-ID: <573f7b5e.KGjLGArb+GOZPZUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, arnd@arndb.de, davem@davemloft.net, john.stultz@linaro.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: poll/select/recvmmsg: use timespec64 for timeout events
has been removed from the -mm tree.  Its filename was
     fs-poll-select-recvmmsg-use-timespec64-for-timeout-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: fs: poll/select/recvmmsg: use timespec64 for timeout events

struct timespec is not y2038 safe.  Even though timespec might be
sufficient to represent timeouts, use struct timespec64 here as the plan
is to get rid of all timespec reference in the kernel.

The patch transitions the common functions: poll_select_set_timeout() and
select_estimate_accuracy() to use timespec64.  And, all the syscalls that
use these functions are transitioned in the same patch.

The restart block parameters for poll uses monotonic time.  Use timespec64
here as well to assign timeout value.  This parameter in the restart block
need not change because this only holds the monotonic timestamp at which
timeout should occur.  And, unsigned long data type should be big enough
for this timestamp.

The system call interfaces will be handled in a separate series.

Compat interfaces need not change as timespec64 is an alias to struct
timespec on a 64 bit system.

Link: http://lkml.kernel.org/r/1461947989-21926-3-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c       |   12 +++----
 fs/select.c          |   67 ++++++++++++++++++++++-------------------
 include/linux/poll.h |   11 +++---
 net/socket.c         |    8 +++-
 4 files changed, 54 insertions(+), 44 deletions(-)

diff -puN fs/eventpoll.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events fs/eventpoll.c
--- a/fs/eventpoll.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events
+++ a/fs/eventpoll.c
@@ -1583,15 +1583,15 @@ static int ep_send_events(struct eventpo
 	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
-static inline struct timespec ep_set_mstimeout(long ms)
+static inline struct timespec64 ep_set_mstimeout(long ms)
 {
-	struct timespec now, ts = {
+	struct timespec64 now, ts = {
 		.tv_sec = ms / MSEC_PER_SEC,
 		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
 	};
 
-	ktime_get_ts(&now);
-	return timespec_add_safe(now, ts);
+	ktime_get_ts64(&now);
+	return timespec64_add_safe(now, ts);
 }
 
 /**
@@ -1621,11 +1621,11 @@ static int ep_poll(struct eventpoll *ep,
 	ktime_t expires, *to = NULL;
 
 	if (timeout > 0) {
-		struct timespec end_time = ep_set_mstimeout(timeout);
+		struct timespec64 end_time = ep_set_mstimeout(timeout);
 
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
-		*to = timespec_to_ktime(end_time);
+		*to = timespec64_to_ktime(end_time);
 	} else if (timeout == 0) {
 		/*
 		 * Avoid the unnecessary trip to the wait queue loop, if the
diff -puN fs/select.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events fs/select.c
--- a/fs/select.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events
+++ a/fs/select.c
@@ -47,7 +47,7 @@
 
 #define MAX_SLACK	(100 * NSEC_PER_MSEC)
 
-static long __estimate_accuracy(struct timespec *tv)
+static long __estimate_accuracy(struct timespec64 *tv)
 {
 	long slack;
 	int divfactor = 1000;
@@ -70,10 +70,10 @@ static long __estimate_accuracy(struct t
 	return slack;
 }
 
-u64 select_estimate_accuracy(struct timespec *tv)
+u64 select_estimate_accuracy(struct timespec64 *tv)
 {
 	u64 ret;
-	struct timespec now;
+	struct timespec64 now;
 
 	/*
 	 * Realtime tasks get a slack of 0 for obvious reasons.
@@ -82,8 +82,8 @@ u64 select_estimate_accuracy(struct time
 	if (rt_task(current))
 		return 0;
 
-	ktime_get_ts(&now);
-	now = timespec_sub(*tv, now);
+	ktime_get_ts64(&now);
+	now = timespec64_sub(*tv, now);
 	ret = __estimate_accuracy(&now);
 	if (ret < current->timer_slack_ns)
 		return current->timer_slack_ns;
@@ -260,7 +260,7 @@ EXPORT_SYMBOL(poll_schedule_timeout);
 
 /**
  * poll_select_set_timeout - helper function to setup the timeout value
- * @to:		pointer to timespec variable for the final timeout
+ * @to:		pointer to timespec64 variable for the final timeout
  * @sec:	seconds (from user space)
  * @nsec:	nanoseconds (from user space)
  *
@@ -269,26 +269,28 @@ EXPORT_SYMBOL(poll_schedule_timeout);
  *
  * Returns -EINVAL if sec/nsec are not normalized. Otherwise 0.
  */
-int poll_select_set_timeout(struct timespec *to, long sec, long nsec)
+int poll_select_set_timeout(struct timespec64 *to, time64_t sec, long nsec)
 {
-	struct timespec ts = {.tv_sec = sec, .tv_nsec = nsec};
+	struct timespec64 ts = {.tv_sec = sec, .tv_nsec = nsec};
 
-	if (!timespec_valid(&ts))
+	if (!timespec64_valid(&ts))
 		return -EINVAL;
 
 	/* Optimize for the zero timeout value here */
 	if (!sec && !nsec) {
 		to->tv_sec = to->tv_nsec = 0;
 	} else {
-		ktime_get_ts(to);
-		*to = timespec_add_safe(*to, ts);
+		ktime_get_ts64(to);
+		*to = timespec64_add_safe(*to, ts);
 	}
 	return 0;
 }
 
-static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
+static int poll_select_copy_remaining(struct timespec64 *end_time,
+				      void __user *p,
 				      int timeval, int ret)
 {
+	struct timespec64 rts64;
 	struct timespec rts;
 	struct timeval rtv;
 
@@ -302,16 +304,18 @@ static int poll_select_copy_remaining(st
 	if (!end_time->tv_sec && !end_time->tv_nsec)
 		return ret;
 
-	ktime_get_ts(&rts);
-	rts = timespec_sub(*end_time, rts);
-	if (rts.tv_sec < 0)
-		rts.tv_sec = rts.tv_nsec = 0;
+	ktime_get_ts64(&rts64);
+	rts64 = timespec64_sub(*end_time, rts64);
+	if (rts64.tv_sec < 0)
+		rts64.tv_sec = rts64.tv_nsec = 0;
+
+	rts = timespec64_to_timespec(rts64);
 
 	if (timeval) {
 		if (sizeof(rtv) > sizeof(rtv.tv_sec) + sizeof(rtv.tv_usec))
 			memset(&rtv, 0, sizeof(rtv));
-		rtv.tv_sec = rts.tv_sec;
-		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+		rtv.tv_sec = rts64.tv_sec;
+		rtv.tv_usec = rts64.tv_nsec / NSEC_PER_USEC;
 
 		if (!copy_to_user(p, &rtv, sizeof(rtv)))
 			return ret;
@@ -396,7 +400,7 @@ static inline void wait_key_set(poll_tab
 		wait->_key |= POLLOUT_SET;
 }
 
-int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
+int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 {
 	ktime_t expire, *to = NULL;
 	struct poll_wqueues table;
@@ -522,7 +526,7 @@ int do_select(int n, fd_set_bits *fds, s
 		 * pointer to the expiry value.
 		 */
 		if (end_time && !to) {
-			expire = timespec_to_ktime(*end_time);
+			expire = timespec64_to_ktime(*end_time);
 			to = &expire;
 		}
 
@@ -545,7 +549,7 @@ int do_select(int n, fd_set_bits *fds, s
  * I'm trying ERESTARTNOHAND which restart only when you want to.
  */
 int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, struct timespec *end_time)
+			   fd_set __user *exp, struct timespec64 *end_time)
 {
 	fd_set_bits fds;
 	void *bits;
@@ -622,7 +626,7 @@ out_nofds:
 SYSCALL_DEFINE5(select, int, n, fd_set __user *, inp, fd_set __user *, outp,
 		fd_set __user *, exp, struct timeval __user *, tvp)
 {
-	struct timespec end_time, *to = NULL;
+	struct timespec64 end_time, *to = NULL;
 	struct timeval tv;
 	int ret;
 
@@ -648,15 +652,17 @@ static long do_pselect(int n, fd_set __u
 		       const sigset_t __user *sigmask, size_t sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts, end_time, *to = NULL;
+	struct timespec ts;
+	struct timespec64 ts64, end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
 		if (copy_from_user(&ts, tsp, sizeof(ts)))
 			return -EFAULT;
+		ts64 = timespec_to_timespec64(ts);
 
 		to = &end_time;
-		if (poll_select_set_timeout(to, ts.tv_sec, ts.tv_nsec))
+		if (poll_select_set_timeout(to, ts64.tv_sec, ts64.tv_nsec))
 			return -EINVAL;
 	}
 
@@ -779,7 +785,7 @@ static inline unsigned int do_pollfd(str
 }
 
 static int do_poll(struct poll_list *list, struct poll_wqueues *wait,
-		   struct timespec *end_time)
+		   struct timespec64 *end_time)
 {
 	poll_table* pt = &wait->pt;
 	ktime_t expire, *to = NULL;
@@ -854,7 +860,7 @@ static int do_poll(struct poll_list *lis
 		 * pointer to the expiry value.
 		 */
 		if (end_time && !to) {
-			expire = timespec_to_ktime(*end_time);
+			expire = timespec64_to_ktime(*end_time);
 			to = &expire;
 		}
 
@@ -868,7 +874,7 @@ static int do_poll(struct poll_list *lis
 			sizeof(struct pollfd))
 
 int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
-		struct timespec *end_time)
+		struct timespec64 *end_time)
 {
 	struct poll_wqueues table;
  	int err = -EFAULT, fdcount, len, size;
@@ -936,7 +942,7 @@ static long do_restart_poll(struct resta
 {
 	struct pollfd __user *ufds = restart_block->poll.ufds;
 	int nfds = restart_block->poll.nfds;
-	struct timespec *to = NULL, end_time;
+	struct timespec64 *to = NULL, end_time;
 	int ret;
 
 	if (restart_block->poll.has_timeout) {
@@ -957,7 +963,7 @@ static long do_restart_poll(struct resta
 SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
 		int, timeout_msecs)
 {
-	struct timespec end_time, *to = NULL;
+	struct timespec64 end_time, *to = NULL;
 	int ret;
 
 	if (timeout_msecs >= 0) {
@@ -993,7 +999,8 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __u
 		size_t, sigsetsize)
 {
 	sigset_t ksigmask, sigsaved;
-	struct timespec ts, end_time, *to = NULL;
+	struct timespec ts;
+	struct timespec64 end_time, *to = NULL;
 	int ret;
 
 	if (tsp) {
diff -puN include/linux/poll.h~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events include/linux/poll.h
--- a/include/linux/poll.h~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events
+++ a/include/linux/poll.h
@@ -96,7 +96,7 @@ extern void poll_initwait(struct poll_wq
 extern void poll_freewait(struct poll_wqueues *pwq);
 extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 				 ktime_t *expires, unsigned long slack);
-extern u64 select_estimate_accuracy(struct timespec *tv);
+extern u64 select_estimate_accuracy(struct timespec64 *tv);
 
 
 static inline int poll_schedule(struct poll_wqueues *pwq, int state)
@@ -153,12 +153,13 @@ void zero_fd_set(unsigned long nr, unsig
 
 #define MAX_INT64_SECONDS (((s64)(~((u64)0)>>1)/HZ)-1)
 
-extern int do_select(int n, fd_set_bits *fds, struct timespec *end_time);
+extern int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time);
 extern int do_sys_poll(struct pollfd __user * ufds, unsigned int nfds,
-		       struct timespec *end_time);
+		       struct timespec64 *end_time);
 extern int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
-			   fd_set __user *exp, struct timespec *end_time);
+			   fd_set __user *exp, struct timespec64 *end_time);
 
-extern int poll_select_set_timeout(struct timespec *to, long sec, long nsec);
+extern int poll_select_set_timeout(struct timespec64 *to, time64_t sec,
+				   long nsec);
 
 #endif /* _LINUX_POLL_H */
diff -puN net/socket.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events net/socket.c
--- a/net/socket.c~fs-poll-select-recvmmsg-use-timespec64-for-timeout-events
+++ a/net/socket.c
@@ -2168,7 +2168,8 @@ int __sys_recvmmsg(int fd, struct mmsghd
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
 	struct msghdr msg_sys;
-	struct timespec end_time;
+	struct timespec64 end_time;
+	struct timespec64 timeout64;
 
 	if (timeout &&
 	    poll_select_set_timeout(&end_time, timeout->tv_sec,
@@ -2220,8 +2221,9 @@ int __sys_recvmmsg(int fd, struct mmsghd
 			flags |= MSG_DONTWAIT;
 
 		if (timeout) {
-			ktime_get_ts(timeout);
-			*timeout = timespec_sub(end_time, *timeout);
+			ktime_get_ts64(&timeout64);
+			*timeout = timespec64_to_timespec(
+					timespec64_sub(end_time, timeout64));
 			if (timeout->tv_sec < 0) {
 				timeout->tv_sec = timeout->tv_nsec = 0;
 				break;
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are


