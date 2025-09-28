Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6EA216E1B
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084639; cv=none; b=tbo/LRYwvRfXcT2bEkdDhWnhCkqB8D0+rfbUrvaYQ4WM+QzoyStSAzCXC+G9GphaxHMDzKigLoL0+WjxcbJQdaqsw5CeZXpRlQ4oCenONgf9fKSVpd9pyc4ZxN15J9IH3cQkJYYwXYXRE0u5DmK+XJlIoxfN+YcCGO3sKd9pnIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084639; c=relaxed/simple;
	bh=D9HvxfoR4mKDnA/1an4Xx4LUkB4XVOAaiFg3Hy+r7b8=;
	h=Date:To:From:Subject:Message-Id; b=Yr4Q3FPQ25jwtsRfoOmyanWPFMl/7INuIA9qmwmxwvayhOKexMK8hK3H1JLD3ik5TFA+Vb/oeBGEwcpZzodoaYJHTQGK7yEHYUVSr4/BpiHb3gzdWQ3kZXUhNFIYFmrjfP/yYND3PcTawUJbOFgWu4v1aaObNRfhmqYgbKNl/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCoh5a3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCoh5a3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C34C4CEF0;
	Sun, 28 Sep 2025 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759084638;
	bh=D9HvxfoR4mKDnA/1an4Xx4LUkB4XVOAaiFg3Hy+r7b8=;
	h=Date:To:From:Subject:From;
	b=XCoh5a3TeINdhX6jgajuAIU520tLiWh0YMbTxzLF502s6mJzYqOibaG6N1YdWTnxs
	 vkP4yBuIg2HF16LBYGM+rgdxOlk1ViAGjX7lWDPDumN/JYoG9H5cE0Ucbz0r9eZaEY
	 24saRJUJmkOXcBE9zlEXInipoHANXd1+Gw0ypM8E=
Date: Sun, 28 Sep 2025 11:37:18 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-add-additional-inode-sanity-checking.patch removed from -mm tree
Message-Id: <20250928183718.D8C34C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: add additional inode sanity checking
has been removed from the -mm tree.  Its filename was
     squashfs-add-additional-inode-sanity-checking.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: add additional inode sanity checking
Date: Tue, 23 Sep 2025 23:06:51 +0100

Patch series "Squashfs: performance improvement and a sanity check".

This patchset adds an additional sanity check when reading regular file
inodes, and adds support for SEEK_DATA/SEEK_HOLE lseek() whence values.


This patch (of 2):

Add an additional sanity check when reading regular file inodes.

A regular file if the file size is an exact multiple of the filesystem
block size cannot have a fragment.  This is because by definition a
fragment block stores tailends which are not a whole block in size.

Link: https://lkml.kernel.org/r/20250923220652.568416-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20250923220652.568416-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-add-additional-inode-sanity-checking
+++ a/fs/squashfs/inode.c
@@ -144,8 +144,17 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
+			/*
+			 * the file cannot have a fragment (tailend) and have a
+			 * file size a multiple of the block size
+			 */
+			if ((inode->i_size & (msblk->block_size - 1)) == 0) {
+				err = -EINVAL;
+				goto failed_read;
+			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
 			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
 			if (frag_size < 0) {
@@ -159,7 +168,6 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		set_nlink(inode, 1);
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;
 		inode->i_blocks = ((inode->i_size - 1) >> 9) + 1;
@@ -188,8 +196,17 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
+			/*
+			 * the file cannot have a fragment (tailend) and have a
+			 * file size a multiple of the block size
+			 */
+			if ((inode->i_size & (msblk->block_size - 1)) == 0) {
+				err = -EINVAL;
+				goto failed_read;
+			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
 			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
 			if (frag_size < 0) {
@@ -204,7 +221,6 @@ int squashfs_read_inode(struct inode *in
 
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_inode_ops;
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


