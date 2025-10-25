Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CCC28C840
	for <mm-commits@vger.kernel.org>; Sat, 25 Oct 2025 23:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761436423; cv=none; b=k3hFa/tahH/yPSP5CHRnx1uvX0eBnozEm/tS+YyARONlynNAwSc1+hre2OLYamMF6hypEpptBM8GSzZwSgp0AHjs5B/q5cWP+y5LFTZBZRu9O4pV8Y+iSehT1dzbGJbrjZbDxfEKzQOrIZ5/rF6nXiQXhI8h7wvzNhoS++e/0lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761436423; c=relaxed/simple;
	bh=euvH3OsO+NW7smIZCwCaU2DlrfMNQ+B3Hmlxh7wwBwo=;
	h=Date:To:From:Subject:Message-Id; b=CMgqlhD8+90Sb6LsQYxsBtMPJiv4B3AmS7l8WBzB3qJHr0n677yhvc0/n0fYaQvrHFDDktO6MWglF5UX603Vpyrf1TKs/ZBf1BeFZ1we1wvnpL2zuEut8op82WSKQQ8DNrnoPfiqC4TuTI2zyhbm8yTAd6HaZDrmL4+Dvrrpfcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqVIjI5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqVIjI5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7A2C4CEF5;
	Sat, 25 Oct 2025 23:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761436423;
	bh=euvH3OsO+NW7smIZCwCaU2DlrfMNQ+B3Hmlxh7wwBwo=;
	h=Date:To:From:Subject:From;
	b=sqVIjI5I/w2P0d09Yc3NmIVgCZP7sS+Dm1vfpK3QjC+TyTVNHqvTIgRsqAhLo+XF0
	 WvWfjUZirzPnLk6EON3S4njzmPC4XRKVmvf6e0F6eNp4lDgs8UZ2Qz3ep4GJi8JcvY
	 ifdn7uODtK+wNdQVNLJLgbbqdW4GgPurF0mfy4J0=
Date: Sat, 25 Oct 2025 16:53:42 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch added to mm-nonmm-unstable branch
Message-Id: <20251025235343.1D7A2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use correct endian in ocfs2_dinode_has_extents
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: use correct endian in ocfs2_dinode_has_extents
Date: Sat, 25 Oct 2025 20:32:17 +0800

Fields in ocfs2_dinode is little endian, covert to host endian when
checking those contents.

Link: https://lkml.kernel.org/r/20251025123218.3997866-1-joseph.qi@linux.alibaba.com
Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents
+++ a/fs/ocfs2/inode.c
@@ -201,13 +201,15 @@ bail:
 static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 {
 	/* inodes flagged with other stuff in id2 */
-	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
-			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+	if (le32_to_cpu(di->i_flags) &
+	    (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL | OCFS2_CHAIN_FL |
+	     OCFS2_DEALLOC_FL))
 		return 0;
 	/* i_flags doesn't indicate when id2 is a fast symlink */
-	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) && le64_to_cpu(di->i_size) &&
+	    !le32_to_cpu(di->i_clusters))
 		return 0;
-	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
 		return 0;
 
 	return 1;
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch
ocfs2-convert-to-host-endian-in-ocfs2_validate_inode_block.patch

