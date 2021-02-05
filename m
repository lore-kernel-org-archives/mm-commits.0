Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08B1C433E6
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A160164F3D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhBEA4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232279AbhBEA4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 19:56:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3302664FB0;
        Fri,  5 Feb 2021 00:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612486522;
        bh=kbhQ7fCpNYjjjY5Y2YF9ghdJu7dVe37l4Rdq3Y7rqZA=;
        h=Date:From:To:Subject:From;
        b=ym7vxWlfgRcWtRNw2h3xmlvMsX4FwDVLybpHY/pqODNsy2+qp1+GLL9DDitZT+g+X
         UYNcDF4Ltn7OF+M8gu7VrQyHo2F2GiqRLdDBa7gEjSVO6GkHifTfYOF8Hku2xLVnxZ
         /X/Y3CZprMZEFbMX0chWoKVnPGsGqeoWgETnPx/g=
Date:   Thu, 04 Feb 2021 16:55:21 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  + squashfs-add-more-sanity-checks-in-id-lookup.patch
 added to -mm tree
Message-ID: <20210205005521._hMecOhqB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: add more sanity checks in id lookup
has been added to the -mm tree.  Its filename is
     squashfs-add-more-sanity-checks-in-id-lookup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-add-more-sanity-checks-in-id-lookup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-add-more-sanity-checks-in-id-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: add more sanity checks in id lookup

Sysbot has reported a number of "slab-out-of-bounds reads" and
"use-after-free read" errors which has been identified as being caused by
a corrupted index value read from the inode.  This could be because the
metadata block is uncompressed, or because the "compression" bit has been
corrupted (turning a compressed block into an uncompressed block).

This patch adds additional sanity checks to detect this, and the
following corruption.

1. It checks against corruption of the ids count.  This can either
   lead to a larger table to be read, or a smaller than expected
   table to be read.

   In the case of a too large ids count, this would often have been
   trapped by the existing sanity checks, but this patch introduces
   a more exact check, which can identify too small values.

2. It checks the contents of the index table for corruption.

Link: https://lkml.kernel.org/r/20210204130249.4495-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+b06d57ba83f604522af2@syzkaller.appspotmail.com
Reported-by: syzbot+c021ba012da41ee9807c@syzkaller.appspotmail.com
Reported-by: syzbot+5024636e8b5fd19f0f19@syzkaller.appspotmail.com
Reported-by: syzbot+bcbc661df46657d0fa4f@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/id.c             |   40 ++++++++++++++++++++++++++-------
 fs/squashfs/squashfs_fs_sb.h |    1 
 fs/squashfs/super.c          |    6 ++--
 fs/squashfs/xattr.h          |   10 +++++++-
 4 files changed, 45 insertions(+), 12 deletions(-)

