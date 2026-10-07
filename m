Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766AE355048
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338683; cv=none; b=F7g3JG+OKMhQsliTzlX1mxEzUqT8cVuy2ozUttnnkb8NB7ri37qPGRS1QdgJ3S2kePVf1B/5kki0bsjwqpDH72ns30MaF0IB0Y0qpI/0ruHNWlzy3qIreKKExv1fo9qAtDDNXMl5ftWnlBSxoEcU9T+lwJGZyXJdtOVs0k61RP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338683; c=relaxed/simple;
	bh=xTd3IxC/SdD4fBl1AsMXMJ9hdzTGqQB7No9n871uXuE=;
	h=Date:To:From:Subject:Message-Id; b=u7WVbUWVfVwDGwEz5i4fAHMBbMfDo2+0B7n44A+Wa3sfIPVNi3lR8oDfJ+Yelzp7F/yNGiY4lpoGWoxKBjp0WGm4sYIpSJm0yq8iEB1FIsZur854VmzwF67t1ZoUV7kT9xzZ1JCBXbciPDnl+L6s00U3RM9e8ReP7SinaJKt35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZhGdGpl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZhGdGpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2DC1F0089B;
	Wed,  7 Oct 2026 02:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338682;
	bh=07Ixr0vfxPtbeC4x14/zbAWGW5L2id6Zi0Z+YO+EwUk=;
	h=Date:To:From:Subject;
	b=yZhGdGpldJWL3y3/aW05ijw9ESwYyzSrHJYYmJuDs4cCDJrWiqF9W1dSOs+CO19Nx
	 2KVCw1s46TklCpcUsLs/jPuuCfinW83jp7i7HVfFMVmcioOo1kJrltxXJDi2Sr9Bwk
	 b/NqSlrjGoEK6lO7ZnBJ7KT6Qx3B7xEuBPe/DomY=
Date: Tue, 06 Oct 2026 19:04:41 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch removed from -mm tree
Message-Id: <20261007020442.4D2DC1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate suballoc slot and bit of extent and refcount blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate suballoc slot and bit of extent and refcount blocks
Date: Tue, 1 Sep 2026 20:52:21 +0800

ocfs2_validate_extent_block() and ocfs2_validate_refcount_block() do not
validate h_suballoc_slot, h_suballoc_bit, rf_suballoc_slot and
rf_suballoc_bit at all.  Since extent blocks and refcount blocks are
allocated from a per-slot suballocator at runtime, their suballoc slots
must be within range and their suballoc bits must fit in a block group
bitmap.

Otherwise a corrupted image can carry an out-of-range slot.  When the
extent block is freed, ocfs2_cache_extent_block_free() caches it and
ocfs2_free_cached_blocks() later passes the unvalidated slot to
ocfs2_get_system_file_inode(); when the refcount block is freed,
ocfs2_remove_refcount_extent() passes it via ocfs2_cache_block_dealloc(). 
get_local_system_inode() will then either hit BUG_ON(slot ==
OCFS2_INVALID_SLOT) or compute an out-of-bounds index into the
local_system_inodes array.  Similarly an oversized suballoc bit will error
out the filesystem in _ocfs2_free_suballoc_bits().

Furthermore group descriptor validation only guarantees bg_bits within the
physical bitmap size, so a corrupted image can still carry a suballoc bit
beyond bg_bits, which would let ocfs2_block_group_clear_bits() clear bits
beyond bg_bitmap.  Convert the remaining BUG_ON against group->bg_bits in
_ocfs2_free_suballoc_bits() to ocfs2_error() as well.

Reject out-of-range suballoc slots and oversized suballoc bits during
validation.

Link: https://lore.kernel.org/20260901125221.1634686-5-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/alloc.c        |   27 +++++++++++++++++++++++++++
 fs/ocfs2/refcounttree.c |   27 +++++++++++++++++++++++++++
 fs/ocfs2/suballoc.c     |   15 ++++++++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks
+++ a/fs/ocfs2/alloc.c
@@ -925,6 +925,33 @@ static int ocfs2_validate_extent_block(s
 		goto bail;
 	}
 
+	/*
+	 * Extent blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(eb->h_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has an invalid h_suballoc_slot of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_suballoc_slot));
+		goto bail;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(eb->h_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb,
+				 "Extent block #%llu has an invalid h_suballoc_bit of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(eb->h_suballoc_bit));
+		goto bail;
+	}
+
 	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
 		rc = ocfs2_error(sb,
 				 "Extent block #%llu has invalid l_count %u (expected %u)\n",
--- a/fs/ocfs2/refcounttree.c~ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks
+++ a/fs/ocfs2/refcounttree.c
@@ -118,6 +118,33 @@ static int ocfs2_validate_refcount_block
 	}
 
 	/*
+	 * Refcount blocks are allocated from a per-slot suballocator, so the
+	 * slot must be in range.  Otherwise freeing the block passes it to
+	 * get_local_system_inode(), which hits BUG_ON() for
+	 * OCFS2_INVALID_SLOT or computes an out-of-bounds index otherwise.
+	 */
+	if ((u32)le16_to_cpu(rb->rf_suballoc_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb,
+				 "Refcount block #%llu has an invalid rf_suballoc_slot of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(rb->rf_suballoc_slot));
+		goto out;
+	}
+
+	/*
+	 * Similarly the suballoc bit must fit in a block group bitmap.
+	 * Otherwise freeing the block will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() and trigger ocfs2_error() there.
+	 */
+	if (le16_to_cpu(rb->rf_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb,
+				 "Refcount block #%llu has an invalid rf_suballoc_bit of %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(rb->rf_suballoc_bit));
+		goto out;
+	}
+
+	/*
 	 * rf_records (rl_count/rl_used/rl_recs[]) is only meaningful when
 	 * this block is not an interior tree block (OCFS2_REFCOUNT_TREE_FL);
 	 * in that case the same union bytes hold an extent list (rf_list)
--- a/fs/ocfs2/suballoc.c~ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks
+++ a/fs/ocfs2/suballoc.c
@@ -3070,7 +3070,20 @@ static int _ocfs2_free_suballoc_bits(han
 	}
 	group = (struct ocfs2_group_desc *) group_bh->b_data;
 
-	BUG_ON((count + start_bit) > le16_to_cpu(group->bg_bits));
+	/*
+	 * Group descriptor validation only guarantees bg_bits within the
+	 * physical bitmap size, so double check the freeing range here.
+	 * Otherwise ocfs2_block_group_clear_bits() would clear bits beyond
+	 * bg_bitmap.
+	 */
+	if ((count + start_bit) > le16_to_cpu(group->bg_bits)) {
+		status = ocfs2_error(alloc_inode->i_sb,
+				     "Group descriptor #%llu has %u bits, cannot free bits %u+%u\n",
+				     (unsigned long long)le64_to_cpu(group->bg_blkno),
+				     le16_to_cpu(group->bg_bits),
+				     count, start_bit);
+		goto bail;
+	}
 
 	if (ocfs2_is_cluster_bitmap(alloc_inode))
 		old_bg_contig_free_bits = group->bg_contig_free_bits;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

