Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408572472AA
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338643; cv=none; b=NvqD08UGY/P75hLjdkIAktG4rpUvYxvj4K7ZPNTMM4xvuw8ukGERs6ZOkztZ2ozn7DimTVoilFZUnw6raiJ0biTm2zUvD+iCXH6Qnpj2o0ciN6ym4pMKx8dMn616mUnadMRh387s7yLzylOah3rSdzN7AmUzmT79upRUzDNxoCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338643; c=relaxed/simple;
	bh=wQKK+okUUMcdGvPF72SQgXoJhxSAA5oltHzss3qhPb8=;
	h=Date:To:From:Subject:Message-Id; b=DP7PAk9f0GP7xOTv4KhvkYckw5EmU4yNbjb5eK+VGQyejvS2UPVY1BOeg0w+/xZQbzltRjc9V2VmtPm8YkP2soEeQKbCTw3Vle4EoVEs4TKf8lxIyGKQssnq4T2AV2pkhFch7wdk+BndtvDezLkX/eoThFQRAKctu7UZHW3TgxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jYz+0zx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jYz+0zx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD7C1F0089B;
	Wed,  7 Oct 2026 02:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338642;
	bh=QHO6vSdIolaOD+wMga1bZGSo01sL+N2X+4i+Q1DRDmw=;
	h=Date:To:From:Subject;
	b=jYz+0zx5iID+y8qypp8LeGDuDiE1sF8t4syxnbLNvyqAtfr6RxuX8km/W71dgi3K6
	 3NQ/ElwS4Fz3UOzpCv4Vj8WfpFZBE5LOUK4nyixXTDCFoNll4JdH1QP6DRjs6ze5bA
	 SN/Rv85oU/4q0nhK/XxUjsqShwfbZvwknEm8gJfo=
Date: Tue, 06 Oct 2026 19:04:01 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reject-inconsistent-local-xattr-entries.patch removed from -mm tree
Message-Id: <20261007020402.1DD7C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: reject inconsistent local xattr entries
has been removed from the -mm tree.  Its filename was
     ocfs2-reject-inconsistent-local-xattr-entries.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: reject inconsistent local xattr entries
Date: Thu, 6 Aug 2026 16:50:12 +0800

[BUG]
A corrupt OCFS2 xattr entry can set OCFS2_XATTR_ENTRY_LOCAL while
keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE. When that
entry reaches namevalue_size_xe(), the filesystem hits its BUG_ON:

kernel BUG at fs/ocfs2/xattr.c:231!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:namevalue_size_xe fs/ocfs2/xattr.c:231 [inline]
RIP: 0010:ocfs2_xa_block_wipe_namevalue+0x2e4/0x330 fs/ocfs2/xattr.c:1638
Call Trace:
 ocfs2_xa_wipe_namevalue fs/ocfs2/xattr.c:1470 [inline]
 ocfs2_xa_remove_entry+0xae/0x1d0 fs/ocfs2/xattr.c:1941
 ocfs2_xa_remove fs/ocfs2/xattr.c:2043 [inline]
 ocfs2_xa_set+0x11a8/0x30a0 fs/ocfs2/xattr.c:2247
 ocfs2_xattr_ibody_set+0x302/0xc50 fs/ocfs2/xattr.c:2795
 __ocfs2_xattr_set_handle+0x7e6/0xdb0 fs/ocfs2/xattr.c:3416
 ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
 ocfs2_xattr_security_set+0x37/0x50 fs/ocfs2/xattr.c:7241
 __vfs_removexattr+0x14d/0x1d0 fs/xattr.c:518
 cap_inode_killpriv+0x29/0x50 security/commoncap.c:355
 security_inode_killpriv+0x105/0x220 security/security.c:2724
 setattr_prepare+0x147/0x8a0 fs/attr.c:219
 ocfs2_setattr+0x504/0x1fd0 fs/ocfs2/file.c:1148
 notify_change+0x4b5/0x1030 fs/attr.c:546
 do_truncate+0x1d2/0x230 fs/open.c:68
 handle_truncate fs/namei.c:3596 [inline]
 do_open fs/namei.c:3979 [inline]
 path_openat+0x260f/0x2ce0 fs/namei.c:4134
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 ...

[CAUSE]
namevalue_size_xe() assumes that local entries contain an inline value
no larger than OCFS2_XATTR_INLINE_SIZE. Existing xattr metadata
validation only checks whether the value fits the storage region, and
cached entries can reach lookup and bucket maintenance paths without a
semantic check. A corrupt entry can therefore be passed to
namevalue_size_xe().

[FIX]
Validate the local/value-size invariant in the existing flat and bucket
metadata validators and before accepting matched entries or traversing
bucket entries in paths that call namevalue_size_xe(). Return an OCFS2
corruption error instead of firing the assertion.

Link: https://lore.kernel.org/20260806085012.2650042-1-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/xattr.c |   53 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reject-inconsistent-local-xattr-entries
+++ a/fs/ocfs2/xattr.c
@@ -237,6 +237,21 @@ static int namevalue_size_xe(struct ocfs
 	return namevalue_size(xe->xe_name_len, value_len);
 }
 
