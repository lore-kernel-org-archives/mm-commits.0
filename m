Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051770;
	b=2nRxjqNvVOu7RWKrDw7MR75AoOrRnWxNYXL0IfiGJhI/SRy3ecE25fJjXkySXfI86a6t
	 maLVtGFie6YlHmMo0oC5mt5DOEwt7slwIwuO2snmkWGKAcN1UldmIXMPPBLvE9D/31Iq8
	 OrB7dFQPDksZcwRpZUSU4i+LKQJKF9L4Aqt9Z+YXUoCNXBd/804kaQECzWQc/AAK4uDSh
	 s9KhTslc+StY6jZYcNYZ5S4uQIa9T9OpZSm8B9AqzcBp42TfHfsBGQB9vPTs8dM0v+Mx0
	 MpiaUbxWiheovWHh11X2RmQVq7qYtHYbhJp1rKkN5NLBwH3UNmDkwwIBHVVAIbjJoZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051770;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=MdDVPM16hrarczTaXjisnBzLIMM4O1xzyqeyQ7HLrFk=;
	b=U0HHUbgseZ2iwN25jmZoGbfDK8G9lStjVHde25tf6IR+j7CYEu+Pj/J5OFoT9zvtNz6j
	 ogpaycApJXJBQobhoG8cdfPXG9zzS5EhvJPI3mfAdkoGfni+zd93q4hoTikdKrcwm++Tx
	 7VGMCPjyYbSQMSrk5qOi6mZBz8VKdmvQ8nahZRM9+aSW5iMQrZtOYOgN8ywMweACXgkQT
	 RVeY0vUdM4i8mAGKGeoBryZUlZ24a6hXI9daV/1XQ/5t5SjV0/d/B8TTOl92Lmj0jpw9W
	 4gjCDuq2MEUjpLGmOHVc5FS1Jmoa5uIC1Tek93t6lAgQ1yuiIT0VzVtW6ykcuaA8L5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W1vWFAHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC30A606A31E;
	Mon, 26 Oct 2026 21:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=W1vWFAHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D451F01828;
	Mon, 26 Oct 2026 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793051769;
	bh=MdDVPM16hrarczTaXjisnBzLIMM4O1xzyqeyQ7HLrFk=;
	h=Date:To:From:Subject;
	b=W1vWFAHp7cUDYSL4eVPb4cA2sl+1RBrvmvcZvpHP8PNBR+Qx4SOZWDoMZQZkNuR6C
	 Z188SmUVh8wGjFDydEXq5jwI5UFG3Q9uaPg0Mub72HLR/r2eqRqX3Cq3FBOERO4SuU
	 akcb5hMbObiKiksQev+Sy51elGs2RCynvh0tVf4M=
Date: Mon, 26 Oct 2026 14:56:09 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-move-extents-against-a-stable-eof.patch added to mm-nonmm-unstable branch
Message-Id: <20261026215609.91D451F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: validate move extents against a stable EOF
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-move-extents-against-a-stable-eof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-move-extents-against-a-stable-eof.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-validate-move-extents-against-a-stable-eof.patch

