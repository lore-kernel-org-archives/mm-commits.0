Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560652;
	b=4xGc6ysYg7ZP8BpGEFkpARidFB3wXUEWxAU5bK3mqCPyx4T5WqYz+Ll26A5DU4ibfpHY
	 1I3Pe77MSERbGDLqwmnvwAv67zoStHoUmZajo4hJ+3BUPBeEz1L7Jsy2Eu5/WQuFAE+Uz
	 N/8RPRfbI9mOFcwakpq3Kl9bx/ojFxB67MK68xkcMXX1uZL9VSHLuVUfPKQsNv5ghCy0u
	 UvTzO9gtGYmj2yyrY5x2nSVAMUncwixSCrs9Df9yRWAL5WbPlOmu8ytmZLMPNOac9msYb
	 8xfU171uJVfLBrVelvQ1hTzHI9f12m8b0MpdtxD4sIKottkmN2O00ZSbTbvwCgkqbHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560652;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wPGCxAMe2LoEOeYTxGyLLssxMUrRyLfeIhP7vNsshp4=;
	b=SWhH4QaW/BE6F2FLWYq4xV8VBAXwGcqpwFoMMAWA73RC3/PPGJVS9CsHBvzztrKQRHm0
	 5PVnZW0U249swk809zq7/pIupkm+y/jLIA4AVMODomsY3jc3r9GYYMolvf+aWKxOn4WiD
	 GZ3i7whr2y4gWxe3ZvlrtnLl3WUtM5a2piGsYfcIvNujz8IltAhEIEbNmx6T/acbEUoJK
	 rrhOyhhLka2c+UtFW5cOaJCfjnoHSsIlAJ+ThPtexoz8Knm6EAa6BbxVAPHPVzhEZalWZ
	 Kjc9NqIJCwBm7f4XPprFWgDsztskEOGEU/0A580Yeb1AXIRIzCm3tK9odQnt6QgLnqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Gp0HxDl/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EA7606A330
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Gp0HxDl/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1941F000C9;
	Wed, 21 Oct 2026 05:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560652;
	bh=wPGCxAMe2LoEOeYTxGyLLssxMUrRyLfeIhP7vNsshp4=;
	h=Date:To:From:Subject;
	b=Gp0HxDl/oqnnYw9maQEzzJWneVRCvD8L74hSzq9rtcfXhhVeo22sqyRgoXkKiYTVA
	 QLI8po+s7lRd6i7qmNrOa9wN4oYY9ESyRLSlY/QpuiH7QmH4zhLXgTH3DjYvqHruUF
	 /9Ch3TfQ969sxqA4SKIcVIEwXJtlxivaWYGwkN+o=
Date: Tue, 20 Oct 2026 22:30:51 -0700
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch removed from -mm tree
Message-Id: <20261021053052.5F1941F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: validate the xattr tree root of an indexed xattr block
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-the-xattr-tree-root-of-an-indexed-xattr-block.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


