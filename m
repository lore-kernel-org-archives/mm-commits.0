Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7265286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127185; cv=none; b=TBW/F0e/z4uTYaLzQjoP6BQqiAkCsr8iN9p9kA6P1/yLQbE4kMCf4tE1zgRtVLxv+PUYbaOzPQ5r8a/XDDX6haBWUJau/HJoNbvERN+ja1nRrIOUSfU1QxtU4jFZ9ssTe8yUDXTTT3YcKIITPRsasaCuXx5Tqoenjot4rxPD+oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127185; c=relaxed/simple;
	bh=wxJixpFy/snb7VgPn+kqvn9g5XmmjcGy0TMLCTGvsNw=;
	h=Date:To:From:Subject:Message-Id; b=rjEFQIxlZLYd47zkG6ymnwJL76MdkyZvvDZVp5fyfZZyOuuCanlKFGp94xb4VTvqO9BU7Xew9LboRLKn1MmJlMnS6zJdTcB36ZkXokL6oGbQvWndtfvgdICYNi5hc2l4eNpjdlqawDMVwkTpXZ4SEsh+C83QZnW1D/+X7QY66Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2EALB0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2EALB0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5A9C4CEE3;
	Thu, 10 Jul 2025 05:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127185;
	bh=wxJixpFy/snb7VgPn+kqvn9g5XmmjcGy0TMLCTGvsNw=;
	h=Date:To:From:Subject:From;
	b=w2EALB0CumM6/sLEnmF+OIP5nvlOLoiojzxYcwtck+cxKJBcXwZEW2U33QD/TPlHa
	 ftaGVlwjrbYi2JhcB/uwQEZaSyqz5MUhb8tRtxiyCvTfFRKE5pAddyM58HwBXMuVXZ
	 o5sfRH4xtLGyQwpbwMnzDUt4KPFYDac3/ri3BQ/s=
Date: Wed, 09 Jul 2025 22:59:45 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com,richard@nod.at,piaojun@huawei.com,penguin-kernel@i-love-sakura.ne.jp,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-update-d_splice_alias-return-code-checking.patch removed from -mm tree
Message-Id: <20250710055945.9C5A9C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: update d_splice_alias() return code checking
has been removed from the -mm tree.  Its filename was
     ocfs2-update-d_splice_alias-return-code-checking.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: update d_splice_alias() return code checking
Date: Mon, 30 Jun 2025 19:21:31 +0900

When commit d3556babd7fa ("ocfs2: fix d_splice_alias() return code
checking") was merged into v3.18-rc3, d_splice_alias() was returning one
of a valid dentry, NULL or an ERR_PTR.

When commit b5ae6b15bd73 ("merge d_materialise_unique() into
d_splice_alias()") was merged into v3.19-rc1, d_splice_alias() started
returning -ELOOP as one of ERR_PTR values.

Now, when syzkaller mounts a crafted ocfs2 filesystem image that hits
d_splice_alias() == -ELOOP case from ocfs2_lookup(), ocfs2_lookup() fails
to handle -ELOOP case and generic_shutdown_super() hits "VFS: Busy inodes
after unmount" message.

Instead of calling ocfs2_dentry_attach_lock() or ocfs2_dentry_attach_gen()
when d_splice_alias() returned an ERR_PTR value, change ocfs2_lookup() to
bail out immediately.

Also, ocfs2_lookup() needs to call dupt() when ocfs2_dentry_attach_lock()
returned an ERR_PTR value.

Link: https://lkml.kernel.org/r/da5be67d-2a0b-4b93-85d6-42f3b7440135@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1134d3a5b062e9665a7a
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tetsuo Handa <penguin-kernel@i-love-sakura.ne.jp>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-update-d_splice_alias-return-code-checking
+++ a/fs/ocfs2/namei.c
@@ -142,6 +142,8 @@ static struct dentry *ocfs2_lookup(struc
 
 bail_add:
 	ret = d_splice_alias(inode, dentry);
+	if (IS_ERR(ret))
+		goto bail_unlock;
 
 	if (inode) {
 		/*
@@ -154,15 +156,16 @@ bail_add:
 		 * NOTE: This dentry already has ->d_op set from
 		 * ocfs2_get_parent() and ocfs2_get_dentry()
 		 */
-		if (!IS_ERR_OR_NULL(ret))
+		if (ret)
 			dentry = ret;
 
 		status = ocfs2_dentry_attach_lock(dentry, inode,
 						  OCFS2_I(dir)->ip_blkno);
 		if (status) {
 			mlog_errno(status);
+			if (ret)
+				dput(ret);
 			ret = ERR_PTR(status);
-			goto bail_unlock;
 		}
 	} else
 		ocfs2_dentry_attach_gen(dentry);
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch

