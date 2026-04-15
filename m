Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7657C9F
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244544; cv=none; b=E57PRIThOwacLt/E/46ZPB0afm2zK9GlfqvJptA73O/lI7x1JMKnBnHmJfLgXpecoSk8tQG00t9Csxv1hBzYAyMAvBpLlR6kHj5GSdrbWeZCzETfIUWwOuNtrY0/U3RRCm1JsGqYrhpniaYlrskSZLanINwk2rKz6wdrafZLfms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244544; c=relaxed/simple;
	bh=hcqidZy0jBRtIsOnSL5JkIAs0kDdQ2yakuwO9irt/Lk=;
	h=Date:To:From:Subject:Message-Id; b=R5ZbbE8tffGyde4XmfRjivXEBB8hnPvR+seThVRGzCawm8HmcApb5fiwokVoUYAPi0rs5rkjobc3SotFAnfTJCFhBTMseu3WYcc/aYLEXO7riv6bmF8REvF1+YVfYeJgv96MJg5HRCOxAfCdUYWMKawhhmcabrj6qOo0hbQ1ltA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BOzqUUPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BOzqUUPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A35C19424;
	Wed, 15 Apr 2026 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244543;
	bh=hcqidZy0jBRtIsOnSL5JkIAs0kDdQ2yakuwO9irt/Lk=;
	h=Date:To:From:Subject:From;
	b=BOzqUUPrgqU142cGfx3NV0dTwST6HOWDKWchhzL6dinJnr8E5pQiHcc/JP17pRjep
	 WqlY9AqWAFZS0SDGzc969P1lG9cRtzSj4aabRcZZkYDpW5yZOpVA9j0bZO96XvHnYS
	 Q1aKS5MhkSfiiZcP4eLmTVAv0TrEVUf+Q6v85r8o=
Date: Wed, 15 Apr 2026 02:15:39 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,ericterminal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-heartbeat-fix-slot-mapping-rollback-leaks-on-error-paths.patch removed from -mm tree
Message-Id: <20260415091543.62A35C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/heartbeat: fix slot mapping rollback leaks on error paths
has been removed from the -mm tree.  Its filename was
     ocfs2-heartbeat-fix-slot-mapping-rollback-leaks-on-error-paths.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yufan Chen <ericterminal@gmail.com>
Subject: ocfs2/heartbeat: fix slot mapping rollback leaks on error paths
Date: Mon, 30 Mar 2026 23:34:28 +0800

o2hb_map_slot_data() allocates hr_tmp_block, hr_slots, hr_slot_data, and
pages in stages.  If a later allocation fails, the current code returns
without unwinding the earlier allocations.

o2hb_region_dev_store() also leaves slot mapping resources behind when
setup aborts, and it keeps hr_aborted_start/hr_node_deleted set across
retries.  That leaves stale state behind after a failed start.

Factor the slot cleanup into o2hb_unmap_slot_data(), use it from both
o2hb_map_slot_data() and o2hb_region_release(), and call it from the
dev_store() rollback after stopping a started heartbeat thread.  While
freeing pages, clear each hr_slot_data entry as it is released, and reset
the start state before each new setup attempt.

This closes the slot mapping leak on allocation/setup failure paths and
keeps failed setup attempts retryable.

Link: https://lkml.kernel.org/r/20260330153428.19586-1-yufan.chen@linux.dev
Signed-off-by: Yufan Chen <ericterminal@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   83 ++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 27 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-heartbeat-fix-slot-mapping-rollback-leaks-on-error-paths
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1488,33 +1488,45 @@ static struct o2hb_region *to_o2hb_regio
 	return item ? container_of(item, struct o2hb_region, hr_item) : NULL;
 }
 
