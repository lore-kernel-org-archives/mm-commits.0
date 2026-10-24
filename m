Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863575;
	b=pSQODq7Ew8eN7N1Dj3KW8Q6hfrQPI7HRHtUvO8jWCwschXiAdWI2trnxh4n1TOQRaGzv
	 UhIR96i5ie/p8L5x1Za1Sk4h8ifnsQpq/j6stkUebDqfMvTLT3TeqBMKOsa5MB0S0t3Qb
	 G4AH3gSz5a/3EUr1F38YVe1t0MfGsosHs+pa0XJJOyWYDeoMqMoMDjkto4bgDRADg9XkJ
	 u+Rj7H04diBYL+hMl2Bp4mj9K3FphYYHhxPbfHqPWj9+6TZnfWIq5+GeFqmge4fEewEYj
	 xT5DnoRnPhkpgPFM7WZTs2sPnnMmVsSVMJA+OxGt7L0KWxFdJHqWyOw+MvxckDwiqTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863575;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dOYFw+rnLSNm3IoDGQR/cUouyy2ZPftlN5E3fvK9T7U=;
	b=l7oVcO6RZaRbpPYkLtHr9FBb7XTV+w6CL/TSzmDVdzVvu+P37QSyolhtBQJDcxX27qph
	 LSjYlgkSdMHZEjephziijSs+c2l1PathVQoWIlVfgylemtvKZM52Y9tXK8A3iyiikHb2E
	 spT5ENe/4wRmlTgqQ9Ivl1JVGA7SHZa22q7vt2iMI71fJLXDqeVOALuxfYzV3+E/JVF81
	 1++83/j7aCI1ndnwV/RY176iwjhbH0pyx638nxVWSf4TJhYr+hX1V7w1/IeV2FM8uP6xd
	 poMMQZkBCi1kfQ8LIHnqqvywMhULfaL3JdyqkGKIsQrXJH66sGN8bAB96P0V7SeK8fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xyJ4I7tH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D250B606A326;
	Sat, 24 Oct 2026 17:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xyJ4I7tH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9481F01825;
	Sat, 24 Oct 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863574;
	bh=dOYFw+rnLSNm3IoDGQR/cUouyy2ZPftlN5E3fvK9T7U=;
	h=Date:To:From:Subject;
	b=xyJ4I7tH1XCVrnX1+gQb8OUR3o0AU0jP6FLvQ1WxEv4LIVljIz0vhECeTIzh2gKT3
	 4I/V29AdchvcPUN9TuoNk6tBGkBnIYBbmh1nPhqiDBB0u08D4uN4zTG1SktCWFbYXY
	 6zkTV3pPdBL+OMHvB768E3B3udxIUzwJfhbYI2L0=
Date: Sat, 24 Oct 2026 10:39:34 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch added to mm-nonmm-unstable branch
Message-Id: <20261024173934.9E9481F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: do not read the entry array of an empty xattr block
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

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
Subject: ocfs2: do not read the entry array of an empty xattr block
Date: Sat, 24 Oct 2026 23:10:12 +0800

ocfs2_cp_xattr_block_to_bucket() sizes the name and value area it has to
carry over from the block's last entry, so an empty block makes it read
xh_entries[-1].  That lands on the header, where xe_name_offset overlaps
xh_name_value_len, and block storage never maintains that field, so it
reads as 0 and the copy runs from the header to the end of the block.

The bucket that comes out has xh_count 0 but a name_value_len of
blocksize less the header, and a matching xh_free_start that claims
those bytes are in use -- nearly the whole bucket with the common 4K
block size -- while the last block of the bucket holds a copy of the old
block's bytes.  Nothing but a trace event reads xh_name_value_len, the
copied bytes came from the same inode and were wiped before the entry
was removed, and ocfs2_defrag_xattr_bucket() recomputes xh_free_start,
so this corrupts the header rather than leaking anything.

Leave the bucket empty instead, carrying over the hash the block was
keyed by, since ocfs2_add_new_xattr_bucket() and
ocfs2_xattr_bucket_find() both read xh_entries[0] of an empty bucket.
That read is the exception ocfs2_xa_remove_entry() documents rather than
a new out of bounds access.

A block reaches the conversion empty when truncating an external value
back fails partway through: the "reusing" and "overwriting" callers of
ocfs2_xa_cleanup_value_truncate() remove the entry without setting
ctxt->set_abort, so ocfs2_xattr_block_set() sees a plain -ENOSPC and
converts.  The "growing" caller does set it, and the block form makes a
single attempt with no defragment and retry in between, so that is the
only route here.

Link: https://lore.kernel.org/20261024151012.1059683-7-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block
+++ a/fs/ocfs2/xattr.c
@@ -4705,6 +4705,21 @@ static void ocfs2_cp_xattr_block_to_buck
 		memset(bucket_block(bucket, i), 0, blocksize);
 
 	/*
+	 * An empty block has no names or values to carry over, and the
+	 * xh_entries[count - 1] below would be xh_entries[-1].  Leave the
+	 * bucket empty, but carry over the hash ocfs2_xa_remove_entry() left
+	 * in the block's xh_entries[0] so that the bucket still holds the key
+	 * it is looked up by.
+	 */
+	if (!count) {
+		xh->xh_num_buckets = cpu_to_le16(1);
+		xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+		xh->xh_entries[0].xe_name_hash =
+			xb_xh->xh_entries[0].xe_name_hash;
+		return;
+	}
+
+	/*
 	 * Since the xe_name_offset is based on ocfs2_xattr_header,
 	 * there is a offset change corresponding to the change of
 	 * ocfs2_xattr_header's position.
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch
ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch
ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch
ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

