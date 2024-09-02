Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD037149C50
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248855; cv=none; b=BnBBxSKxs2nxa383Dim9tnCg6ioZy/Lb6prJb5QkAEuh5fm0v9VlmXAuE7n2bg16Yal1EI59+uWeyFYuUe+t/bz7S/nPki8dp0XIcW4vTqaGoeVflUxxB09IhitQywXfHzmOmqvI1DR/MpfObXTogKCggDRjk5aYq88/aoxQyhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248855; c=relaxed/simple;
	bh=qk2p83Q174vq4Z2F7WqF98hAmVz6/tYRxpKk3EfoTpU=;
	h=Date:To:From:Subject:Message-Id; b=Fd0VJI6I5kAkPErzEaKAqut/pZVGJC1RvGcSjWt4fX+vIEY6QMhbbdLP11oY2xIxjezZLfPNP0qfJfKLTFH3duBgGPtO1JcOpurnSRD2m19UVXJ45I2Hiz350w47Tey4g9jQYo8bqcQap7jvqiamuLK7AeEM35ZZmS2JD9n9wZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A/NMH0kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A/NMH0kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44B8C4CEC2;
	Mon,  2 Sep 2024 03:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248855;
	bh=qk2p83Q174vq4Z2F7WqF98hAmVz6/tYRxpKk3EfoTpU=;
	h=Date:To:From:Subject:From;
	b=A/NMH0kfKOONuq9ShTCBmgI4v5qQab/JJCKPM2df/rxv9LUaezbpNLVRZEk8eaLAX
	 EORhT9tpvMb7ajFM3o9BBR5/0rmq3dSfYu22ue4fo0wwan52wjkfPSv3gcizAsGtBO
	 VS/XEKXDoe9f/tqie5a1rBX/ZFCWBxfmQrusDQ30=
Date: Sun, 01 Sep 2024 20:47:35 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch removed from -mm tree
Message-Id: <20240902034735.A44B8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
Date: Tue, 27 Aug 2024 02:41:13 +0900

After commit 93aef9eda1ce ("nilfs2: fix incorrect inode allocation from
reserved inodes") is applied, the inode number returned by
nilfs_ifile_create_inode() is guaranteed to always be greater than or
equal to NILFS_USER_INO, so if the inode number is a reserved inode number
(less than NILFS_USER_INO), the code to repair the bitmap immediately
following it is no longer executed.  So, delete it.

Link: https://lkml.kernel.org/r/20240826174116.5008-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode
+++ a/fs/nilfs2/inode.c
@@ -345,19 +345,6 @@ struct inode *nilfs_new_inode(struct ino
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
-
-	if (unlikely(ino < NILFS_USER_INO)) {
-		nilfs_warn(sb,
-			   "inode bitmap is inconsistent for reserved inodes");
-		do {
-			brelse(bh);
-			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
-			if (unlikely(err))
-				goto failed_ifile_create_inode;
-		} while (ino < NILFS_USER_INO);
-
-		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
-	}
 	ii->i_bh = bh;
 
 	atomic64_inc(&root->inodes_count);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


