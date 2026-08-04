Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3321423E8A
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816313; cv=none; b=uZRc7LQ12tdRFXbqqyz6iytY25A5mRddx/WeDSATlAYkQIHZpoOUoxO3mNT0Y8S8FGSsp2rh69LDtgZeZwDaqie4KL9TGA2vwf4Zg6gZusVtfCqxOlAxMavSZ2HNBPoLsddCzUlGqudFr52/GubYm7MNDI082XB2AJePpTNrqh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816313; c=relaxed/simple;
	bh=G3J0FkjCAyFez+W7ATImUdSsZyHKthJ66pxcNNvNhb0=;
	h=Date:To:From:Subject:Message-Id; b=sSXLKD3bZxvaTt4CYeRdtCYgtQ7NCtyk6nnpt9jioj2iE3ssApyhgbJCxrYctKKFDvuY1J5ZpXE35nD/nT9fv5fb8U7Ab98jhyo56TQS8ZFO1ybSKZUSoR8c2TJ/K3UQOouOYjT4/IocoB15+9dmmH2Cc6dtg/Tmk9LpLNHjbYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lA8KrD36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lA8KrD36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9742B1F00A3A;
	Tue,  4 Aug 2026 04:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816311;
	bh=4/GEQWU2L3fDvNP/YUYzZbpNdZS0Bl7KjWD7Ne+RPuY=;
	h=Date:To:From:Subject;
	b=lA8KrD36/C7nD5omm5vHgovknyTGRGuVorsVegrvheuID3mBKZSc3HO7SaTQNwr8q
	 UnnlUbpG2ZY2noNy4dCCUCBGvI+3ApGyBWDmfEz7jpynIVV1hKDC21De1SlgOOK9nS
	 Z7OrQmzX+dH6d8hUnE5SRw+4DhqaZb9vxAUYaRbU=
Date: Mon, 03 Aug 2026 21:05:11 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,zzzccc427@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-inline-xattrs-during-inode-block-validation.patch removed from -mm tree
Message-Id: <20260804040511.9742B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate inline xattrs during inode block validation
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-inline-xattrs-during-inode-block-validation.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: validate inline xattrs during inode block validation
Date: Sun, 5 Jul 2026 10:53:10 +0800

Patch series "ocfs2: validate xattr entry bounds", v7.

This series validates OCFS2 xattr entry name/value bounds when xattr
metadata is read and validated, before getxattr() or listxattr() can walk
out-of-range entry arrays or offsets from corrupted metadata.


This patch (of 2):

ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
metadata from it, but inline xattr metadata is still checked only in
operation-specific consumers.  The existing ibody lookup helper validates
inline header placement and entry count, but inode block validation does
not reject entry name/value bounds.

Add a flat xattr entry validator and call it from inode block validation
for inline xattrs.  Keep the operation paths on their existing
header/count lookup checks; the full entry bounds check now runs when the
inode block is validated at read time.

Reject corrupted inline xattr metadata before ocfs2_xattr_ibody_get() or
listxattr() can walk past the inline storage.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170
Read of size 2 at addr ffff8881242a2000 by task python3/529
Call Trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  kasan_report+0xe0/0x110
  ocfs2_xattr_find_entry+0x5a/0x170
  ocfs2_xattr_get_nolock+0x20a/0x820
  ocfs2_xattr_get+0x10c/0x1e0
  __vfs_getxattr+0xe2/0x130
  vfs_getxattr+0x185/0x1b0

Link: https://lore.kernel.org/20260705025311.3429854-1-zzzccc427@gmail.com
Link: https://lore.kernel.org/20260705025311.3429854-2-zzzccc427@gmail.com
Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: Codex:gpt-5.5
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    4 +
 fs/ocfs2/xattr.c |  118 ++++++++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/xattr.h |    2 
 3 files changed, 111 insertions(+), 13 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-validate-inline-xattrs-during-inode-block-validation
