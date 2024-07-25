Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9771BC43;
	Thu, 25 Jul 2024 05:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721886626; cv=none; b=oJEWO7J3B/6mfI1LKG3nFNaBq7wSCa49L5hF+9dAPJTUBXztXMg9Pv7IKca1O9+tuMgkQhumCkn9N6XG0TGWlVE3zQIpjjR0E9ymo9Ed5veM6RcWRO5en61GfCjR7hvxjzDIV57yE/b5kLId6l5bL9QDCpKLr3L42OYXIH4ROsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721886626; c=relaxed/simple;
	bh=GenA40uiHEfDASyykxQOv84tC5ZU492Fawl2U80k6Zg=;
	h=Date:To:From:Subject:Message-Id; b=XWgnUbJjJytGSOPEK4AKkv+7GVZLW+nNG1VHebTYh3Yt7T14h2gTxQ0AsyY53fwevUz+dw64cj3OEdDHHj1NSLUseePn6YjFJVhhjpAJ/khavYX0eMsXkLbHo9gYbHyJ4SjKuInBP8oQ7lnv8rH+U4aSaxmHMFX/KeON0M6HLWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKLyxNlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKLyxNlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1759C116B1;
	Thu, 25 Jul 2024 05:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721886625;
	bh=GenA40uiHEfDASyykxQOv84tC5ZU492Fawl2U80k6Zg=;
	h=Date:To:From:Subject:From;
	b=YKLyxNlI6Dx6R3wdCK6tPG4CkKFrQngphGKKJ+z5YMuRsOK9ubqd6z21ub3Cw8vuH
	 4qvcSOW40aWoseDH+pY5vurduE6gG8xYIPJ0aS6q3IXwLFFqWz2KbrzXftyqGpvObK
	 6aI9DXZODO3jxMqIc9GV/6l6LalWlcfkPwulbTrU=
Date: Wed, 24 Jul 2024 22:50:25 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch added to mm-hotfixes-unstable branch
Message-Id: <20240725055025.C1759C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: handle inconsistent state in nilfs_btnode_create_block()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

nilfs2-handle-inconsistent-state-in-nilfs_btnode_create_block.patch

