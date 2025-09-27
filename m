Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720F817B505
	for <mm-commits@vger.kernel.org>; Sat, 27 Sep 2025 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758935957; cv=none; b=nMOeuqvq7LG0rjCSs7RT7KVPY2CN0+UqR73QiRhGZe3i5TJITDLaBPwMEPGgEtDvhQyrpe2W0EIOxP0K0Sv/f0GEMhe3d2pDdiB2OvhHOpMvf6IjCgXTQ5/ROgQaus/3Pajn+ECCNKztVXTeOAey8hEQCOtIzE0knFZqkAQRN74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758935957; c=relaxed/simple;
	bh=5Fkj+eaTZTzklDaLzGFA/DMrdRAd9SlXMBPBSAmveL0=;
	h=Date:To:From:Subject:Message-Id; b=N//wbMElv2GjavTh+j7QSk/DUnu2UenBIvJzZnj/3lum7Y8KCucdsLC1/k8YfRDXQSvVmAy5RXwszlB2wQ4UgcdSgrhV/Cm1WhInQQhBlSzMC5jFQ3esAot67TEKLDQynB2ICecTLol3IpbLl2FFTHBRXBDTo/dFiqjE9vs8yeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dc561lzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dc561lzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6741C4CEF4;
	Sat, 27 Sep 2025 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758935956;
	bh=5Fkj+eaTZTzklDaLzGFA/DMrdRAd9SlXMBPBSAmveL0=;
	h=Date:To:From:Subject:From;
	b=Dc561lzKWzfvP/LSWh+Ycw0eYc/h/VedLEFQD+Ag1RD2cF2FKEaPWQ/aKdA9FWpax
	 JdUj+lbklfTF6LOtp0g8It1Sp/0sXEvmKLnRpdt6lEtYQ0EPIspBew1j1K8JX7ttXp
	 nogdwJCVArG3i3Ru0YYSjJda+ltVE89xzOzcD52I=
Date: Fri, 26 Sep 2025 18:19:16 -0700
To: mm-commits@vger.kernel.org,amir73il@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20250927011916.D6741C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
Date: Fri, 26 Sep 2025 23:23:05 +0100

only need to check 64 bit quantity

Link: https://lkml.kernel.org/r/20250926222305.110103-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/inode.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2
+++ a/fs/squashfs/inode.c
@@ -145,10 +145,6 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
 			/*
@@ -257,12 +253,8 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -285,13 +277,9 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
-		if (inode->i_size < 0) {
-			err = -EINVAL;
-			goto failed_read;
-		}
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -318,7 +306,7 @@ int squashfs_read_inode(struct inode *in
 			goto failed_read;
 
 		inode->i_size = le32_to_cpu(sqsh_ino->symlink_size);
-		if (inode->i_size < 0 || inode->i_size > PAGE_SIZE) {
+		if (inode->i_size > PAGE_SIZE) {
 			ERROR("Corrupted symlink\n");
 			return -EINVAL;
 		}
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-uninit-value-in-squashfs_get_parent.patch
squashfs-add-additional-inode-sanity-checking.patch
squashfs-add-seek_data-seek_hole-support.patch
squashfs-reject-negative-file-sizes-in-squashfs_read_inode.patch
squashfs-reject-negative-file-sizes-in-squashfs_read_inode-v2.patch