+static int ocfs2_validate_xattr_entry(struct super_block *sb, u64 blkno,
+				      struct ocfs2_xattr_entry *xe)
+{
+	u64 value_len = le64_to_cpu(xe->xe_value_size);
+
+	if (value_len > OCFS2_XATTR_INLINE_SIZE &&
+	    ocfs2_xattr_is_local(xe))
+		return ocfs2_error(sb,
+				   "Invalid local xattr in block %llu: value size %llu\n",
+				   (unsigned long long)blkno,
+				   (unsigned long long)value_len);
+
+	return 0;
+}
+
 
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 					     struct ocfs2_xattr_header *xh,
@@ -989,7 +1004,7 @@ static int ocfs2_validate_xattr_entries_
 	size_t entries_limit = region_size;
 	size_t nv_limit = region_size;
 	size_t max_entries;
-	int i;
+	int i, ret;
 
 	if (region_size < sizeof(*xh))
 		return ocfs2_error(sb,
@@ -1009,6 +1024,11 @@ static int ocfs2_validate_xattr_entries_
 		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
 		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
 		size_t value_offset;
+		u64 value_len = le64_to_cpu(xe->xe_value_size);
+
+		ret = ocfs2_validate_xattr_entry(sb, blkno, xe);
+		if (ret)
+			return ret;
 
 		if (name_offset > nv_limit ||
 		    xe->xe_name_len > nv_limit - name_offset)
@@ -1023,8 +1043,7 @@ static int ocfs2_validate_xattr_entries_
 					   (unsigned long long)blkno, i);
 
 		if (ocfs2_xattr_is_local(xe)) {
-			if (le64_to_cpu(xe->xe_value_size) >
-			    nv_limit - value_offset)
+			if (value_len > nv_limit - value_offset)
 				return ocfs2_error(sb,
 						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
 						   (unsigned long long)blkno,
@@ -1109,7 +1128,7 @@ static int ocfs2_validate_xattr_bucket(s
 	size_t entries_limit = sb->s_blocksize;
 	size_t nv_limit = sb->s_blocksize;
 	size_t max_entries;
-	int i;
+	int i, ret;
 
 	if (region_size < sizeof(*xh))
 		return ocfs2_error(sb,
@@ -1137,6 +1156,11 @@ static int ocfs2_validate_xattr_bucket(s
 		size_t block_off = name_offset >> sb->s_blocksize_bits;
 		size_t block_offset = name_offset % nv_limit;
 		size_t value_offset;
+		u64 value_len = le64_to_cpu(xe->xe_value_size);
+
+		ret = ocfs2_validate_xattr_entry(sb, blkno, xe);
+		if (ret)
+			return ret;
 
 		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
 			return ocfs2_error(sb,
@@ -1155,8 +1179,7 @@ static int ocfs2_validate_xattr_bucket(s
 					   (unsigned long long)blkno, i);
 
 		if (ocfs2_xattr_is_local(xe)) {
-			if (le64_to_cpu(xe->xe_value_size) >
-			    nv_limit - value_offset)
+			if (value_len > nv_limit - value_offset)
 				return ocfs2_error(sb,
 						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
 						   (unsigned long long)blkno,
@@ -1304,7 +1327,7 @@ static int ocfs2_xattr_find_entry(struct
 {
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
-	int i, name_offset, cmp = 1;
+	int i, name_offset, cmp = 1, ret;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1327,6 +1350,12 @@ static int ocfs2_xattr_find_entry(struct
 				return -EFSCORRUPTED;
 			}
 			cmp = memcmp(name, (xs->base + name_offset), name_len);
+			if (!cmp) {
+				ret = ocfs2_validate_xattr_entry(inode->i_sb,
+								 OCFS2_I(inode)->ip_blkno, entry);
+				if (ret)
+					return ret;
+			}
 		}
 		if (cmp == 0)
 			break;
@@ -4068,6 +4097,10 @@ static int ocfs2_find_xe_in_bucket(struc
 
 		xe_name = bucket_block(bucket, block_off) + new_offset;
 		if (!memcmp(name, xe_name, name_len)) {
+			ret = ocfs2_validate_xattr_entry(inode->i_sb,
+							 OCFS2_I(inode)->ip_blkno, xe);
+			if (ret)
+				break;
 			*xe_index = i;
 			*found = 1;
 			ret = 0;
@@ -4705,6 +4738,9 @@ static int ocfs2_defrag_xattr_bucket(str
 	xe = xh->xh_entries;
 	end = OCFS2_XATTR_BUCKET_SIZE;
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++, xe++) {
+		ret = ocfs2_validate_xattr_entry(inode->i_sb, blkno, xe);
+		if (ret)
+			goto out;
 		offset = le16_to_cpu(xe->xe_name_offset);
 		len = namevalue_size_xe(xe);
 
@@ -4987,6 +5023,9 @@ static int ocfs2_divide_xattr_bucket(str
 	name_value_len = 0;
 	for (i = 0; i < start; i++) {
 		xe = &xh->xh_entries[i];
+		ret = ocfs2_validate_xattr_entry(inode->i_sb, blk, xe);
+		if (ret)
+			goto out;
 		name_value_len += namevalue_size_xe(xe);
 		if (le16_to_cpu(xe->xe_name_offset) < name_offset)
 			name_offset = le16_to_cpu(xe->xe_name_offset);
_

Patches currently in -mm which might be from gality369@gmail.com are


