Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170DE2BE653;
	Fri, 19 Sep 2025 21:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758316044; cv=none; b=V2TlAHQC0i38fDup5FeQiJF6TcExyuMaGky2iumv2H/6PR9tHh4gO4QBnTC9B5lL9YodecKvG9/5iyUBx3/0oy1kMLEZI+tOwCzhd/6k999WVIMg0kLICTSLWp4+ccjrYjIG77LHwUhVpjhP35eQbQD0lfOxV+Ig7+RJQLEqvZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758316044; c=relaxed/simple;
	bh=rJc9yPU41ifibH1xbMxA1Q9hKKO4z8mUpv1BvJ+5uxk=;
	h=Date:To:From:Subject:Message-Id; b=ZDBHnxEUqQpqYTBOkm1ooxxGTif5ealH4OG+wmuf2+qhgrZbS/NM8Vj3SAkTxb+J6l+BJIze3kRDgRMXRMLiLBotRGYHpNntHcY0NGE6T8yF0ircyOvqS+tHBGAIveaeHpMiLwcMmH9eZHRpUi8lsCMYGwYhefhZQZgwPGonEXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1bSOih1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1bSOih1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91432C4CEF0;
	Fri, 19 Sep 2025 21:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758316043;
	bh=rJc9yPU41ifibH1xbMxA1Q9hKKO4z8mUpv1BvJ+5uxk=;
	h=Date:To:From:Subject:From;
	b=1bSOih1mDlmLTUvuK88S4MpU39ooBIWqx4G3kv8VzEZGHpCis4qRjm8sWbq/bsreP
	 FDhwArQFEZfPSBmtNpSi1BT8HOpgpTnDIqIbsjif/QWt9aCTBH5mKGUatjMgKmHkxm
	 SfiNaXunrQqYOG8v9OuTfPH5eWxId595D6UtkviY=
Date: Fri, 19 Sep 2025 14:07:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-uninit-value-in-squashfs_get_parent.patch added to mm-nonmm-unstable branch
Message-Id: <20250919210723.91432C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: fix uninit-value in squashfs_get_parent
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-uninit-value-in-squashfs_get_parent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-uninit-value-in-squashfs_get_parent.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix uninit-value in squashfs_get_parent
Date: Fri, 19 Sep 2025 00:33:08 +0100

Syzkaller reports a "KMSAN: uninit-value in squashfs_get_parent" bug.

This is caused by open_by_handle_at() being called with a file handle
containing an invalid parent inode number.  In particular the inode number
is that of a symbolic link, rather than a directory.

Squashfs_get_parent() gets called with that symbolic link inode, and
accesses the parent member field.

	unsigned int parent_ino = squashfs_i(inode)->parent;

Because non-directory inodes in Squashfs do not have a parent value, this
is uninitialised, and this causes an uninitialised value access.

The fix is to initialise parent with the invalid inode 0, which will cause
an EINVAL error to be returned.

Regular inodes used to share the parent field with the block_list_start
field.  This is removed in this commit to enable the parent field to
contain the invalid inode number 0.

Link: https://lkml.kernel.org/r/20250918233308.293861-1-phillip@squashfs.org.uk
Fixes: 122601408d20 ("Squashfs: export operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+157bdef5cf596ad0da2c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68cc2431.050a0220.139b6.0001.GAE@google.com/
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c         |    7 +++++++
 fs/squashfs/squashfs_fs_i.h |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/squashfs/inode.c~squashfs-fix-uninit-value-in-squashfs_get_parent
+++ a/fs/squashfs/inode.c
@@ -169,6 +169,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->start = le32_to_cpu(sqsh_ino->start_block);
 		squashfs_i(inode)->block_list_start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
@@ -216,6 +217,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->start = le64_to_cpu(sqsh_ino->start_block);
 		squashfs_i(inode)->block_list_start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
@@ -296,6 +298,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_mode |= S_IFLNK;
 		squashfs_i(inode)->start = block;
 		squashfs_i(inode)->offset = offset;
+		squashfs_i(inode)->parent = 0;
 
 		if (type == SQUASHFS_LSYMLINK_TYPE) {
 			__le32 xattr;
@@ -333,6 +336,7 @@ int squashfs_read_inode(struct inode *in
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
+		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
 				SQUASHFS_INODE_BLK(ino), offset, rdev);
@@ -357,6 +361,7 @@ int squashfs_read_inode(struct inode *in
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		rdev = le32_to_cpu(sqsh_ino->rdev);
 		init_special_inode(inode, inode->i_mode, new_decode_dev(rdev));
+		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
 				SQUASHFS_INODE_BLK(ino), offset, rdev);
@@ -377,6 +382,7 @@ int squashfs_read_inode(struct inode *in
 			inode->i_mode |= S_IFSOCK;
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
+		squashfs_i(inode)->parent = 0;
 		break;
 	}
 	case SQUASHFS_LFIFO_TYPE:
@@ -396,6 +402,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_op = &squashfs_inode_ops;
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		init_special_inode(inode, inode->i_mode, 0);
+		squashfs_i(inode)->parent = 0;
 		break;
 	}
 	default:
--- a/fs/squashfs/squashfs_fs_i.h~squashfs-fix-uninit-value-in-squashfs_get_parent
+++ a/fs/squashfs/squashfs_fs_i.h
@@ -16,6 +16,7 @@ struct squashfs_inode_info {
 	u64		xattr;
 	unsigned int	xattr_size;
 	int		xattr_count;
+	int		parent;
 	union {
 		struct {
 			u64		fragment_block;
@@ -27,7 +28,6 @@ struct squashfs_inode_info {
 			u64		dir_idx_start;
 			int		dir_idx_offset;
 			int		dir_idx_cnt;
-			int		parent;
 		};
 	};
 	struct inode	vfs_inode;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-uninit-value-in-squashfs_get_parent.patch

