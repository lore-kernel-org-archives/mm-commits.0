Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E322B72608;
	Sun, 28 Sep 2025 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084630; cv=none; b=qJ9qG8Pe9ue32mniEwOpDPdShPfy2U7wPsWqCtG1tnZpy2yqRS9JP4EZdXDFOo3oY+Z6ABbINXOuYqrUVzA2tqeMhB/X7g5bxw1sjELjUtixB/DacZ8FjQtcNebwy3MpC13WIpx0fLdMoUqMBu50j9+4RHVc6wOEabv8GlwS9K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084630; c=relaxed/simple;
	bh=L14VdbVldA27zIrzDOtrblWaSVoGiZg+6+OXs3L8E74=;
	h=Date:To:From:Subject:Message-Id; b=sF4mMwfxM3fBDQiUh8HUdHUmsBJiG+V5KPAa5IgCf+Kz9bbRqlg1ktPQQQupfKDFBMbyyob3SZk5lcmByTVknF9mMVkBkXAgpUU7eVKxbtuHl1HdApLNzQFchAMCWNtnF2i3WR2IGj9YS1gp2pqbtdSdIYJTs4TL7BCpmT6fKdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=trnJzaAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="trnJzaAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E503C4CEF0;
	Sun, 28 Sep 2025 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084629;
	bh=L14VdbVldA27zIrzDOtrblWaSVoGiZg+6+OXs3L8E74=;
	h=Date:To:From:Subject:From;
	b=trnJzaAr6DlCXwQtMCeDaVNaRrFK4OS+tX77oSmlBzPvCU8SDkJAlqK/nZV0KwomD
	 ONaK02DDvSJkPlCktuQGSVhAMVLBUCkr3PHw2lSNQgFmAMKm4TkQw0/m9VtE+bnnaw
	 HLvgYAYSVKT5Liytd6omeZ/etj75X6TLaXBxrhmI=
Date: Sun, 28 Sep 2025 11:37:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-fix-uninit-value-in-squashfs_get_parent.patch removed from -mm tree
Message-Id: <20250928183709.4E503C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: fix uninit-value in squashfs_get_parent
has been removed from the -mm tree.  Its filename was
     squashfs-fix-uninit-value-in-squashfs_get_parent.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


