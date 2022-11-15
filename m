Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C079FC43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiKOWcc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbiKOWcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D29BD8A
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 154F0B81B8A
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBD4C433D6;
        Tue, 15 Nov 2022 22:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551520;
        bh=crC9bzDWx+3n6DBBh6OrtCpT2lH2nt5oHlnl6OTlfoY=;
        h=Date:To:From:Subject:From;
        b=aw/a5E3kk77g3COrY6ZVAFllfAIChtxjdY2ItFSgfKZKHUooz+yPEdeEJDmpeisXL
         lQNEUhlyVrbILxpuI1XKEP3sDMONtV66FMRt+0eXmQM3xAOoru7nOEHDInIsRBV9jH
         ce6SYZy5i8RVG2u4ysFIXOOaffH4bNNSnzAZfVTM=
Date:   Tue, 15 Nov 2022 14:32:00 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-use-bitmap-api-instead-of-hand-writing-it.patch removed from -mm tree
Message-Id: <20221115223200.AFBD4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2/cluster: use bitmap API instead of hand-writing it
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-use-bitmap-api-instead-of-hand-writing-it.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2/cluster: use bitmap API instead of hand-writing it
Date: Fri, 7 Oct 2022 20:48:44 +0800

Use bitmap_zero/bitmap_copy/bitmap_equal directly for bitmap operations.

Link: https://lkml.kernel.org/r/20221007124846.186453-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c   |   20 ++++++++++----------
 fs/ocfs2/cluster/nodemanager.c |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -335,7 +335,7 @@ static void o2hb_arm_timeout(struct o2hb
 	/* negotiate timeout must be less than write timeout. */
 	schedule_delayed_work(&reg->hr_nego_timeout_work,
 			      msecs_to_jiffies(O2HB_NEGO_TIMEOUT_MS));
-	memset(reg->hr_nego_node_bitmap, 0, sizeof(reg->hr_nego_node_bitmap));
+	bitmap_zero(reg->hr_nego_node_bitmap, O2NM_MAX_NODES);
 }
 
 static void o2hb_disarm_timeout(struct o2hb_region *reg)
@@ -386,8 +386,8 @@ static void o2hb_nego_timeout(struct wor
 				config_item_name(&reg->hr_item), reg->hr_bdev);
 			set_bit(master_node, reg->hr_nego_node_bitmap);
 		}
-		if (memcmp(reg->hr_nego_node_bitmap, live_node_bitmap,
-				sizeof(reg->hr_nego_node_bitmap))) {
+		if (!bitmap_equal(reg->hr_nego_node_bitmap, live_node_bitmap,
+				  O2NM_MAX_NODES)) {
 			/* check negotiate bitmap every second to do timeout
 			 * approve decision.
 			 */
@@ -856,8 +856,8 @@ static void o2hb_set_quorum_device(struc
 	 * live nodes heartbeat on it. In other words, the region has been
 	 * added to all nodes.
 	 */
-	if (memcmp(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
-		   sizeof(o2hb_live_node_bitmap)))
+	if (!bitmap_equal(reg->hr_live_node_bitmap, o2hb_live_node_bitmap,
+			  O2NM_MAX_NODES))
 		goto unlock;
 
 	printk(KERN_NOTICE "o2hb: Region %s (%pg) is now a quorum device\n",
@@ -1437,11 +1437,11 @@ void o2hb_init(void)
 	for (i = 0; i < ARRAY_SIZE(o2hb_live_slots); i++)
 		INIT_LIST_HEAD(&o2hb_live_slots[i]);
 
-	memset(o2hb_live_node_bitmap, 0, sizeof(o2hb_live_node_bitmap));
-	memset(o2hb_region_bitmap, 0, sizeof(o2hb_region_bitmap));
-	memset(o2hb_live_region_bitmap, 0, sizeof(o2hb_live_region_bitmap));
-	memset(o2hb_quorum_region_bitmap, 0, sizeof(o2hb_quorum_region_bitmap));
-	memset(o2hb_failed_region_bitmap, 0, sizeof(o2hb_failed_region_bitmap));
+	bitmap_zero(o2hb_live_node_bitmap, O2NM_MAX_NODES);
+	bitmap_zero(o2hb_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_live_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_quorum_region_bitmap, O2NM_MAX_REGIONS);
+	bitmap_zero(o2hb_failed_region_bitmap, O2NM_MAX_REGIONS);
 
 	o2hb_dependent_users = 0;
 
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-cluster-use-bitmap-api-instead-of-hand-writing-it
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -54,7 +54,7 @@ int o2nm_configured_node_map(unsigned lo
 		return -EINVAL;
 
 	read_lock(&cluster->cl_nodes_lock);
-	memcpy(map, cluster->cl_nodes_bitmap, sizeof(cluster->cl_nodes_bitmap));
+	bitmap_copy(map, cluster->cl_nodes_bitmap, O2NM_MAX_NODES);
 	read_unlock(&cluster->cl_nodes_lock);
 
 	return 0;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


