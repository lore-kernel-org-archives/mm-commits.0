Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAB01E5018
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477307; cv=none; b=ucJ2Wg74nehL9Sa+Z3owYavVru4VXBVWA7kFphMkYiAQmb5klYz4JIXQnBKrsn9OK9JB0y0qN8I6Z2YSFZGiAEeWmi5uC8/qJSFABhFxdpyMe858CmZSSzcNxR2QXoDL5eR8qENvQSHPuIvY55UKsC+KUUPYUPl7Pe2be/p42hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477307; c=relaxed/simple;
	bh=3higvrydggSFD/UHsUsobD8BKw0ORL7wQjnd0Pegwzo=;
	h=Date:To:From:Subject:Message-Id; b=iHYQk+VTjaHj1sLUphrKqfsUoWBKNJVW9+Mwj2y8RxLeanNY6mMeSSgYqlSvhq2gwC5QsXL1mWw1KLwbJFTK2xhgNTBCrXIN7HVCdfBxSjPHoGzXLzq396BlkNY/vLM0bg068Aj/kAkVqGcdyX48XmbW7SxZcxUE2SvtG+jmPig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=06kYjv4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="06kYjv4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AAFC4CEC6;
	Wed,  4 Sep 2024 19:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725477306;
	bh=3higvrydggSFD/UHsUsobD8BKw0ORL7wQjnd0Pegwzo=;
	h=Date:To:From:Subject:From;
	b=06kYjv4At5jdoBcFFdQIdKK9COgsGYnzSgJgNG+p0V9AATukCGDehopiOaOaUip4h
	 Dc/wLRW5RWPhgq+b2mHy50JYoEk8Y5WIUYZnu3pl6kSxM9h2LhseZ5lrEBQXo/mm9p
	 OqA0Ic3tJdEt+ffcdULxpTJzridj1dCSUjFgmEMY=
Date: Wed, 04 Sep 2024 12:15:06 -0700
To: mm-commits@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch added to mm-nonmm-unstable branch
Message-Id: <20240904191506.B7AAFC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential oob read in nilfs_btree_check_delete()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

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
Subject: nilfs2: fix potential oob read in nilfs_btree_check_delete()
Date: Wed, 4 Sep 2024 17:13:09 +0900

The function nilfs_btree_check_delete(), which checks whether degeneration
to direct mapping occurs before deleting a b-tree entry, causes memory
access outside the block buffer when retrieving the maximum key if the
root node has no entries.

This does not usually happen because b-tree mappings with 0 child nodes
are never created by mkfs.nilfs2 or nilfs2 itself.  However, it can happen
if the b-tree root node read from a device is configured that way, so fix
this potential issue by adding a check for that case.

Link: https://lkml.kernel.org/r/20240904081401.16682-4-konishi.ryusuke@gmail.com
Fixes: 17c76b0104e4 ("nilfs2: B-tree based block mapping")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/btree.c~nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete
+++ a/fs/nilfs2/btree.c
@@ -1659,13 +1659,16 @@ static int nilfs_btree_check_delete(stru
 	int nchildren, ret;
 
 	root = nilfs_btree_get_root(btree);
+	nchildren = nilfs_btree_node_get_nchildren(root);
+	if (unlikely(nchildren == 0))
+		return 0;
+
 	switch (nilfs_btree_height(btree)) {
 	case 2:
 		bh = NULL;
 		node = root;
 		break;
 	case 3:
-		nchildren = nilfs_btree_node_get_nchildren(root);
 		if (nchildren > 1)
 			return 0;
 		ptr = nilfs_btree_node_get_ptr(root, nchildren - 1,
@@ -1674,12 +1677,12 @@ static int nilfs_btree_check_delete(stru
 		if (ret < 0)
 			return ret;
 		node = (struct nilfs_btree_node *)bh->b_data;
+		nchildren = nilfs_btree_node_get_nchildren(node);
 		break;
 	default:
 		return 0;
 	}
 
-	nchildren = nilfs_btree_node_get_nchildren(node);
 	maxkey = nilfs_btree_node_get_key(node, nchildren - 1);
 	nextmaxkey = (nchildren > 1) ?
 		nilfs_btree_node_get_key(node, nchildren - 2) : 0;
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-null-ptr-deref-in-nilfs_btree_insert.patch
nilfs2-determine-empty-node-blocks-as-corrupted.patch
nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

