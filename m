Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB49D437138
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816328; cv=none; b=GHbHtpUaTk4fHcelSpTbUFFyuxdz2qdB0Nr+bMiMfn51evSkVyqp6142l0/zlDKQjDhieCFsQYulbAizkKQ956dMJanBEd1isw1AaZfmL3mqt6PnuLlTvMYHWPB+1L9Pwa1Bt5LPkm9qOE6WgdbulPVupimfVRwT3YU/+mTZs20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816328; c=relaxed/simple;
	bh=RnW82Q7dUd02n9TUStaWs69zJeKLP+omItVooobthA4=;
	h=Date:To:From:Subject:Message-Id; b=upivdGxEcZpOs2RHtySmmDan/dtSAMj/bPiL/U83DlK05u8I+tem+ZpL8tm+O16TD1WgTB+lb12Ife1rMfMvsnGNOxkEnPyiKDTDEjUaxSmon2mZqM+fRfNtnwQTYpaczOvxKyB+ZY3pof47RSY1TNKp17Hn1w5cTSv+K6MuQyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QEtMSAMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QEtMSAMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B0A1F000E9;
	Tue,  4 Aug 2026 04:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816326;
	bh=XZZ/qN6R2rNK9KSBsmVV+USX6F48Jy4TyDZ/pJVD88Y=;
	h=Date:To:From:Subject;
	b=QEtMSAMUPRv4VEcp7vt8YU2CYBB324UVyOTpr8vjPLx3S0LEJZyFQd/ZCd10i5cGX
	 GM2qRF4uv2LYzfQmaLb5ebwuGluNLz93LMxPVCSahTigtPH2TZnjEw08anhDblQ9e7
	 rrgmF3MPVAaiJjzFK/X5GC7PfZBlJfWynzR30IAE=
Date: Mon, 03 Aug 2026 21:05:26 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch removed from -mm tree
Message-Id: <20260804040526.C0B0A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cluster: use GFP_NOFS for heartbeat bio allocation
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cluster: use GFP_NOFS for heartbeat bio allocation
Date: Fri, 10 Jul 2026 15:17:55 +0800

o2hb_setup_one_bio() allocates the heartbeat bio with GFP_ATOMIC.  The
disk heartbeat runs in the o2hb kernel thread (o2hb_do_disk_heartbeat),
which is process context and can sleep, so there is no atomicity
requirement here.

GFP_ATOMIC lacks __GFP_DIRECT_RECLAIM, so the allocation is not served
from the fs_bio_set mempool reserve and can return NULL under memory
pressure.  A failed heartbeat allocation aborts the heartbeat and can lead
to the local node being fenced, which is exactly what the old comment
worried about.

Use GFP_NOFS instead.  It keeps __GFP_DIRECT_RECLAIM so the allocation is
backed by the fs_bio_set mempool and cannot fail, while avoiding recursion
back into the filesystem during heartbeat I/O.  As the allocation can no
longer fail, drop the dead ERR_PTR(-ENOMEM) path in o2hb_setup_one_bio()
and the now-redundant IS_ERR() handling in its callers.

Link: https://lore.kernel.org/20260710071756.3586797-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   41 ++++++---------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -522,16 +522,12 @@ static struct bio *o2hb_setup_one_bio(st
 	struct bio *bio;
 	struct page *page;
 
-	/* Testing has shown this allocation to take long enough under
-	 * GFP_KERNEL that the local node can get fenced. It would be
-	 * nicest if we could pre-allocate these bios and avoid this
-	 * all together. */
-	bio = bio_alloc(reg_bdev(reg), 16, opf, GFP_ATOMIC);
-	if (!bio) {
-		mlog(ML_ERROR, "Could not alloc slots BIO!\n");
-		bio = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
+	/*
+	 * The heartbeat runs in process context and can sleep, so use
+	 * GFP_NOFS. It is backed by the fs_bio_set mempool and thus cannot
+	 * fail, while avoiding recursion back into the filesystem.
+	 */
+	bio = bio_alloc(reg_bdev(reg), 16, opf, GFP_NOFS);
 
 	/* Must put everything in 512 byte sectors for the bio... */
 	bio->bi_iter.bi_sector = (reg->hr_start_block + cs) << (bits - 9);
@@ -556,7 +552,6 @@ static struct bio *o2hb_setup_one_bio(st
 		vec_start = 0;
 	}
 
-bail:
 	*current_slot = cs;
 	return bio;
 }
@@ -566,7 +561,6 @@ static int o2hb_read_slots(struct o2hb_r
 			   unsigned int max_slots)
 {
 	unsigned int current_slot = begin_slot;
-	int status;
 	struct o2hb_bio_wait_ctxt wc;
 	struct bio *bio;
 
@@ -575,30 +569,18 @@ static int o2hb_read_slots(struct o2hb_r
 	while(current_slot < max_slots) {
 		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
 					 REQ_OP_READ);
-		if (IS_ERR(bio)) {
-			status = PTR_ERR(bio);
-			mlog_errno(status);
-			goto bail_and_wait;
-		}
-
 		atomic_inc(&wc.wc_num_reqs);
 		submit_bio(bio);
 	}
 
-	status = 0;
-
-bail_and_wait:
 	o2hb_wait_on_io(&wc);
-	if (wc.wc_error && !status)
-		status = wc.wc_error;
 
-	return status;
+	return wc.wc_error;
 }
 
 static int o2hb_issue_node_write(struct o2hb_region *reg,
 				 struct o2hb_bio_wait_ctxt *write_wc)
 {
-	int status;
 	unsigned int slot;
 	struct bio *bio;
 
@@ -610,18 +592,11 @@ static int o2hb_issue_node_write(struct
 
 	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1,
 				 REQ_OP_WRITE | REQ_SYNC);
-	if (IS_ERR(bio)) {
-		status = PTR_ERR(bio);
-		mlog_errno(status);
-		goto bail;
-	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
 	submit_bio(bio);
 
-	status = 0;
-bail:
-	return status;
+	return 0;
 }
 
 static u32 o2hb_compute_block_crc_le(struct o2hb_region *reg,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


