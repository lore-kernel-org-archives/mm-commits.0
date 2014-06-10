From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-ivalid-one-orabug-17489469.patch removed from -mm tree
Date: Tue, 10 Jun 2014 15:15:59 -0700
Message-ID: <5397839f.c5wdbHC7A95PA56C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaFJWQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: [folded-merged] ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-ivalid-one-orabug-17489469.patch removed from -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:15:59 -0700


The patch titled
     Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-ivalid-one-orabug-17489469.patch

This patch was dropped because it was folded into ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one

Orabug: 17489469

When o2net-accept-one() rejects an illegal connection, it terminates the
loop picking up the remaining queued connections.  This fix will continue
accepting connections till the queue is emtpy.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-ivalid-one-orabug-17489469 fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-ivalid-one-orabug-17489469
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1921,12 +1921,30 @@ out:
 	return ret;
 }
 
+/*
+ * This function is invoked in response to one or more
+ * pending accepts at softIRQ level. We must drain the
+ * entire que before returning.
+ */
+
 static void o2net_accept_many(struct work_struct *work)
 {
 	struct socket *sock = o2net_listen_sock;
 	int	more;
 	int	err;
 
+	/*
+	 * It is critical to note that due to interrupt moderation
+	 * at the network driver level, we can't assume to get a
+	 * softIRQ for every single conn since tcp SYN packets
+	 * can arrive back-to-back, and therefore many pending
+	 * accepts may result in just 1 softIRQ. If we terminate
+	 * the o2net_accept_one() loop upon seeing an err, what happens
+	 * to the rest of the conns in the queue? If no new SYN
+	 * arrives for hours, no softIRQ  will be delivered,
+	 * and the connections will just sit in the queue.
+	 */
+
 	for (;;) {
 		err = o2net_accept_one(sock, &more);
 		if (!more)
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch
deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn.patch

