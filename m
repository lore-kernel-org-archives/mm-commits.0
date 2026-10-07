Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10323356766
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338695; cv=none; b=Os12sLron6T41HNjL10RzreKhNhekd3Soy5T/CvKYP6jPtMbVOQuwPVfiEzwGsbZ3xU55xAaXZi6VYI5sMZkmHmMBHVFF0e54eyD09Q5u5zNymoz0ilO3XWmgbQtSJBBbbHBcm5qayrUuHkUs/eaNqpxQ68BVQgw2PAEaHwdX9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338695; c=relaxed/simple;
	bh=zHV7AKfqc7mms3C1TTUHKOyHPG4/p04jhIHmrx/MvrQ=;
	h=Date:To:From:Subject:Message-Id; b=RBgF4qe/SlOdafokiVaHO+c9uXg4ljoxZf7Ewl8fZLOO7TSPqQJWXLDnMleGwnRJRDD1TE45gjX3j3tKPK/2wfnVk4QAAoHURDiQMlfgotsyv6DyClJuhqNFHfOfLbKysZxGtzffkBc8d4rFKS7elp+mnxXhQoJs5r8mUUy022c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aGi78c7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aGi78c7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86E41F0089B;
	Wed,  7 Oct 2026 02:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338694;
	bh=w6URz+Sjgavnn0Q3tfX+4LNhJOED1dvFfyiKr0842wk=;
	h=Date:To:From:Subject;
	b=aGi78c7Jo9L9ggBWZxbvIabemmFI9lBF6p8p+2jOkefH52u+yMireiIluQEHMHdyN
	 gss9u0azoraUsXREQBEr0q6znn/AJCDFw/jbbA0+1B03Voje+G43YBqAKaVWVmQTBr
	 omCZQlY8NNv3UXZjKIejaRJ1YrLuPR74inO1Xtck=
Date: Tue, 06 Oct 2026 19:04:53 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch removed from -mm tree
Message-Id: <20261007020453.D86E41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
Date: Sat, 5 Sep 2026 22:21:44 +0800

ocfs2_validate_dx_leaf() checks the checksum, the signature and the entry
list counts, but it never checks dl_blkno or dl_fs_generation.  The inode,
extent block, xattr block, refcount block and dir index root validators
all check the on-disk block number against bh->b_blocknr and the
generation against the superblock, and both dir index leaf fields are
documented as "Must match super block".

Without the checks, a stale dir index leaf block left on the device from a
previously formatted filesystem at the same physical block number can pass
validation as long as its signature, entry counts and checksum match.  Its
index entries would then be used in the new filesystem context.

Both fields are written unconditionally when a leaf block is formatted in
ocfs2_dx_dir_format_cluster(), from the live superblock generation and the
real block number, so a correctly formatted filesystem cannot trip the new
checks.  The leaf block number read back here comes from on-disk dir index
root extent records.

Reject dir index leaf blocks whose dl_blkno or dl_fs_generation does not
match, like the dir index root validator does.

Link: https://lore.kernel.org/20260905142144.2869105-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
---

 fs/ocfs2/dir.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ocfs2/dir.c~ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks
+++ a/fs/ocfs2/dir.c
@@ -733,6 +733,18 @@ static int ocfs2_validate_dx_leaf(struct
 		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
 				   7, dx_leaf->dl_signature);
 
+	if (le64_to_cpu(dx_leaf->dl_blkno) != bh->b_blocknr)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_blkno of %llu\n",
+				   (unsigned long long)bh->b_blocknr,
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno));
+
+	if (le32_to_cpu(dx_leaf->dl_fs_generation) != OCFS2_SB(sb)->fs_generation)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_fs_generation of #%u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le32_to_cpu(dx_leaf->dl_fs_generation));
+
 	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
 	    ocfs2_dx_entries_per_leaf(sb))
 		return ocfs2_error(sb,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

