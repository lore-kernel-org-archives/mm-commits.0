Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9179E7DA7B;
	Mon,  2 Sep 2024 03:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248756; cv=none; b=i1iaGxk1EqOTX0oDmbvsxqwROKbLm+FuR8LKXiuRt7aCCzbmpa77MawX91TsvROw2Cq4SZ5S3iDePc7HcKk2t1Gc0ay4sEEkSGEZ74MgRgksjl3c9K3iFCI4l7KLqG/mBI9tjvB0Sh42yC4JLZOmjiayOvs7sm357cy8Wj0L73c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248756; c=relaxed/simple;
	bh=HZ2tuSX8G8EG3sjziunwSkDRF5wRnq3haKFHhBNK/Rc=;
	h=Date:To:From:Subject:Message-Id; b=DSEOF+woAd+je1lFmFILSGHVghqbkHukgrkMGI5MboB1tY9gk6ve++TVWma0LmdYWKZixlonyPo14OrKJ9x4OnoW321aL+I7ZzgB+h9LKma8q5yX6BCI2UOxQiPTE65Em+J7ld5CSO1pptvoTB8NRdLnxIwN5jzf4udpo/PpPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mkuqj15Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mkuqj15Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CE1C4CEC7;
	Mon,  2 Sep 2024 03:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248756;
	bh=HZ2tuSX8G8EG3sjziunwSkDRF5wRnq3haKFHhBNK/Rc=;
	h=Date:To:From:Subject:From;
	b=mkuqj15QHd5rp10RIvp7J/HPnlObQLrEd6DET8AlrQNw59+WNvX6qpArGep3NKz2p
	 Xf6d2lnqSXn+mr1W9pxRnQlTUQDhZgmx0pf3s1TNurtE6CTdGLVA8MhsebBWeAbQrH
	 lq89SLsXPuieDGBTKnnNuO7vM7quiUbrnzP+DfCA=
Date: Sun, 01 Sep 2024 20:45:55 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,glass.su@suse.com,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch removed from -mm tree
Message-Id: <20240902034556.07CE1C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix the la space leak when unmounting an ocfs2 volume
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Fri, 19 Jul 2024 19:43:10 +0800

This bug has existed since the initial OCFS2 code.  The code logic in
ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
free bits, which causes an OCFS2 volume to lose the last free clusters of
LA window on each umount command.

Link: https://lkml.kernel.org/r/20240719114310.14245-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ocfs2/localalloc.c~ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume
+++ a/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);
_

Patches currently in -mm which might be from heming.zhao@suse.com are


