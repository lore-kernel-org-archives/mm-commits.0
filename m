From: akpm@linux-foundation.org
Subject: + ocfs2-fix-wrong-comment.patch added to -mm tree
Date: Tue, 06 Jan 2015 16:10:12 -0800
Message-ID: <54ac7964.AQChwRSsRcr1sDER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbAGAKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 19:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix wrong comment
has been added to the -mm tree.  Its filename is
     ocfs2-fix-wrong-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-wrong-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-wrong-comment.patch

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
Subject: ocfs2: fix wrong comment

O2NET_CONN_IDLE_DELAY is not defined, connection attempts will not be
canceled due to timeout.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp_internal.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/tcp_internal.h~ocfs2-fix-wrong-comment fs/ocfs2/cluster/tcp_internal.h
--- a/fs/ocfs2/cluster/tcp_internal.h~ocfs2-fix-wrong-comment
+++ a/fs/ocfs2/cluster/tcp_internal.h
@@ -107,12 +107,12 @@ struct o2net_node {
 	struct list_head		nn_status_list;
 
 	/* connects are attempted from when heartbeat comes up until either hb
-	 * goes down, the node is unconfigured, no connect attempts succeed
-	 * before O2NET_CONN_IDLE_DELAY, or a connect succeeds.  connect_work
-	 * is queued from set_nn_state both from hb up and from itself if a
-	 * connect attempt fails and so can be self-arming.  shutdown is
-	 * careful to first mark the nn such that no connects will be attempted
-	 * before canceling delayed connect work and flushing the queue. */
+	 * goes down, the node is unconfigured, or a connect succeeds.
+	 * connect_work is queued from set_nn_state both from hb up and from
+	 * itself if a connect attempt fails and so can be self-arming.
+	 * shutdown is careful to first mark the nn such that no connects will
+	 * be attempted before canceling delayed connect work and flushing the
+	 * queue. */
 	struct delayed_work		nn_connect_work;
 	unsigned long			nn_last_connect_attempt;
 
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-fix-uninitialized-variable-access.patch
ocfs2-fix-wrong-comment.patch

