From: akpm@linux-foundation.org
Subject: [to-be-updated] ipc-mqueue-enforce-hard-limits.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:57:51 -0800
Message-ID: <20120110235751.C6CCD1E04F4@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57198 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab2AJX5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, manfred@colorfullife.com, serue@us.ibm.com, stable@kernel.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: enforce hard limits
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-enforce-hard-limits.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: enforce hard limits

In two places we don't enforce the hard limits for CAP_SYS_RESOURCE apps. 
In preparation for making more reasonable hard limits, start enforcing
them even on CAP_SYS_RESOURCE.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-enforce-hard-limits ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-enforce-hard-limits
+++ a/ipc/mqueue.c
@@ -310,8 +310,9 @@ static int mqueue_create(struct inode *d
 		error = -EACCES;
 		goto out_unlock;
 	}
-	if (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
-			!capable(CAP_SYS_RESOURCE)) {
+	if (ipc_ns->mq_queues_count >= HARD_QUEUESMAX ||
+	    (ipc_ns->mq_queues_count >= ipc_ns->mq_queues_max &&
+	     !capable(CAP_SYS_RESOURCE))) {
 		error = -ENOSPC;
 		goto out_unlock;
 	}
@@ -595,7 +596,8 @@ static int mq_attr_ok(struct ipc_namespa
 	if (attr->mq_maxmsg <= 0 || attr->mq_msgsize <= 0)
 		return 0;
 	if (capable(CAP_SYS_RESOURCE)) {
-		if (attr->mq_maxmsg > HARD_MSGMAX)
+		if (attr->mq_maxmsg > HARD_MSGMAX ||
+		    attr->mq_msgsize > HARD_MSGSIZEMAX)
 			return 0;
 	} else {
 		if (attr->mq_maxmsg > ipc_ns->mq_msg_max ||
_

Patches currently in -mm which might be from dledford@redhat.com are

ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

