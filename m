From: akpm@linux-foundation.org
Subject: +
 ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch added to -mm tree
Date: Tue, 19 Nov 2013 15:30:09 -0800
Message-ID: <528bf481.AqT/olmZ18XMcLf5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3KSXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:30:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: + ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch added to -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:30:09 -0800


The patch titled
     Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one
has been added to the -mm tree.  Its filename is
     ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2/o2net: incorrect to terminate accepting connections loop upon rejecting an invalid one

When o2net-accept-one() rejects an illegal connection, it terminates the
loop picking up the remaining queued connections.  This fix will continue
accepting connections till the queue is emtpy.

Addresses Orabug 17489469.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1826,7 +1826,7 @@ int o2net_register_hb_callbacks(void)
 
 /* ------------------------------------------------------------ */
 
-static int o2net_accept_one(struct socket *sock)
+static int o2net_accept_one(struct socket *sock, int *more)
 {
 	int ret, slen;
 	struct sockaddr_in sin;
@@ -1837,6 +1837,7 @@ static int o2net_accept_one(struct socke
 	struct o2net_node *nn;
 
 	BUG_ON(sock == NULL);
+	*more = 0;
 	ret = sock_create_lite(sock->sk->sk_family, sock->sk->sk_type,
 			       sock->sk->sk_protocol, &new_sock);
 	if (ret)
@@ -1848,6 +1849,7 @@ static int o2net_accept_one(struct socke
 	if (ret < 0)
 		goto out;
 
+	*more = 1;
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
 	ret = o2net_set_nodelay(new_sock);
@@ -1949,8 +1951,15 @@ out:
 static void o2net_accept_many(struct work_struct *work)
 {
 	struct socket *sock = o2net_listen_sock;
-	while (o2net_accept_one(sock) == 0)
+	int	more;
+	int	err;
+
+	for (;;) {
+		err = o2net_accept_one(sock, &more);
+		if (!more)
+			break;
 		cond_resched();
+	}
 }
 
 static void o2net_listen_data_ready(struct sock *sk, int bytes)
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch
ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

