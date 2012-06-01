From: akpm@linux-foundation.org
Subject: [merged] ipc-mqueue-enforce-hard-limits.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:34:39 -0700
Message-ID: <20120601193439.9CCC5A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:44792 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804Ab2FATek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:34:40 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so245076ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:34:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dledford@redhat.com, amwang@redhat.com, joe.korty@ccur.com, jslaby@suse.cz, kosaki.motohiro@jp.fujitsu.com, manfred@colorfullife.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: enforce hard limits
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-enforce-hard-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Doug Ledford <dledford@redhat.com>
Subject: ipc/mqueue: enforce hard limits

In two places we don't enforce the hard limits for CAP_SYS_RESOURCE apps. 
In preparation for making more reasonable hard limits, start enforcing
them even on CAP_SYS_RESOURCE.

Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: Joe Korty <joe.korty@ccur.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN ipc/mqueue.c~ipc-mqueue-enforce-hard-limits ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-enforce-hard-limits
+++ a/ipc/mqueue.c
@@ -301,8 +301,9 @@ static int mqueue_create(struct inode *d
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
@@ -589,7 +590,8 @@ static int mq_attr_ok(struct ipc_namespa
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

origin.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
mqueue-revert-bump-up-dflt_max.patch
mqueue-dont-use-kmalloc-with-kmalloc_max_size.patch
mqueue-separate-mqueue-default-value-from-maximum-value-v2.patch
selftests-add-mq_open_tests.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch

