Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863571;
	b=Ecz8eRT5y5wk+0L1rkoXu0puasTiH+VccAgULsnmi1BZ/NHOIY1Kkr28CxwAYgA0Sd32
	 X5wF3SzHi7oD3AufCON9vnHNkzMMFLk0vlLGGj249S6puFcBzm0aWyJgN81AVcY6Vqc0+
	 vUICGGxgfUEFdZuY1LhmjHOmJWKOoHLM4ubqxZs9vEoaK6mX4sOEerGCARyx/L4jJ2tp3
	 Fy3MdQ9+H7byaJqSKLt/bSp8/mle6M7gf7fFrdps/cfV/7u7ltf/Sp2vMaZxAFpa66mhV
	 9CJztGNpdqRbQ+8Rt/0Pjhs0s3FvwcYS4uXHdbQGnbJNcgUCgvAq/RPkMqvaJiRr8kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863571;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rhJCZn+DiKdmnzDaQVMc9AOS84gxSKvW59YBsF7oblc=;
	b=CoMCJABBTIS8tJ34HnE3G3KQUOydhhGuUTtZkEXrml++Wsx8TRRKa1rUIm+PMfPhrTr7
	 JojzRZFr9AgrzNMWv3ABZwpxJ0ol30yUGRkkum8xEf9XnG9oCGwt13eqOR0T+rYwZAFgv
	 KlFUr9yC+8N7duZ6YrUYb83swGQvsfZxeojJ2s3P1lsSQYoCv8B2dyfmVJ5rLANthk2uB
	 2CUbfufbWvxH8UX5QIEHq/vi9FsELF0oQAY9IjygvaowsauVf2DMLUlL6Vs9G6WZod9Hu
	 ta6buVAkh0qFUoH6L+ID7gCYXF6h7TuFcW3sKsGNIE9V7GSboCTVEs3QuHvfbkg62mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JZRfxh+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516D7606A31B;
	Sat, 24 Oct 2026 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JZRfxh+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39791F01825;
	Sat, 24 Oct 2026 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863571;
	bh=rhJCZn+DiKdmnzDaQVMc9AOS84gxSKvW59YBsF7oblc=;
	h=Date:To:From:Subject;
	b=JZRfxh+KAAsIdy6TN0H2WRWh4EUSs1WWBn+Lv/hloOzNP2LZR1Qwf7SagTs9Z8HsT
	 pf5pnrUuQohrTFObz5FCmkePN0IE6FbemfFtjUSITEIGIV0AcoweemtqwESDgG/9Oz
	 J7rPmjqKBMsgdV78K4urEDAUDNWSzucmhkawLtdE=
Date: Sat, 24 Oct 2026 10:39:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20261024173930.E39791F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: do not read the entry array of an empty xattr bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch

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

ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch
ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch
ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch
ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

