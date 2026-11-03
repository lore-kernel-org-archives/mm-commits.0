Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675980;
	b=GVFpWO6V54dke3AynqkUUP1CYXtLrTDUtPq0uzHTJniDNkt84oD5GELGg0PoN2xy97TZ
	 Vc2hByQwMRyDYWuXl00uZOZOd0gap4EgZzYGYI+AOnKaZjXiW7PJBPogNkd+Ba4bBv20a
	 RyXrQB2A+1bef48VRGG+Qnd+9V914huFtDFwEbYCA1JAgNXcNJ3/xc1EP/kFNufL6oOuN
	 XHgilxlzqRlCkEsTEtYqkkc/8EfT8/SSrdMrKcw9PD6NNKVtrYwwS1OVbIhoYMPuXr9yC
	 e/OXqHT+7VqTqCS5JAMRWZbQt7R8b22OwIJ6zlkpopx7AAa9JgajSLo7UkbJLyZUX/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675980;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=v0J13UtSpiONvAkOdsLpJ+HTBIxE2Ed/v2b6+39TZWc=;
	b=u2oR/lG+ZZeAX16x5xC7/yc7N4raJcog07JPa+rK8E4zYJJMWQqVHjfapk/4S5yxyonc
	 Vli8gixBmu82sYO+UObirJ3q+ODN3dIfXhD8GJ/pfQE6r7cylfYrcdsn7gNoX8+zfZeyR
	 3G7bHb3XqCClwWAZZdJ+nZIX7OvvWm+TqC93g8O6AELZ7xul7+rrKzIZafyPIwhKLmncE
	 OKAT6HVDEQDCpVdXRz5jNXK1xRo5plcx38Nh3+rakQDjLZVL9OqKyTxI2WD1eU1JwOC9a
	 f9vygtSj4yvj3lTKjoMmU5IJvuRDtxd68PJXKtlVrwnlrhDNO/BYoUyeHX6V/XmAesQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QOJcCNKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28AF606A336;
	Tue,  3 Nov 2026 03:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QOJcCNKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE5D1F0093A;
	Tue,  3 Nov 2026 03:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675979;
	bh=v0J13UtSpiONvAkOdsLpJ+HTBIxE2Ed/v2b6+39TZWc=;
	h=Date:To:From:Subject;
	b=QOJcCNKTn0KidKIjiTucbLA7bkP98BWgrGOSZaAD3CNHwEe1Nueor6aCLeINB6fFO
	 FnvN0aesAp0D8pbk4IHczj57WX7yKoF+FM53HPsb7VORxPAKzsACWRPhs9zxxQKRAm
	 O63LBFBrPyAtw2m2cISxoiJtyua5cJiJJTsX+7ZQ=
Date: Mon, 02 Nov 2026 19:19:39 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch removed from -mm tree
Message-Id: <20261103031939.7FE5D1F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: do not read the entry array of an empty xattr bucket
has been removed from the -mm tree.  Its filename was
     ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: do not read the entry array of an empty xattr bucket
Date: Sat, 24 Oct 2026 23:10:10 +0800

ocfs2_check_xattr_bucket_collision() decides whether splitting a bucket
can make room by comparing the hash being inserted against the first and
the last entry.  xh_count comes off disk and is never checked, and a
bucket is allowed to hold no entries: ocfs2_xa_remove_entry() keeps the
last slot when it removes the only one, so that an empty bucket still
carries the hash it is keyed by.  xh_count then reads back as 0 while
xh_entries[0] is still meaningful, and the second comparison indexes
xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header.  An entry is 16 bytes and xe_name_hash is its first
field, so the value read is xh_count | xh_free_start << 16.  It stays
inside the block, but the answer is arbitrary, and for an empty bucket
it says there is no collision, so a new bucket gets added on the
strength of it.

An empty bucket holds no entries to collide with.  Return before reading
the array.

One way to reach the test with an empty bucket is a set that removes the
bucket's only entry during cleanup and then fails for space again, since
it is that second -ENOSPC which calls this.  Growing a value past
OCFS2_XATTR_INLINE_SIZE is the easy route: the cluster allocation fails,
the "!orig_clusters" arm of ocfs2_xa_cleanup_value_truncate() removes
the entry, and although the "growing" caller does set ctxt->set_abort,
only ocfs2_xattr_block_set() and __ocfs2_xattr_set_handle() look at it,
so ocfs2_xattr_set_entry_index_block() goes straight on to the collision
check.

This sits on commit a9ea8b397864 ("ocfs2: use the stored hash when
checking xattr bucket collision"), which gave the collision check its two
argument form and is marked for 6.2 and later.  The read fixed here is
present in the three argument version too, but a tree without that
commit needs the hunk adapted by hand.

Link: https://lore.kernel.org/20261024151012.1059683-5-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket
+++ a/fs/ocfs2/xattr.c
@@ -6061,11 +6061,20 @@ static int ocfs2_check_xattr_bucket_coll
 					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 count = le16_to_cpu(xh->xh_count);
+
+	/*
+	 * An empty bucket keeps the hash of the entry that was removed in
+	 * xh_entries[0] so that it can still be found, but it holds no
+	 * entries to collide with.
+	 */
+	if (!count)
+		return 0;
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
 
-	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
+	if (xh->xh_entries[count - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
 		mlog(ML_ERROR, "Too much hash collision in xattr bucket %llu, "
 		     "hash = %u\n",
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


