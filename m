Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4230233122D
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338681; cv=none; b=QtENMzMkXadN4/xYDjXyisgpRgGhG6XWPvqV3UivgsUEUINTb26OeEW9M2Vfw4aDeffZAs8UFqFZiwnU17GIPRnRLJgrq3lWsUIluuwCMXXCRa18TTzSZ6utTvpNCeCclgYO7tUUDssdfJAksls6tCbUsH0bxpiPptQcfa+JBfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338681; c=relaxed/simple;
	bh=zmbepcrPgvmJMtOsyxzqj6JcdNY5eBU8yJKZAk0xY3E=;
	h=Date:To:From:Subject:Message-Id; b=XOTyEqe+0KvGfFK1WByLR5lq9gwZajBYiKTAVLi8xlMCi4v8ylzbYejZOnuolPHBY6fymcnsJjz0wpEI8Lk67YdoGwfi9m5m+xbssdi9UsBtN0KZggw5dFbhEvJy+QVLfzAeCCal99mcEdI+uEFR0gWCMgoEcq7E2gUyNczD6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zjed+Rg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zjed+Rg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0336F1F0089B;
	Wed,  7 Oct 2026 02:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338680;
	bh=ObUM+xZeHB+LiDX6TD1gtOADCq5xgeFUjhduuSjHPNE=;
	h=Date:To:From:Subject;
	b=Zjed+Rg06MxjLh8rTTK8FpzcfhrR25Pz8CPbtem68xQIYCSMxylADKyehxJkNpnM3
	 3ST+iJeEPnSq5ejE1Dz5XPHU7WfQqOSrhojhOQG7sJeG34rQPZo7LBPN+EHQWhA9nQ
	 kHpwFw4sen0gR6GL/cfFPpjxZrA+Z70aspwxa9fU=
Date: Tue, 06 Oct 2026 19:04:39 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-suballoc-bit-during-inode-read.patch removed from -mm tree
Message-Id: <20261007020440.0336F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate suballoc bit during inode read
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-suballoc-bit-during-inode-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate suballoc bit during inode read
Date: Tue, 1 Sep 2026 20:52:19 +0800

i_suballoc_bit of a dinode is currently not validated at all.  A corrupted
dinode can carry an abnormally large i_suballoc_bit, which bypasses
ocfs2_validate_inode_block().  When the inode is deleted,
ocfs2_remove_inode() calls ocfs2_free_dinode(), which passes the
unvalidated bit to _ocfs2_free_suballoc_bits() and triggers BUG_ON((count
+ start_bit) > ocfs2_bits_per_group(cl)).

A suballocator block group bitmap is contained in a single block and
starts after the group descriptor header, so a valid suballoc bit must be
smaller than the number of bits fitting in the remaining space.  Reject
oversized i_suballoc_bit values during dinode validation.  The bound is
derived from ocfs2_group_bitmap_size() so it is also tight when
discontig_bg caps the suballocator bitmap at OCFS2_MAX_BG_BITMAP_SIZE.

Note the above check alone is not sufficient since the freeing path
compares the bit against ocfs2_bits_per_group(), which is derived from
cl_cpg/cl_bpc of the allocator dinode that is not validated against the
actual group capacity and can be artificially smaller on a corrupted
image.  Convert this BUG_ON in _ocfs2_free_suballoc_bits() to
ocfs2_error() as well.

Link: https://lore.kernel.org/20260901125221.1634686-3-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
---

 fs/ocfs2/inode.c    |   16 ++++++++++++++++
 fs/ocfs2/ocfs2.h    |   12 ++++++++++++
 fs/ocfs2/suballoc.c |   18 +++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-validate-suballoc-bit-during-inode-read
+++ a/fs/ocfs2/inode.c
@@ -1547,6 +1547,22 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * A suballocator block group bitmap is contained in a single block
+	 * and starts after the group descriptor header, so a valid suballoc
+	 * bit can never exceed ocfs2_suballoc_bits_per_block().  Otherwise
+	 * deleting the inode will pass the oversized bit to
+	 * _ocfs2_free_suballoc_bits() via ocfs2_free_dinode() and trigger
+	 * BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl)), since any
+	 * group holds at most ocfs2_suballoc_bits_per_block() bits.
+	 */
+	if (le16_to_cpu(di->i_suballoc_bit) >= ocfs2_suballoc_bits_per_block(sb)) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc bit %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_bit));
+		goto bail;
+	}
+
 	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
 	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
--- a/fs/ocfs2/ocfs2.h~ocfs2-validate-suballoc-bit-during-inode-read
+++ a/fs/ocfs2/ocfs2.h
@@ -593,6 +593,18 @@ static inline int ocfs2_supports_discont
 	return 0;
 }
 
+/*
+ * A suballocator block group bitmap starts right after the group
+ * descriptor header, so a suballoc bit can never exceed this number
+ * of bits.  Derive it from ocfs2_group_bitmap_size() which also caps
+ * it at OCFS2_MAX_BG_BITMAP_SIZE when discontig_bg is enabled.
+ */
+static inline u32 ocfs2_suballoc_bits_per_block(struct super_block *sb)
+{
+	return ocfs2_group_bitmap_size(sb, 1,
+				       OCFS2_SB(sb)->s_feature_incompat) * 8;
+}
+
 static inline unsigned int ocfs2_link_max(struct ocfs2_super *osb)
 {
 	if (ocfs2_supports_indexed_dirs(osb))
--- a/fs/ocfs2/suballoc.c~ocfs2-validate-suballoc-bit-during-inode-read
+++ a/fs/ocfs2/suballoc.c
@@ -3040,10 +3040,22 @@ static int _ocfs2_free_suballoc_bits(han
 	/* The alloc_bh comes from ocfs2_free_dinode() or
 	 * ocfs2_free_clusters().  The callers have all locked the
 	 * allocator and gotten alloc_bh from the lock call.  This
-	 * validates the dinode buffer.  Any corruption that has happened
-	 * is a code bug. */
+	 * validates the dinode buffer. */
 	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
-	BUG_ON((count + start_bit) > ocfs2_bits_per_group(cl));
+
+	/*
+	 * ocfs2_bits_per_group() is derived from cl_cpg and cl_bpc of the
+	 * allocator dinode, which are not validated against the volume
+	 * geometry.  A corrupted image can carry a suballoc bit beyond it,
+	 * so error out instead of crashing.
+	 */
+	if ((count + start_bit) > ocfs2_bits_per_group(cl)) {
+		return ocfs2_error(alloc_inode->i_sb,
+				   "Allocator #%llu: freeing bits %u+%u exceeds bits per group %u\n",
+				   (unsigned long long)le64_to_cpu(fe->i_blkno),
+				   count, start_bit,
+				   ocfs2_bits_per_group(cl));
+	}
 
 	trace_ocfs2_free_suballoc_bits(
 		(unsigned long long)OCFS2_I(alloc_inode)->ip_blkno,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

