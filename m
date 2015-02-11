From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-wrong-comment.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:01 -0800
Message-ID: <54dbb9ad.5ux22fqb+XbjzvNy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix wrong comment
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-wrong-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
ocfs2-prepare-some-interfaces-used-in-append-direct-io.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-implement-ocfs2_direct_io_write.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-complete-the-rest-request-through-buffer-io.patch
ocfs2-wait-for-orphan-recovery-first-once-append-o_direct-write-crash.patch
ocfs2-set-append-dio-as-a-ro-compat-feature.patch