-/* drop_item only drops its ref after killing the thread, nothing should
- * be using the region anymore.  this has to clean up any state that
- * attributes might have built up. */
-static void o2hb_region_release(struct config_item *item)
+static void o2hb_unmap_slot_data(struct o2hb_region *reg)
 {
 	int i;
 	struct page *page;
-	struct o2hb_region *reg = to_o2hb_region(item);
-
-	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
-
-	kfree(reg->hr_tmp_block);
 
 	if (reg->hr_slot_data) {
 		for (i = 0; i < reg->hr_num_pages; i++) {
 			page = reg->hr_slot_data[i];
-			if (page)
+			if (page) {
 				__free_page(page);
+				reg->hr_slot_data[i] = NULL;
+			}
 		}
 		kfree(reg->hr_slot_data);
+		reg->hr_slot_data = NULL;
 	}
 
+	kfree(reg->hr_slots);
+	reg->hr_slots = NULL;
+
+	kfree(reg->hr_tmp_block);
+	reg->hr_tmp_block = NULL;
+}
+
+/* drop_item only drops its ref after killing the thread, nothing should
+ * be using the region anymore.  this has to clean up any state that
+ * attributes might have built up.
+ */
+static void o2hb_region_release(struct config_item *item)
+{
+	struct o2hb_region *reg = to_o2hb_region(item);
+
+	mlog(ML_HEARTBEAT, "hb region release (%pg)\n", reg_bdev(reg));
+
+	o2hb_unmap_slot_data(reg);
+
 	if (reg->hr_bdev_file)
 		fput(reg->hr_bdev_file);
 
-	kfree(reg->hr_slots);
-
 	debugfs_remove_recursive(reg->hr_debug_dir);
 	kfree(reg->hr_db_livenodes);
 	kfree(reg->hr_db_regnum);
@@ -1667,6 +1679,7 @@ static void o2hb_init_region_params(stru
 static int o2hb_map_slot_data(struct o2hb_region *reg)
 {
 	int i, j;
+	int ret = -ENOMEM;
 	unsigned int last_slot;
 	unsigned int spp = reg->hr_slots_per_page;
 	struct page *page;
@@ -1674,14 +1687,14 @@ static int o2hb_map_slot_data(struct o2h
 	struct o2hb_disk_slot *slot;
 
 	reg->hr_tmp_block = kmalloc(reg->hr_block_bytes, GFP_KERNEL);
-	if (reg->hr_tmp_block == NULL)
-		return -ENOMEM;
+	if (!reg->hr_tmp_block)
+		goto out;
 
 	reg->hr_slots = kzalloc_objs(struct o2hb_disk_slot, reg->hr_blocks);
-	if (reg->hr_slots == NULL)
-		return -ENOMEM;
+	if (!reg->hr_slots)
+		goto out;
 
-	for(i = 0; i < reg->hr_blocks; i++) {
+	for (i = 0; i < reg->hr_blocks; i++) {
 		slot = &reg->hr_slots[i];
 		slot->ds_node_num = i;
 		INIT_LIST_HEAD(&slot->ds_live_item);
@@ -1695,12 +1708,12 @@ static int o2hb_map_slot_data(struct o2h
 
 	reg->hr_slot_data = kzalloc_objs(struct page *, reg->hr_num_pages);
 	if (!reg->hr_slot_data)
-		return -ENOMEM;
+		goto out;
 
-	for(i = 0; i < reg->hr_num_pages; i++) {
+	for (i = 0; i < reg->hr_num_pages; i++) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
-			return -ENOMEM;
+			goto out;
 
 		reg->hr_slot_data[i] = page;
 
@@ -1720,6 +1733,10 @@ static int o2hb_map_slot_data(struct o2h
 	}
 
 	return 0;
+
+out:
+	o2hb_unmap_slot_data(reg);
+	return ret;
 }
 
 /* Read in all the slots available and populate the tracking
@@ -1809,9 +1826,11 @@ static ssize_t o2hb_region_dev_store(str
 		     "blocksize %u incorrect for device, expected %d",
 		     reg->hr_block_bytes, sectsize);
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
+	reg->hr_aborted_start = 0;
+	reg->hr_node_deleted = 0;
 	o2hb_init_region_params(reg);
 
 	/* Generation of zero is invalid */
@@ -1823,13 +1842,13 @@ static ssize_t o2hb_region_dev_store(str
 	ret = o2hb_map_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	ret = o2hb_populate_slot_data(reg);
 	if (ret) {
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	INIT_DELAYED_WORK(&reg->hr_write_timeout_work, o2hb_write_timeout);
@@ -1860,7 +1879,7 @@ static ssize_t o2hb_region_dev_store(str
 	if (IS_ERR(hb_task)) {
 		ret = PTR_ERR(hb_task);
 		mlog_errno(ret);
-		goto out3;
+		goto out;
 	}
 
 	spin_lock(&o2hb_live_lock);
@@ -1877,12 +1896,12 @@ static ssize_t o2hb_region_dev_store(str
 
 	if (reg->hr_aborted_start) {
 		ret = -EIO;
-		goto out3;
+		goto out;
 	}
 
 	if (reg->hr_node_deleted) {
 		ret = -EINVAL;
-		goto out3;
+		goto out;
 	}
 
 	/* Ok, we were woken.  Make sure it wasn't by drop_item() */
@@ -1901,8 +1920,18 @@ static ssize_t o2hb_region_dev_store(str
 		printk(KERN_NOTICE "o2hb: Heartbeat started on region %s (%pg)\n",
 		       config_item_name(&reg->hr_item), reg_bdev(reg));
 
-out3:
+out:
 	if (ret < 0) {
+		spin_lock(&o2hb_live_lock);
+		hb_task = reg->hr_task;
+		reg->hr_task = NULL;
+		spin_unlock(&o2hb_live_lock);
+
+		if (hb_task)
+			kthread_stop(hb_task);
+
+		o2hb_unmap_slot_data(reg);
+
 		fput(reg->hr_bdev_file);
 		reg->hr_bdev_file = NULL;
 	}
_

Patches currently in -mm which might be from ericterminal@gmail.com are


