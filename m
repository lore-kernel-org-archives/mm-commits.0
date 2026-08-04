Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C82415F22
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816322; cv=none; b=EnOjF4ohL5D+RwBQxMttJbmE4FYL73rfxMLFOKkveIUkrByIGCq11B7TrVJ06ms3CrEVYEarNskq5RxKkR2EHPuP9mkBrFWvZvFvsewYW5UnlXG2cF3IvxNw8TUWBjrz2WwjS/M/pbdyU2K6WrxghcuxRBmBIfoEOVdyVejd8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816322; c=relaxed/simple;
	bh=xkiTuN0IeQ6Kes23XnWuaOKhUJidmJHiMj2DpC2IUxQ=;
	h=Date:To:From:Subject:Message-Id; b=GWIcfFMkseVe5UHXDNgQGJlZEUkjDaGTt5rmy8t8sMidxCJWQwJHBdq2OwOWG7fkmnwV6CFsfRx5x3G+kk1EgjJXBPveEOwvATFxwU6OSlMJRvgwPno6xOwEPfU9k6gi1UkC6yLcaq2426NnLm9ImC44ft24UrJcTzCXCDy/RZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9tAnRFA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9tAnRFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAEC1F00A3F;
	Tue,  4 Aug 2026 04:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816321;
	bh=dZOkh4NHPbFvlHGxS/ArhW/VF4wrn3BY5QLI/RBBIoE=;
	h=Date:To:From:Subject;
	b=m9tAnRFAOs9FAv/gpDzB9DPq0FDwWi9HbKD9dUMkAdXbCnsYezzcC+LONYo1ISdp0
	 l08vRwHi89yu1mGyN4uVYzKY50bGvxCmyXTUUeA8hnX8hrb1sB7puMmB5gK/EB2S2s
	 Oej7Cdt2zLT95UQcadn1XGa5XDYhX6VQdf/lYkIA=
Date: Mon, 03 Aug 2026 21:05:20 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch removed from -mm tree
Message-Id: <20260804040520.EAAEC1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
Date: Thu, 9 Jul 2026 09:01:01 +0300

This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation
failure during read").

Since 'make_bad_inode()' resets inode type to S_IFREG, doing this for
directory inode during active VFS lookup is likely to confuse the latter,
including VFS_BUG_ON_INODE() triggered in this case.

Link: https://lore.kernel.org/20260709060101.207262-1-dmantipov@yandex.ru
Fixes: 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation failure during read")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-do-not-use-make_bad_inode-in-ocfs2_read_inode_block_full
+++ a/fs/ocfs2/inode.c
@@ -1952,8 +1952,6 @@ int ocfs2_read_inode_block_full(struct i
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
-	if (rc < 0)
-		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


