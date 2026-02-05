Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDBC22DA1C
	for <mm-commits@vger.kernel.org>; Thu,  5 Feb 2026 23:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770334199; cv=none; b=gCKwAKlvftiTep5FJaiPpBXXrPe1Z8k5ue8bsNCMnFRWkAjxHiQGrjtXHwCp+h/8HJKE0YlqotA2La/ZSKWmpm6lqcpRg1OxLbUeC9qWz7zuvi79pyXLNfuqM4tmpbS+xpVh3LF8mtrFwQTd4YKr8HvWlX1701F0Mw/GoQu7nCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770334199; c=relaxed/simple;
	bh=JenXy+ylFMY1CTmNZHH3XVtjBMt6xxY0e7IPKcCdcL4=;
	h=Date:To:From:Subject:Message-Id; b=SSzDrWLseZE7GCz4fLSSYwpsKWKFVh7oQHuNCs/sDGHQDvwoGsJpqRZAYQDO+ohjX47I6UL0Ve4iDyRu4OIvU3shhuCxoArPw0MYAdWg/luHfjMGgyZpaWfhN5JswkTQrrkU6nhOejWvQOmjV9NvTTmJiq0JUgM4EVHgl4S1Am8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xS6+Z7hN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xS6+Z7hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3290C4CEF7;
	Thu,  5 Feb 2026 23:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770334198;
	bh=JenXy+ylFMY1CTmNZHH3XVtjBMt6xxY0e7IPKcCdcL4=;
	h=Date:To:From:Subject:From;
	b=xS6+Z7hNo/bgtJIQdfhJlDDui6kMyggsdlHkTMPniQIJjw4gyNX9D9BrqDDsgfeyS
	 wF5dTFNl2eayeNHq/s+aMUgg/1EhNpufEdzdeYezwJgvkKzdsf/Eh5/1arBe+RdFzQ
	 lRgPQdb2CJrebiyGSZl9jLgIHhpwCbI3RPC14HJM=
Date: Thu, 05 Feb 2026 15:29:58 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,swilczek.lx@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch removed from -mm tree
Message-Id: <20260205232958.C3290C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Szymon Wilczek <swilczek.lx@gmail.com>
Subject: ocfs2: fix circular locking dependency in ocfs2_acquire_dquot
Date: Thu, 8 Jan 2026 15:19:31 +0100

Move ocfs2_extend_no_holes() and ocfs2_start_trans() to execute before
ocfs2_lock_global_qf() to fix a circular locking dependency reported by
syzbot.

The issue occurs because ocfs2_start_trans() acquires sb_internal (via
sb_start_intwrite) while already holding quota file locks (ip_alloc_sem
and sysfile_lock_key).  This conflicts with freeze/dismount paths that
acquire sb_internal first, creating the following circular dependency:

  sb_internal -> sysfile_lock_key -> ip_alloc_sem (freeze/dismount)
  ip_alloc_sem -> sysfile_lock_key -> sb_internal (quota acquire)

Fix this by reordering the operations:
1. Speculatively extend quota file (uses need_alloc estimate)
2. Start transaction
3. Acquire global quota file lock
4. Perform quota operations
5. Release lock
6. Commit transaction

This ensures sb_internal is acquired before quota file locks, matching
the expected kernel lock order.

Link: https://lkml.kernel.org/r/20260108141931.67110-1-swilczek.lx@gmail.com
Reported-by: syzbot+51244a05705883616c95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug\?extid\=51244a05705883616c95
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   49 ++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot
+++ a/fs/ocfs2/quota_global.c
@@ -821,13 +821,35 @@ static int ocfs2_acquire_dquot(struct dq
 	trace_ocfs2_acquire_dquot(from_kqid(&init_user_ns, dquot->dq_id),
 				  type);
 	mutex_lock(&dquot->dq_lock);
+
+	/*
+	 * Speculatively extend quota file before acquiring any locks or
+	 * starting transaction to avoid lock inversion. sb_start_intwrite
+	 * (via ocfs2_start_trans) ranks above quota file locks.
+	 */
+	if (need_alloc) {
+		WARN_ON(journal_current_handle());
+		status = ocfs2_extend_no_holes(gqinode, NULL,
+			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
+			i_size_read(gqinode));
+		if (status < 0)
+			goto out;
+	}
+
+	handle = ocfs2_start_trans(osb,
+				   ocfs2_calc_global_qinit_credits(sb, type));
+	if (IS_ERR(handle)) {
+		status = PTR_ERR(handle);
+		goto out;
+	}
+
 	/*
 	 * We need an exclusive lock, because we're going to update use count
 	 * and instantiate possibly new dquot structure
 	 */
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
-		goto out;
+		goto out_trans;
 	status = ocfs2_qinfo_lock(info, 0);
 	if (status < 0)
 		goto out_dq;
@@ -843,29 +865,12 @@ static int ocfs2_acquire_dquot(struct dq
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
 	OCFS2_DQUOT(dquot)->dq_originodes = dquot->dq_dqb.dqb_curinodes;
-	if (!dquot->dq_off) {	/* No real quota entry? */
+	if (!dquot->dq_off)	/* No real quota entry? */
 		ex = 1;
-		/*
-		 * Add blocks to quota file before we start a transaction since
-		 * locking allocators ranks above a transaction start
-		 */
-		WARN_ON(journal_current_handle());
-		status = ocfs2_extend_no_holes(gqinode, NULL,
-			i_size_read(gqinode) + (need_alloc << sb->s_blocksize_bits),
-			i_size_read(gqinode));
-		if (status < 0)
-			goto out_dq;
-	}
 
-	handle = ocfs2_start_trans(osb,
-				   ocfs2_calc_global_qinit_credits(sb, type));
-	if (IS_ERR(handle)) {
-		status = PTR_ERR(handle);
-		goto out_dq;
-	}
 	status = ocfs2_qinfo_lock(info, ex);
 	if (status < 0)
-		goto out_trans;
+		goto out_dq;
 	status = qtree_write_dquot(&info->dqi_gi, dquot);
 	if (ex && info_dirty(sb_dqinfo(sb, type))) {
 		err = __ocfs2_global_write_info(sb, type);
@@ -873,10 +878,10 @@ static int ocfs2_acquire_dquot(struct dq
 			status = err;
 	}
 	ocfs2_qinfo_unlock(info, ex);
-out_trans:
-	ocfs2_commit_trans(osb, handle);
 out_dq:
 	ocfs2_unlock_global_qf(info, 1);
+out_trans:
+	ocfs2_commit_trans(osb, handle);
 	if (status < 0)
 		goto out;
 
_

Patches currently in -mm which might be from swilczek.lx@gmail.com are


