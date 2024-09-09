Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA073440
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925698; cv=none; b=kA+iC2rmTwKYq4+ExwEloC/sX+2EfhyQAdoFwjiw0H8J45sWscgNgGLLi/dRvkd6HYWgK8smuRasxK/71DSaAb0tpwx8SVJbqMrmnxmr1geS9NHuaCXIXibedvzOna4lNOPmpN3c7PPfuZO6w2SrVpanUmaTwhaDTcBWbsWMJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925698; c=relaxed/simple;
	bh=6/EkKUC9sB5+FjIY8zcvl5nL9USPZedZMuA6CNqZ0ZY=;
	h=Date:To:From:Subject:Message-Id; b=TCHnAnfI7aC/eSWi+i+R80KIoFAFRvK8CJoVCGLjqiGrHBMwCGGE/UgTHGorbBKuLGn1YPF20PaW2oyvuciz0ohiiSh91jTbO6QpLXkmUE5u7kNMxZ1+/0ySaShq/Z1oWA9dtefhoD6lFLU/Hx9Ryye6tuXboCBWpjV/7ZMqzAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eiKBMwSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eiKBMwSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D20BC4CEC5;
	Mon,  9 Sep 2024 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925698;
	bh=6/EkKUC9sB5+FjIY8zcvl5nL9USPZedZMuA6CNqZ0ZY=;
	h=Date:To:From:Subject:From;
	b=eiKBMwSmEYNEO7+Jd+gPeTrApPRENDGt8fqvu+XM5IwRB28GMau5MnU5j7yKA1/bY
	 m+VyZxYv5igasKSu10KuTHKMtKOnEqAu+lFdCVtF7+s79CZGmJpvT7GG8ORevJaGGQ
	 hF4TJxWX353pXefFeeHBqGpKvJWs4ee/+eF9GYHQ=
Date: Mon, 09 Sep 2024 16:48:17 -0700
To: mm-commits@vger.kernel.org,lizhi.xu@windriver.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch removed from -mm tree
Message-Id: <20240909234818.2D20BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix potential oob read in nilfs_btree_check_delete()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-oob-read-in-nilfs_btree_check_delete.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


