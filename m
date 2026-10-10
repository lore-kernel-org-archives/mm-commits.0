Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4C6547044;
	Sat, 10 Oct 2026 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791650904; cv=none; b=gpO3bY0XExjaSZUdRP44L+7hG540nsLBnBdTfdozS9/nIZcj1FDmW2WhJXRxTNPx6/mwDxG1/VX3eX7uRh9Bw/WT37jxP28fmdAHyciE4Ue3Br+C2WA//AHNHuRiCVPIg0YQGyoXNtEf8tUxUPIqSJU3X4cAt+RW04SSXmMcZaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791650904; c=relaxed/simple;
	bh=nz23+LSUA915DFq4HRv4hSWjlt8GI7vSicxxZHCzHNc=;
	h=Date:To:From:Subject:Message-Id; b=IPjIYgDLG/Rsj3217jUjsWigLGEW8LD08qgxJntWntS4uGA38V04BebXZ5SRpI4vt5wEmRRU9jm0wShkftiN7d0/FxyfgIFnz93YTocy/mFE/sHFGyM7Ovz4xfmhHdXgtu23ySBFoV9wWohdBbnLKwFvXW/qdey89eju4Pl/fZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vG2KhEsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vG2KhEsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27121F00893;
	Sat, 10 Oct 2026 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791650902;
	bh=jOnI+hYs+PYvBRzzuL9uAYOL5D6bbfTwCWGPO+XJWA4=;
	h=Date:To:From:Subject;
	b=vG2KhEsFMLitN0vKcNukLQzOLUZHDfipgs8aag/4Q7gnxKcD3U48uF7FtGsPBlbMb
	 1TN6kqFC8bSzpASegKFUoIqnz7ieALpgLqxf3xAqBqBUS4FafhakJyTOd6kYSz5u3h
	 Zg7Y4vnPO9r3Milmt+n5M5n3hHzIjKGKPcgEjw14=
Date: Sat, 10 Oct 2026 09:48:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch added to mm-nonmm-unstable branch
Message-Id: <20261010164821.E27121F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reserve metadata for a new xattr block and its value tree
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch

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
Subject: ocfs2: reserve metadata for a new xattr block and its value tree
Date: Sat, 10 Oct 2026 19:34:52 +0800

Patch series "ocfs2: fix metadata reservation for xattr value trees".

ocfs2_calc_xattr_set_need() reserves too little metadata for a new xattr
value's extent tree on three paths.  The reservation cannot be topped up
once the transaction has started, so ocfs2_add_clusters_in_btree() gives
up with RESTART_META when the value root fills and nothing is left. 
ocfs2_xattr_extend_allocation() turns that into -ENOSPC, after
ocfs2_xa_cleanup_value_truncate() has dropped the entry and leaked the
clusters already handed out; before commit 0cdc7dde00ec ("ocfs2: fix
missing metadata reservation for large xattrs") it was a BUG_ON() instead.
It takes a fragmented cluster allocator to get there, since the first
extent always fits in the root.

Patch 1 fixes the create side of meta_guess: commit 3ed2be719eb9 ("ocfs2:
allow for more than one data extent when creating xattr") replaced the
block reserved for the new xattr block with the two the value tree needs
instead of adding them together.

Patch 2 fixes the arm that moves an xattr back into the inode, which
charges credits for a value tree but no metadata for one.

Patch 3 drops a second copy of the same reservation on the path that falls
through to meta_guess.  That one is cleanup rather than a fix and is not
for stable, and it must not be backported without patch 1: the duplicate
it removes is what currently covers the shortfall patch 1 fixes.


This patch (of 3):

The create side of meta_guess in ocfs2_calc_xattr_set_need() reserves
metadata for the new value's extent tree and nothing for the xattr block
that will hold it:

        } else {
                credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
                if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
                        struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
                        meta_add += ocfs2_extend_meta_needed(el);
                        ...

Commit 3ed2be719eb9 ("ocfs2: allow for more than one data extent when
creating xattr") meant to add that tree on top of the meta_add += 1 the
branch already had, but it moved the 1 into the else arm instead, so the
external-value case lost it.  The 1 is not optional: it is what
ocfs2_create_xattr_block() takes from meta_ac through
ocfs2_claim_metadata(), and it is spent before the value tree exists.

ocfs2_extend_meta_needed() on the empty def_xv list returns 2, so the
branch reserves 2 where 3 are needed.  The xattr block consumes one, and
when the cluster allocator is fragmented enough that the value needs more
than one extent, ocfs2_add_clusters_in_btree() comes back around with a
full value root and ocfs2_alloc_context_bits_left() of 1 against a
threshold of 2.  It answers RESTART_META, which
ocfs2_xattr_extend_allocation() turns into a BUG_ON().  Commit
0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
downgraded that to -ENOSPC, at the cost of leaking the clusters already
handed out: ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters
arm, drops the entry and leaves the clusters for fsck.ocfs2 to reclaim.

Reserve for the block and the tree separately.

Link: https://lore.kernel.org/20261010113454.1420939-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261010113454.1420939-2-joseph.qi@linux.alibaba.com
Fixes: 3ed2be719eb9 ("ocfs2: allow for more than one data extent when creating xattr")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree
+++ a/fs/ocfs2/xattr.c
@@ -3598,7 +3598,13 @@ meta_guess:
 		credits += OCFS2_XATTR_BLOCK_CREATE_CREDITS;
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE) {
 			struct ocfs2_extent_list *el = &def_xv.xv.xr_list;
-			meta_add += ocfs2_extend_meta_needed(el);
+			/*
+			 * One block for the xattr block we may have to
+			 * allocate, the rest for growing the value tree it
+			 * would hold.  If ocfs2_xattr_ibody_set() succeeds
+			 * instead, that first block goes unused.
+			 */
+			meta_add += 1 + ocfs2_extend_meta_needed(el);
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     el);
 		} else {
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch
ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch
ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch

