Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A106348987C
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283340; cv=none; b=OE15OzyBGXFMVjOLTxSii8IQ1dJF+aWxkS7FErmzgNOzFU6BswPqCWOnLqZbn4RqEoeZ2ZavrGC6OrsbP6iUe/jjveKV5XNMBxh2UfRi6eMmMlrT16WAuSTDrxfPCWDoc6O7k7t9x7+YlaylAPYcF7EiYtsIfKbLR5ksJGNOQDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283340; c=relaxed/simple;
	bh=SaDjOtbf5KVSmoc2pXBPYRg9L9liQWRWoySsuZ3wuoU=;
	h=Date:To:From:Subject:Message-Id; b=GDaJL305TQv0h6vEcKsudNdLEwDW56eX+Gtt7unUE+tzL0bIddOrJmpQhNqlVrg6LOYE/sd7cmtuMUumIqJTY23tbCMP4cO9UJEdaNjGgfzuXV2PtooLrPTHzYqfLlL/HhQhzuryW+ba0C3u+yUN6+Y1lJU5I1Rkdpy8YtM8TC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZWw27loU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZWw27loU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EDE1F000E9;
	Tue,  1 Sep 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283338;
	bh=uN11lHCbTIM59HMyMxB/WY+hvFN7LbG7r5JKo3iPOAk=;
	h=Date:To:From:Subject;
	b=ZWw27loUG4KAbQ7sWJryRrYpDUDLULRSStMpjQe1J/SRaXq085Dkccu5CRAIvz8Ts
	 FgfqcXuR+8ZvQwN4TafIK/8ZtRbgdLbllgC2AlmiNcFToHM2poSkOYdx+xank5PyrY
	 6tm5tW67k4n08MNshqogbTz0yAJWnEuIJtFJvN3Q=
Date: Tue, 01 Sep 2026 10:22:17 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch added to mm-nonmm-unstable branch
Message-Id: <20260901172218.61EDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate suballoc slot and bit of xattr and dir index blocks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate suballoc slot and bit of xattr and dir index blocks
Date: Tue, 1 Sep 2026 20:52:20 +0800

ocfs2_validate_xattr_block() and ocfs2_validate_dx_root() do not validate
xb_suballoc_slot, xb_suballoc_bit, dr_suballoc_slot and dr_suballoc_bit at
all.  Since xattr blocks and dir index root blocks are allocated from a
per-slot suballocator at runtime, their suballoc slots must be within
range and their suballoc bits must fit in a block group bitmap.

Otherwise a corrupted image can carry an out-of-range slot.  When the
xattr block or dir index is removed, ocfs2_xattr_block_remove() or
ocfs2_dx_dir_remove_index() passes the unvalidated slot to
ocfs2_get_system_file_inode() and get_local_system_inode() will either hit
BUG_ON(slot == OCFS2_INVALID_SLOT) or compute an out-of-bounds index into
the local_system_inodes array.  Similarly an oversized suballoc bit will
error out the filesystem in _ocfs2_free_suballoc_bits().

Furthermore ocfs2_validate_dx_root() does not verify dr_blkno against the
physical block number like the extent and xattr block validators do, so a
misplaced dir index root block can pass validation.

Reject misplaced dir index root blocks, out-of-range suballoc slots and
oversized suballoc bits during validation.

Link: https://lore.kernel.org/20260901125221.1634686-4-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c   |   35 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/xattr.c |   25 +++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks
+++ a/fs/ocfs2/dir.c
@@ -605,6 +605,41 @@ static int ocfs2_validate_dx_root(struct
 		goto bail;
 	}
 
+	if (le64_to_cpu(dx_root->dr_blkno) != bh->b_blocknr) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_blkno of %llu\n",
+				  (unsigned long long)bh->b_blocknr,
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno));
+		goto bail;
+	}
+
+	/*
+	 * Dir index root blocks are allocated from a per-slot suballocator,
+	 * so the slot must be in range.  Otherwise removing the index passes
+	 * it to get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(dx_root->dr_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has invalid dr_suballoc_slot %u\n",
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+				  le16_to_cpu(dx_root->dr_suballoc_slot));
+		goto bail;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise removing the index will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(dx_root->dr_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has invalid dr_suballoc_bit %u\n",
+				  (unsigned long long)le64_to_cpu(dx_root->dr_blkno),
+				  le16_to_cpu(dx_root->dr_suballoc_bit));
+		goto bail;
+	}
+
 	if (!(dx_root->dr_flags & OCFS2_DX_FLAG_INLINE)) {
 		struct ocfs2_extent_list *el = &dx_root->dr_list;
 
--- a/fs/ocfs2/xattr.c~ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks
+++ a/fs/ocfs2/xattr.c
@@ -532,6 +532,31 @@ static int ocfs2_validate_xattr_block(st
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	/*
+	 * Xattr blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(xb->xb_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		return ocfs2_error(sb,
+				   "Extended attribute block #%llu has an invalid xb_suballoc_slot of %u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(xb->xb_suballoc_slot));
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(xb->xb_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		return ocfs2_error(sb,
+				   "Extended attribute block #%llu has an invalid xb_suballoc_bit of %u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(xb->xb_suballoc_bit));
+	}
+
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		size_t region_offset =
 			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch

