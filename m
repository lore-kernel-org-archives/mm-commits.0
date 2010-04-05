From: akpm@linux-foundation.org
Subject: + ipc-mqueuec-let-message-queue-timeout-use-hrtimers.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:26:55 -0700
Message-ID: <201004052026.o35KQtwQ007144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357Ab0DEU1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: C.Emde@osadl.org, arjan@infradead.org, pradysam@gmail.com, tglx@linutronix.de


The patch titled
     ipc/mqueue.c: let message queue timeout use hrtimers
has been added to the -mm tree.  Its filename is
     ipc-mqueuec-let-message-queue-timeout-use-hrtimers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/mqueue.c: let message queue timeout use hrtimers
From: Carsten Emde <C.Emde@osadl.org>

The message queue functions mq_timedsend() and mq_timedreceive() have not
yet been converted to use the hrtimer interface.

This patch replaces the call to schedule_timeout() by a call to
schedule_hrtimeout() and transforms the expiration time from timespec to
ktime as required.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Pradyumna Sampath <pradysam@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   74 ++++++++++++++++---------------------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueuec-let-message-queue-timeout-use-hrtimers ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueuec-let-message-queue-timeout-use-hrtimers
+++ a/ipc/mqueue.c
@@ -429,7 +429,7 @@ static void wq_add(struct mqueue_inode_i
  * sr: SEND or RECV
  */
 static int wq_sleep(struct mqueue_inode_info *info, int sr,
-			long timeout, struct ext_wait_queue *ewp)
+		    ktime_t *timeout, struct ext_wait_queue *ewp)
 {
 	int retval;
 	signed long time;
@@ -440,7 +440,8 @@ static int wq_sleep(struct mqueue_inode_
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
-		time = schedule_timeout(timeout);
+		time = schedule_hrtimeout_range_clock(timeout,
+		    HRTIMER_MODE_ABS, 0, CLOCK_REALTIME);
 
 		while (ewp->state == STATE_PENDING)
 			cpu_relax();
@@ -552,31 +553,16 @@ static void __do_notify(struct mqueue_in
 	wake_up(&info->wait_q);
 }
 
-static long prepare_timeout(struct timespec *p)
+static int prepare_timeout(const struct timespec __user *u_abs_timeout,
+			   ktime_t *expires, struct timespec *ts)
 {
-	struct timespec nowts;
-	long timeout;
-
-	if (p) {
-		if (unlikely(p->tv_nsec < 0 || p->tv_sec < 0
-			|| p->tv_nsec >= NSEC_PER_SEC))
-			return -EINVAL;
-		nowts = CURRENT_TIME;
-		/* first subtract as jiffies can't be too big */
-		p->tv_sec -= nowts.tv_sec;
-		if (p->tv_nsec < nowts.tv_nsec) {
-			p->tv_nsec += NSEC_PER_SEC;
-			p->tv_sec--;
-		}
-		p->tv_nsec -= nowts.tv_nsec;
-		if (p->tv_sec < 0)
-			return 0;
-
-		timeout = timespec_to_jiffies(p) + 1;
-	} else
-		return MAX_SCHEDULE_TIMEOUT;
+	if (copy_from_user(ts, u_abs_timeout, sizeof(struct timespec)))
+		return -EFAULT;
+	if (!timespec_valid(ts))
+		return -EINVAL;
 
-	return timeout;
+	*expires = timespec_to_ktime(*ts);
+	return 0;
 }
 
 static void remove_notification(struct mqueue_inode_info *info)
@@ -862,22 +848,21 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	struct ext_wait_queue *receiver;
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
-	struct timespec ts, *p = NULL;
-	long timeout;
+ 	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 	int ret;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
 		return -EINVAL;
 
-	audit_mq_sendrecv(mqdes, msg_len, msg_prio, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, msg_prio, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -919,9 +904,6 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -954,24 +936,23 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		size_t, msg_len, unsigned int __user *, u_msg_prio,
 		const struct timespec __user *, u_abs_timeout)
 {
-	long timeout;
 	ssize_t ret;
 	struct msg_msg *msg_ptr;
 	struct file *filp;
 	struct inode *inode;
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
-	struct timespec ts, *p = NULL;
+   	ktime_t expires, *timeout = NULL;
+	struct timespec ts;
 
 	if (u_abs_timeout) {
-		if (copy_from_user(&ts, u_abs_timeout, 
-					sizeof(struct timespec)))
-			return -EFAULT;
-		p = &ts;
+		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
+		if (res)
+			return res;
+		timeout = &expires;
 	}
 
-	audit_mq_sendrecv(mqdes, msg_len, 0, p);
-	timeout = prepare_timeout(p);
+	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
 
 	filp = fget(mqdes);
 	if (unlikely(!filp)) {
@@ -1003,11 +984,6 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
-			msg_ptr = NULL;
-		} else if (unlikely(timeout < 0)) {
-			spin_unlock(&info->lock);
-			ret = timeout;
-			msg_ptr = NULL;
 		} else {
 			wait.task = current;
 			wait.state = STATE_NONE;
_

Patches currently in -mm which might be from C.Emde@osadl.org are

hrtimer-provide-schedule_hrtimeout-for-wallclock.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers.patch

