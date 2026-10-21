Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560636;
	b=VX9wzXmU7ZVb+1DmlI6Tzc7v7ipkeg/TdgX6pW7gSnLt7Ff8+10oWmAC+ac7XDuI0DH9
	 N+IzLb5fznBT4n2aSNLmWQsuDzojIQ6PxSyLBbIJpbHc9e/NP/qV0n8WOnH0Hx2Hn170+
	 NUXri/zNYzV3cJbojWv4Ntpv5WiTRFY64C+cu4FMpTAljrkwETMpnfrUCXBPN4FAovgti
	 sR40NCIwmrzEr7O91QV0USPh2xOv+JpmmVuFLCaKe2b2bf1Nez+k9n0DuH34SiTI56gpW
	 WoXr0RNEtrRLPA6ibKP9qmALbsmherzPMKQfALirkPmaXbVlDRcgcfEu78m+Mv5F+5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560636;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=h0AL68Vnruo1lClEYSepc1KFjD3vx3fqrkqej6K2RA4=;
	b=DyVRM2Duy01kg7Eev29tbgAlLq5fonTUgYmLm7JiRjgGFROMKcboY2SzW/Imx1WsOhWg
	 Lzy/pVx/r6yDuK3Cek9BMxK0Ae+6PuPjQWxT5gjMf11127CWoC2x8sghLBRFVR2tgn4Hp
	 Jhgmvj5RHsOS3zCwEhMxQZYpS2X+gdqusMW+pQYyCt5DP7zAGB7bJac/9eMq7pBgha8El
	 C8afw9jr3Okhylab5aaBHZ1COKTgNfuPLlIEqiTNOFcaaXQGRritp0IEgCJUr5Bv+B4Wk
	 J45BrTqjYbwKKfDEcKpgq71HIbmsV+sQWXajCwSOK9JjXOsVQqABQI1Wg74W/Xezngg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O+JSmT6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448D606A322;
	Wed, 21 Oct 2026 05:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O+JSmT6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6A31F000C9;
	Wed, 21 Oct 2026 05:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560635;
	bh=h0AL68Vnruo1lClEYSepc1KFjD3vx3fqrkqej6K2RA4=;
	h=Date:To:From:Subject;
	b=O+JSmT6gzPO4myNlPBuXHw2wtjbGKCJMYhyFnX7LQWlg4bVHJaPqGoc9na7mQXNga
	 GCWO6ep9wdNziJv7FO5RYfWHhGgSYBc6q31ese2y++ynImDAYiqTeOTj0i0no0qMb0
	 w6VqOqiESSpj1ReBc0Fjb9keslHEuYphe1MgCUnA=
Date: Tue, 20 Oct 2026 22:30:35 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,anderson.ferneda@braza.com.br,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch removed from -mm tree
Message-Id: <20261021053035.9E6A31F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: use the stored hash when checking xattr bucket collision
has been removed from the -mm tree.  Its filename was
     ocfs2-use-the-stored-hash-when-checking-xattr-bucket-collision.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


