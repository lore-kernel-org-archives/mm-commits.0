Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4177713BAD8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645194; cv=none; b=iD1Evaem98er+VZz3n70Iqep9o7MQyJRoG39eA4Cs5wIqodKMdMQqCdD8dYa2CkVVFm64W3y4Ql+BLL0gvakZrgZirsrHqEGlaPMIblGhHt5U97x2vu6+AzVMcyiwIeHB1I5azielVPoxtW46hENP+z/ZjewZeef08uYBj7mWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645194; c=relaxed/simple;
	bh=A2hOwzsDMZK2etAABjdNQFg74Lh+DM2p6n7G4l8JnxI=;
	h=Date:To:From:Subject:Message-Id; b=ongIwN0gsx2QtcQtf9/zCsc5d6CFJ03pW3NK1SAXeNDIQtu51sdsmpaWeWkrPmbE/dp8E7CVODoYwuMbYv/CmS+oxXye1gTUUnh0hOrdv/ejr9usAUMJTdX+K/CzGzubDS42AreHT9XKSVkKti/KdUnwzr5AH7nYgbry8VgxSpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y62LZdKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y62LZdKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BDFC43394;
	Thu, 22 Feb 2024 23:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645194;
	bh=A2hOwzsDMZK2etAABjdNQFg74Lh+DM2p6n7G4l8JnxI=;
	h=Date:To:From:Subject:From;
	b=Y62LZdKm1aGo5N7CMYkpCaPlas9LNuVXAs5cG9Ra34KppZNFW+78vNpu/fBG5O/LY
	 4dsk+aoRrPw0Vwgo83hevWCa6881grYVJFGt4YmE01C5GXYIGLjYHSIEPYtJAcz7Y2
	 brnPvQxyvXZfeTVUgDLMhcekgBt06sTQ4UPjqsZs=
Date: Thu, 22 Feb 2024 15:39:53 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch removed from -mm tree
Message-Id: <20240222233954.14BDFC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not acquire rwsem in nilfs_bmap_write()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not acquire rwsem in nilfs_bmap_write()
Date: Mon, 22 Jan 2024 23:01:56 +0900

It is now clear that nilfs_bmap_write() is only used to finalize logs
written to disk.  Concurrent bmap modification operations are not
performed on bmaps in this context.  Additionally, this function does not
modify data used in read-only operations such as bmap lookups.

Therefore, there is no need to acquire bmap->b_sem in nilfs_bmap_write(),
so delete it.

Link: https://lkml.kernel.org/r/20240122140202.6950-10-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write
+++ a/fs/nilfs2/bmap.c
@@ -548,13 +548,10 @@ int nilfs_bmap_read(struct nilfs_bmap *b
  */
 void nilfs_bmap_write(struct nilfs_bmap *bmap, struct nilfs_inode *raw_inode)
 {
-	down_write(&bmap->b_sem);
 	memcpy(raw_inode->i_bmap, bmap->b_u.u_data,
 	       NILFS_INODE_BMAP_SIZE * sizeof(__le64));
 	if (bmap->b_inode->i_ino == NILFS_DAT_INO)
 		bmap->b_last_allocated_ptr = NILFS_BMAP_NEW_PTR_INIT;
-
-	up_write(&bmap->b_sem);
 }
 
 void nilfs_bmap_init_gc(struct nilfs_bmap *bmap)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


