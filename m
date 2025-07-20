Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C96D1624F7
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977371; cv=none; b=U7eHp4vOwIfsicgVEfFrIeQL+RnfUMgQaAEZ4annD2hKjtvitvb8qIh3YBNzqlGAzHhP8qMFNcToBfJvEL+1j3Jb3cxEyzLUY7bwJTf80XpZE9Riopv5WRIx9oOyYwVNwV3134loSyEanc1PgykqvnbPD6zK6Z09zYakxm7s30U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977371; c=relaxed/simple;
	bh=p01tA5nizloG7xeFqN0/PNpSOXQuybz5G539mwSvqY8=;
	h=Date:To:From:Subject:Message-Id; b=CteDjX6BUxTdyEO2KTmt3CsuMAehXUuAfegzmOmPiwwy3TRFyKMEUNhwKE7M9xYAeQS8XLzGTU53xvqdIvTiL4qJT+sBzU3M8TfoxX17A9mbWUy7iKeLuriMhXEC1dRrgtX9P3BUWd+K3bWry4qJVHONAWdyycBFo/fy41NplUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FKlZXpFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FKlZXpFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50787C4CEE3;
	Sun, 20 Jul 2025 02:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977371;
	bh=p01tA5nizloG7xeFqN0/PNpSOXQuybz5G539mwSvqY8=;
	h=Date:To:From:Subject:From;
	b=FKlZXpFjIG4Ot5ZVX/f5GoIbCMn2lQXWCg9OGMzlmtYPDGOJ/LCefb8SLNfjjGJnw
	 Qnbz4kSqH7hY/BeIKUUyOXV37bpkIrDOM6rF75FRMn4BFo7exDMa+n3a3oIui9y53k
	 wPve8q1wmb9BB4ECxi+uxNMguew1sF0Vh6q0oip4=
Date: Sat, 19 Jul 2025 19:09:30 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,ipravdin.official@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-avoid-potential-abba-deadlock-by-reordering-tl_inode-lock.patch removed from -mm tree
Message-Id: <20250720020931.50787C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-potential-abba-deadlock-by-reordering-tl_inode-lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ivan Pravdin <ipravdin.official@gmail.com>
Subject: ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock
Date: Mon, 7 Jul 2025 22:06:40 -0400

In ocfs2_move_extent(), tl_inode is currently locked after the global
bitmap inode.  However, in ocfs2_flush_truncate_log(), the lock order is
reversed: tl_inode is locked first, followed by the global bitmap inode.

This creates a classic ABBA deadlock scenario if two threads attempt these
operations concurrently and acquire the locks in different orders.

To prevent this, move the tl_inode locking earlier in ocfs2_move_extent(),
so that it always precedes the global bitmap inode lock.

No functional changes beyond lock ordering.

Link: https://lkml.kernel.org/r/20250708020640.387741-1-ipravdin.official@gmail.com
Reported-by: syzbot+6bf948e47f9bac7aacfa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67d5645c.050a0220.1dc86f.0004.GAE@google.com/
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-avoid-potential-abba-deadlock-by-reordering-tl_inode-lock
+++ a/fs/ocfs2/move_extents.c
@@ -617,6 +617,8 @@ static int ocfs2_move_extent(struct ocfs
 	 */
 	credits += OCFS2_INODE_UPDATE_CREDITS + 1;
 
+	inode_lock(tl_inode);
+
 	/*
 	 * ocfs2_move_extent() didn't reserve any clusters in lock_allocators()
 	 * logic, while we still need to lock the global_bitmap.
@@ -626,7 +628,7 @@ static int ocfs2_move_extent(struct ocfs
 	if (!gb_inode) {
 		mlog(ML_ERROR, "unable to get global_bitmap inode\n");
 		ret = -EIO;
-		goto out;
+		goto out_unlock_tl_inode;
 	}
 
 	inode_lock(gb_inode);
@@ -634,16 +636,14 @@ static int ocfs2_move_extent(struct ocfs
 	ret = ocfs2_inode_lock(gb_inode, &gb_bh, 1);
 	if (ret) {
 		mlog_errno(ret);
-		goto out_unlock_gb_mutex;
+		goto out_unlock_gb_inode;
 	}
 
-	inode_lock(tl_inode);
-
 	handle = ocfs2_start_trans(osb, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		mlog_errno(ret);
-		goto out_unlock_tl_inode;
+		goto out_unlock;
 	}
 
 	new_phys_blkno = ocfs2_clusters_to_blocks(inode->i_sb, *new_phys_cpos);
@@ -703,15 +703,14 @@ static int ocfs2_move_extent(struct ocfs
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 	brelse(gd_bh);
-
-out_unlock_tl_inode:
-	inode_unlock(tl_inode);
-
+out_unlock:
 	ocfs2_inode_unlock(gb_inode, 1);
-out_unlock_gb_mutex:
+out_unlock_gb_inode:
 	inode_unlock(gb_inode);
 	brelse(gb_bh);
 	iput(gb_inode);
+out_unlock_tl_inode:
+	inode_unlock(tl_inode);
 
 out:
 	if (context->meta_ac) {
_

Patches currently in -mm which might be from ipravdin.official@gmail.com are


