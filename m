Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDC519F115;
	Sat, 27 Sep 2025 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758935855; cv=none; b=f7LafHlv8KTr52WxdM2FgJ6d1X7G02DDFXjiBcMvhw2pCApl7DooSWF98Wk8QgTXSfIpam+vITz3UumO58irTawvWP1YbOrl7ri6JQQv29EQQJZdQnvBVdk7g4HvjYHIBDbBJhVGa3i0pfa8B2iOL4pqQq68fFm2C1dnfgq1eEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758935855; c=relaxed/simple;
	bh=pizmtrfKoypHyRxkeP8m/nrxYXysI7n7A6x0lqgFs/A=;
	h=Date:To:From:Subject:Message-Id; b=Xu5OvqJMkRplz3o5lpQ0/lX1KQx358AY+3HKNVyfh1kcbxWAl/9evi+DajL9ejp95o64cZXpuOfq6jjf7cCcUJp5fwb8jjaFKNgr8MUGAF5CaQr/EUBSioDP5qoBbF1Bs4vxwoZI5uTXNiAAgBl4HtdVcXz+ZZlGdugncZwn9lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Svye4Gpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Svye4Gpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C16C4CEF4;
	Sat, 27 Sep 2025 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758935855;
	bh=pizmtrfKoypHyRxkeP8m/nrxYXysI7n7A6x0lqgFs/A=;
	h=Date:To:From:Subject:From;
	b=Svye4GpqK37A4M6v0FQ/BIcwN4vdDwswIoWXCIC6flCfwZto1iAkZ3w2SiUbNFKhV
	 lsong9s3G+sFXrV7ituBhAfewBLimp+M7X+AzaLOrUhQTeaxmHEsuq2Bq06VFBXoI4
	 /Ld1rBZ8ud30ZHYNIaT/YR/NAg/YAiL1IU7ua8oc=
Date: Fri, 26 Sep 2025 18:17:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,amir73il@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch added to mm-nonmm-unstable branch
Message-Id: <20250927011735.18C16C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: reject negative file sizes in squashfs_read_inode()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

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
Subject: Squashfs: reject negative file sizes in squashfs_read_inode()
Date: Fri, 26 Sep 2025 22:59:35 +0100

Syskaller reports a "WARNING in ovl_copy_up_file" in overlayfs.

This warning is ultimately caused because the underlying Squashfs file
system returns a file with a negative file size.

This commit checks for a negative file size and returns EINVAL.

Link: https://lkml.kernel.org/r/20250926215935.107233-1-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68d580e5.a00a0220.303701.0019.GAE@google.com/
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-reject-negative-file-sizes-in-squashfs_read_inode
+++ a/fs/squashfs/inode.c
@@ -145,6 +145,10 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*
@@ -197,6 +201,10 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*
@@ -249,8 +257,12 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -273,9 +285,13 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 0) {
+			err = -EINVAL;
+			goto failed_read;
+		}
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -302,7 +318,7 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
-		if (inode->i_size > PAGE_SIZE) {
+		if (inode->i_size < 0 || inode->i_size > PAGE_SIZE) {
 			ERROR("Corrupted symlink\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-uninit-value-in-squashfs_get_parent.patch
squashfs-add-additional-inode-sanity-checking.patch
squashfs-add-seek_data-seek_hole-support.patch
squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

