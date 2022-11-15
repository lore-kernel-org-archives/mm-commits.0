Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E92C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiKOWca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiKOWcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7772C19
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7469C61A5C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ACFC433C1;
        Tue, 15 Nov 2022 22:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551521;
        bh=eOhrEQ+SkKU7pQJH8Wj5ActKd88J295T6s3j0OAxIMo=;
        h=Date:To:From:Subject:From;
        b=YhnGyDZJRBn4MK91GyyEgLA6p0ffWRGYWtP9rTsyYny7XDXyYkfcIMmXgSmY2crxx
         2DzeH+hkftdnXn+5caytHrW9Otk8wzraPomYx3xDLyHGkfx3ezC0n80B6BK3GfIgYL
         YUPM7hueSRCQPVuCvEsr0KTZU3yKuiHsRy6u3EO4=
Date:   Tue, 15 Nov 2022 14:32:01 -0800
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com,
        gechangwei@live.cn, joseph.qi@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-bitmap-api-in-fill_node_map.patch removed from -mm tree
Message-Id: <20221115223201.C8ACFC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: use bitmap API in fill_node_map
has been removed from the -mm tree.  Its filename was
     ocfs2-use-bitmap-api-in-fill_node_map.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: use bitmap API in fill_node_map
Date: Fri, 7 Oct 2022 20:48:45 +0800

Pass bits directly into fill_node_map helper and use bitmap API directly
to simplify code.

