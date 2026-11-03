Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675985;
	b=qL98vwC1r2BhvO+DCwYdG9L+5zBlNGIyjp595hvBqHUod63qjIo0IutTIumaZpBxqPL5
	 sV3HHtVJ2gNtM7EU98uTwGjPqACqCd62n/4S5djWCwPvrV2eyZ9Wd0R1FaDFv76xM4rU1
	 TQMqLMYakQImwJmhnyxX99cnJTHjcexYI0z4kIIRvEnUSVSMB5NCZ5gIvvASXjAsfnQzo
	 oRIqT7EA6acconaHNwwFw7UN6wD/xK7SL6nXfA8gbwz7dUN8XYeCiqbEnJ/c3/yayFj30
	 5YwpocB184K9anYLqj2v856oQZrL/sfOZp9QUDn9/6d9lTsxw8WzTR6pLECL+N1TGnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675985;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cD55soKBuVNeTqtBtw3fyWy6Zhcy6lphTDTzlA4jpgA=;
	b=oqq7VIi4c/pe/GdQUwvIhwS+h5rxiLiLNMS+sXuMRRNn96rRV/gGEwpRk4Rylqr3/D1/
	 0u9m6LAtnUrkN27W5CvOp7OGhc2QPpR9CBzvhGE9HxcqhBYwW+fTRvf2p4yPi0982vJmE
	 b/hRBFkY9SL7QrX3kEQMd667a6v/7QHweTg7WXpSTDoT11Nr7POpACSCwTXYKE9gnj0gN
	 t96sWbsRcBAYpiqsP3wf49d0AT4ERfmPK8wVgOVIFMOPcD2zHkIn2QEdE2dimxeJcqsTk
	 ssnxOh1/fOqI1my1tu3k1XPtaJRhvmWOyyVUsSgCInMN5IjTwsib+lRHC45i6gph90Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="a/U5I71S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D20606A324;
	Tue,  3 Nov 2026 03:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a/U5I71S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0591F0093A;
	Tue,  3 Nov 2026 03:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675985;
	bh=cD55soKBuVNeTqtBtw3fyWy6Zhcy6lphTDTzlA4jpgA=;
	h=Date:To:From:Subject;
	b=a/U5I71SAR/NCmMFhPp346A1cST9z8GYK0XI3Ap2cXaPrnv3YEQ5rP66Q977Slgcn
	 aD5S8cr8elBGwy0Iyxz/RnQeE9YquBQVz122AEE6Iz8MJFuK8Z6tt68VWarJNkMELD
	 JIFjVau8iaOejl/U8PtPjKkfJYMpVMZdJT8hUHdg=
Date: Mon, 02 Nov 2026 19:19:44 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-validate-move-extents-against-a-stable-eof.patch removed from -mm tree
Message-Id: <20261103031945.4C0591F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: validate move extents against a stable EOF
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-move-extents-against-a-stable-eof.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: validate move extents against a stable EOF
Date: Mon, 26 Oct 2026 19:04:00 +0800

The move-extents range must be bounded by the inode size used for extent
movement.  ocfs2_ioctl_move_extents() checks and clamps the request before
taking the local inode and cluster locks in ocfs2_move_extents().  It also
uses separate i_size_read() calls for the range check and subtraction.

A concurrent truncate can invalidate the first check and make the later
unsigned subtraction underflow:

  Move-extents ioctl                  Truncate
  ------------------                  --------
  check me_start <= i_size
                                      take inode and cluster locks
                                      shrink EOF below me_start
                                      release locks
  compare me_start + me_len with EOF
  set me_len = EOF - me_start
    [unsigned underflow]
  acquire inode and cluster locks
  select extents using the bad range

A truncate after clamping can also leave the range extending beyond EOF. 
Conversely, the cached size may be smaller than the size refreshed when
the cluster inode lock is acquired.  Early validation can then reject a
valid start or permanently shorten the requested length and threshold. 
The me_start + me_len comparison can also wrap for a large input length.

Validate and adjust the original request once, after inode_lock(), the
exclusive rw lock and ocfs2_inode_lock() have stabilized and refreshed the
size.  Read EOF once, reject a start beyond it, and bound the length by
EOF minus start.  Normalize the threshold using the same EOF snapshot. 
This keeps zero as the default-threshold sentinel until validation uses
the size that will govern extent movement.

