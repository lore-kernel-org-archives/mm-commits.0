Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB5A4718D3;
	Tue, 13 Oct 2026 03:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791860545; cv=none; b=Gc28GXiV4dD2Ph15sGTVkL/7kG1mk499FHp5xId2J5GtY9/CairTODxuqZ+oJtQcfCQsC+p3JGbBDYF1BmcRXohq8v4Xjc1vVXeQqwpvGcZZuoEqTpINYCTvCi9X6BwnYlmPtDnuCjt1Ai7a0Kpq6SjELns4YZGmhIvOCeW5PDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791860545; c=relaxed/simple;
	bh=iGqi0e5HHvjpQoX9cYZ3wNSVQeRVFP/0v0FRbI283M4=;
	h=Date:To:From:Subject:Message-Id; b=oEX9wJ3AgMN+C9J6YwuFXpNQ+VtdA1xS34YkttLIRvvhwOXyLDxN84uFTzZujeZkznd9FqKezMnPBwzBBoYb3xVQyNmZF2XHo9AtqXsFD8Je5icuabtLaqBXNxEde/nwO0eAH2UQgTI7KgKajpi3NC/PELVqgabiWYli50iybvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w8+UP1r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w8+UP1r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6930D1F000FF;
	Tue, 13 Oct 2026 03:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791860543;
	bh=ggdh0gMnWSNeHsqGPXeKj4HGqHGf1ualClFCAWoH7lY=;
	h=Date:To:From:Subject;
	b=w8+UP1r7Gvsla3tvcv76ClQUscvQtK3eywPQfaWBAIYoRVOHO13jG03wvbegD/CVT
	 xxVpd2qH0K1pMK1B2hc57slTxZ9mJLRNs4Nj54n/1dzViB1BwJDSak3UoiD6ZBB0ik
	 mbLXqk8YCJPNfJL2ZphkZ7go634j0rlivOM/EYd4=
Date: Mon, 12 Oct 2026 20:02:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch added to mm-nonmm-unstable branch
Message-Id: <20261013030223.6930D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use the stored hash when checking xattr bucket collision
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch

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
Subject: ocfs2: use the stored hash when checking xattr bucket collision
Date: Fri, 09 Oct 2026 16:30:01 +0800

ocfs2_check_xattr_bucket_collision() decides whether splitting a full
bucket can make room for the entry being set by recomputing the hash of
the name:

	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));

	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
		return 0;

For a new entry that is the hash it will be stored under, so comparing it
is correct.  An existing entry keeps the hash it already has: an update
never rewrites xe_name_hash, since ocfs2_xa_add_entry() is the only
writer of that field for a real entry and ocfs2_xa_prepare_entry() calls
it only when loc->xl_entry is NULL.

An entry stored by a kernel that sign-extended the name bytes when
hashing can still be updated, because ocfs2_xattr_find_entry() searches
a non-indexed xattr block by memcmp on the name and never looks at
xe_name_hash.  Growing it past the space left in the block converts the
block into a tree, ocfs2_cp_xattr_block_to_bucket() fills the bucket in
stored hash order, and the update runs out of room in the bucket too.
The collision check then compares the unsigned hash against the legacy
hashes in the bucket and reports no collision.

ocfs2_xattr_set_entry_index_block() goes on to allocate a bucket that
ocfs2_divide_xattr_bucket() cannot fill: a bucket whose entries all share
one hash has no divide position, so all it does is append an empty bucket
with a sentinel hash one above the last entry's.

The re-search that follows depends on where the unsigned hash sorts.
Below the legacy ones, it comes back to the full bucket and the set fails
with -ENOSPC, having grown the tree for nothing.  Above them, it lands on
the new empty bucket, which ocfs2_xattr_bucket_find() handles explicitly
and ocfs2_find_xe_in_bucket() scans zero times, so the set stores a second
copy of the entry under the unsigned hash and returns success.  The
original stays in the full bucket, listxattr reports the name twice and
getxattr returns the new copy.

Pass the hash the entry is stored under instead: the stored one for an
existing entry, the unsigned one for a new entry.  A tree whose entries
are all stored under the unsigned hash sees no change, since there the
two are the same value.

Link: https://lore.kernel.org/20261009083002.2621201-3-joseph.qi@linux.alibaba.com
Fixes: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org> # 6.2+
---

 fs/ocfs2/xattr.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision
+++ a/fs/ocfs2/xattr.c
@@ -5923,16 +5923,14 @@ out:
 
 /*
  * check whether the xattr bucket is filled up with the same hash value.
- * If we want to insert the xattr with the same hash, return -ENOSPC.
- * If we want to insert a xattr with different hash value, go ahead
- * and ocfs2_divide_xattr_bucket will handle this.
+ * If the entry being set carries that same hash, return -ENOSPC, since
+ * ocfs2_divide_xattr_bucket() has no divide position to work with.
+ * Otherwise go ahead and ocfs2_divide_xattr_bucket() will handle this.
  */
-static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
-					      struct ocfs2_xattr_bucket *bucket,
-					      const char *name)
+static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
+					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
@@ -6001,6 +5999,7 @@ static int ocfs2_xattr_set_entry_index_b
 					     struct ocfs2_xattr_search *xs,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
+	u32 name_hash;
 	int ret;
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
@@ -6020,10 +6019,18 @@ static int ocfs2_xattr_set_entry_index_b
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
+	 *
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	ret = ocfs2_check_xattr_bucket_collision(inode,
-						 xs->bucket,
-						 xi->xi_name);
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
+	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-reserve-metadata-for-a-new-xattr-block-and-its-value-tree.patch
ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch
ocfs2-reserve-xattr-value-tree-metadata-only-once.patch
ocfs2-deal-with-legacy-signed-dir-index-name-hash-values.patch
ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch
ocfs2-deal-with-legacy-signed-xattr-name-hash-values.patch

