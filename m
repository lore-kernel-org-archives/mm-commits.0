Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD7F1F4CAE
	for <mm-commits@vger.kernel.org>; Sat, 27 Sep 2025 01:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758935981; cv=none; b=BLuQFTiSm3y07fpimRmH3iPMzDcktze4H34/Jw/pd95fQCCyreh+cdBppRrJOmislvPWW+fHwMh7HXaPo0biSqq8eenkEKbLckDGj5V/9SpBCbKfNrOAt5GmIMAUfwegHJxMIf5SU5rti6yP01ebseASVOKkTIX8RhBhd7rafgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758935981; c=relaxed/simple;
	bh=ES8UqK2jHPcshL14UdV9CyB1Rlyo3RrgE6MbLj6EUH0=;
	h=Date:To:From:Subject:Message-Id; b=osFr9Hs9xV7ftNVYkzrh1J//gcvZFVOFu+ARNJUE6JRuLhk2WXJn4E4yM3YtgXxiBrkeQDCvG6FaZSOjxn9qsUgu/YvMSEe74pgn2RVCAhThYuLYiYQeVVZnMQ5oVVXFv3SuMOcnNEtTVI5r2M8VajJkBRZ/v38TpR72Ic725rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0lrif3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0lrif3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F9CC4CEF5;
	Sat, 27 Sep 2025 01:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758935981;
	bh=ES8UqK2jHPcshL14UdV9CyB1Rlyo3RrgE6MbLj6EUH0=;
	h=Date:To:From:Subject:From;
	b=k0lrif3U40gKeM69xXURVs4RkTpFdzjTkqfV//zWEr4tjzb3pHdMKuxbwSjILRWEx
	 Y9QxTtQcuFfcyEZQjfU6l5ZowUvxPzhXMQeX9XE2KLDKVMjwJovTnsJ2+Ahy/tSfdX
	 x5Xc+Uo73I4R5y5KI3gkagSQ3GyayVSfrqvXSVqo=
Date: Fri, 26 Sep 2025 18:19:40 -0700
To: mm-commits@vger.kernel.org,amir73il@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch removed from -mm tree
Message-Id: <20250927011941.63F9CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
has been removed from the -mm tree.  Its filename was
     squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch

This patch was dropped because it was folded into squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
Date: Fri, 26 Sep 2025 23:23:05 +0100

only need to check 64 bit quantity

Link: https://lkml.kernel.org/r/20250926222305.110103-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
+++ a/fs/squashfs/inode.c
@@ -145,10 +145,6 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*
@@ -257,12 +253,8 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -285,13 +277,9 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -318,7 +306,7 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
-		if (inode->i_size < 0 || inode->i_size > PAGE_SIZE) {
+		if (inode->i_size > PAGE_SIZE) {
 			ERROR("Corrupted symlink\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-uninit-value-in-squashfs_get_parent.patch
squashfs-add-additional-inode-sanity-checking.patch
squashfs-add-seek_data-seek_hole-support.patch
squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch

