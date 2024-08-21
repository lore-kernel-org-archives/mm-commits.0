Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EECE13B297
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275440; cv=none; b=O75Kr5E8rJ+oUyP6VWdKp9QqB6LeUf2/d9Bz+We3+0oY1piU0gEjAkjOcCQnmz4NMS1AXVUiJpavB4mtHBqtb1OMB5JhjTXngbM3Ke8xYkSCuREKXNe0FFR+I+2ZRGjqVbIdyzbNVw4sRfjgjZqNR6jTZHLMk6R4tmXl+aa4tT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275440; c=relaxed/simple;
	bh=Y+UgsxwPOeB71mPsLjwLlkD1/DluflcAGdQA1F3pxG4=;
	h=Date:To:From:Subject:Message-Id; b=st5BL6svIYxfiwCtVJsILnKMU0wL3x6WakA6yTXKKsRI3P8/I0M5uWGIkFWAfPfQLCftL8TyLfsu6bEWENaMm9np2z0Il4FoboJQnrA9YE/nAYKiHQ54p/sW9rJpB4nfqE9qx12I09Oe4vDunW8VBavkbquJ9VygxLvSPZQhApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/fPhzQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/fPhzQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE0AC4AF11;
	Wed, 21 Aug 2024 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275440;
	bh=Y+UgsxwPOeB71mPsLjwLlkD1/DluflcAGdQA1F3pxG4=;
	h=Date:To:From:Subject:From;
	b=j/fPhzQnpIHO6/7caghlO/TDHX+LfLAUELMkJ130/qPehepz75Ghxj9gc6ogqoZlA
	 H2xZ6ZKXT9qEnJKPF5nafWKcctUKyQHqTvI6B1rJwwpHH6t/B2gpXIyJ9lPxAoEumn
	 wAW3O6Nyfcho+RdlSvFi/apiWEfBUtP9SBqi1cY4=
Date: Wed, 21 Aug 2024 14:23:59 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch added to mm-nonmm-unstable branch
Message-Id: <20240821212400.0BE0AC4AF11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: treat missing cpfile header block as metadata corruption
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: treat missing cpfile header block as metadata corruption
Date: Thu, 22 Aug 2024 00:46:24 +0900

The cpfile, a metadata file that holds metadata for checkpoint management,
also has statistical information in its first block, and if reading this
block fails, it receives the internal code -ENOENT and returns that code
to the callers.

As with sufile, to prevent this -ENOENT from being propagated to system
calls, return -EIO instead when reading the header block fails.

Link: https://lkml.kernel.org/r/20240821154627.11848-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/cpfile.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/cpfile.c~nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption
+++ a/fs/nilfs2/cpfile.c
@@ -125,10 +125,17 @@ static void nilfs_cpfile_block_init(stru
 	}
 }
 
-static inline int nilfs_cpfile_get_header_block(struct inode *cpfile,
-						struct buffer_head **bhp)
+static int nilfs_cpfile_get_header_block(struct inode *cpfile,
+					 struct buffer_head **bhp)
 {
-	return nilfs_mdt_get_block(cpfile, 0, 0, NULL, bhp);
+	int err = nilfs_mdt_get_block(cpfile, 0, 0, NULL, bhp);
+
+	if (unlikely(err == -ENOENT)) {
+		nilfs_error(cpfile->i_sb,
+			    "missing header block in checkpoint metadata");
+		err = -EIO;
+	}
+	return err;
 }
 
 static inline int nilfs_cpfile_get_checkpoint_block(struct inode *cpfile,
@@ -283,14 +290,9 @@ int nilfs_cpfile_create_checkpoint(struc
 
 	down_write(&NILFS_MDT(cpfile)->mi_sem);
 	ret = nilfs_cpfile_get_header_block(cpfile, &header_bh);
-	if (unlikely(ret < 0)) {
-		if (ret == -ENOENT) {
-			nilfs_error(cpfile->i_sb,
-				    "checkpoint creation failed due to metadata corruption.");
-			ret = -EIO;
-		}
+	if (unlikely(ret < 0))
 		goto out_sem;
-	}
+
 	ret = nilfs_cpfile_get_checkpoint_block(cpfile, cno, 1, &cp_bh);
 	if (unlikely(ret < 0))
 		goto out_header;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch

