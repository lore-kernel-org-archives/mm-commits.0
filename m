Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFDA1A285;
	Thu, 10 Jul 2025 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120545; cv=none; b=UXQbSHR7UKQFFga17wcjB47IBxx9MesThnhqG8HhZVqtRvNi0Mk20KrSSly8COsVXFGDjIpWspiyq+j6qkPxolHgHNdcQ6Ka2SBcI4j22NldjrMxdkBEl+8zmVx2T2IQaPIpI336yqhBB3lxgz8StkiCj6XrOdeijm1NkEiWByQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120545; c=relaxed/simple;
	bh=tK5ooo5ikku6vovvA7reTh+etqI8yCrlqoXvpiLo+6I=;
	h=Date:To:From:Subject:Message-Id; b=NlF3DiaqL9U3qR6NvEAjFkdI6DdhK+Zo5wmPwL14ZF6LSeKC9fWeHfkgqfzdxq9BitsHW0gNKzGQZBix6iD65OxbTtVQomHwTN5OrByFfN4dg9cWjeznlA3LapW/SD7xWUMZn71ed4C/6Q8ycHbDtP9PbR5filNv1BEeyB6uBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NwvZi42C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NwvZi42C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B764BC4CEE3;
	Thu, 10 Jul 2025 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120544;
	bh=tK5ooo5ikku6vovvA7reTh+etqI8yCrlqoXvpiLo+6I=;
	h=Date:To:From:Subject:From;
	b=NwvZi42CjLMCwtdLgbqF5aDqFnSHgqYgGFM7h2YDaenFYtcnLHt+VoMPG7pTtDx5W
	 XH2NYkTP6rDp7J74/Lu/+PCnHRZHLxk0jQCNhYCUaqSnqxtxX6gYhZEo5zn+MGkgKB
	 CY5M3N7671cs5X7zVVlygPNWQQSl9Hyfo2Naq/6A=
Date: Wed, 09 Jul 2025 21:09:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@oracle.com,dev.jain@arm.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch removed from -mm tree
Message-Id: <20250710040904.B764BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix mt_destroy_walk() on root leaf node
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: fix mt_destroy_walk() on root leaf node
Date: Tue, 24 Jun 2025 15:18:40 -0400

On destroy, we should set each node dead.  But current code miss this when
the maple tree has only the root node.

The reason is mt_destroy_walk() leverage mte_destroy_descend() to set node
dead, but this is skipped since the only root node is a leaf.

Fixes this by setting the node dead if it is a leaf.

Link: https://lore.kernel.org/all/20250407231354.11771-1-richard.weiyang@gmail.com/
Link: https://lkml.kernel.org/r/20250624191841.64682-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-fix-mt_destroy_walk-on-root-leaf-node
+++ a/lib/maple_tree.c
@@ -5319,6 +5319,7 @@ static void mt_destroy_walk(struct maple
 	struct maple_enode *start;
 
 	if (mte_is_leaf(enode)) {
+		mte_set_node_dead(enode);
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-migrate-remove-the-eexist-conversion-for-move_pages.patch

