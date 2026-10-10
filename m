Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A080388E63;
	Sat, 10 Oct 2026 16:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791650905; cv=none; b=OKmbUlQl2/V1sv0wMu2KWG4+3vxxVxA2pLuLS/jIuGaGdzzEwYrxxTe4JQSUt36XFQ6wOp10BW+AMOrzQbNFjMXmOVuHUfSPTn9+I/hn2RLoBNpksTi+fDo6MkahyWqIcmxnw8yPCUaIJAcJ26gVZIC1xEQYKJ8yIt8PPmJ295A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791650905; c=relaxed/simple;
	bh=2jQFGoyhBHFdHC0LBuwjXCnjfPBSKxtLRlWgdQ+ouB4=;
	h=Date:To:From:Subject:Message-Id; b=Qy0TEY8k5Ei4JJ5i6v/LaSh38UlZoI7wf30qDPlX7t9PsGb16pMSHvpi3w4KWnTPCFou2RhzBG5B5IWqlHUzGvUNtInu0riFO40XkV2Vd8bN6WXzMVgP6wzDJgRJxF8EG55zDG+/ePvybaUDfuhn1gklq9nVllPlb4J83Rh55PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijW0PGXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijW0PGXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D504D1F000FF;
	Sat, 10 Oct 2026 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791650903;
	bh=pHPkJwbLrbS255Mcjd4DbMVSvgZGRSBSfgrFVyoKphE=;
	h=Date:To:From:Subject;
	b=ijW0PGXq69apZLSYK/wupO+94FVGcCBtcsiV4JcPS8a+SpNbyJwQTP5/HlXtAy5cC
	 nYuOMccsDxc9uLczEL84V5GBUb40ZCq1tp4a7ZphUARJijLWRmtn4kOwpelwJliNNS
	 a6p+uFylZO48VHieK/7+t3064vHPADgu0DwVu7Ug=
Date: Sat, 10 Oct 2026 09:48:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch added to mm-nonmm-unstable branch
Message-Id: <20261010164823.D504D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reserve value tree metadata when moving an xattr into the inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch

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
Subject: ocfs2: reserve value tree metadata when moving an xattr into the inode
Date: Sat, 10 Oct 2026 19:34:53 +0800

ocfs2_calc_xattr_set_need() charges no metadata for the case where an
xattr living in an xattr block or bucket moves back into the inode:

        if (old_in_xb) {
                if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
                        clusters_add += new_clusters;
                        credits += ...;
                        if (!ocfs2_xattr_is_local(xe))
                                credits += ocfs2_calc_extend_credits(...);
                        goto out;
                }
        }

The credits for extending a value tree are there but the matching blocks
are not, so meta_add stays 0, ocfs2_init_xattr_set_ctxt() skips
ocfs2_reserve_new_metadata_blocks() and ctxt->meta_ac is left NULL.

This is the shape commit 0cdc7dde00ec ("ocfs2: fix missing metadata
reservation for large xattrs") fixed for the xattr block case, and it is
reached the same way: namevalue_size() charges a value larger than
OCFS2_XATTR_INLINE_SIZE as only OCFS2_XATTR_ROOT_SIZE, so
ocfs2_xattr_can_be_in_inode() accepts a new value that will be stored
outside.  ocfs2_xa_prepare_entry() installs a value root from def_xv and
grows it, and once the cluster allocator is fragmented enough to need a
second extent ocfs2_add_clusters_in_btree() finds the root full with no
meta_ac at all and answers RESTART_META.  ocfs2_xattr_extend_allocation()
turns that into -ENOSPC, or into a BUG_ON() without that commit, and
ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters arm, dropping
the entry and leaking the clusters already handed out until fsck.ocfs2
reclaims them.

Reserve for the value tree here too.  The entry moves back into the inode
rather than into a new xattr block, so unlike the create side of
meta_guess this needs no block of its own.

Link: https://lore.kernel.org/20261010113454.1420939-3-joseph.qi@linux.alibaba.com
Fixes: 78f30c314a74 ("ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode
+++ a/fs/ocfs2/xattr.c
@@ -3498,6 +3498,14 @@ static int ocfs2_calc_xattr_set_need(str
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
 							&def_xv.xv.xr_list);
+			/*
+			 * A value too big to stay inline is only charged as
+			 * OCFS2_XATTR_ROOT_SIZE above, so it can still need a
+			 * value tree of its own.  No xattr block is allocated
+			 * on this path, so the tree is all we reserve for.
+			 */
+			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+				meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
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

