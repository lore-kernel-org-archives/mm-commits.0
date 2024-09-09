Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903E718DF76
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925697; cv=none; b=Ro0x1rcU6fFuSdl484kYJMBoCRZVjLgs2Gn+MegIGwb2zMBTv+y75kwCIlotcXEp0yzz95q45v0tiz0cZ23ZUdnwsCFcHdRLw9RMEKDFKj+zIvYuikjKeYivKfGUm2hd3LFblQqYbKEKPKct0opYZbnJeQtj+7iXxuZULyWgtAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925697; c=relaxed/simple;
	bh=7khiFBkoGyJdNrZ5sQhOvXZjnqQprEIkqwvMgqSnO2U=;
	h=Date:To:From:Subject:Message-Id; b=lZ8RylFeKzz6yUdcMgTlo3Gf1hScWgK5CJIpw1RIb5LDEF0y1ZGNZOiNPl5yUe6dQ6dbyT3xbNmD5OPOXSU/75gT7kUvnBLLxsZQFZbl3406lHSVWxPzWwk61HlJRp0sYC1TBVHom8sn/biL1euMaJZX3Syk+bWrBWTUbfa+0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ueCiRm7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ueCiRm7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A548C4CEC5;
	Mon,  9 Sep 2024 23:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925697;
	bh=7khiFBkoGyJdNrZ5sQhOvXZjnqQprEIkqwvMgqSnO2U=;
	h=Date:To:From:Subject:From;
	b=ueCiRm7a29TGwEiidNJW8P7jcsOdzcuccg0Zpa6nALCZPLIitdnC648v7SqAvy14h
	 uCL5Mn+OJVFC7LzPDjvYb3vNG8BLUzAuLw8vnZphspO5vcLEa6pS5CQgvMX5xpeKxH
	 Xv0bMriSg75r/zfVNlb8IA9VzAeew/w3TFlh+c9k=
Date: Mon, 09 Sep 2024 16:48:16 -0700
To: mm-commits@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-determine-empty-node-blocks-as-corrupted.patch removed from -mm tree
Message-Id: <20240909234817.0A548C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: determine empty node blocks as corrupted
has been removed from the -mm tree.  Its filename was
     nilfs2-determine-empty-node-blocks-as-corrupted.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: determine empty node blocks as corrupted
Date: Wed, 4 Sep 2024 17:13:08 +0900

Due to the nature of b-trees, nilfs2 itself and admin tools such as
mkfs.nilfs2 will never create an intermediate b-tree node block with 0
child nodes, nor will they delete (key, pointer)-entries that would result
in such a state.  However, it is possible that a b-tree node block is
corrupted on the backing device and is read with 0 child nodes.

Because operation is not guaranteed if the number of child nodes is 0 for
intermediate node blocks other than the root node, modify
nilfs_btree_node_broken(), which performs sanity checks when reading a
b-tree node block, so that such cases will be judged as metadata
corruption.

Link: https://lkml.kernel.org/r/20240904081401.16682-3-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-determine-empty-node-blocks-as-corrupted
+++ a/fs/nilfs2/btree.c
@@ -350,7 +350,7 @@ static int nilfs_btree_node_broken(const
 	if (unlikely(level < NILFS_BTREE_LEVEL_NODE_MIN ||
 		     level >= NILFS_BTREE_LEVEL_MAX ||
 		     (flags & NILFS_BTREE_NODE_ROOT) ||
-		     nchildren < 0 ||
+		     nchildren <= 0 ||
 		     nchildren > NILFS_BTREE_NODE_NCHILDREN_MAX(size))) {
 		nilfs_crit(inode->i_sb,
 			   "bad btree node (ino=%lu, blocknr=%llu): level = %d, flags = 0x%x, nchildren = %d",
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


