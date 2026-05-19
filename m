Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4283EA953;
	Tue, 19 May 2026 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779212718; cv=none; b=n/RfMki3rOrJdDPdRk+bJLMpvECG2/flywrGl4V6XFNOTws4BrZiNXDw5Vg1aXqTluO6Sf/H5ss8NJsqO0tFHGL22R9DK8r/QKgfmfNxjkYpnWyaebqebvvBHjBnCvVGwjQhY1e27g39f93wdNRdYBKxeptmQ/zJPjlT8ZWNVO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779212718; c=relaxed/simple;
	bh=Akh3Zfn8+lYDQjfzNyhBVf7AJoRyxFn7W6oAfZBtfUc=;
	h=Date:To:From:Subject:Message-Id; b=Ew0jMIk5pW1lcFlYBlknFFE7dgh6tgfhTSnH40o/ViSj7Pc4l9q/SHKFNMcKIt0MPQMQjqZ7Vv5njbiv/vXhgbn397xAtn/fJiwJH4itDEukGLjX4CQLco4tfY0+LETx79i3y1YJnHodMqfHHyNuF2cVKQvsygrGe/iUQWDwKFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cu+FmfFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cu+FmfFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F154C2BCB3;
	Tue, 19 May 2026 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779212718;
	bh=Akh3Zfn8+lYDQjfzNyhBVf7AJoRyxFn7W6oAfZBtfUc=;
	h=Date:To:From:Subject:From;
	b=cu+FmfFPUSoyusL1MLssSX541tq3FfxOG86zjP06Fb6TmmI+7vwM6WdNtw+c2sxd8
	 E2xZ5WO3ogQ7SETM9CNDCftpQVH3CqRWHd9COrKlEDQlx8y+TwkovOLPOzhBjpEy2M
	 jdORehbz9R2654i1ZVv2bKHgFWBX71SrlqDb5tB8=
Date: Tue, 19 May 2026 10:45:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch added to mm-nonmm-unstable branch
Message-Id: <20260519174518.3F154C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject non-inline dinodes with i_size and zero i_clusters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch

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
Subject: ocfs2: reject non-inline dinodes with i_size and zero i_clusters
Date: Tue, 19 May 2026 07:04:04 -0400

On a volume mounted without OCFS2_FEATURE_INCOMPAT_SPARSE_ALLOC, a
non-inline regular file with non-zero i_size and zero i_clusters is
structurally malformed: the extent map declares no allocated clusters yet
the size header claims content exists.  Keep rejecting that shape, but
express it through a shared predicate so the same invariant is available
to normal inode reads and online filecheck.

The same zero-cluster shape is also malformed for non-inline directories. 
ocfs2 directory growth allocates backing storage before advancing i_size,
and ocfs2_dir_foreach_blk_el() later walks until ctx->pos reaches
i_size_read(inode).  A forged directory dinode with a huge i_size and no
clusters would repeatedly fail on holes while advancing through the
claimed size.

Sparse regular files remain exempt: on sparse-alloc volumes, truncate can
legitimately grow i_size without allocating clusters.  System inodes and
inline-data dinodes also retain their separate storage rules.

Mirror the check in ocfs2_filecheck_validate_inode_block() as well. 
filecheck reports through its own error namespace, so malformed
size/cluster state is logged as a filecheck invalid-inode result rather
than via ocfs2_error(), but it must not proceed into
ocfs2_populate_inode().

Link: https://lore.kernel.org/20260519110404.1803902-4-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
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

 fs/ocfs2/inode.c |   60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters
+++ a/fs/ocfs2/inode.c
@@ -82,6 +82,24 @@ static bool ocfs2_dinode_has_unexpected_
 	return !S_ISCHR(mode) && !S_ISBLK(mode) && di->id1.dev1.i_rdev != 0;
 }
 
+static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	umode_t mode = le16_to_cpu(di->i_mode);
+
+	if (le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)
+		return false;
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
+		return false;
+	if (!le64_to_cpu(di->i_size) || le32_to_cpu(di->i_clusters))
+		return false;
+
+	if (S_ISDIR(mode))
+		return true;
+
+	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1563,6 +1581,33 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * Non-inline directories must not have i_size without allocated
+	 * clusters: directory growth adds storage before advancing i_size,
+	 * and readdir walks i_size block-by-block.  A forged directory
+	 * with zero clusters and a huge i_size would repeatedly fault on
+	 * holes while advancing through the claimed size.
+	 *
+	 * Non-inline regular files have the same invariant on non-sparse
+	 * volumes.  Sparse regular files are different: truncate can
+	 * legitimately grow i_size without allocating clusters, so keep
+	 * the sparse-alloc carveout for S_IFREG only.  System inodes and
+	 * inline-data dinodes have their own storage rules.
+	 */
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)le64_to_cpu(di->i_size));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1712,6 +1757,21 @@ static int ocfs2_filecheck_validate_inod
 		     le16_to_cpu(di->i_mode),
 		     (unsigned long long)le64_to_cpu(di->id1.dev1.i_rdev));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_size_without_clusters(sb, di)) {
+		if (S_ISDIR(le16_to_cpu(di->i_mode)))
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: directory i_size %llu with i_clusters 0 and no inline-data flag\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		else
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: regular file i_size %llu with i_clusters 0 and no inline-data flag on non-sparse volume\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
_

Patches currently in -mm which might be from michael.bommarito@gmail.com are

ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch
ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch
ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch

