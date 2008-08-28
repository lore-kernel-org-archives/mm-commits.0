From: akpm@linux-foundation.org
Subject: + message-queues-increase-range-limits.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:35:03 -0700
Message-ID: <200808282335.m7SNZ3gH020275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbYH1XgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, Nadia.Derbey@bull.net, manfred@colorfullife.com, viro@zeniv.linux.org.uk


The patch titled
     message queues: increase range limits
has been added to the -mm tree.  Its filename is
     message-queues-increase-range-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: message queues: increase range limits
From: Joe Korty <joe.korty@ccur.com>

Increase the range of various posix message queue limits.

Posix gives the message queue user the ability to 'trade off' the maximum
size of messages with the number of possible messages that can be 'in
flight'.  Linux currently makes this trade off more restrictive than it
needs to be.

In particular, the maximum message size today can be made no smaller than
8192.  This greatly restricts those applications that would like to have
the ability to post large numbers of very small messages.

So this task lowers the limit that the maximum message size can be set to,
from 8192 to 128.  It also lowers the limit that the maximum #number of
messages in flight can be set to, from 10 to 1.

With these changes the message queue user can make better trade offs
between #messages and message size, in order to get everything to fit
within the setrlimit(RLIMIT_MSGQUEUE) limit for that particular user.

This patch also applies the values in

	/proc/sys/fs/mqueue/msg_max
	/proc/sys/fs/mqueue/msgsize_max

as the defaults for the max #messages allowed and the max message size
allowed, respectively, for those applications that do not supply these. 
Previously, the defaults were hardwired to 10 and 8192, respectively.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN ipc/mqueue.c~message-queues-increase-range-limits ipc/mqueue.c
--- a/ipc/mqueue.c~message-queues-increase-range-limits
+++ a/ipc/mqueue.c
@@ -52,6 +52,14 @@
 #define HARD_MSGMAX 	(131072/sizeof(void*))
 #define DFLT_MSGSIZEMAX 8192	/* max message size */
 
+/*
+ * Define the ranges various user-specified maximum values can
+ * be set to.
+ */
+#define MIN_MSGMAX	1		/* min value for msg_max */
+#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
+#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
+#define MAX_MSGSIZEMAX	8192*128	/* max value for msgsize_max */
 
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
@@ -134,8 +142,8 @@ static struct inode *mqueue_get_inode(st
 			info->qsize = 0;
 			info->user = NULL;	/* set when all is ok */
 			memset(&info->attr, 0, sizeof(info->attr));
-			info->attr.mq_maxmsg = DFLT_MSGMAX;
-			info->attr.mq_msgsize = DFLT_MSGSIZEMAX;
+			info->attr.mq_maxmsg = msg_max;
+			info->attr.mq_msgsize = msgsize_max;
 			if (attr) {
 				info->attr.mq_maxmsg = attr->mq_maxmsg;
 				info->attr.mq_msgsize = attr->mq_msgsize;
@@ -1194,11 +1202,11 @@ static struct file_system_type mqueue_fs
 	.kill_sb = kill_litter_super,
 };
 
-static int msg_max_limit_min = DFLT_MSGMAX;
-static int msg_max_limit_max = HARD_MSGMAX;
+static int msg_max_limit_min = MIN_MSGMAX;
+static int msg_max_limit_max = MAX_MSGMAX;
 
-static int msg_maxsize_limit_min = DFLT_MSGSIZEMAX;
-static int msg_maxsize_limit_max = INT_MAX;
+static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
+static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
 
 static ctl_table mq_sysctls[] = {
 	{
_

Patches currently in -mm which might be from joe.korty@ccur.com are

x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch
x86-make-poll_idle-behave-more-like-the-other-idle-methods-checkpatch-fixes.patch
message-queues-increase-range-limits.patch

