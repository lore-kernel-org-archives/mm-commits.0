From: akpm@linux-foundation.org
Subject: [to-be-updated] ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:57:48 -0800
Message-ID: <20120110235748.D91431004E8@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49134 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab2AJX5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, manfred@colorfullife.com, serue@us.ibm.com, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: switch back to using non-max values on create
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: switch back to using non-max values on create

Commit b231cca4381ee15e ("message queues: increase range limits") changed
how we create a queue that does not include an attr struct passed to open
so that it creates the queue with whatever the maximum values are. 
However, if the admin has set the maximums to allow flexibility in
creating a queue (aka, both a large size and large queue are allowed, but
combined they create a queue too large for the RLIMIT_MSGQUEUE of the
user), then attempts to create a queue without an attr struct will fail. 
Switch back to using acceptable defaults regardless of what the maximums
are.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 ++
 ipc/mqueue.c                  |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-mqueue-switch-back-to-using-non-max-values-on-create include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-mqueue-switch-back-to-using-non-max-values-on-create
+++ a/include/linux/ipc_namespace.h
@@ -95,9 +95,11 @@ extern int mq_init_ns(struct ipc_namespa
 #define DFLT_QUEUESMAX 256     /* max number of message queues */
 #define HARD_QUEUESMAX 1024
 #define MIN_MSGMAX     1
+#define DFLT_MSG       10U
 #define DFLT_MSGMAX    10      /* max number of messages in each queue */
 #define HARD_MSGMAX    (32768*sizeof(void *)/4)
 #define MIN_MSGSIZEMAX  128
+#define DFLT_MSGSIZE    8192U
 #define DFLT_MSGSIZEMAX 8192   /* max message size */
 #define HARD_MSGSIZEMAX (8192*128)
 #else
diff -puN ipc/mqueue.c~ipc-mqueue-switch-back-to-using-non-max-values-on-create ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-switch-back-to-using-non-max-values-on-create
+++ a/ipc/mqueue.c
@@ -143,8 +143,9 @@ static struct inode *mqueue_get_inode(st
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		memset(&info->attr, 0, sizeof(info->attr));
-		info->attr.mq_maxmsg = ipc_ns->mq_msg_max;
-		info->attr.mq_msgsize = ipc_ns->mq_msgsize_max;
+		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max, DFLT_MSG);
+		info->attr.mq_msgsize =
+			min(ipc_ns->mq_msgsize_max, DFLT_MSGSIZE);
 		if (attr) {
 			info->attr.mq_maxmsg = attr->mq_maxmsg;
 			info->attr.mq_msgsize = attr->mq_msgsize;
_

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

