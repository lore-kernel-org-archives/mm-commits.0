From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch removed from
 -mm tree
Date: Wed, 03 Sep 2014 10:57:47 -0700
Message-ID: <5407569b.iRXsfc0iOJv9WeD5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR5s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: don't shutdown connection when idle timeout
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2net: don't shutdown connection when idle timeout

This patch series is to fix a possible message lost bug in ocfs2 when
network go bad.  This bug will cause ocfs2 hung forever even network
become good again.

The messages may lost in this case.  After the tcp connection is
established between two nodes, an idle timer will be set to check its
state periodically, if no messages are received during this time, idle
timer will timeout, it will shutdown the connection and try to reconnect,
so pending messages in tcp queues will be lost.  This messages may be from
dlm.  Dlm may get hung in this case.  This may cause the whole ocfs2
cluster hung.  

This is very possible to happen when network state goes bad.  Do the
reconnect is useless, it will fail if network state is still bad.  Just
waiting there for network recovering may be a good idea, it will not lost
messages and some node will be fenced until cluster goes into split-brain
state, for this case, Tcp user timeout is used to override the tcp
retransmit timeout.  It will timeout after 25 days, user should have
notice this through the provided log and fix the network, if they don't,
ocfs2 will fall back to original reconnect way.



This patch (of 3):

Some messages in the tcp queue maybe lost if we shutdown the connection
and reconnect when idle timeout.  If packets lost and reconnect success,
then the ocfs2 cluster maybe hung.

To fix this, we can leave the connection there and do the fence decision
when idle timeout, if network recover before fence dicision is made, the
connection survive without lost any messages.

This bug can be saw when network state go bad.  It may cause ocfs2 hung
forever if some packets lost.  With this fix, ocfs2 will recover from hung
if network becomes good again.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-dont-shutdown-connection-when-idle-timeout fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-dont-shutdown-connection-when-idle-timeout
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1536,16 +1536,20 @@ static void o2net_idle_timer(unsigned lo
 #endif
 
 	printk(KERN_NOTICE "o2net: Connection to " SC_NODEF_FMT " has been "
-	       "idle for %lu.%lu secs, shutting it down.\n", SC_NODEF_ARGS(sc),
-	       msecs / 1000, msecs % 1000);
+	       "idle for %lu.%lu secs.\n",
+	       SC_NODEF_ARGS(sc), msecs / 1000, msecs % 1000);
 
-	/*
-	 * Initialize the nn_timeout so that the next connection attempt
-	 * will continue in o2net_start_connect.
+	/* idle timerout happen, don't shutdown the connection, but
+	 * make fence decision. Maybe the connection can recover before
+	 * the decision is made.
 	 */
 	atomic_set(&nn->nn_timeout, 1);
+	o2quo_conn_err(o2net_num_from_nn(nn));
+	queue_delayed_work(o2net_wq, &nn->nn_still_up,
+			msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
+
+	o2net_sc_reset_idle_timer(sc);
 
-	o2net_sc_queue_work(sc, &sc->sc_shutdown_work);
 }
 
 static void o2net_sc_reset_idle_timer(struct o2net_sock_container *sc)
@@ -1560,6 +1564,15 @@ static void o2net_sc_reset_idle_timer(st
 
 static void o2net_sc_postpone_idle(struct o2net_sock_container *sc)
 {
+	struct o2net_node *nn = o2net_nn_from_num(sc->sc_node->nd_num);
+
+	/* clear fence decision since the connection recover from timeout*/
+	if (atomic_read(&nn->nn_timeout)) {
+		o2quo_conn_up(o2net_num_from_nn(nn));
+		cancel_delayed_work(&nn->nn_still_up);
+		atomic_set(&nn->nn_timeout, 0);
+	}
+
 	/* Only push out an existing timer */
 	if (timer_pending(&sc->sc_idle_timeout))
 		o2net_sc_reset_idle_timer(sc);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch

