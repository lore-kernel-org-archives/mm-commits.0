Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7357C2AE99
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752924; cv=none; b=OKOoWtEByerBGxCUraTHCDxgsrS+g8gWF9v2EoWJr6VvmTkoOvej9yTrmOQlVUzPcQiJxWmrBMrZ3KUzlXU7eEmcizjzack0oIbWYJhBm07F7+SBPNqJdQ2pD6NaNVNaOjqWF5wxbsqTzDRK4FQAdGylk5oeQjuvAckQQwpIaV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752924; c=relaxed/simple;
	bh=Kmt4IVfMjfj9E3+QSXyAhlsfeKuHrzhE0iTG86o40qo=;
	h=Date:To:From:Subject:Message-Id; b=M0WIcev7JELJy4pMkYAWKrNnN3YpsYNipx10+G+gpjylnHRGT0yhwEuqI9dV+EY/+fDMqYFe7fBIaSrd/1DmzxQkYrc+IUNKwJbkIzw/fLmwnI1R2p25HAV101oSbz5Se8OtMmA5oZYkY0/8qlAtnUsD1CwQMVwQSyWxCSr4me8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyVJE2mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyVJE2mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64B2C4CEE7;
	Wed, 24 Sep 2025 22:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758752924;
	bh=Kmt4IVfMjfj9E3+QSXyAhlsfeKuHrzhE0iTG86o40qo=;
	h=Date:To:From:Subject:From;
	b=iyVJE2mxF0sk0i/sHy1vKR6Id9+P9ZziB5j/FG1dFvRArfmFfgnmhEiutqjQq0Yqd
	 Dn9KkOSYTsV6BzEGmV5RGGad50uLSgljfl7UyJno0tXam3oef3R9ydMz9IqiAu4kYK
	 CRT/yjo8bg8RhQ9lId+VvkxUI/y8VwaeGTSPrPUA=
Date: Wed, 24 Sep 2025 15:28:43 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-add-additional-inode-sanity-checking.patch added to mm-nonmm-unstable branch
Message-Id: <20250924222843.E64B2C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: add additional inode sanity checking
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-add-additional-inode-sanity-checking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-add-additional-inode-sanity-checking.patch

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

squashfs-fix-uninit-value-in-squashfs_get_parent.patch
squashfs-add-additional-inode-sanity-checking.patch
squashfs-add-seek_data-seek_hole-support.patch

