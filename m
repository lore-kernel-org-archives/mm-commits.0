From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:36 -0700
Message-ID: <533f085c.NyYdMccffAeOjZD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaDDTah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, jlbec@evilplan.org, tariq.x.saeed@oracle.com

Subject: [merged] ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch removed from -mm tree
To: tariq.x.saeed@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,srinivas.eeda@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:36 -0700


The patch titled
     Subject: ocfs2/o2net: o2net_listen_data_ready should do nothing if socket state is not TCP_LISTEN
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2/o2net: o2net_listen_data_ready should do nothing if socket state is not TCP_LISTEN

Orabug: 17330860

When accepting an incomming connection o2net_accept_one clones a child
data socket from the parent listening socket.  It then proceeds to setup
the child with callback o2net_data_ready() and sk_user_data to NULL.  If
data arrives in this window, o2net_listen_data_ready will be called with
some non-deterministic value in sk_user_data (not inherited).  We panic
when we page fault on sk_user_data -- in parent it is sock_def_readable().
 The fix is to recognize that this is a data socket being set up by
looking at the socket state and do nothing.

Signed-off-by: Tariq Saseed <tariq.x.saeed@oracle.com>
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-o2net_listen_data_ready-should-do-nothing-if-socket-state-is-not-tcp_listen
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1964,18 +1964,30 @@ static void o2net_listen_data_ready(stru
 		goto out;
 	}
 
-	/* ->sk_data_ready is also called for a newly established child socket
-	 * before it has been accepted and the acceptor has set up their
-	 * data_ready.. we only want to queue listen work for our listening
-	 * socket */
+	/* This callback may called twice when a new connection
+	 * is  being established as a child socket inherits everything
+	 * from a parent LISTEN socket, including the data_ready cb of
+	 * the parent. This leads to a hazard. In o2net_accept_one()
+	 * we are still initializing the child socket but have not
+	 * changed the inherited data_ready callback yet when
+	 * data starts arriving.
+	 * We avoid this hazard by checking the state.
+	 * For the listening socket,  the state will be TCP_LISTEN; for the new
+	 * socket, will be  TCP_ESTABLISHED. Also, in this case,
+	 * sk->sk_user_data is not a valid function pointer.
+	 */
+
 	if (sk->sk_state == TCP_LISTEN) {
 		mlog(ML_TCP, "bytes: %d\n", bytes);
 		queue_work(o2net_wq, &o2net_listen_work);
+	} else {
+		ready = NULL;
 	}
 
 out:
 	read_unlock(&sk->sk_callback_lock);
-	ready(sk, bytes);
+	if (ready != NULL)
+		ready(sk, bytes);
 }
 
 static int o2net_open_listening_sock(__be32 addr, __be16 port)
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch
ocfs2-o2net-incorrect-to-terminate-accepting-connections-loop-upon-rejecting-an-invalid-one.patch

