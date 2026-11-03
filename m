Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675976;
	b=5RA+pzPOSReZglCvxcUbzrHfkHHz6E3Y9cecfo13AL325qHTN4xB0TmrBC9FcCYEJOuw
	 83L1pWD1vZD6bPLv+ntZn4PO31nbKLpbJo286X7gl0SZodv26YCkAYggZX/v5r3FbwtFo
	 TAo2uKg+QEMcRWpyj4QPJQ65uNGR+hOzH+uzveqigg29jMD61TSw9HZseY5CxoxJSVhfb
	 d/OGx8e0GkYu7vW1jkdqWhaCu8JNG/sup0f2Vkry0shT5QsdQMZyC7n2Jol/qR6NVC5AS
	 Sk6x7tD+a6QWH1Lp4icM7XevQEGJndTWK0rz3ntPc+j5tomMjxEV7z0/rMirXz164Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675976;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RLKoVjVHETQ99hov+Wl4G9A2hMLEwsKYlPjJAMvIzss=;
	b=Gv6dRHmPJzb4iG+qbuETQWwFFR7yqg28VCPg/SNRsPnFz1aYvh9qL8Y4a5o+q61QIAvh
	 YUQ92MxVx7CidyY7y8nIzTdpyapHQp4VdTPf+yapdzY6oAxf+iaLNo6LQq3rSOwKmkUmy
	 Vy0PNRivfO2OHvkozIq3mPwm5l+KSL1M3zljOZ/AtJg4W73e5nnYQjrgzGSDtAdX9terK
	 t/TQSPWfY1QXgl28nvfc8DjKa+6iSIIDH6HYr/lYbOxCY5wPye1MpAkoiuzHrfpHfQYER
	 jL0i4jNuZPhWm9YtEO+GePL9yK50fwU3GPbeUoEVswatIPnl4M+g8EFXplFo7qjjlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BXHi7Kdb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FDA606A337
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 03:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BXHi7Kdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5161F000C1;
	Tue,  3 Nov 2026 03:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675976;
	bh=RLKoVjVHETQ99hov+Wl4G9A2hMLEwsKYlPjJAMvIzss=;
	h=Date:To:From:Subject;
	b=BXHi7KdbmFssp2MJF1+E9vc859ypL8TXYBC4TULV4hqB3l+HG+ab9o6CPvAuzJfZ1
	 aKChq7ovVXJ1JATeGqN3s9wj0MnzWc7d7//ivIPhKntdpb3+BEXyqjozbRJISjo6jZ
	 tLCOmnEVYdM3BFMzuV+UHfvOTWAtxziOz3tTdqr8=
Date: Mon, 02 Nov 2026 19:19:35 -0800
To: mm-commits@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,
	heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch removed from -mm tree
Message-Id: <20261103031936.0F5161F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: read the xattr entry hash before defragmenting the bucket
has been removed from the -mm tree.  Its filename was
     ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: read the xattr entry hash before defragmenting the bucket
Date: Sat, 24 Oct 2026 23:10:07 +0800

Patch series "ocfs2: fix stale xattr entry pointers and empty header
reads", v1.

Five defects in the ocfs2 extended attribute code, plus one robustness
measure that belongs with them, all on the paths that move entries
between a block, a bucket and an index tree.  They fall into two groups.

Stale entry pointers (patches 1 to 3)

ocfs2_xa_set() writes through a pointer into xh_entries[] that two of
its callers invalidate first.  Defragmenting a bucket ends in a sort()
on xe_name_hash, and lib/sort.c is an unstable heapsort, so entries that
share a hash can trade slots.  Copying a block into a bucket changes the
order outright, since a block holds its entries in insertion order while
a bucket holds them by hash, yet ocfs2_xattr_update_xattr_search()
relocates the search by the index the entry had in the block.  Neither
path compares the entry's name with the one being set, so setxattr() can
replace a neighbouring attribute's value and still report success, or
trip ocfs2_xa_reuse_entry()'s BUG_ON.  Patch 1 takes the hash before the
sort; patches 2 and 3 look the entry up again afterwards.

Reads of an empty entry array (patches 4 to 6)

A block and a bucket may both hold no entries: ocfs2_xa_remove_entry()
keeps the last slot when it removes the only one, so an empty bucket
still carries the hash it is keyed by.  Three sites index xh_entries[]
without checking xh_count and so read xh_entries[-1], which lands on the
header and comes back as xh_count | xh_free_start << 16.  Nothing
faults, but the value is acted on: the collision check reports no
collision for an empty bucket, the divide commits a sentinel hash that
hides part of the key space from ocfs2_xattr_bucket_find(), and the
block to bucket copy claims storage the bucket does not hold.  Patches 4
to 6 guard each site and keep the one read of xh_entries[0] that
ocfs2_xa_remove_entry() documents as intentional.


This patch (of 6):

ocfs2_xattr_set_entry_index_block() takes the hash a bucket split has to
work with out of xs->here, but only after ocfs2_xattr_set_entry_bucket()
has tried and failed to fit the entry.  That call defragments the bucket
when it runs out of room, and ocfs2_defrag_xattr_bucket() finishes by
sorting the entry array by name hash.  lib/sort.c is not stable, so two
entries sharing a hash may trade slots and xs->here is left naming an
entry other than the one the search found.

The hash value itself survives the permutation -- the array is already
sorted, so a slot can only exchange with an equal-hash neighbour -- but
there is no reason to depend on that.  Pick the hash up before the set,
where xs->here is unambiguously the entry the search landed on.

No functional change intended.

Link: https://lore.kernel.org/20261024151012.1059683-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20261024151012.1059683-2-joseph.qi@linux.alibaba.com
Fixes: e39baff18b85 ("ocfs2: use the stored hash when checking xattr bucket collision")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/xattr.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket
+++ a/fs/ocfs2/xattr.c
@@ -6100,6 +6100,22 @@ static int ocfs2_xattr_set_entry_index_b
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
 
+	/*
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
+	 *
+	 * Read it before the set below.  Filling the bucket may defragment it,
+	 * and ocfs2_defrag_xattr_bucket() re-sorts the entry array, so
+	 * afterwards xs->here only denotes whichever entry the sort left in
+	 * that slot.
+	 */
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
 	ret = ocfs2_xattr_set_entry_bucket(inode, xi, xs, ctxt);
 	if (!ret)
 		goto out;
@@ -6115,17 +6131,7 @@ static int ocfs2_xattr_set_entry_index_b
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
-	 *
-	 * An existing entry keeps the hash it was stored under, and that is
-	 * the hash a split has to work with.  A new entry is stored under the
-	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	if (xs->not_found)
-		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
-						  xi->xi_name_len);
-	else
-		name_hash = le32_to_cpu(xs->here->xe_name_hash);
-
 	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


