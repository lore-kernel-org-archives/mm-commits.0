Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D0F488DAD
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283337; cv=none; b=ArWTA32rSU9QJH+GWLWM56GhMyDHpAM1z/mTBFcPjsXcJ2zaHNiDoDh+DRUQUPua/rP+f2K3Pel1hskHKiw+P0kP2/kl7aJLs6KbaEDpUTQZQV7dQxYv5pGB9e1VkdaI+y66sKtve8gfBO/qefPfN/mF6cm9YizjOhke0jBZT0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283337; c=relaxed/simple;
	bh=8Qpbh2OYpwlTUPNS2KqBBDSRbw1ObgUYQ6322OsS/NQ=;
	h=Date:To:From:Subject:Message-Id; b=JixMaBA6BNpfK3W94IbT/MKtRVcj5YhzqiX+6uo1kt9fJZyH5z3LzpvV9gdcrnsoz+Xbw5YTTHkwe0aIcC9H/V/bdyhdZHkfOLt1pcNGXYjAwNfPEUqhN6Z0so7U4Rp9WYPz5H+MP5et5lwnWPO7eHbsS5G9Y3JrvnuHQnAq+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8+lGw0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8+lGw0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FEA1F00A3A;
	Tue,  1 Sep 2026 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283335;
	bh=+07pPsZqjEA5Efuj7Ye0Ak8Jm5cxd0yOfUJuBPi6JuM=;
	h=Date:To:From:Subject;
	b=t8+lGw0t5DV8CU/HnETtePUxGwd+vh2KsTeegNHdDkXaZHMlH/Jkhw9J11oWi7Pcy
	 QobPLaiSq20aPa3k/Mfsa9Dg5XCetsf7REH/KJmQ9dAeCtu8CqgQPYWvJqpTGivFBC
	 EVOO7FqTOjPg0yvJ5Ka1cSwKJrpW0EMS0o+Q6lkQ=
Date: Tue, 01 Sep 2026 10:22:14 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-suballoc-bit-during-inode-read.patch added to mm-nonmm-unstable branch
Message-Id: <20260901172215.63FEA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate suballoc bit during inode read
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-suballoc-bit-during-inode-read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-suballoc-bit-during-inode-read.patch

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
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch

