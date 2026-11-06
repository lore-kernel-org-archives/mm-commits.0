Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793999620;
	b=oPHdXQwTXMpBXN2SSVT1Vo9vNEQfzNAfq6RQRT5bCPagHG9W7n66O7su18YTrI2TUqsM
	 IKqXFbqGh2mwSyu5YROx7i/ezXITEnrhvL7BvXh++VVbQ9+2UzhvA8LM8+Gi+gMHMcY0y
	 dxAsD1dMUA1TWQXFyYKFH5LnF4yFcGRs4PIB4oLgBg44SZ5Cplr/1HXk01UfjQ1QP8tVP
	 IB5dN09suZJQJoYpkJP58b41xFAHplyDpqXhxuA1eB9jZ32JJjc+9fdpk6sp9+4a7YOl8
	 wgy30JigwpRtb7ufnLD0lHy8CCE6e9PYv8uGYIkSgZJIaOjI83FD0h0oxbHUoCLVn0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793999620;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3jG4w/FSxEGHSeTqiXDVDOfwVPdsi+WOjBRLAo0iVng=;
	b=uu7tuw+pmBJ7DTtYiKUhiNNPuxCbf3h34+xIRmJzE8mLbVF8JatxM1sye67Q5hPGf/2f
	 AYqKMUAGG69LJGGJhY/PnrLuToitb6HJ4Jx2EDCO+sdB6hfJA+bJKAzitlXw2rb+AdkL2
	 +LercoTGeibjne982cueI54ITU6yNKO1FFr0skiB6omoW84gbz1FjnDv3H6AEPV745leE
	 E4V2c57Ot+ewIpH5VGu22DkYLpddtXft3Y90tMbGI4pyFT2NxPtazKMICtSpZDLJ0li20
	 KBzfasvOCIzjQreypH0mhbuLw4fF8R0wJ/yc77o0LdM8kr+0ppBE/qkN2uYTdnlcfdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zg1XesU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADF6606A332
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zg1XesU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0FF1F008A5;
	Fri,  6 Nov 2026 21:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793999619;
	bh=3jG4w/FSxEGHSeTqiXDVDOfwVPdsi+WOjBRLAo0iVng=;
	h=Date:To:From:Subject;
	b=Zg1XesU7GM38yEgnneuFlOnn2TkdrD7IvLpMixQ+j+Qbw7OjH4x73/m2w+x9uIQbP
	 dcgmgQFM8Hkh71kmnoppKTQ8s4HLM6MAZTqIo0Nxiaqq3OwgzyMKL+HtMrLyQmgkQZ
	 Rj+q9VWB2AOHRDFWJ58lpCjYB+xPy7eoaYRk4BnY=
Date: Fri, 06 Nov 2026 13:13:38 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	christian.loehle@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-identify-device-in-mount-errors.patch added to mm-nonmm-unstable branch
Message-Id: <20261106211339.5C0FF1F008A5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs: identify device in mount errors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-identify-device-in-mount-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-identify-device-in-mount-errors.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christian Loehle <christian.loehle@arm.com>
Subject: squashfs: identify device in mount errors
Date: Sat, 12 Sep 2026 15:53:14 +0100

Squashfs mount failures reported through fs_context do not identify the
backing device, fix this by printing the block device.

Repeated automount failures used to be ambiguous, for example:
  Filesystem uses "xz" compression. This is not supported

All of the affected errors occur after get_tree_bdev() has opened the
block device and setup_bdev_super() has assigned sb->s_bdev.  Use it to
identify the failing Squashfs image even when the mount is retried.  For
example, the error above now reads:
  Filesystem on loop0 uses "xz" compression. This is not supported

Link: https://lore.kernel.org/20260912145314.788588-1-christian.loehle@arm.com
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
---

 fs/squashfs/super.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/fs/squashfs/super.c~squashfs-identify-device-in-mount-errors
