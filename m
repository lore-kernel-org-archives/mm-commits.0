Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8463F39F1
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816285; cv=none; b=okWkzjJaKE3UKRnjU2gfqO9kaWJWpNwj37jDt8BybXDmfrfgtsNSqI6ZM+OCeNEuQmwxccWmQ5r4UCNZUf45D8z9YjWFIwNqc1l3aeiF8Hd042MBv2h6YEl5YGDBkTapqwPz+9cV0PhdCV9ySemW3IVRcSm6K1OqDAm2zJdgymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816285; c=relaxed/simple;
	bh=zKOb68iCo3mWGkTMzihw8P1AWjto+JLvVG4mhBT3wpM=;
	h=Date:To:From:Subject:Message-Id; b=K2ReJqnAAiAIltcFzO+K6CObIok6sD2mMm9RkbZ/gFi+l8WQXp4PZx0Q2wjJqm59xi4lentw/mbcnzs6buXW+xT0N2fX/2ZeU78ehtcZI4ifsnt5SSy0G+W9yAoNFBscP9ea+AoLfYx8zTXy00MNvyW+AALwINYSgCRF6E/3HNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZcOMKBpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZcOMKBpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790AF1F00A3A;
	Tue,  4 Aug 2026 04:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816283;
	bh=nr3jV/Jl2C42Y77jb1fe5J81cBFTALnOZJXHxTWtH84=;
	h=Date:To:From:Subject;
	b=ZcOMKBpcEGeyNUpFO6t9pQtYQvFVC/ZwGxL5FkFCpt993yPl4gc3rr2CItPbgD+IJ
	 yseRffnD6qt6+BK69B2E1peL2wluKopHthONtdJYeYnxgFlCxOHrmtPfipuOrgOOak
	 1gQbTIYZQshMT0jkoN7skJNtBFPCTbU6eP5iilu8=
Date: Mon, 03 Aug 2026 21:04:43 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-keep-heartbeat-local-node-stable.patch removed from -mm tree
Message-Id: <20260804040443.790AF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/cluster: keep heartbeat local node stable
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-keep-heartbeat-local-node-stable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2/cluster: keep heartbeat local node stable
Date: Tue, 16 Jun 2026 15:49:31 +0800

o2nm_node_local_store() handles local=0 by stopping o2net and setting
cl_local_node to O2NM_INVALID_NODE_NUM, but it leaves cl_has_local set. 
That stale state makes o2nm_this_node() return 255, blocks a later local=1
attempt with -EBUSY, and can feed 255 to heartbeat users that call
o2nm_this_node() dynamically.

Clearing cl_has_local is required when the local node is reset.  But
heartbeat threads can still be running at that point.  They pin the local
node config item at startup, yet o2hb_do_disk_heartbeat() and thread
teardown re-read o2nm_this_node() for the local slot and for
o2nm_undepend_this_node().  Once local=0 has cleared the live local-node
state, those dynamic reads return O2NM_MAX_NODES, which is also the
invalid node number 255.

Store the local node number in the heartbeat region when the region
starts.  Use that stable node for heartbeat slot writes/checks,
negotiation messages, and the final configfs undepend.  Stop the heartbeat
loop when the current local node no longer matches the stored node, and
clear cl_has_local together with cl_local_node in the local=0 path so
nodemanager state matches node removal.

Validation reproduced this kernel report:
KASAN slab-out-of-bounds in o2hb_do_disk_heartbeat+0x372/0xb30
RIP: 0010:memset+0xf/0x20
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xd0/0x630
  o2hb_do_disk_heartbeat+0x372/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x188/0x2f0
  kasan_report+0xe4/0x120
  o2hb_do_disk_heartbeat+0x5/0xb30 (fs/ocfs2/cluster/heartbeat.c:1079)
  o2hb_thread+0x14e/0x770
  kthread_affine_node+0x139/0x180
  lockdep_hardirqs_on_prepare+0xda/0x190
  trace_hardirqs_on+0x18/0x130
  kthread+0x19d/0x1e0
  ret_from_fork+0x37a/0x4d0
  __switch_to+0x2d5/0x6f0
  ret_from_fork_asm+0x1a/0x30