+++ a/fs/ocfs2/inode.c
@@ -1608,6 +1608,10 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	rc = ocfs2_validate_inode_xattr(sb, bh->b_blocknr, di);
+	if (rc)
+		goto bail;
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattrs-during-inode-block-validation
+++ a/fs/ocfs2/xattr.c
@@ -950,41 +950,133 @@ static int ocfs2_xattr_list_entries(stru
 	return result;
 }
 
-static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
-					   struct ocfs2_dinode *di,
-					   struct ocfs2_xattr_header **header)
+static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
+					     struct ocfs2_xattr_header *xh,
+					     size_t region_size)
 {
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t entries_limit = region_size;
+	size_t nv_limit = region_size;
+	size_t max_entries;
+	int i;
+
+	if (region_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: region size %zu is too small\n",
+				   (unsigned long long)blkno, region_size);
+
+	max_entries = (entries_limit - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno,
+				   xattr_count, max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t value_offset;
+
+		if (name_offset > nv_limit ||
+		    xe->xe_name_len > nv_limit - name_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = name_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > nv_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    nv_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   nv_limit - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
+static int ocfs2_xattr_ibody_lookup_header_raw(struct super_block *sb,
+					       u64 blkno,
+					       struct ocfs2_dinode *di,
+					       struct ocfs2_xattr_header **header,
+					       u16 *inline_size_ret)
+{
+	struct ocfs2_xattr_header *xh;
 	u16 xattr_count;
 	size_t max_entries;
 	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
 
-	if (inline_size > inode->i_sb->s_blocksize ||
+	if (inline_size > sb->s_blocksize ||
 	    inline_size < sizeof(struct ocfs2_xattr_header)) {
-		ocfs2_error(inode->i_sb,
-			    "Invalid xattr inline size %u in inode %llu\n",
-			    inline_size,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		ocfs2_error(sb,
+			    "Invalid inode %llu: xattr inline size %u\n",
+			    (unsigned long long)blkno, inline_size);
 		return -EFSCORRUPTED;
 	}
 
-	*header = (struct ocfs2_xattr_header *)
-		((void *)di + inode->i_sb->s_blocksize - inline_size);
+	xh = (struct ocfs2_xattr_header *)
+		((void *)di + sb->s_blocksize - inline_size);
 
-	xattr_count = le16_to_cpu((*header)->xh_count);
+	xattr_count = le16_to_cpu(xh->xh_count);
 	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
 		      sizeof(struct ocfs2_xattr_entry);
 
 	if (xattr_count > max_entries) {
-		ocfs2_error(inode->i_sb,
+		ocfs2_error(sb,
 			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
 			    xattr_count, max_entries,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			    (unsigned long long)blkno);
 		return -EFSCORRUPTED;
 	}
 
+	*header = xh;
+	if (inline_size_ret)
+		*inline_size_ret = inline_size;
+
 	return 0;
 }
 
+int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
+			       struct ocfs2_dinode *di)
+{
+	struct ocfs2_xattr_header *xh;
+	u16 inline_size;
+	int ret;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return 0;
+
+	ret = ocfs2_xattr_ibody_lookup_header_raw(sb, blkno, di, &xh,
+						  &inline_size);
+	if (ret)
+		return ret;
+
+	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
+}
+
+static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
+					   struct ocfs2_dinode *di,
+					   struct ocfs2_xattr_header **header)
+{
+	return ocfs2_xattr_ibody_lookup_header_raw(inode->i_sb,
+						   OCFS2_I(inode)->ip_blkno,
+						   di, header, NULL);
+}
+
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
--- a/fs/ocfs2/xattr.h~ocfs2-validate-inline-xattrs-during-inode-block-validation
+++ a/fs/ocfs2/xattr.h
@@ -43,6 +43,8 @@ int ocfs2_xattr_set_handle(handle_t *, s
 			   struct ocfs2_alloc_context *);
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di);
+int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
+			       struct ocfs2_dinode *di);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 int ocfs2_init_security_get(struct inode *, struct inode *,
 			    const struct qstr *,
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