+++ a/fs/squashfs/super.c
@@ -150,26 +150,26 @@ static int squashfs_parse_param(struct f
 }
 
 static const struct squashfs_decompressor *supported_squashfs_filesystem(
-	struct fs_context *fc,
+	struct super_block *sb, struct fs_context *fc,
 	short major, short minor, short id)
 {
 	const struct squashfs_decompressor *decompressor;
 
 	if (major < SQUASHFS_MAJOR) {
-		errorf(fc, "Major/Minor mismatch, older Squashfs %d.%d "
-		       "filesystems are unsupported", major, minor);
+		errorf(fc, "Unsupported older Squashfs %d.%d filesystem on %pg",
+		       major, minor, sb->s_bdev);
 		return NULL;
 	} else if (major > SQUASHFS_MAJOR || minor > SQUASHFS_MINOR) {
-		errorf(fc, "Major/Minor mismatch, trying to mount newer "
-		       "%d.%d filesystem", major, minor);
+		errorf(fc, "Major/Minor mismatch, trying to mount newer %d.%d filesystem on %pg",
+		       major, minor, sb->s_bdev);
 		errorf(fc, "Please update your kernel");
 		return NULL;
 	}
 
 	decompressor = squashfs_lookup_decompressor(id);
 	if (!decompressor->supported) {
-		errorf(fc, "Filesystem uses \"%s\" compression. This is not supported",
-		       decompressor->name);
+		errorf(fc, "Filesystem on %pg uses \"%s\" compression. This is not supported",
+		       sb->s_bdev, decompressor->name);
 		return NULL;
 	}
 
@@ -192,7 +192,7 @@ static int squashfs_fill_super(struct su
 	TRACE("Entered squashfs_fill_superblock\n");
 
 	if (!devblksize) {
-		errorf(fc, "squashfs: unable to set blocksize\n");
+		errorf(fc, "squashfs: unable to set blocksize on %pg\n", sb->s_bdev);
 		return -EINVAL;
 	}
 
@@ -221,7 +221,7 @@ static int squashfs_fill_super(struct su
 	sblk = squashfs_read_table(sb, SQUASHFS_START, sizeof(*sblk));
 
 	if (IS_ERR(sblk)) {
-		errorf(fc, "unable to read squashfs_super_block");
+		errorf(fc, "unable to read squashfs_super_block on %pg", sb->s_bdev);
 		err = PTR_ERR(sblk);
 		sblk = NULL;
 		goto failed_mount;
@@ -246,7 +246,7 @@ static int squashfs_fill_super(struct su
 
 	/* Check the MAJOR & MINOR versions and lookup compression type */
 	msblk->decompressor = supported_squashfs_filesystem(
-			fc,
+			sb, fc,
 			le16_to_cpu(sblk->s_major),
 			le16_to_cpu(sblk->s_minor),
 			le16_to_cpu(sblk->compression));
@@ -270,8 +270,8 @@ static int squashfs_fill_super(struct su
 	 * block size (by default 128K).  This is currently not supported.
 	 */
 	if (PAGE_SIZE > msblk->block_size) {
-		errorf(fc, "Page size > filesystem block size (%d).  This is "
-		       "currently not supported!", msblk->block_size);
+		errorf(fc, "Page size > filesystem block size (%d) on %pg is not supported",
+		       msblk->block_size, sb->s_bdev);
 		goto failed_mount;
 	}
 
@@ -330,7 +330,7 @@ static int squashfs_fill_super(struct su
 	msblk->read_page = squashfs_cache_init("data",
 		SQUASHFS_READ_PAGES, msblk->block_size);
 	if (IS_ERR(msblk->read_page)) {
-		errorf(fc, "Failed to allocate read_page block");
+		errorf(fc, "Failed to allocate read_page block for %pg", sb->s_bdev);
 		err = PTR_ERR(msblk->read_page);
 		goto failed_mount;
 	}
@@ -369,7 +369,7 @@ static int squashfs_fill_super(struct su
 	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
 		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
 	if (IS_ERR(msblk->xattr_id_table)) {
-		errorf(fc, "unable to read xattr id index table");
+		errorf(fc, "unable to read xattr id index table on %pg", sb->s_bdev);
 		err = PTR_ERR(msblk->xattr_id_table);
 		msblk->xattr_id_table = NULL;
 		if (err != -ENOTSUPP)
@@ -382,7 +382,7 @@ allocate_id_index_table:
 	msblk->id_table = squashfs_read_id_index_table(sb,
 		le64_to_cpu(sblk->id_table_start), next_table, msblk->ids);
 	if (IS_ERR(msblk->id_table)) {
-		errorf(fc, "unable to read id index table");
+		errorf(fc, "unable to read id index table on %pg", sb->s_bdev);
 		err = PTR_ERR(msblk->id_table);
 		msblk->id_table = NULL;
 		goto failed_mount;
@@ -398,7 +398,7 @@ allocate_id_index_table:
 	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
 		lookup_table_start, next_table, msblk->inodes);
 	if (IS_ERR(msblk->inode_lookup_table)) {
-		errorf(fc, "unable to read inode lookup table");
+		errorf(fc, "unable to read inode lookup table on %pg", sb->s_bdev);
 		err = PTR_ERR(msblk->inode_lookup_table);
 		msblk->inode_lookup_table = NULL;
 		goto failed_mount;
@@ -423,7 +423,7 @@ handle_fragments:
 	msblk->fragment_index = squashfs_read_fragment_index_table(sb,
 		le64_to_cpu(sblk->fragment_table_start), next_table, fragments);
 	if (IS_ERR(msblk->fragment_index)) {
-		errorf(fc, "unable to read fragment index table");
+		errorf(fc, "unable to read fragment index table on %pg", sb->s_bdev);
 		err = PTR_ERR(msblk->fragment_index);
 		msblk->fragment_index = NULL;
 		goto failed_mount;
@@ -470,7 +470,7 @@ check_directory_table:
 	return 0;
 
 insanity:
-	errorf(fc, "squashfs image failed sanity check");
+	errorf(fc, "squashfs image on %pg failed sanity check", sb->s_bdev);
 failed_mount:
 	squashfs_cache_delete(msblk->block_cache);
 	squashfs_cache_delete(msblk->fragment_cache);
_

Patches currently in -mm which might be from christian.loehle@arm.com are

squashfs-identify-device-in-mount-errors.patch

