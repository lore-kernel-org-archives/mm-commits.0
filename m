From: akpm@linux-foundation.org
Subject: [merged] ocfs2-quorum-add-a-log-for-node-not-fenced.patch removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:51 -0700
Message-ID: <5407569f.+WzeFr/FD54eIGOl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, srinivas.eeda@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: quorum: add a log for node not fenced
has been removed from the -mm tree.  Its filename was
     ocfs2-quorum-add-a-log-for-node-not-fenced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: quorum: add a log for node not fenced

For debug use, we can see from the log whether the fence decision is made
and why it is not fenced.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-quorum-add-a-log-for-node-not-fenced fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-quorum-add-a-log-for-node-not-fenced
+++ a/fs/ocfs2/cluster/quorum.c
@@ -160,9 +160,18 @@ static void o2quo_make_decision(struct w
 	}
 
 out:
-	spin_unlock(&qs->qs_lock);
-	if (fence)
+	if (fence) {
+		spin_unlock(&qs->qs_lock);
 		o2quo_fence_self();
+	} else {
+		mlog(ML_NOTICE, "not fencing this node, heartbeating: %d, "
+			"connected: %d, lowest: %d (%sreachable)\n",
+			qs->qs_heartbeating, qs->qs_connected, lowest_hb,
+			lowest_reachable ? "" : "un");
+		spin_unlock(&qs->qs_lock);
+
+	}
+
 }
 
 static void o2quo_set_hold(struct o2quo_state *qs, u8 node)
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-reflink-fix-slow-unlink-for-refcounted-file.patch
ocfs2-fix-journal-commit-deadlock.patch