Link: https://lore.kernel.org/20260616074931.3774929-1-zzzccc427@gmail.com
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c   |   43 ++++++++++++++++++++-----------
 fs/ocfs2/cluster/nodemanager.c |   19 ++++++++++---
 fs/ocfs2/cluster/nodemanager.h |    2 +
 3 files changed, 46 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-keep-heartbeat-local-node-stable
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -203,6 +203,7 @@ struct o2hb_region {
 
 	/* protected by the hr_callback_sem */
 	struct task_struct 	*hr_task;
+	u8			hr_node_num;
 
 	unsigned int		hr_blocks;
 	unsigned long long	hr_start_block;
@@ -350,12 +351,12 @@ static void o2hb_disarm_timeout(struct o
 	cancel_delayed_work_sync(&reg->hr_nego_timeout_work);
 }
 
-static int o2hb_send_nego_msg(int key, int type, u8 target)
+static int o2hb_send_nego_msg(int key, int type, u8 target, u8 node_num)
 {
 	struct o2hb_nego_msg msg;
 	int status, ret;
 
-	msg.node_num = o2nm_this_node();
+	msg.node_num = node_num;
 again:
 	ret = o2net_send_message(type, key, &msg, sizeof(msg),
 			target, &status);
@@ -373,8 +374,10 @@ static void o2hb_nego_timeout(struct wor
 	unsigned long live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 	int master_node, i, ret;
 	struct o2hb_region *reg;
+	u8 node_num;
 
 	reg = container_of(work, struct o2hb_region, hr_nego_timeout_work.work);
+	node_num = reg->hr_node_num;
 	/* don't negotiate timeout if last hb failed since it is very
 	 * possible io failed. Should let write timeout fence self.
 	 */
@@ -385,10 +388,10 @@ static void o2hb_nego_timeout(struct wor
 	/* lowest node as master node to make negotiate decision. */
 	master_node = find_first_bit(live_node_bitmap, O2NM_MAX_NODES);
 
-	if (master_node == o2nm_this_node()) {
+	if (master_node == node_num) {
 		if (!test_bit(master_node, reg->hr_nego_node_bitmap)) {
 			printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg).\n",
-				o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000,
+				node_num, O2HB_NEGO_TIMEOUT_MS / 1000,
 				config_item_name(&reg->hr_item), reg_bdev(reg));
 			set_bit(master_node, reg->hr_nego_node_bitmap);
 		}
@@ -417,7 +420,7 @@ static void o2hb_nego_timeout(struct wor
 
 			mlog(ML_HEARTBEAT, "send NEGO_APPROVE msg to node %d\n", i);
 			ret = o2hb_send_nego_msg(reg->hr_key,
-					O2HB_NEGO_APPROVE_MSG, i);
+					O2HB_NEGO_APPROVE_MSG, i, node_num);
 			if (ret)
 				mlog(ML_ERROR, "send NEGO_APPROVE msg to node %d fail %d\n",
 					i, ret);
@@ -425,10 +428,10 @@ static void o2hb_nego_timeout(struct wor
 	} else {
 		/* negotiate timeout with master node. */
 		printk(KERN_NOTICE "o2hb: node %d hb write hung for %ds on region %s (%pg), negotiate timeout with node %d.\n",
-			o2nm_this_node(), O2HB_NEGO_TIMEOUT_MS/1000, config_item_name(&reg->hr_item),
+			node_num, O2HB_NEGO_TIMEOUT_MS / 1000, config_item_name(&reg->hr_item),
 			reg_bdev(reg), master_node);
 		ret = o2hb_send_nego_msg(reg->hr_key, O2HB_NEGO_TIMEOUT_MSG,
-				master_node);
+				master_node, node_num);
 		if (ret)
 			mlog(ML_ERROR, "send NEGO_TIMEOUT msg to node %d fail %d\n",
 				master_node, ret);
@@ -601,7 +604,9 @@ static int o2hb_issue_node_write(struct
 
 	o2hb_bio_wait_init(write_wc);
 
-	slot = o2nm_this_node();
+	slot = reg->hr_node_num;
+	if (slot >= O2NM_MAX_NODES)
+		return -EINVAL;
 
 	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
 				 REQ_OP_WRITE | REQ_SYNC);
@@ -670,8 +675,12 @@ static int o2hb_check_own_slot(struct o2
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 	char *errstr;
+	u8 node_num = reg->hr_node_num;
+
+	if (node_num >= O2NM_MAX_NODES)
+		return 0;
 
-	slot = &reg->hr_slots[o2nm_this_node()];
+	slot = &reg->hr_slots[node_num];
 	/* Don't check on our 1st timestamp */
 	if (!slot->ds_last_time)
 		return 0;
@@ -712,7 +721,10 @@ static inline void o2hb_prepare_block(st
 	struct o2hb_disk_slot *slot;
 	struct o2hb_disk_heartbeat_block *hb_block;
 
-	node_num = o2nm_this_node();
+	node_num = reg->hr_node_num;
+	if (node_num >= O2NM_MAX_NODES)
+		return;
+
 	slot = &reg->hr_slots[node_num];
 
 	hb_block = (struct o2hb_disk_heartbeat_block *)slot->ds_raw_block;
@@ -1206,7 +1218,7 @@ static int o2hb_thread(void *data)
 	set_user_nice(current, MIN_NICE);
 
 	/* Pin node */
-	ret = o2nm_depend_this_node();
+	ret = o2nm_depend_node(reg->hr_node_num);
 	if (ret) {
 		mlog(ML_ERROR, "Node has been deleted, ret = %d\n", ret);
 		reg->hr_node_deleted = 1;
@@ -1215,7 +1227,8 @@ static int o2hb_thread(void *data)
 	}
 
 	while (!kthread_should_stop() &&
-	       !reg->hr_unclean_stop && !reg->hr_aborted_start) {
+	       !reg->hr_unclean_stop && !reg->hr_aborted_start &&
+	       o2nm_this_node() == reg->hr_node_num) {
 		/* We track the time spent inside
 		 * o2hb_do_disk_heartbeat so that we avoid more than
 		 * hr_timeout_ms between disk writes. On busy systems
@@ -1264,7 +1277,7 @@ static int o2hb_thread(void *data)
 	}
 
 	/* Unpin node */
-	o2nm_undepend_this_node();
+	o2nm_undepend_node(reg->hr_node_num);
 
 	mlog(ML_HEARTBEAT|ML_KTHREAD, "o2hb thread exiting\n");
 
@@ -1791,7 +1804,8 @@ static ssize_t o2hb_region_dev_store(str
 
 	/* We can't heartbeat without having had our node number
 	 * configured yet. */
-	if (o2nm_this_node() == O2NM_MAX_NODES)
+	reg->hr_node_num = o2nm_this_node();
+	if (reg->hr_node_num == O2NM_MAX_NODES)
 		return -EINVAL;
 
 	ret = kstrtol(p, 0, &fd);
@@ -2036,6 +2050,7 @@ static struct config_item *o2hb_heartbea
 		ret = -ENAMETOOLONG;
 		goto free;
 	}
+	reg->hr_node_num = O2NM_MAX_NODES;
 
 	spin_lock(&o2hb_live_lock);
 	reg->hr_region_num = 0;
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-cluster-keep-heartbeat-local-node-stable
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -367,6 +367,7 @@ static ssize_t o2nm_node_local_store(str
 	if (!tmp && cluster->cl_has_local &&
 	    cluster->cl_local_node == node->nd_num) {
 		o2net_stop_listening(node);
+		cluster->cl_has_local = 0;
 		cluster->cl_local_node = O2NM_INVALID_NODE_NUM;
 	}
 
@@ -782,12 +783,12 @@ void o2nm_undepend_item(struct config_it
 	configfs_undepend_item(item);
 }
 
-int o2nm_depend_this_node(void)
+int o2nm_depend_node(u8 node_num)
 {
 	int ret = 0;
 	struct o2nm_node *local_node;
 
-	local_node = o2nm_get_node_by_num(o2nm_this_node());
+	local_node = o2nm_get_node_by_num(node_num);
 	if (!local_node) {
 		ret = -EINVAL;
 		goto out;
@@ -800,17 +801,27 @@ out:
 	return ret;
 }
 
-void o2nm_undepend_this_node(void)
+void o2nm_undepend_node(u8 node_num)
 {
 	struct o2nm_node *local_node;
 
-	local_node = o2nm_get_node_by_num(o2nm_this_node());
+	local_node = o2nm_get_node_by_num(node_num);
 	BUG_ON(!local_node);
 
 	o2nm_undepend_item(&local_node->nd_item);
 	o2nm_node_put(local_node);
 }
 
+int o2nm_depend_this_node(void)
+{
+	return o2nm_depend_node(o2nm_this_node());
+}
+
+void o2nm_undepend_this_node(void)
+{
+	o2nm_undepend_node(o2nm_this_node());
+}
+
 
 static void __exit exit_o2nm(void)
 {
--- a/fs/ocfs2/cluster/nodemanager.h~ocfs2-cluster-keep-heartbeat-local-node-stable
+++ a/fs/ocfs2/cluster/nodemanager.h
@@ -65,6 +65,8 @@ void o2nm_node_put(struct o2nm_node *nod
 
 int o2nm_depend_item(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
+int o2nm_depend_node(u8 node_num);
+void o2nm_undepend_node(u8 node_num);
 int o2nm_depend_this_node(void);
 void o2nm_undepend_this_node(void);
 
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


