From: akpm@linux-foundation.org
Subject: + mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately.patch added to -mm tree
Date: Wed, 14 Mar 2012 14:48:57 -0700
Message-ID: <20120314214858.047E8A076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50475 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031116Ab2CNVtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 17:49:00 -0400
Received: by eaaq10 with SMTP id q10so98000eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:48:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takeuchi.akr@jp.panasonic.com, C.Emde@osadl.org, manfred@colorfullife.com, owada.kiyoshi@jp.panasonic.com, tglx@linutronix.de


The patch titled
     Subject: mqueue: ignore the validity of abs_timeout parameter when message can be performed immediately
has been added to the -mm tree.  Its filename is
     mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Subject: mqueue: ignore the validity of abs_timeout parameter when message can be performed immediately

This patch fixes a regression in the mq_timed{send,receive} syscall.

When a message of mqueue can be performed immediately, the validity of
abs_timeout parameter should not be checked.

According to the manpage of mq_timedreceive:
    Under no circumstance shall the operation fail with a timeout
    if a message can be removed from the message queue immediately.
    The validity of the abstime parameter need not be checked
    if a message can be removed from the message queue immediately.

On 2.6.35+ kernel, mq_timed{send,receive} returns EINVAL incorrectly, in
this situation.

I found this problem during the OPTS testcase
"conformance/interfaces/mq_timedreceive/10-2":

    # ./10-2.test
    FAIL: the validity of abs_timeout is checked
    Test FAILED

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff -puN ipc/mqueue.c~mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately
+++ a/ipc/mqueue.c
@@ -851,14 +851,22 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
 	ktime_t expires, *timeout = NULL;
+	int timeout_param_error = 0;
 	struct timespec ts;
 	int ret;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
 		if (res)
-			return res;
-		timeout = &expires;
+			/*
+			 * The validity of the abs_timeout parameter need not be
+			 * checked when there is sufficient room in the queue.
+			 * So, do not return here, even if the parameter is
+			 * invalid.
+			 */
+			timeout_param_error = res;
+		else
+			timeout = &expires;
 	}
 
 	if (unlikely(msg_prio >= (unsigned long) MQ_PRIO_MAX))
@@ -906,6 +914,9 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
+		} else if (unlikely(timeout_param_error)) {
+			spin_unlock(&info->lock);
+			ret = timeout_param_error;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
@@ -945,13 +956,21 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
 	ktime_t expires, *timeout = NULL;
+	int timeout_param_error = 0;
 	struct timespec ts;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
 		if (res)
-			return res;
-		timeout = &expires;
+			/*
+			 * The validity of the abs_timeout parameter need not be
+			 * checked if a message can be removed from the message
+			 * queue immediately. So, do not return here, even if
+			 * the parameter is invalid.
+			 */
+			timeout_param_error = res;
+		else
+			timeout = &expires;
 	}
 
 	audit_mq_sendrecv(mqdes, msg_len, 0, timeout ? &ts : NULL);
@@ -986,6 +1005,10 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
 			ret = -EAGAIN;
+		} else if (unlikely(timeout_param_error)) {
+			spin_unlock(&info->lock);
+			ret = timeout_param_error;
+			msg_ptr = NULL; /* just for shutting up warning */
 		} else {
 			wait.task = current;
 			wait.state = STATE_NONE;
_
Subject: Subject: mqueue: ignore the validity of abs_timeout parameter when message can be performed immediately

Patches currently in -mm which might be from takeuchi.akr@jp.panasonic.com are

mqueue-ignore-the-validity-of-abs_timeout-parameter-when-message-can-be-performed-immediately.patch

