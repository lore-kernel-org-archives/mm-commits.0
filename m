Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E10FC1F;
	Fri, 26 Jul 2024 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026299; cv=none; b=NFvKWLPwFJXKKdSONmXhQFxmXpTHdRBviQpgvm6FzEbVSFN5egGLiUFpa09o0pgGrrSlDGGbBWwjI5MSm3a1VNqV7vro3dnbkkziFoIagQIvD8lQJgtL22bK6EjGRM7raNJO1Tz+H9DUHT8z9DUr8s/OdBtlqsx0843nNEZWkoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026299; c=relaxed/simple;
	bh=erFWMLNHrLCAagBPeoRBSyKy6YQNhkKu95aTVyyJ7ns=;
	h=Date:To:From:Subject:Message-Id; b=pGOEtZyt/fH6FB6F6NT7Ws89b3a5C+XsObKBCgvUjpPleHD194N1GehZVcTVRBmFPzH5jI/SWjtRjQD/X2lCrInBDcFk4Fa91IEfkOv85EUi7HvM3uPNAWx+/Ulz8WFyvZV05M3wv4oYX668oYexxQbuJfNzqdp0VYk447K0cnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pv/PxPVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pv/PxPVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085ADC32782;
	Fri, 26 Jul 2024 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026299;
	bh=erFWMLNHrLCAagBPeoRBSyKy6YQNhkKu95aTVyyJ7ns=;
	h=Date:To:From:Subject:From;
	b=pv/PxPVT7nl0otM6DCkI93AglbvCNruo49lcRmHOC6SR2rlNbm4ZHvUXcPvy+MB31
	 0fW1ffiK2Ft4/Jb3HkkWVw9zQeY6m+FU4QH1HCFx7owaU6OTh6mXKSNRNfweurdIYN
	 j3YR04pMcGCFemzT1RZRdOVC1Iu3YdMzo4IDKetk=
Date: Fri, 26 Jul 2024 13:38:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch removed from -mm tree
Message-Id: <20240726203819.085ADC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: handle inconsistent state in nilfs_btnode_create_block()
has been removed from the -mm tree.  Its filename was
     nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: handle inconsistent state in nilfs_btnode_create_block()
Date: Thu, 25 Jul 2024 14:20:07 +0900

Syzbot reported that a buffer state inconsistency was detected in
nilfs_btnode_create_block(), triggering a kernel bug.

It is not appropriate to treat this inconsistency as a bug; it can occur
if the argument block address (the buffer index of the newly created
block) is a virtual block number and has been reallocated due to
corruption of the bitmap used to manage its allocation state.

So, modify nilfs_btnode_create_block() and its callers to treat it as a
possible filesystem error, rather than triggering a kernel bug.

Link: https://lkml.kernel.org/r/20240725052007.4562-1-konishi.ryusuke@gmail.com
Fixes: a60be987d45d ("nilfs2: B-tree node cache")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+89cc4f2324ed37988b60@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=89cc4f2324ed37988b60
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c |   25 ++++++++++++++++++++-----
 fs/nilfs2/btree.c  |    4 ++--
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block
+++ a/fs/nilfs2/btnode.c
@@ -51,12 +51,21 @@ nilfs_btnode_create_block(struct address
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
 	if (unlikely(!bh))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (unlikely(buffer_mapped(bh) || buffer_uptodate(bh) ||
 		     buffer_dirty(bh))) {
-		brelse(bh);
-		BUG();
+		/*
+		 * The block buffer at the specified new address was already
+		 * in use.  This can happen if it is a virtual block number
+		 * and has been reallocated due to corruption of the bitmap
+		 * used to manage its allocation state (if not, the buffer
+		 * clearing of an abandoned b-tree node is missing somewhere).
+		 */
+		nilfs_error(inode->i_sb,
+			    "state inconsistency probably due to duplicate use of b-tree node block address %llu (ino=%lu)",
+			    (unsigned long long)blocknr, inode->i_ino);
+		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
 	bh->b_bdev = inode->i_sb->s_bdev;
@@ -67,6 +76,12 @@ nilfs_btnode_create_block(struct address
 	folio_unlock(bh->b_folio);
 	folio_put(bh->b_folio);
 	return bh;
+
+failed:
+	folio_unlock(bh->b_folio);
+	folio_put(bh->b_folio);
+	brelse(bh);
+	return ERR_PTR(-EIO);
 }
 
 int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
@@ -217,8 +232,8 @@ retry:
 	}
 
 	nbh = nilfs_btnode_create_block(btnc, newkey);
-	if (!nbh)
-		return -ENOMEM;
+	if (IS_ERR(nbh))
+		return PTR_ERR(nbh);
 
 	BUG_ON(nbh == obh);
 	ctxt->newbh = nbh;
--- a/fs/nilfs2/btree.c~nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block
+++ a/fs/nilfs2/btree.c
@@ -63,8 +63,8 @@ static int nilfs_btree_get_new_block(con
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
-	if (!bh)
-		return -ENOMEM;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 
 	set_buffer_nilfs_volatile(bh);
 	*bhp = bh;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


