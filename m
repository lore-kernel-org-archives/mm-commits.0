Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20594438017
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816329; cv=none; b=P74s9uJynEzjtCEx6t8W4f1ylMzSQhuPJEg3BoDZ7baWmBZJIj/4Rsh1y767tFpHUAzpuCgEcnKwrR/eHKIwkIOTKMn9uFnU6v7W5QXdteaBaelzVjPHisru0QWfGE6YCO9DGKBVIP5p9h/VV2TnxCez5nmToSsRS8xar8XuxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816329; c=relaxed/simple;
	bh=zCEXbv6ZkM8g5kIxrayiV4/xilE3BRE67div+CYYyt4=;
	h=Date:To:From:Subject:Message-Id; b=SucMDT8yJUhFC+iyG6SdklstVwYislPVfzreZcV3TKDA/Gyexgz+qs6W/bZ4lblybjPuCtfNKnjtY8H7DzSZWf1s04qJAXz37hDEDcBJZENieokE4q5txEynlf1k7kRchDrRWpFDSer3hL4YzpwWPrBTICIp7YcaGBHFIJYzN6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ouwd2jFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ouwd2jFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC961F00A3A;
	Tue,  4 Aug 2026 04:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816328;
	bh=53K3zUQiVOYWtEdraIRQtRvLcVrLZKW60mQmYuVzd7o=;
	h=Date:To:From:Subject;
	b=ouwd2jFsReRT8PKiddHyIdgA6PhiiT20lSf0jU9P9BPkMnPpbvwzVY9SBPH6oqpbr
	 hNFfd7FVdfZOpyxBE1BJkvQYlxkz1wP+jZO834zRPrNRAIza1U2ICuQ13nD99ZE+jR
	 8Ejkn+PuD2WMS/eSlyN+R9M2puiJel4SvQdLtwYQ=
Date: Mon, 03 Aug 2026 21:05:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch removed from -mm tree
Message-Id: <20260804040527.EAC961F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cluster: use an on-stack bio for the heartbeat write
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cluster: use an on-stack bio for the heartbeat write
Date: Fri, 10 Jul 2026 15:17:56 +0800

The disk heartbeat write always covers this node's own single slot, i.e. 
one heartbeat block that lives within a single page.  It is submitted by
o2hb_issue_node_write() and waited on by the caller before the ctxt goes
out of scope, so its lifetime is well bounded.

Turn it into an on-stack bio embedded in struct o2hb_bio_wait_ctxt rather
than allocating one from the mempool.  This removes any allocation from
the fence-critical write path entirely: a delayed or blocked heartbeat
write is what leads to the local node being fenced, so it should not
depend on the state of a shared bio pool.

Because the bio is embedded rather than allocated, add a dedicated
o2hb_write_bio_end_io() that does not call bio_put(), and tear the bio
down with bio_uninit() once the caller has waited on the I/O.

The read path still allocates via o2hb_setup_one_bio() with GFP_NOFS,
since it issues a variable number of bios in a loop.

Link: https://lore.kernel.org/20260710071756.3586797-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   50 +++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -272,6 +272,9 @@ struct o2hb_bio_wait_ctxt {
 	atomic_t          wc_num_reqs;
 	struct completion wc_io_complete;
 	int               wc_error;
+	/* On-stack bio used by the synchronous write path only. */
+	struct bio        wc_write_bio;
+	struct bio_vec    wc_write_bvec;
 };
 
 #define O2HB_NEGO_TIMEOUT_MS (O2HB_MAX_WRITE_TIMEOUT_MS/2)
@@ -507,6 +510,23 @@ static void o2hb_bio_end_io(struct bio *
 	bio_put(bio);
 }
 
+/*
+ * End I/O for the synchronous write path. The write bio is embedded in
+ * the wait ctxt rather than allocated, so it must not be freed here; it
+ * is torn down with bio_uninit() once the caller has waited on it.
+ */
+static void o2hb_write_bio_end_io(struct bio *bio)
+{
+	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
+
+	if (bio->bi_status) {
+		mlog(ML_ERROR, "IO Error %d\n", bio->bi_status);
+		wc->wc_error = blk_status_to_errno(bio->bi_status);
+	}
+
+	o2hb_bio_wait_dec(wc, 1);
+}
+
 /* Setup a Bio to cover I/O against num_slots slots starting at
  * start_slot. */
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
@@ -582,7 +602,11 @@ static int o2hb_issue_node_write(struct
 				 struct o2hb_bio_wait_ctxt *write_wc)
 {
 	unsigned int slot;
-	struct bio *bio;
+	unsigned int bits = reg->hr_block_bits;
+	unsigned int spp = reg->hr_slots_per_page;
+	unsigned int vec_start, vec_len;
+	struct page *page;
+	struct bio *bio = &write_wc->wc_write_bio;
 
 	o2hb_bio_wait_init(write_wc);
 
@@ -590,8 +614,21 @@ static int o2hb_issue_node_write(struct
 	if (slot >= O2NM_MAX_NODES)
 		return -EINVAL;
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
-				 REQ_OP_WRITE | REQ_SYNC);
+	/*
+	 * The heartbeat write always covers our own single slot, i.e. one
+	 * block that lives within a single page. Use an on-stack bio (embedded
+	 * in write_wc) so this fence-critical path never has to allocate.
+	 */
+	bio_init(bio, reg_bdev(reg), &write_wc->wc_write_bvec, 1,
+		 REQ_OP_WRITE | REQ_SYNC);
+	bio->bi_iter.bi_sector = (reg->hr_start_block + slot) << (bits - 9);
+	bio->bi_private = write_wc;
+	bio->bi_end_io = o2hb_write_bio_end_io;
+
+	page = reg->hr_slot_data[slot / spp];
+	vec_start = (slot << bits) % PAGE_SIZE;
+	vec_len = PAGE_SIZE / spp;
+	__bio_add_page(bio, page, vec_len, vec_start);
 
 	atomic_inc(&write_wc->wc_num_reqs);
 	submit_bio(bio);
@@ -1133,6 +1170,7 @@ static int o2hb_do_disk_heartbeat(struct
 	 * people we find in our steady state have seen us.
 	 */
 	o2hb_wait_on_io(&write_wc);
+	bio_uninit(&write_wc.wc_write_bio);
 	if (write_wc.wc_error) {
 		/* Do not re-arm the write timeout on I/O error - we
 		 * can't be sure that the new block ever made it to
@@ -1245,10 +1283,12 @@ static int o2hb_thread(void *data)
 	if (!reg->hr_unclean_stop && !reg->hr_aborted_start) {
 		o2hb_prepare_block(reg, 0);
 		ret = o2hb_issue_node_write(reg, &write_wc);
-		if (ret == 0)
+		if (ret == 0) {
 			o2hb_wait_on_io(&write_wc);
-		else
+			bio_uninit(&write_wc.wc_write_bio);
+		} else {
 			mlog_errno(ret);
+		}
 	}
 
 	/* Unpin node */
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


