Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA938F949;
	Mon, 18 May 2026 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140469; cv=none; b=KnA/gPf5ND1b1j6wqRMO1VVadEONQmDspk3CDKLXahrLPzRTR7E7JzIDP1n+l5JtV19irzaT+KLOWdlZHzAOKUsECqTbYlqyVYcR250VAmWJHh6fRimZF27TTTLxDR9W2bIkB4ULG87fbMRd2bjLWFGtMOl7hSDkuiLGViCjnJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140469; c=relaxed/simple;
	bh=aHVm7Hj0OODiSxgMPoeKSYLH9hJzR5gTzwSTa4kw0nU=;
	h=Date:To:From:Subject:Message-Id; b=FrxPb02p9upb1KxVb0B0vpVsTZsoQs9SRuVgTe3uQrNaBUoGGrtG7pY6JuyU3BMAvXPNt+I9aQFSzBpW/dQVKCBqu9OmffRPDxAtpeKei4thJxAUJ4i+UqKzZXDWSVa0yW21ccHzZ9uM2oE9H74iT1hDmZfiu3ggHmHo1VIe3EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FjVyqEvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FjVyqEvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0084C2BCB7;
	Mon, 18 May 2026 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779140468;
	bh=aHVm7Hj0OODiSxgMPoeKSYLH9hJzR5gTzwSTa4kw0nU=;
	h=Date:To:From:Subject:From;
	b=FjVyqEvW24EhkuB7iBoiGRdjmznO+q6l4zQRUjR5Nsdm8NypttauOeFbvV1a5TbXG
	 ePgxBV02yRYU8tj2VRhgjNmO95dV22qyPUKyIErvulcjM0WlhgGeIuZH0aZfIgTbz7
	 RkCcX0xgDUFy+iOX3uB6ZEVqfNWZ+AHBMJ2Ja7NE=
Date: Mon, 18 May 2026 14:41:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters.patch added to mm-nonmm-unstable branch
Message-Id: <20260518214108.D0084C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject regular files with non-zero i_size and zero i_clusters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters.patch

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
From: Michael Bommarito <michael.bommarito@gmail.com>
Subject: ocfs2: reject regular files with non-zero i_size and zero i_clusters
Date: Sun, 17 May 2026 07:10:14 -0400

On a volume mounted WITHOUT OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a regular
file with non-zero i_size, zero i_clusters, and no OCFS2_INLINE_DATA_FL
flag is structurally malformed: the extent map declares no allocated
clusters yet the size header claims the file has content. 
ocfs2_populate_inode() copies i_size into the in-core inode and dispatches
to ocfs2_aops; subsequent reads or truncates then operate on an
inconsistent extent state.

This is the shape an attacker who keeps the rest of the extent list intact
(to satisfy the inline-data, refcount, chain-list, and per-field
validators already in this function) would produce when forging only the
inode header to publish a synthetic file size on a victim node.  It is
also the shape on-disk corruption of the i_clusters field produces. 
Reject early in the validator.

The check is restricted to non-sparse volumes (ocfs2_sparse_alloc()
returns false).  On non-sparse mounts the allocator path always grows
clusters before i_size: ocfs2_extend_file() takes the !sparse branch into
ocfs2_extend_no_holes(), which calls ocfs2_extend_allocation() to journal
new clusters first, and only then ocfs2_simple_size_update() journals the
larger i_size.  The truncate path likewise lowers i_size in
ocfs2_orphan_for_truncate() and then frees clusters in
ocfs2_commit_truncate(), which uses ocfs2_clusters_for_bytes(new_i_size)
as its new_highest_cpos: when new_i_size > 0 the floor is at least one
cluster, so the on-disk dinode never legitimately exposes a non-inline
regular file with i_size > 0 and i_clusters == 0 on a non-sparse volume.

On sparse-alloc volumes the same shape is legitimate: an
ocfs2_extend_file() call goes through ocfs2_zero_extend() +
ocfs2_simple_size_update(), which grows i_size on its own without changing
i_clusters; a freshly truncate -s 1M of a sparse regular file is therefore
on-disk (i_size = 1048576, i_clusters = 0).  The check therefore opts out
via ocfs2_sparse_alloc(OCFS2_SB(sb)).

System inodes (OCFS2_SYSTEM_FL) carry their own size and cluster
invariants validated by the allocator, journal, quota, and truncate-log
subsystems; skip them here.  The inline-data fast path is filtered
separately by its own dedicated branch below: its well-formed case is
exactly i_clusters == 0 with i_size <= id_count.  Symlinks legitimately
keep i_clusters == 0 with non-zero i_size (fast symlinks), so this check
is restricted to S_IFREG.

Link: https://lore.kernel.org/20260517111015.3187935-4-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters
+++ a/fs/ocfs2/inode.c
@@ -1571,6 +1571,47 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * On a non-sparse volume, a regular file with non-zero i_size
+	 * and zero i_clusters that is not marked as inline data is
+	 * structurally malformed: the extent map declares no allocated
+	 * clusters yet the size header claims the file has content.
+	 * ocfs2_populate_inode() would still publish i_size to VFS and
+	 * leave the extent state inconsistent for any later read or
+	 * truncate.  This is the shape an attacker who keeps the rest
+	 * of the extent list intact (to satisfy the inline-data,
+	 * refcount, chain-list, and per-field validators above) would
+	 * produce when forging only the inode header to publish a
+	 * synthetic file size on a victim node.  It is also the shape
+	 * on-disk corruption of the i_clusters field produces.
+	 *
+	 * The check opts out on sparse-alloc volumes, where the
+	 * extend path (ocfs2_extend_file -> ocfs2_zero_extend ->
+	 * ocfs2_simple_size_update) legitimately grows i_size without
+	 * allocating clusters.  On non-sparse volumes the equivalent
+	 * path (ocfs2_extend_no_holes) journals clusters first and
+	 * i_size second, and truncate-down floors i_clusters at
+	 * ocfs2_clusters_for_bytes(new_i_size) which is >= 1 whenever
+	 * new_i_size > 0, so the rejected shape never appears on disk.
+	 *
+	 * Skip system inodes (OCFS2_SYSTEM_FL) and the inline-data
+	 * fast path (handled below).  Symlinks legitimately keep
+	 * i_clusters == 0 with non-zero i_size (fast symlinks), so
+	 * restrict to S_IFREG.
+	 */
+	if (!ocfs2_sparse_alloc(OCFS2_SB(sb)) &&
+	    S_ISREG(le16_to_cpu(di->i_mode)) &&
+	    !(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL) &&
+	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) &&
+	    le64_to_cpu(di->i_size) != 0 &&
+	    le32_to_cpu(di->i_clusters) == 0) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+				 (unsigned long long)bh->b_blocknr,
+				 (unsigned long long)le64_to_cpu(di->i_size));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
_

Patches currently in -mm which might be from michael.bommarito@gmail.com are

ocfs2-reject-dinodes-with-non-canonical-i_mode-type-or-stray-bits.patch
ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch
ocfs2-reject-regular-files-with-non-zero-i_size-and-zero-i_clusters.patch

