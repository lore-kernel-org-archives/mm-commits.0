Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863569;
	b=lH7yTqNyNHx84fiNIDY+25bzEVRp3HKWb4Q5qlByDSYRP/BKRVdVKnu51gmY9+ExSXoi
	 UmmdPOpBx8sKQ8+d74AJyLft/QVDavXCA3ASQIRRe8svLvht9lC74x/PIJZdZllu5Cfd6
	 VWVavcSUU0qeL6Fj1k4WItCjoF/VFtrRLwTUhiH9+QBXTQStus90HWS5KUHEjFIs/7gwH
	 aHmA+iKqEkYZOLa+fuaYrdMwHTNVyECI8K2yItV3opsDOaRmk5lw/jOGLFuQY/8gQg872
	 NnFxvL+DE19vXkVQ2TWxdvFNQCVaUn0i8n89/kHmX6U8uJvgV3Rag7/zjOXf4S61Gtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863569;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=bDe8hIXqTDCWibJgI/VwpsTRyzLy+UtS32+Ph4OdA+g=;
	b=4QbG1/Ytcdj+cwXqKhDVqLBd2mVlclXVzR4KnqXKO++LSWPsWaZA4N5pSEf7cJDoR23u
	 Wn+HQX/VoxW3GJxlcyM1vr0/k3YpkH+/+jhEwfgGbu/dq1KAapnH0jPa93nwGXBgy4O1g
	 +XItUaXu6fgXCoCqmgU+HAt/5IoCzEbo1sM/MomTgM53VrdIC7SG+YmvsQwfOn+guwAAb
	 abAdqAuy1g3LiAaJxKzybA/nfHShO19Z1NCzoav9V4/0n77eDlMsZMyCWHvziXSjvOjIc
	 A4HTXimDtb8OLIQ6ZPKaUhW/tV9vlcyBTHcK+NBH+zd6r3SYE+fUx7B3Br1Kb2o2+gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0b7rn1N+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7715B606A320;
	Sat, 24 Oct 2026 17:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0b7rn1N+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40D31F01825;
	Sat, 24 Oct 2026 17:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863569;
	bh=bDe8hIXqTDCWibJgI/VwpsTRyzLy+UtS32+Ph4OdA+g=;
	h=Date:To:From:Subject;
	b=0b7rn1N+HN2lDDJyIEJRtpVrQ6lQyiHSdIdkE/8wrydjdNnkCCuyMeaSst7qrv82t
	 o9MFPnacPrjK2RP5w/3nUH4YLamhsPhqxA2IQl+8rxGqYR55qoS0d3kU0lSJNgxY8B
	 cJ7mfT4mi3OGDTDF4TGRvwO0Tl4/cuKjW8sSN8zQ=
Date: Sat, 24 Oct 2026 10:39:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20261024173928.F40D31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: find the xattr entry again after converting a block to a bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch

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
Subject: ocfs2: find the xattr entry again after converting a block to a bucket
Date: Sat, 24 Oct 2026 23:10:09 +0800

ocfs2_xattr_create_index_block() turns a non-indexed xattr block into a
tree by copying it into a bucket, and the copy sorts the entries: a
block holds them in insertion order, a bucket by name hash.
ocfs2_xattr_update_xattr_search() nevertheless relocates the caller's
search by the index the entry had in the block, so unless the two orders
agreed it points at an unrelated entry, and nothing between there and
the write compares that entry's name with the one being set.

Setting an xattr whose new value no longer fits the block arrives here
with xs->not_found clear.  The block gave up because
ocfs2_xa_block_can_reuse() wants an exact namevalue size match, while
ocfs2_xa_bucket_can_reuse() only wants an entry at least as large as the
new one, so the bucket accepts a pair the block rejected and the update
lands on whichever entry the sort left at that index.  Equal padded name
lengths get that other attribute's value replaced in place and its name
left alone, so setxattr returns success while the attribute asked for
keeps its old value.  A longer one trips ocfs2_xa_reuse_entry()'s
BUG_ON, and a shorter one is refused by the bucket as well, so
ocfs2_xa_prepare_entry() wipes the entry and writes the new name over
it, leaving xe_name_hash describing a name that is no longer there.

Find the entry again by the name being set, matching the type as well.
The copy carries every entry and every name over unchanged, and (type,
name) pairs are unique within a block, so the match is exact.  The type
matters because the handlers strip their prefix before calling
ocfs2_xattr_set(), so user.foo and trusted.foo share a stored name, a
stored length and a hash, and both can sit in the same block.

