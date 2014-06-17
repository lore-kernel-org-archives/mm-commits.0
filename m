From: akpm@linux-foundation.org
Subject: + ocfs2-quorum-add-a-log-for-node-not-fenced.patch added to -mm
 tree
Date: Tue, 17 Jun 2014 15:43:34 -0700
Message-ID: <53a0c496.VrMX49qhJ2UpRS2w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584AbaFQWnf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 18:43:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srinivas.eeda@oracle.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com


The patch titled
     Subject: ocfs2: quorum: add a log for node not fenced
has been added to the -mm tree.  Its filename is
     ocfs2-quorum-add-a-log-for-node-not-fenced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-quorum-add-a-log-for-node-not-fenced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-quorum-add-a-log-for-node-not-fenced.patch

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
Subject: ocfs2: quorum: add a log for node not fenced

For debug use, we can see from the log whether the fence decision is made
and why it is not fenced.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
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

ocfs2-o2net-dont-shutdown-connection-when-idle-timeout.patch
ocfs2-o2net-set-tcp-user-timeout-to-max-value.patch
ocfs2-quorum-add-a-log-for-node-not-fenced.patch

