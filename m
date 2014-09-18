From: akpm@linux-foundation.org
Subject: + ocfs2-dont-fire-quorum-before-connection-established.patch
 added to -mm tree
Date: Thu, 18 Sep 2014 15:46:07 -0700
Message-ID: <541b60af.fpNdR2NzgNm2I854%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIRWqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 18:46:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: don't fire quorum before connection established
has been added to the -mm tree.  Its filename is
     ocfs2-dont-fire-quorum-before-connection-established.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dont-fire-quorum-before-connection-established.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dont-fire-quorum-before-connection-established.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: don't fire quorum before connection established

Firing quorum before connection established can cause unexpected node to
reboot.

Assume there are 3 nodes in the cluster, Node 1, 2, 3.  Node 2 and 3 have
wrong ip address of Node 1 in cluster.conf and global heartbeat is enabled
in the cluster.  After the heatbeats are started on these three nodes,
Node 1 will reboot due to quorum fencing.  It is similar case if Node 1's
networking is not ready when starting the global heartbeat.

The reboot is not friendly as customer is not fully ready for ocfs2 to
work.  Fix it by not allowing firing quorum before the connection is
established.  In this case, ocfs2 will wait until the wrong configuration
is fixed or networking is up to continue.  Also update the log to guide
the user where to check when connection is not built for a long time.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-dont-fire-quorum-before-connection-established fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-dont-fire-quorum-before-connection-established
+++ a/fs/ocfs2/cluster/tcp.c
@@ -536,7 +536,7 @@ static void o2net_set_nn_state(struct o2
 	if (nn->nn_persistent_error || nn->nn_sc_valid)
 		wake_up(&nn->nn_sc_wq);
 
-	if (!was_err && nn->nn_persistent_error) {
+	if (was_valid && !was_err && nn->nn_persistent_error) {
 		o2quo_conn_err(o2net_num_from_nn(nn));
 		queue_delayed_work(o2net_wq, &nn->nn_still_up,
 				   msecs_to_jiffies(O2NET_QUORUM_DELAY_MS));
@@ -1721,7 +1721,8 @@ static void o2net_connect_expired(struct
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
 		printk(KERN_NOTICE "o2net: No connection established with "
-		       "node %u after %u.%u seconds, giving up.\n",
+		       "node %u after %u.%u seconds, check network and"
+		       " cluster configuration.\n",
 		     o2net_num_from_nn(nn),
 		     o2net_idle_timeout() / 1000,
 		     o2net_idle_timeout() % 1000);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-dont-fire-quorum-before-connection-established.patch
ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch
ocfs2-fix-deadlock-due-to-wrong-locking-order.patch
mm-clear-__gfp_fs-when-pf_memalloc_noio-is-set.patch
ocfs2-fix-a-deadlock-while-o2net_wq-doing-direct-memory-reclaim.patch

