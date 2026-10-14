Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0007D4A6CCA
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017024; cv=none; b=j3eyVhW4xMYKzo/Ca5KOf+hFQg/NZnxQkLpGXe+rhkheyErVTioHBepCl9L0Ns4KIGqxs3mAK+TB0VS0x3jNHy4WIbUxcy7YMMNQ11YvjEOzWcJaY3nvjG0lpiw2l+AXhPq0M0MtDxt+uJZcsRToO8Bczb2K4JAO9r72nUYBMYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017024; c=relaxed/simple;
	bh=v7nxqT5BDNR/VhDRr1oWLV8LN1P9nv8nKJ9nLpu4GPY=;
	h=Date:To:From:Subject:Message-Id; b=uReFjh5OPiALw6jBsloewbcbpA1pUR4MvY7N3/MXCJvEWeKJL4ue7adThh7G5HVqspDOcCYjtuI8J0Nhji6E+YqKwkjjMioMbx5+oiimN6V+knDJQs88SkJdp6L8R00nkx7yTmQ3FssRSPturknqoaf83l9c6sSckCrcoo84aZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h69TIF+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h69TIF+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B921F000C4;
	Wed, 14 Oct 2026 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792017022;
	bh=aO5W+giykx8mlFX7HVIX++kkSkjzBQTA4nFvyNcfws4=;
	h=Date:To:From:Subject;
	b=h69TIF+I/cWf44dJ4XPyIHgTOJm2JCzH+pKATjk5X/fvsH9cSlAmD6Ns1988E9LYg
	 NngdaXObSNpLXIUdqMfkmEygSCHt01qfJQPx6j4QxTSIdNGOLfly1BzVxRTW39ob4E
	 PI50NAtGBAcjDZ4wE4WLMgqX5AmlH6oS1A3TIRg0=
Date: Wed, 14 Oct 2026 15:30:21 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch added to mm-nonmm-unstable branch
Message-Id: <20261014223022.55B921F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate the xattr tree root of an indexed xattr block
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch

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
Subject: ocfs2: validate the xattr tree root of an indexed xattr block
Date: Wed, 14 Oct 2026 18:58:56 +0800

ocfs2_validate_xattr_block() checks an xattr block's signature, blkno,
generation and suballocator fields, and for a non-indexed block the entry
array it carries.  An indexed block is passed straight through, so the
extent list in its xattr tree root is never looked at.

Both fields that describe the list are bounded.  The two places that
create a root set l_count from ocfs2_xattr_recs_per_xb() and nothing
rewrites it, and the insert path asserts in ocfs2_rotate_leaf() that
l_next_free_rec stays within l_count.  Check both when the block is
first read, so a root that disagrees with the block size, or claims more
records than it has room for, is caught before anything indexes into
l_recs[].

An empty root is deliberately not rejected.  Emptying the tree leaves it
that way: ocfs2_rm_xattr_cluster() removes one extent per transaction,
and the last one ends in ocfs2_truncate_rec(), whose closing
ocfs2_rotate_tree_left() reaches ocfs2_remove_empty_extent() on the
depth-zero root and takes l_next_free_rec to zero.  That transaction
commits before ocfs2_xattr_free_block() frees the block, and before
ocfs2_xattr_remove() clears i_xattr_loc, in two later transactions, so a
crash in between leaves an orphan inode pointing at an xattr block whose
root has no extents.  Both readers already cope with it:
__ocfs2_xattr_index_block_find() answers -ENODATA, and
ocfs2_iterate_xattr_index_block() returns without iterating.

Link: https://lore.kernel.org/20261014105856.2909777-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/xattr.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block
+++ a/fs/ocfs2/xattr.c
@@ -491,6 +491,7 @@ static int ocfs2_validate_xattr_block(st
 				      struct buffer_head *bh)
 {
 	int rc;
+	struct ocfs2_extent_list *el;
 	struct ocfs2_xattr_block *xb =
 		(struct ocfs2_xattr_block *)bh->b_data;
 
@@ -573,6 +574,30 @@ static int ocfs2_validate_xattr_block(st
 							 region_offset);
 	}
 
+	/*
+	 * An indexed xattr block carries the root of the xattr tree.  Its
+	 * record count is fixed by the block size and l_next_free_rec never
+	 * exceeds it.  A zero l_next_free_rec is valid: emptying the tree on
+	 * the inode deletion path leaves the root with no extents.
+	 */
+	el = &xb->xb_attrs.xb_root.xt_list;
+
+	if (le16_to_cpu(el->l_count) != ocfs2_xattr_recs_per_xb(sb)) {
+		return ocfs2_error(sb,
+				   "Xattr tree root #%llu has invalid l_count %u (expected %u)\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(el->l_count),
+				   ocfs2_xattr_recs_per_xb(sb));
+	}
+
+	if (le16_to_cpu(el->l_next_free_rec) > le16_to_cpu(el->l_count)) {
+		return ocfs2_error(sb,
+				   "Xattr tree root #%llu has l_next_free_rec %u past the end of its list (l_count %u)\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le16_to_cpu(el->l_next_free_rec),
+				   le16_to_cpu(el->l_count));
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch
ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch
ocfs2-dlm-hold-the-lookup-reference-across-convert-ast-enqueue.patch
ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch

