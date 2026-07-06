Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D5A1F8AC5
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783381853; cv=none; b=rNvLFsvP8IABKrKGrkwzwwN2Eo+SFZAlQSoak/bjgrJ5/MmKyorhCGPPK4H3F2giOzHswJsATnc1zAvWXGbrpEUxzFn4EkLEtqG3RsBTAw030Mdt4CxOhrSZYGUrmBEZ9QK4OGaSfw+RbKm32cAyd+9MIp3kRAXoxf6lxxv/8io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783381853; c=relaxed/simple;
	bh=pbrYAbX7eep4/UxvQvVaWxLekD5U66rFxaw5r+Y+IG8=;
	h=Date:To:From:Subject:Message-Id; b=mr0SZOGY92RaqN0deoXsDhxWfHT5YIvJ09CJfu1CQAw+aVHXU1oRSKiX+Dkjekfj/jxyrGz9nz2K/NmI74oQQbMyFx3XvANeJTu8Bx0TebzhxeuO8D0gu1oWTmcyVMSX2LM2A4gLM7oyrwM3d1frQw/4zsbIkuc8praHqbP9xgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JbOkdxcG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JbOkdxcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CB61F000E9;
	Mon,  6 Jul 2026 23:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783381852;
	bh=v8mIEvKT9UnlwPshC51jyyQK1GvT3CrsOlEGKV2QwUg=;
	h=Date:To:From:Subject;
	b=JbOkdxcGs21tvxWy7MRej4hnxEP8aV1VZvjRjuZQ2mwmgwf70Q3rMjI1vIGVJeT1E
	 jA3htKTZsPJODsdK3DoM3UEZoQnHeQjhKAp13LL/q5Tk87Q8h1XQfLuWvGoGck2BkK
	 vUKsy2hCAT6U/cc4QE98goaQD9XbYUMQLZQcRF54=
Date: Mon, 06 Jul 2026 16:50:51 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-external-xattr-entries-when-reading-metadata.patch added to mm-nonmm-unstable branch
Message-Id: <20260706235051.E5CB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate external xattr entries when reading metadata
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-external-xattr-entries-when-reading-metadata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-external-xattr-entries-when-reading-metadata.patch

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
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: validate external xattr entries when reading metadata
Date: Sun, 5 Jul 2026 10:53:11 +0800

ocfs2_validate_xattr_block() checks the xattr block header before the
block reaches higher-level xattr users, but it does not verify that a
non-indexed block's xh_count and entry offsets fit inside the block. 
Indexed buckets likewise reach list/get consumers after ECC without an
entry-bounds check.

Use the flat xattr entry validator for non-indexed external xattr blocks,
and use a bucket-specific validator for indexed buckets at metadata read
time.  The bucket validator keeps the entry array bounded by the first
bucket block while checking name/value offsets against the bucket block
they target.

Reject corrupted external xattr metadata before listxattr() or getxattr()
can walk out-of-range entry arrays or name/value offsets.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
Read of size 1 at addr ffff88810a654007 by task ocfs2_xattr_lis/630
Call Trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  kasan_report+0xe0/0x110
  ocfs2_xattr_list_entries+0xd7/0x190
  ocfs2_listxattr+0x3f6/0x610
  listxattr+0x90/0xe0
  path_listxattrat+0xed/0x220
  do_syscall_64+0x115/0x6a0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/20260705025311.3429854-3-zzzccc427@gmail.com
Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers of EAs")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: Codex:gpt-5.5
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   97 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-external-xattr-entries-when-reading-metadata
+++ a/fs/ocfs2/xattr.c
@@ -390,6 +390,12 @@ static int ocfs2_init_xattr_bucket(struc
 	return rc;
 }
 
+static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
+					     struct ocfs2_xattr_header *xh,
+					     size_t region_size);
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -408,6 +414,8 @@ static int ocfs2_read_xattr_bucket(struc
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -509,6 +517,22 @@ static int ocfs2_validate_xattr_block(st
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		size_t region_offset =
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+
+		if (bh->b_size < region_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr block %llu: block size %zu is too small\n",
+					   (unsigned long long)bh->b_blocknr,
+					   bh->b_size);
+
+		return ocfs2_validate_xattr_entries_flat(sb, bh->b_blocknr,
+							 &xb->xb_attrs.xb_header,
+							 bh->b_size -
+							 region_offset);
+	}
+
 	return 0;
 }
 
@@ -1068,6 +1092,79 @@ int ocfs2_validate_inode_xattr(struct su
 	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno)
+{
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
+	size_t entries_limit = sb->s_blocksize;
+	size_t nv_limit = sb->s_blocksize;
+	size_t max_entries;
+	int i;
+
+	if (region_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: region size %zu is too small\n",
+				   (unsigned long long)blkno, region_size);
+
+	if (entries_limit < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entries limit %zu is too small\n",
+				   (unsigned long long)blkno,
+				   entries_limit);
+
+	max_entries = (entries_limit - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno,
+				   xattr_count, max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t block_off = name_offset >> sb->s_blocksize_bits;
+		size_t block_offset = name_offset % nv_limit;
+		size_t value_offset;
+
+		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (xe->xe_name_len > nv_limit - block_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name crosses block boundary\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = block_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > nv_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    nv_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   nv_limit - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
 static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
 					   struct ocfs2_dinode *di,
 					   struct ocfs2_xattr_header **header)
_

Patches currently in -mm which might be from zzzccc427@gmail.com are

ocfs2-cluster-keep-heartbeat-local-node-stable.patch
ocfs2-validate-inline-xattrs-during-inode-block-validation.patch
ocfs2-validate-external-xattr-entries-when-reading-metadata.patch

