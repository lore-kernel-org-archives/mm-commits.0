From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-o2hb-add-negotiate-timer-v2.patch removed
 from -mm tree
Date: Mon, 23 May 2016 14:36:55 -0700
Message-ID: <574377f7.w13PsaabZRRElg9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbcEWVg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 17:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-o2hb-add-negotiate-timer-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-o2hb-add-negotiate-timer-v2.patch

This patch was dropped because it was folded into ocfs2-o2hb-add-negotiate-timer.patch

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2-o2hb-add-negotiate-timer-v2

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate-timer-v2 fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-add-negotiate-timer-v2
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -357,12 +357,11 @@ static void o2hb_disarm_timeout(struct o
 
 static void o2hb_nego_timeout(struct work_struct *work)
 {
-	struct o2hb_region *reg =
-		container_of(work, struct o2hb_region,
-			     hr_nego_timeout_work.work);
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int master_node;
+	struct o2hb_region *reg;
 
+	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);
 	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_next_bit(live_node_bitmap, O2NM_MAX_NODES, 0);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-nego_timeout-message-v2.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-negotiate_approve-message-v2.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-add-some-user-debug-log-v2.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

