Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07088C433E9
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E2564F38
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 00:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhBEA4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:56:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232279AbhBEA4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 19:56:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCDFD64FB2;
        Fri,  5 Feb 2021 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612486527;
        bh=infvnKb4huJwnAIM6BmLydfm+q46UiQi4Og+D1Ga5mU=;
        h=Date:From:To:Subject:From;
        b=YRI4MTTbSiaEs/BwJ+LLmljBlZDtL9k/RVhmSEyfDoifrWhlXEyr3vrUgsI6LOi6o
         yC0s7EIsb6zpf7nKutllKHCvgNH4Ls7vQ6CEFtUujcqruaLIW5eAFnuzEg8OoXi65z
         KjpG1ykr0e2jSiM757MCM1jgDf9rVMJvG0ROcbVQ=
Date:   Thu, 04 Feb 2021 16:55:26 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk
Subject:  +
 squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch added to -mm tree
Message-ID: <20210205005526.CkozRAjDo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: add more sanity checks in xattr id lookup
has been added to the -mm tree.  Its filename is
     squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch

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
Subject: squashfs: add more sanity checks in xattr id lookup

Sysbot has reported a warning where a kmalloc() attempt exceeds the
maximum limit.  This has been identified as corruption of the xattr_ids
count when reading the xattr id lookup table.

This patch adds a number of additional sanity checks to detect
this corruption and others.

1. It checks for a corrupted xattr index read from the inode.  This could
   be because the metadata block is uncompressed, or because the
   "compression" bit has been corrupted (turning a compressed block
   into an uncompressed block).  This would cause an out of bounds read.

2. It checks against corruption of the xattr_ids count.  This can either
   lead to the above kmalloc failure, or a smaller than expected
   table to be read.

3. It checks the contents of the index table for corruption.

Link: https://lkml.kernel.org/r/20210204130249.4495-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+2ccea6339d368360800d@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/xattr_id.c |   66 +++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 9 deletions(-)

--- a/fs/squashfs/xattr_id.c~squashfs-add-more-sanity-checks-in-xattr-id-lookup
+++ a/fs/squashfs/xattr_id.c
@@ -31,10 +31,15 @@ int squashfs_xattr_lookup(struct super_b
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block = SQUASHFS_XATTR_BLOCK(index);
 	int offset = SQUASHFS_XATTR_BLOCK_OFFSET(index);
-	u64 start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+	u64 start_block;
 	struct squashfs_xattr_id id;
 	int err;
 
+	if (index >= msblk->xattr_ids)
+		return -EINVAL;
+
+	start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+
 	err = squashfs_read_metadata(sb, &id, &start_block, &offset,
 							sizeof(id));
 	if (err < 0)
@@ -50,13 +55,17 @@ int squashfs_xattr_lookup(struct super_b
 /*
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
-__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 start,
+__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 		u64 *xattr_table_start, int *xattr_ids)
 {
-	unsigned int len;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	unsigned int len, indexes;
 	struct squashfs_xattr_id_table *id_table;
+	__le64 *table;
+	u64 start, end;
+	int n;
 
-	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
+	id_table = squashfs_read_table(sb, table_start, sizeof(*id_table));
 	if (IS_ERR(id_table))
 		return (__le64 *) id_table;
 
@@ -70,13 +79,52 @@ __le64 *squashfs_read_xattr_id_table(str
 	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
-	/* xattr_table should be less than start */
-	if (*xattr_table_start >= start)
+	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
+	indexes = SQUASHFS_XATTR_BLOCKS(*xattr_ids);
+
+	/*
+	 * The computed size of the index table (len bytes) should exactly
+	 * match the table start and end points
+	 */
+	start = table_start + sizeof(*id_table);
+	end = msblk->bytes_used;
+
+	if (len != (end - start))
 		return ERR_PTR(-EINVAL);
 
-	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
+	table = squashfs_read_table(sb, start, len);
+	if (IS_ERR(table))
+		return table;
+
+	/* table[0], table[1], ... table[indexes - 1] store the locations
+	 * of the compressed xattr id blocks.  Each entry should be less than
+	 * the next (i.e. table[0] < table[1]), and the difference between them
+	 * should be SQUASHFS_METADATA_SIZE or less.  table[indexes - 1]
+	 * should be less than table_start, and again the difference
+	 * shouls be SQUASHFS_METADATA_SIZE or less.
+	 *
+	 * Finally xattr_table_start should be less than table[0].
+	 */
+	for (n = 0; n < (indexes - 1); n++) {
+		start = le64_to_cpu(table[n]);
+		end = le64_to_cpu(table[n + 1]);
+
+		if(start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+			kfree(table);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	start = le64_to_cpu(table[indexes - 1]);
+	if (start >= table_start || (table_start - start) > SQUASHFS_METADATA_SIZE) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
 
-	TRACE("In read_xattr_index_table, length %d\n", len);
+	if (*xattr_table_start >= le64_to_cpu(table[0])) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
 
-	return squashfs_read_table(sb, start + sizeof(*id_table), len);
+	return table;
 }
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-avoid-out-of-bounds-writes-in-decompressors.patch
squashfs-add-more-sanity-checks-in-id-lookup.patch
squashfs-add-more-sanity-checks-in-inode-lookup.patch
squashfs-add-more-sanity-checks-in-xattr-id-lookup.patch

