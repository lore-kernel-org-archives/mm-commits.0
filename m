Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792863567;
	b=nThFV/6l2WTKtTFsFeiK/f+M5GZHq9/NSID40Rg2Hb8/Yq9879deKHsjHHolh1nukD1O
	 tIsfzF9sf6LHsf03k+1ljYFviEdxfKIeor8wwJNw0BUuD+lSssCHzbljqgWKx9aP3uqHM
	 pR+SRgCwVr4SeJP6WSBJj1DaO7I6nX8Gl4Bu09iB1Ykw7j9KPePL1ICQAtfNcjE7peWPF
	 bZsaG21Bn54rU388H3IOczalxNriUgI8i43TBlA0SYDLiQY1SvioGkS8XQaDYcXGjOSFP
	 B+bmM5+mJwYqc7uyzNPcGRtuTZiplhgD1GnX6F6b/hwlqEdZ1tvo1rEh3kqk4xBbblQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792863567;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=24VTtpU7Dzzd34erVhqVjh/Bp+5rAfJG7FTQknYCtpk=;
	b=Y6FIWtd1NQUhOMsBUr3hxY35QcH0T4avQRcSrGWHWMxg3wrxC4+l/elHYBJhF0bIBxze
	 eOleIfXag1Ar65hZkYAYLt4SEcA/7Zg9QrRcwsL0zilyk4iu4u4jIgSspWhmDjOn9goWE
	 ZSNt7XnthcY5fpqjOxpTT0JrMQbNWXdR1aQQxmZAZYuWxi9LfUe0aBV3t+1cE0gBW6d3/
	 X1+izOqkOL5LidGkZMm0uNSo3MNFEWfU4+4h7JV8xmRXZepklclCznjfWCCtFaeCAxx+6
	 cq6sZq3c0MK/LxtIqhnENA9tp0zLA61wiRJ2cm9uens2EDm+k03G14yXO9gL6qy9Axw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZRuvTnqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5D6606A31A;
	Sat, 24 Oct 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ZRuvTnqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A201F01825;
	Sat, 24 Oct 2026 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792863567;
	bh=24VTtpU7Dzzd34erVhqVjh/Bp+5rAfJG7FTQknYCtpk=;
	h=Date:To:From:Subject;
	b=ZRuvTnqrl1a8ACjOdeBnuaB4+VtJv9XIYoZxLVTO0uhzx6rzK8ERRZ+M/2a4efJUu
	 N5fjX+frOgsJjMLW+v7nbie0yEbYMFsi7JKplffRHcHnxbEhewpzy0NtQP9Y9uatjG
	 +TOSqCM/83LvU04KeKdDf0q3x5GQLFLZB/7RHTY0=
Date: Sat, 24 Oct 2026 10:39:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch added to mm-nonmm-unstable branch
Message-Id: <20261024173927.16A201F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: find the xattr entry again after defragmenting a bucket
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch

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
Subject: ocfs2: find the xattr entry again after defragmenting a bucket
Date: Sat, 24 Oct 2026 23:10:08 +0800

ocfs2_xattr_set_entry_bucket() hands loc.xl_entry to ocfs2_xa_set() twice:
once for the bucket as it stands, and, if that reports -ENOSPC, once more
after ocfs2_defrag_xattr_bucket() has packed the name/value pairs down.

Defragmenting ends by sorting the entry array on xe_name_hash.  Buckets
are kept sorted, so the sort only permutes entries that share a hash, but
lib/sort.c is an unstable heapsort and it does permute them.  loc.xl_entry
is an address inside xh_entries[], so afterwards it denotes whichever
entry landed in that slot rather than the one the search found.

The second ocfs2_xa_set() then works on the wrong entry.  Nothing on that
path compares the entry's name with xi->xi_name, so what happens depends
on how the two entries compare in size: ocfs2_xa_reuse_entry() trips its
BUG_ON() when the padded name sizes differ, and otherwise the new value is
written into the neighbouring attribute's value slot while the attribute
being set is left untouched.  setxattr() reports success either way.

Remember the entry's hash before defragmenting and look the entry up
again afterwards, the way ocfs2_xattr_bucket_find() does.  An entry that
cannot be found again means the bucket no longer holds what the search
found, so fail with -EFSCORRUPTED rather than writing through the stale
pointer.

Link: https://lore.kernel.org/20261024151012.1059683-3-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket
+++ a/fs/ocfs2/xattr.c
@@ -6052,13 +6052,18 @@ static int ocfs2_xattr_set_entry_bucket(
 					struct ocfs2_xattr_search *xs,
 					struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret;
+	int ret, found = 0;
+	u16 xe_index;
+	u32 name_hash;
 	struct ocfs2_xa_loc loc;
 
 	trace_ocfs2_xattr_set_entry_bucket(xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
+	/* Defragmenting below may move this entry, so remember its hash. */
+	name_hash = loc.xl_entry ? le32_to_cpu(loc.xl_entry->xe_name_hash) : 0;
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
@@ -6077,6 +6082,29 @@ static int ocfs2_xattr_set_entry_bucket(
 		goto out;
 	}
 
+	/*
+	 * ocfs2_defrag_xattr_bucket() sorts the entries by name hash and
+	 * lib/sort.c is not stable, so entries sharing a hash may have traded
+	 * slots.  Look the entry up again before writing through it.
+	 */
+	if (loc.xl_entry) {
+		ret = ocfs2_find_xe_in_bucket(inode, xs->bucket,
+					      xi->xi_name_index, xi->xi_name,
+					      name_hash, &xe_index, &found);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		if (!found) {
+			mlog(ML_ERROR, "xattr entry not found in bucket %llu after defrag\n",
+			     (unsigned long long)bucket_blkno(xs->bucket));
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		loc.xl_entry = &bucket_xh(xs->bucket)->xh_entries[xe_index];
+		xs->here = loc.xl_entry;
+	}
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-read-the-xattr-entry-hash-before-defragmenting-the-bucket.patch
ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch
ocfs2-find-the-xattr-entry-again-after-converting-a-block-to-a-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-bucket.patch
ocfs2-do-not-index-before-the-entry-array-when-dividing-an-empty-bucket.patch
ocfs2-do-not-read-the-entry-array-of-an-empty-xattr-block.patch