The name has to come from xi rather than from xs->here: a failed set can
remove the entry xs->here names, and only the "growing" caller sets
ctxt->set_abort, which is what stops the conversion.  Scan every entry
rather than narrowing on the hash the way ocfs2_find_xe_in_bucket()
does, since an existing entry keeps the hash it was stored under, which
a kernel that sign-extended the name bytes made different from the one
computed now.  An empty result means the entry did not survive the
failed set and this has become an insert; leaving xs->here alone would
keep it pointing into the block, which is rewritten as a tree root
before the caller reads it again.

Link: https://lore.kernel.org/20261024151012.1059683-4-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   54 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket
+++ a/fs/ocfs2/xattr.c
@@ -275,6 +275,7 @@ static int ocfs2_xattr_tree_list_index_b
 					size_t buffer_size);
 
 static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_info *xi,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt);
 
@@ -3375,7 +3376,7 @@ static int ocfs2_xattr_block_set(struct
 		else if ((ret != -ENOSPC) || ctxt->set_abort)
 			goto end;
 		else {
-			ret = ocfs2_xattr_create_index_block(inode, xs, ctxt);
+			ret = ocfs2_xattr_create_index_block(inode, xi, xs, ctxt);
 			if (ret)
 				goto end;
 		}
@@ -4749,13 +4750,10 @@ static void ocfs2_cp_xattr_block_to_buck
  * real place of the xattr.
  */
 static void ocfs2_xattr_update_xattr_search(struct inode *inode,
-					    struct ocfs2_xattr_search *xs,
-					    struct buffer_head *old_bh)
+					    struct ocfs2_xattr_info *xi,
+					    struct ocfs2_xattr_search *xs)
 {
-	char *buf = old_bh->b_data;
-	struct ocfs2_xattr_block *old_xb = (struct ocfs2_xattr_block *)buf;
-	struct ocfs2_xattr_header *old_xh = &old_xb->xb_attrs.xb_header;
-	int i;
+	int i, count;
 
 	xs->header = bucket_xh(xs->bucket);
 	xs->base = bucket_block(xs->bucket, 0);
@@ -4764,8 +4762,43 @@ static void ocfs2_xattr_update_xattr_sea
 	if (xs->not_found)
 		return;
 
-	i = xs->here - old_xh->xh_entries;
-	xs->here = &xs->header->xh_entries[i];
+	/*
+	 * A block holds its entries in insertion order while a bucket holds
+	 * them by name hash, so ocfs2_cp_xattr_block_to_bucket() sorted the
+	 * copies and the index this entry had in the block no longer says
+	 * where it is.  It copied every entry and every name unchanged, and
+	 * (type, name) pairs are unique within a block, so find it again by
+	 * name.
+	 *
+	 * Search for the name being set, not for the name xs->here carries.
+	 * A failed set may have removed that entry, and ocfs2_xa_remove_entry()
+	 * then memmoves its successor into the slot.  Comparing every entry
+	 * rather than narrowing on the hash also finds an entry stored under
+	 * the legacy signed hash, which ocfs2_find_xe_in_bucket() would skip.
+	 */
+	count = le16_to_cpu(xs->header->xh_count);
+	for (i = 0; i < count; i++) {
+		struct ocfs2_xattr_entry *xe = &xs->header->xh_entries[i];
+
+		if (ocfs2_xattr_get_type(xe) != xi->xi_name_index)
+			continue;
+		if (xe->xe_name_len != xi->xi_name_len)
+			continue;
+		if (!memcmp(xs->base + le16_to_cpu(xe->xe_name_offset),
+			    xi->xi_name, xi->xi_name_len)) {
+			xs->here = xe;
+			return;
+		}
+	}
+
+	/*
+	 * The entry did not survive the failed set, so this has become an
+	 * insert.  Point xs->here back inside the bucket: it still refers to
+	 * the block being converted, which is about to be rewritten as a tree
+	 * root.
+	 */
+	xs->not_found = -ENODATA;
+	xs->here = xs->header->xh_entries;
 }
 
 /*
@@ -4773,6 +4806,7 @@ static void ocfs2_xattr_update_xattr_sea
  * is allocated and the xattr block header is rewritten.
  */
 static int ocfs2_xattr_create_index_block(struct inode *inode,
+					  struct ocfs2_xattr_info *xi,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt)
 {
@@ -4834,7 +4868,7 @@ static int ocfs2_xattr_create_index_bloc
 	ocfs2_cp_xattr_block_to_bucket(inode, xb_bh, xs->bucket);
 	ocfs2_xattr_bucket_journal_dirty(handle, xs->bucket);
 
-	ocfs2_xattr_update_xattr_search(inode, xs, xb_bh);
+	ocfs2_xattr_update_xattr_search(inode, xi, xs);
 
 	/* Change from ocfs2_xattr_header to ocfs2_xattr_tree_root */
 	memset(&xb->xb_attrs, 0, inode->i_sb->s_blocksize -
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch
ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch
ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch
ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

