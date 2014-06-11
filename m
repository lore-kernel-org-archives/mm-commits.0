From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch removed from -mm tree
Date: Wed, 11 Jun 2014 12:03:57 -0700
Message-ID: <5398a81d.GnQeVDT2A2FjdQ9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKTD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 15:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.de, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: [merged] ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch removed from -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 12:03:57 -0700


The patch titled
     Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one

When o2net-accept-one() rejects an illegal connection, it terminates the
loop picking up the remaining queued connections.  This fix will continue
accepting connections till the queue is emtpy.

Addresses Orabug 17489469.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1799,7 +1799,7 @@ int o2net_register_hb_callbacks(void)
 
 /* ------------------------------------------------------------ */
 
-static int o2net_accept_one(struct socket *sock)
+static int o2net_accept_one(struct socket *sock, int *more)
 {
 	int ret, slen;
 	struct sockaddr_in sin;
@@ -1810,6 +1810,7 @@ static int o2net_accept_one(struct socke
 	struct o2net_node *nn;
 
 	BUG_ON(sock == NULL);
+	*more = 0;
 	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
 			       sock->sk->sk_protocol, &new_sock);
 	if (ret)
@@ -1821,6 +1822,7 @@ static int o2net_accept_one(struct socke
 	if (ret < 0)
 		goto out;
 
+	*more = 1;
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
 	ret = o2net_set_nodelay(new_sock);
@@ -1919,11 +1921,36 @@ out:
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
-	while (o2net_accept_one(sock) == 0)
+	int	more;
+	int	err;
+
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
+	for (;;) {
+		err = o2net_accept_one(sock, &more);
+		if (!more)
+			break;
 		cond_resched();
+	}
 }
 
 static void o2net_listen_data_ready(struct sock *sk)
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch
deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn.patch