--- a/fs/squashfs/id.c~squashfs-add-more-sanity-checks-in-id-lookup
+++ a/fs/squashfs/id.c
@@ -35,10 +35,15 @@ int squashfs_get_id(struct super_block *
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block = SQUASHFS_ID_BLOCK(index);
 	int offset = SQUASHFS_ID_BLOCK_OFFSET(index);
-	u64 start_block = le64_to_cpu(msblk->id_table[block]);
+	u64 start_block;
 	__le32 disk_id;
 	int err;
 
+	if (index >= msblk->ids)
+		return -EINVAL;
+
+	start_block = le64_to_cpu(msblk->id_table[block]);
+
 	err = squashfs_read_metadata(sb, &disk_id, &start_block, &offset,
 							sizeof(disk_id));
 	if (err < 0)
@@ -56,7 +61,10 @@ __le64 *squashfs_read_id_index_table(str
 		u64 id_table_start, u64 next_table, unsigned short no_ids)
 {
 	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
+	unsigned int indexes = SQUASHFS_ID_BLOCKS(no_ids);
+	int n;
 	__le64 *table;
+	u64 start, end;
 
 	TRACE("In read_id_index_table, length %d\n", length);
 
@@ -67,20 +75,36 @@ __le64 *squashfs_read_id_index_table(str
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * length bytes should not extend into the next table - this check
-	 * also traps instances where id_table_start is incorrectly larger
-	 * than the next table start
+	 * The computed size of the index table (length bytes) should exactly
+	 * match the table start and end points
 	 */
-	if (id_table_start + length > next_table)
+	if (length != (next_table - id_table_start))
 		return ERR_PTR(-EINVAL);
 
 	table = squashfs_read_table(sb, id_table_start, length);
+	if (IS_ERR(table))
+		return table;
 
 	/*
-	 * table[0] points to the first id lookup table metadata block, this
-	 * should be less than id_table_start
+	 * table[0], table[1], ... table[indexes - 1] store the locations
+	 * of the compressed id blocks.   Each entry should be less than
+	 * the next (i.e. table[0] < table[1]), and the difference between them
+	 * should be SQUASHFS_METADATA_SIZE or less.  table[indexes - 1]
+	 * should be less than id_table_start, and again the difference
+	 * should be SQUASHFS_METADATA_SIZE or less
 	 */
-	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= id_table_start) {
+	for (n = 0; n < (indexes - 1); n++) {
+		start = le64_to_cpu(table[n]);
+		end = le64_to_cpu(table[n + 1]);
+
+		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+			kfree(table);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	start = le64_to_cpu(table[indexes - 1]);
+	if (start >= id_table_start || (id_table_start - start) > SQUASHFS_METADATA_SIZE) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-add-more-sanity-checks-in-id-lookup
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -64,5 +64,6 @@ struct squashfs_sb_info {
 	unsigned int				inodes;
 	unsigned int				fragments;
 	int					xattr_ids;
+	unsigned int				ids;
 };
 #endif
--- a/fs/squashfs/super.c~squashfs-add-more-sanity-checks-in-id-lookup
+++ a/fs/squashfs/super.c
@@ -166,6 +166,7 @@ static int squashfs_fill_super(struct su
 	msblk->directory_table = le64_to_cpu(sblk->directory_table_start);
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	msblk->fragments = le32_to_cpu(sblk->fragments);
+	msblk->ids = le16_to_cpu(sblk->no_ids);
 	flags = le16_to_cpu(sblk->flags);
 
 	TRACE("Found valid superblock on %pg\n", sb->s_bdev);
@@ -177,7 +178,7 @@ static int squashfs_fill_super(struct su
 	TRACE("Block size %d\n", msblk->block_size);
 	TRACE("Number of inodes %d\n", msblk->inodes);
 	TRACE("Number of fragments %d\n", msblk->fragments);
-	TRACE("Number of ids %d\n", le16_to_cpu(sblk->no_ids));
+	TRACE("Number of ids %d\n", msblk->ids);
 	TRACE("sblk->inode_table_start %llx\n", msblk->inode_table);
 	TRACE("sblk->directory_table_start %llx\n", msblk->directory_table);
 	TRACE("sblk->fragment_table_start %llx\n",
@@ -236,8 +237,7 @@ static int squashfs_fill_super(struct su
 allocate_id_index_table:
 	/* Allocate and read id index table */
 	msblk->id_table = squashfs_read_id_index_table(sb,
-		le64_to_cpu(sblk->id_table_start), next_table,
-		le16_to_cpu(sblk->no_ids));
+		le64_to_cpu(sblk->id_table_start), next_table, msblk->ids);
 	if (IS_ERR(msblk->id_table)) {
 		errorf(fc, "unable to read id index table");
 		err = PTR_ERR(msblk->id_table);
--- a/fs/squashfs/xattr.h~squashfs-add-more-sanity-checks-in-id-lookup
+++ a/fs/squashfs/xattr.h
@@ -17,8 +17,16 @@ extern int squashfs_xattr_lookup(struct
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, int *xattr_ids)
 {
+	struct squashfs_xattr_id_table *id_table;
+
+	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
+	if (IS_ERR(id_table))
+		return (__le64 *) id_table;
+
+	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
+	kfree(id_table);
+
 	ERROR("Xattrs in filesystem, these will be ignored\n");
-	*xattr_table_start = start;
 	return ERR_PTR(-ENOTSUPP);
 }
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
squashfs-add-more-sanity-checks-in-id-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch

