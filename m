From: akpm@google.com
Subject: + ipc-mqueue-enforce-hard-limits.patch added to -mm tree
Date: Wed, 28 Sep 2011 14:32:27 -0700
Message-ID: <201109282132.p8SLWScd016613@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:1689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab1I1Vcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 17:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, manfred@colorfullife.com, serue@us.ibm.com


The patch titled
     Subject: ipc/mqueue: enforce hard limits
has been added to the -mm tree.  Its filename is
     ipc-mqueue-enforce-hard-limits.patch

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
Signed-off-by: Andrew Morton <akpm@google.com>
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
@@ -591,7 +592,8 @@ static int mq_attr_ok(struct ipc_namespa
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
Subject: Subject: ipc/mqueue: enforce hard limits

Patches currently in -mm which might be from dledford@redhat.com are

linux-next.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

