From: akpm@linux-foundation.org
Subject: [merged] o2hb-increase-unsteady-iterations.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:31 -0800
Message-ID: <56997343.zUk0Bni/RdS+q4qx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbcAOWbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, jlbec@evilplan.org, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: increase unsteady iterations
has been removed from the -mm tree.  Its filename was
     o2hb-increase-unsteady-iterations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: increase unsteady iterations

When run multiple xattr test of ocfs2-test on a three-nodes cluster, mount
failed sometimes with the following message.

o2hb: Unable to stabilize heartbeart on region D18B775E758D4D80837E8CF3D086AD4A (xvdb)

Stabilize heartbeat depends on the timing order to mount ocfs2 from
cluster nodes and how fast the tcp connections are established.  So
increase unsteady interations to leave more time for it.

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~o2hb-increase-unsteady-iterations fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~o2hb-increase-unsteady-iterations
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1780,8 +1780,8 @@ static ssize_t o2hb_region_dev_store(str
 	}
 	++live_threshold;
 	atomic_set(&reg->hr_steady_iterations, live_threshold);
-	/* unsteady_iterations is double the steady_iterations */
-	atomic_set(&reg->hr_unsteady_iterations, (live_threshold << 1));
+	/* unsteady_iterations is triple the steady_iterations */
+	atomic_set(&reg->hr_unsteady_iterations, (live_threshold * 3));
 
 	hb_task = kthread_run(o2hb_thread, reg, "o2hb-%s",
 			      reg->hr_item.ci_name);
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


