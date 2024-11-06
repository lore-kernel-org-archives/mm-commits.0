Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6634594C
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854808; cv=none; b=gyL2UN1HXwPZd0BI90FB/DNQ6k18DBGYq1oNcxHVdnBwSoX5Y07aKBZEGAcYjxz9rZzHUSHSOUxkxYPQ7Zhjh4L49iOkRiAEiO7rJmQIXt1mdhpbVEzNtlupSG60MSGqkQ4dz4h/TJCvf9XXyDRrCORw+5AOgIhOMHcXSty5U9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854808; c=relaxed/simple;
	bh=uNxaEaDIiFUo7lXTH/42VjNGdGTByHsY20MgR1TE+hI=;
	h=Date:To:From:Subject:Message-Id; b=uXo+BNSXegHv7JEE6Qe3HL9vpR3uswfzPF24r/AmYVg7X7AYcX7Mm1wtT/xhIKZo8tRT8OufKyklyOU3aptf194MgIJlkgozKGZc90bAjWmi2XKrvzkPYf49yNpg7bY8EVVJ8sZ8vY/PRqLMFkYDSH8GgmlY9c/pIv3/ZAi09gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RtVy9jAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RtVy9jAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9530FC4CECF;
	Wed,  6 Nov 2024 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854807;
	bh=uNxaEaDIiFUo7lXTH/42VjNGdGTByHsY20MgR1TE+hI=;
	h=Date:To:From:Subject:From;
	b=RtVy9jAU+kSpRk6QAXbFRG05xq8LIv7WO3CfFzA7PcsCV3LvYAbR0aBKZuubw7NKt
	 XGi60BHM07nxqt/zW/NKpbFm8Jx/kVp9WN23dOi2FI7ShZzyWjY/WQnIns8A5pJVJl
	 8Pi/Mi/xDE7rkno0Da8uY4vpTFYcWtSivsReNip0=
Date: Tue, 05 Nov 2024 17:00:07 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-root-node-could-be-handled-by-p_slot-too.patch removed from -mm tree
Message-Id: <20241106010007.9530FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: root node could be handled by !p_slot too
has been removed from the -mm tree.  Its filename was
     maple_tree-root-node-could-be-handled-by-p_slot-too.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: root node could be handled by !p_slot too
Date: Fri, 13 Sep 2024 06:31:28 +0000

For a root node, mte_parent_slot() return 0, this exactly fits the
following !p_slot check.

So we can remove the special handling for root node.

Link: https://lkml.kernel.org/r/20240913063128.27391-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-root-node-could-be-handled-by-p_slot-too
+++ a/lib/maple_tree.c
@@ -2155,9 +2155,7 @@ static inline bool mas_prev_sibling(stru
 {
 	unsigned int p_slot = mte_parent_slot(mas->node);
 
-	if (mte_is_root(mas->node))
-		return false;
-
+	/* For root node, p_slot is set to 0 by mte_parent_slot(). */
 	if (!p_slot)
 		return false;
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

