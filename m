Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A0D2045AD
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908603; cv=none; b=mGSIt/UxJf04EqCh915gt7kRDqmpemyrCbnHJZC95O7o86ytrvWUGUta+1b1dbPGr/eA07DXSyo+3LEqy3gUaU+jfr3OWvb7tVDiBV4RgPg2oc+WuPUM5AqSUy2gzQr8/E5dk325825lc++Nv5dxcJNbqImiasubpUMHHJLqTpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908603; c=relaxed/simple;
	bh=2OrBxRHn0V0SCDx9e8gBzsF76EcM/n0cP1tE93eqFaU=;
	h=Date:To:From:Subject:Message-Id; b=SZdRATxMpY6dWeRg6a2NhdBO5c8TykBRUd4VrhGFaw4NWhadHAszMZOTv1yn866VQTMCupHEsWoHlhna2ZCTnEQcUcVJI/tMK7oBcodxg2za4rExIMtxPSQIQr5Oc3I52WdUohiEK0ZaRv9HHHpBbyP1Cvbkp76K665+ay98ibE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eUerwqi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eUerwqi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B3C116D0;
	Wed, 12 Nov 2025 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908603;
	bh=2OrBxRHn0V0SCDx9e8gBzsF76EcM/n0cP1tE93eqFaU=;
	h=Date:To:From:Subject:From;
	b=eUerwqi39R2pGSDinheOS76wjQt5YhWpfThonVcSmsb9uXy7rzpS09LQDyr8+5bIn
	 Fr/l3VCyt8qrC934v4UQWGtx90IXzX3+0dEQ5pl8TfRev/RPHXYAc2/SjgjLz0lxQi
	 2z0AoeVsmI3Y1yzq5OqzjIjJvlu3Cy81p8JNaWHI=
Date: Tue, 11 Nov 2025 16:50:02 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch removed from -mm tree
Message-Id: <20251112005003.480B3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use correct endian in ocfs2_dinode_has_extents
has been removed from the -mm tree.  Its filename was
     ocfs2-use-correct-endian-in-ocfs2_dinode_has_extents.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: use correct endian in ocfs2_dinode_has_extents
Date: Sat, 25 Oct 2025 20:32:17 +0800

Fields in ocfs2_dinode is little endian, covert to host endian when
checking those contents.

Link: https://lkml.kernel.org/r/20251025123218.3997866-1-joseph.qi@linux.alibaba.com
Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
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