Link: https://lkml.kernel.org/r/20221007124846.186453-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   18 ++++++++----------
 fs/ocfs2/cluster/heartbeat.h |    2 +-
 fs/ocfs2/cluster/netdebug.c  |    2 +-
 fs/ocfs2/cluster/tcp.c       |    6 ++----
 fs/ocfs2/dlm/dlmdomain.c     |    2 +-
 fs/ocfs2/stack_o2cb.c        |    6 +++---
 6 files changed, 16 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -375,7 +375,7 @@ static void o2hb_nego_timeout(struct wor
 	if (reg->hr_last_hb_status)
 		return;
 
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
@@ -1087,7 +1087,7 @@ static int o2hb_do_disk_heartbeat(struct
 	 * If a node is not configured but is in the livemap, we still need
 	 * to read the slot so as to be able to remove it from the livemap.
 	 */
-	o2hb_fill_node_map(live_node_bitmap, sizeof(live_node_bitmap));
+	o2hb_fill_node_map(live_node_bitmap, O2NM_MAX_NODES);
 	i = -1;
 	while ((i = find_next_bit(live_node_bitmap,
 				  O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES) {
@@ -1450,23 +1450,21 @@ void o2hb_init(void)
 
 /* if we're already in a callback then we're already serialized by the sem */
 static void o2hb_fill_node_map_from_callback(unsigned long *map,
-					     unsigned bytes)
+					     unsigned int bits)
 {
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memcpy(map, &o2hb_live_node_bitmap, bytes);
+	bitmap_copy(map, o2hb_live_node_bitmap, bits);
 }
 
 /*
  * get a map of all nodes that are heartbeating in any regions
  */
-void o2hb_fill_node_map(unsigned long *map, unsigned bytes)
+void o2hb_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	/* callers want to serialize this map and callbacks so that they
 	 * can trust that they don't miss nodes coming to the party */
 	down_read(&o2hb_callback_sem);
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(map, bytes);
+	o2hb_fill_node_map_from_callback(map, bits);
 	spin_unlock(&o2hb_live_lock);
 	up_read(&o2hb_callback_sem);
 }
@@ -2460,7 +2458,7 @@ int o2hb_check_node_heartbeating_no_sem(
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
 	spin_lock(&o2hb_live_lock);
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	spin_unlock(&o2hb_live_lock);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
@@ -2477,7 +2475,7 @@ int o2hb_check_node_heartbeating_from_ca
 {
 	unsigned long testing_map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 
-	o2hb_fill_node_map_from_callback(testing_map, sizeof(testing_map));
+	o2hb_fill_node_map_from_callback(testing_map, O2NM_MAX_NODES);
 	if (!test_bit(node_num, testing_map)) {
 		mlog(ML_HEARTBEAT,
 		     "node (%u) does not have heartbeating enabled.\n",
--- a/fs/ocfs2/cluster/heartbeat.h~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/cluster/heartbeat.h
@@ -59,7 +59,7 @@ int o2hb_register_callback(const char *r
 void o2hb_unregister_callback(const char *region_uuid,
 			      struct o2hb_callback_func *hc);
 void o2hb_fill_node_map(unsigned long *map,
-			unsigned bytes);
+			unsigned int bits);
 void o2hb_exit(void);
 void o2hb_init(void);
 int o2hb_check_node_heartbeating_no_sem(u8 node_num);
--- a/fs/ocfs2/cluster/netdebug.c~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -438,7 +438,7 @@ static int o2net_fill_bitmap(char *buf,
 	unsigned long map[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int i = -1, out = 0;
 
-	o2net_fill_node_map(map, sizeof(map));
+	o2net_fill_node_map(map, O2NM_MAX_NODES);
 
 	while ((i = find_next_bit(map, O2NM_MAX_NODES, i + 1)) < O2NM_MAX_NODES)
 		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/cluster/tcp.c
@@ -990,14 +990,12 @@ static int o2net_tx_can_proceed(struct o
 }
 
 /* Get a map of all nodes to which this node is currently connected to */
-void o2net_fill_node_map(unsigned long *map, unsigned bytes)
+void o2net_fill_node_map(unsigned long *map, unsigned int bits)
 {
 	struct o2net_sock_container *sc;
 	int node, ret;
 
-	BUG_ON(bytes < (BITS_TO_LONGS(O2NM_MAX_NODES) * sizeof(unsigned long)));
-
-	memset(map, 0, bytes);
+	bitmap_zero(map, bits);
 	for (node = 0; node < O2NM_MAX_NODES; ++node) {
 		if (!o2net_tx_can_proceed(o2net_nn_from_num(node), &sc, &ret))
 			continue;
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1604,7 +1604,7 @@ static int dlm_try_to_join_domain(struct
 	/* group sem locking should work for us here -- we're already
 	 * registered for heartbeat events so filling this should be
 	 * atomic wrt getting those handlers called. */
-	o2hb_fill_node_map(dlm->live_nodes_map, sizeof(dlm->live_nodes_map));
+	o2hb_fill_node_map(dlm->live_nodes_map, O2NM_MAX_NODES);
 
 	spin_lock(&dlm->spinlock);
 	memcpy(ctxt->live_map, dlm->live_nodes_map, sizeof(ctxt->live_map));
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-use-bitmap-api-in-fill_node_map
+++ a/fs/ocfs2/stack_o2cb.c
@@ -273,17 +273,17 @@ static int o2cb_cluster_check(void)
 	 */
 #define	O2CB_MAP_STABILIZE_COUNT	60
 	for (i = 0; i < O2CB_MAP_STABILIZE_COUNT; ++i) {
-		o2hb_fill_node_map(hbmap, sizeof(hbmap));
+		o2hb_fill_node_map(hbmap, O2NM_MAX_NODES);
 		if (!test_bit(node_num, hbmap)) {
 			printk(KERN_ERR "o2cb: %s heartbeat has not been "
 			       "started.\n", (o2hb_global_heartbeat_active() ?
 					      "Global" : "Local"));
 			return -EINVAL;
 		}
-		o2net_fill_node_map(netmap, sizeof(netmap));
+		o2net_fill_node_map(netmap, O2NM_MAX_NODES);
 		/* Force set the current node to allow easy compare */
 		set_bit(node_num, netmap);
-		if (!memcmp(hbmap, netmap, sizeof(hbmap)))
+		if (bitmap_equal(hbmap, netmap, O2NM_MAX_NODES))
 			return 0;
 		if (i < O2CB_MAP_STABILIZE_COUNT - 1)
 			msleep(1000);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


