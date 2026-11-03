Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675978;
	b=ry0vmmo59k0L2fAokJmlijEcvFq8DoSeY4cdJUfvppsjBtDUQfud52Xan3qF9PQ67Ee7
	 fp+QeetPgNGmf2mhuI+RaY3IMzTVdozk1XPtEXngRG3YzR0N8cf+HfO/4AB98gwAcNzDF
	 NUCVWen+GK7hCNbcGbH6rVWu7c5xtoPnbpEReaGcU+1j67FLwFfZWAxUDCiGGdPm9DGVD
	 RpWhnV7Mn8Zwpf2he6zbbt2FGlyaJvOuMph8N7hU734k85iWFAGjq4zdg5Cb5hdhYKq7X
	 IgWp5biOCH4sk5vokn92stnIT5TVehMmK2no8NRYBd+0KIz8UNfC5SHc9R/dHIJdOIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675978;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Zl7mPjyKiygkLm9oC+1s52Jh323SJeV2SygsrJmrEyI=;
	b=dohCt72mltiMdSbDQ4Ho2WWgzhwmNltVdh+AbXT0Ni4xb6bW8WLm9UeD9HIobCk9o2UW
	 PkisoTWQJP5h9sYwbQBiEEkHJqX+pbRZv0f1+x+OPX8IsWVd465MUog0Gn3ekpZGKQPTd
	 WxiM0kCVhC7SXH3Oc5OOIKSkS9v3Pp6BRN7wfZ+rXI2rQ/n8NC4CJ93+7KtjEI0ttwaPF
	 StdYJ0AtVBJrEZ+1P+GNXku/OWpWK5Eq9JwtwsHFB325WIVYbSKwOo55p/kJiLJRuavO1
	 GPnoxN5EfKBgRms3od2BI+c+7h7OSqtDAnYaESOra58CPVge0T0J0/iHHLm3B6f8h6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O7tmSVIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6752606A33C;
	Tue,  3 Nov 2026 03:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O7tmSVIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DC11F0093A;
	Tue,  3 Nov 2026 03:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675977;
	bh=Zl7mPjyKiygkLm9oC+1s52Jh323SJeV2SygsrJmrEyI=;
	h=Date:To:From:Subject;
	b=O7tmSVIAJR4gc8HIrA5EAAG11YTwOp0/fL5DdlkySux8LiQEW93xGPtfhWd9KA3/o
	 GAAK3XXV3DlwzG246WXQouuNp9o26Zdm7V/Jk0THvZ4g/3PAPsAg+9qFA5xSmkhU1R
	 +kS+ZaJVnjyoB8DvPdkWwhykqNu81Vg/yT71kvoU=
Date: Mon, 02 Nov 2026 19:19:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch removed from -mm tree
Message-Id: <20261103031937.35DC11F0093A@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: find the xattr entry again after defragmenting a bucket
has been removed from the -mm tree.  Its filename was
     ocfs2-find-the-xattr-entry-again-after-defragmenting-a-bucket.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


