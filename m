Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CCC14F10F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248837; cv=none; b=dHxSB/I+VZA6kVy5D8W4AnFtG3+xsiRE5XyJ+D9xk/9EuH18xwjyHOQIJZWGlgJGHM7hE0ybewjyvFex7D14VzraNyemGz2ly45hvj9r5T0kGQgciN/5GqDHL2E7k9C490PQySUEyo1p17qt5HJbCo6jgmwd+5Jow6A+T4STUvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248837; c=relaxed/simple;
	bh=7P8tKHCivTEtDnsN/IwS2499tDLprkL81i7WJPANnOM=;
	h=Date:To:From:Subject:Message-Id; b=I6sBG8JzfNqf/Ue/SpdghRzHpUEW+FYBvtknt0ff27MiVxKjSZQ+VgMsid+yja8VVrbO3UxHBpARWfZAkkl2a4zlwafICBV8CmMDmTP0XJCqQLcjy3Nao52hrVojyKeXFUOppAYN1omdy3+p6BfnAOvk5E7/TUiip30/blkWhUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WMOrfDGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WMOrfDGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F857C4CEC2;
	Mon,  2 Sep 2024 03:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248837;
	bh=7P8tKHCivTEtDnsN/IwS2499tDLprkL81i7WJPANnOM=;
	h=Date:To:From:Subject:From;
	b=WMOrfDGyNBspSY0cNQjGxmHPGX4i64fXwysE3iux3/saoSvmhY9Yiy2UW6T1AeB2L
	 f5B8izemjcEOPu49x1F1MLpJCvqkJIdpPNMPK/wHVuGRJN+QdWDrnFOVcgJt6PXW0a
	 AzqgOd8PpY8tbxhUin1a3QQfdaKspHh4UnrY4wZk=
Date: Sun, 01 Sep 2024 20:47:16 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch removed from -mm tree
Message-Id: <20240902034717.4F857C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: treat missing cpfile header block as metadata corruption
has been removed from the -mm tree.  Its filename was
     nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