Move goal validation after range adjustment as well.  Its allocation-group
capacity check uses me_len and must see the EOF-clamped length.  Both
validation failures use the existing inode-lock unwind path before any
extent movement or transaction starts.

Range errors now reach the ioctl's normal copyout path, as goal errors
already did.  Unlike the old early rejection, a failed copyout can
therefore override -EINVAL with -EFAULT.

Link: https://lore.kernel.org/pm-ocfs2-move-extents-isize-rrw-v6-395bdee84ea81149068e@gmail.com
Fixes: 53069d4e7695 ("Ocfs2/move_extents: move/defrag extents within a certain range.")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/move_extents.c |   70 +++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 31 deletions(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-validate-move-extents-against-a-stable-eof
+++ a/fs/ocfs2/move_extents.c
@@ -907,6 +907,30 @@ out:
 	return ret;
 }
 
+static int ocfs2_validate_and_adjust_move_range(struct inode *inode,
+						struct ocfs2_move_extents *range)
+{
+	u64 i_size = i_size_read(inode);
+
+	if (range->me_start > i_size)
+		return -EINVAL;
+
+	if (range->me_len > i_size - range->me_start)
+		range->me_len = i_size - range->me_start;
+
+	/*
+	 * The default threshold for defragmentation is 1 MiB, which
+	 * matches the maximum OCFS2 cluster size.
+	 */
+	if (!range->me_threshold)
+		range->me_threshold = 1024 * 1024;
+
+	if (range->me_threshold > i_size)
+		range->me_threshold = i_size;
+
+	return 0;
+}
+
 static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 {
 	int status;
@@ -936,6 +960,21 @@ static int ocfs2_move_extents(struct ocf
 		goto out_rw_unlock;
 	}
 
+	status = ocfs2_validate_and_adjust_move_range(inode, context->range);
+	if (status) {
+		mlog_errno(status);
+		goto out_inode_unlock;
+	}
+
+	/* The goal check depends on the adjusted range length. */
+	if (!context->auto_defrag) {
+		status = ocfs2_validate_and_adjust_move_goal(inode, context->range);
+		if (status) {
+			mlog_errno(status);
+			goto out_inode_unlock;
+		}
+	}
+
 	/*
 	 * remember ip_xattr_sem also needs to be held if necessary
 	 */
@@ -1028,27 +1067,8 @@ int ocfs2_ioctl_move_extents(struct file
 		goto out_free;
 	}
 
-	if (range.me_start > i_size_read(inode)) {
-		status = -EINVAL;
-		goto out_free;
-	}
-
-	if (range.me_start + range.me_len > i_size_read(inode))
-			range.me_len = i_size_read(inode) - range.me_start;
-
 	context->range = &range;
 
-	/*
-	 * ok, the default threshold for the defragmentation
-	 * is 1M, since our maximum clustersize was 1M also.
-	 * any thought?
-	 */
-	if (!range.me_threshold)
-		range.me_threshold = 1024 * 1024;
-
-	if (range.me_threshold > i_size_read(inode))
-		range.me_threshold = i_size_read(inode);
-
 	if (range.me_flags & ~(OCFS2_MOVE_EXT_FL_AUTO_DEFRAG |
 			       OCFS2_MOVE_EXT_FL_PART_DEFRAG)) {
 		status = -EINVAL;
@@ -1060,23 +1080,11 @@ int ocfs2_ioctl_move_extents(struct file
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
-	} else {
-		/*
-		 * first best-effort attempt to validate and adjust the goal
-		 * (physical address in block), while it can't guarantee later
-		 * operation can succeed all the time since global_bitmap may
-		 * change a bit over time.
-		 */
-
-		status = ocfs2_validate_and_adjust_move_goal(inode, &range);
-		if (status)
-			goto out_copy;
 	}
 
 	status = ocfs2_move_extents(context);
 	if (status)
 		mlog_errno(status);
-out_copy:
 	/*
 	 * movement/defragmentation may end up being partially completed,
 	 * that's the reason why we need to return userspace the finished
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


