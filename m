From: akpm@linux-foundation.org
Subject: [merged]
 deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:53 -0700
Message-ID: <53a9cb5d.x7YaAK3Jf/qkPTn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFXTCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix deadlock when two nodes are converting same lock from PR to EX and idletimeout closes conn
has been removed from the -mm tree.  Its filename was
     deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: fix deadlock when two nodes are converting same lock from PR to EX and idletimeout closes conn

Orabug: 18639535

Two node cluster and both nodes hold a lock at PR level and both want to
convert to EX at the same time.  Master node 1 has sent BAST and then
closes the connection due to idletime out.  Node 0 receives BAST, sends
unlock req with cancel flag but gets error -ENOTCONN.  The problem is this
error is ignored in dlm_send_remote_unlock_request() on the **incorrect**
assumption that the master is dead.  See NOTE in comment why it returns
DLM_NORMAL.  Upon getting DLM_NORMAL, node 0 proceeds to sends convert
(without cancel flg) which fails with -ENOTCONN.  waits 5 sec and resends.
 This time gets DLM_IVLOCKID from the master since lock not found in grant
, it had been moved to converting queue in response to conv PR->EX req. 
No way out.

Node 1 (master)				Node 0
==============				======

lock mode PR				PR

convert PR -> EX
mv grant -> convert and que BAST
...
                     <-------- convert PR -> EX
convert que looks like this: ((node 1, PR -> EX) (node 0, PR -> EX))
...
			BAST (want PR -> NL)
                     ------------------>
...
idle timout, conn closed
                                ...
				In response to BAST,
				sends unlock with cancel convert flag
				gets -ENOTCONN. Ignores and
                                sends remote convert request
                                gets -ENOTCONN, waits 5 Sec, retries
...
reconnects
                   <----------------- convert req goes through on next try
does not find lock on grant que
                   status DLM_IVLOCKID
                   ------------------>
...

No way out.  Fix is to keep retrying unlock with cancel flag until it
succeeds or the master dies.

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmunlock.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/dlm/dlmunlock.c~deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn fs/ocfs2/dlm/dlmunlock.c
--- a/fs/ocfs2/dlm/dlmunlock.c~deadlock-when-two-nodes-are-converting-same-lock-from-pr-to-ex-and-idletimeout-closes-conn
+++ a/fs/ocfs2/dlm/dlmunlock.c
@@ -191,7 +191,9 @@ static enum dlm_status dlmunlock_common(
 				     DLM_UNLOCK_CLEAR_CONVERT_TYPE);
 		} else if (status == DLM_RECOVERING ||
 			   status == DLM_MIGRATING ||
-			   status == DLM_FORWARD) {
+			   status == DLM_FORWARD ||
+			   status == DLM_NOLOCKMGR
+			   ) {
 			/* must clear the actions because this unlock
 			 * is about to be retried.  cannot free or do
 			 * any list manipulation. */
@@ -200,7 +202,8 @@ static enum dlm_status dlmunlock_common(
 			     res->lockname.name,
 			     status==DLM_RECOVERING?"recovering":
 			     (status==DLM_MIGRATING?"migrating":
-			      "forward"));
+				(status == DLM_FORWARD ? "forward" :
+						"nolockmanager")));
 			actions = 0;
 		}
 		if (flags & LKM_CANCEL)
@@ -364,7 +367,10 @@ static enum dlm_status dlm_send_remote_u
 			 * updated state to the recovery master.  this thread
 			 * just needs to finish out the operation and call
 			 * the unlockast. */
-			ret = DLM_NORMAL;
+			if (dlm_is_node_dead(dlm, owner))
+				ret = DLM_NORMAL;
+			else
+				ret = DLM_NOLOCKMGR;
 		} else {
 			/* something bad.  this will BUG in ocfs2 */
 			ret = dlm_err_to_dlm_status(tmpret);
@@ -638,7 +644,9 @@ retry:
 
 	if (status == DLM_RECOVERING ||
 	    status == DLM_MIGRATING ||
-	    status == DLM_FORWARD) {
+	    status == DLM_FORWARD ||
+	    status == DLM_NOLOCKMGR) {
+
 		/* We want to go away for a tiny bit to allow recovery
 		 * / migration to complete on this resource. I don't
 		 * know of any wait queue we could sleep on as this
@@ -650,7 +658,7 @@ retry:
 		msleep(50);
 
 		mlog(0, "retrying unlock due to pending recovery/"
-		     "migration/in-progress\n");
+		     "migration/in-progress/reconnect\n");
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

origin.patch

