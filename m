From: akpm@linux-foundation.org
Subject: [merged]
 ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:43 -0700
Message-ID: <51dc9b07.5X5umdprvOhm6c4Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3GIXVo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:43 -0700


The patch titled
     Subject: ipc,msg: introduce lockless functions to obtain the ipc object
has been removed from the -mm tree.  Its filename was
     ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msg: introduce lockless functions to obtain the ipc object

Add msq_obtain_object() and msq_obtain_object_check(), which will allow us
to get the ipc object without acquiring the lock.  Just as with
semaphores, these functions are basically wrappers around
ipc_obtain_object*().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN ipc/msg.c~ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object ipc/msg.c
--- a/ipc/msg.c~ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object
+++ a/ipc/msg.c
@@ -166,6 +166,27 @@ static inline struct msg_queue *msg_lock
 	return container_of(ipcp, struct msg_queue, q_perm);
 }
 
+static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
+}
+
+static inline struct msg_queue *msq_obtain_object_check(struct ipc_namespace *ns,
+							int id)
+{
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_check(&msg_ids(ns), id);
+
+	if (IS_ERR(ipcp))
+		return ERR_CAST(ipcp);
+
+	return container_of(ipcp, struct msg_queue, q_perm);
+}
+
 static inline void msg_rmid(struct ipc_namespace *ns, struct msg_queue *s)
 {
 	ipc_rmid(&msg_ids(ns), &s->q_perm);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

