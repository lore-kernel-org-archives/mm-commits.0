Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A495040C03
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854805; cv=none; b=Z4Y8btiL2bbrzMffaCHysg2AiD7ZgcRAmnS/mXCnRD/2DPbixIXKq26npQqmwHiyGssruGBeoHAwdS9HcjI/9RoNkgqRwAM1KrgTWqaD0cNnNhvyyi6cD53vRdzIJc1r+yITddEpAorBOsRo66tRb6WHzBgZYSlnwADBVukjTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854805; c=relaxed/simple;
	bh=ePHo03kiYsBHdmNFp8llcfnzDQlSAGkCFS8ycp1a/HQ=;
	h=Date:To:From:Subject:Message-Id; b=GcZhSUVreQWrNy3C8KwtfWBwJnmAiOWTA5qiasnGEAWr/sJv06ML9NJOwgPcwauFERTRQ+hAYeuxVtR43JYRLUpBSIhqZAbliK9ejl9bcYl7In/fcE48gWfXHpsRSMn5qCNObagRvAFSj8fPA1OmNBnET+BSqcq/hLYd2K7jrc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jMMAik9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jMMAik9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AEBC4CECF;
	Wed,  6 Nov 2024 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854805;
	bh=ePHo03kiYsBHdmNFp8llcfnzDQlSAGkCFS8ycp1a/HQ=;
	h=Date:To:From:Subject:From;
	b=jMMAik9QNsFPFBttwtKox5v3qJXO5EthsUmTSgHDuPZO0oXjmBK3eWQ56BhSxQAyV
	 ttZDoS8aK8xD8OM7Xv76G275ayQZTW+LinTht05zLsVCTNsG80Udqt/N9AIciZDvnz
	 gfvCq5aEaxrJoxF+r/+kUKtCAg3Kio/ezRLzemi0=
Date: Tue, 05 Nov 2024 17:00:04 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,jqqlijiazi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-alloc-node-fail-issue.patch removed from -mm tree
Message-Id: <20241106010005.75AEBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix alloc node fail issue
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-alloc-node-fail-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiazi Li <jqqlijiazi@gmail.com>
Subject: maple_tree: fix alloc node fail issue
Date: Wed, 26 Jun 2024 12:06:30 -0400

In the following code, the second call to the mas_node_count will return
-ENOMEM:

	mas_node_count(mas, MAPLE_ALLOC_SLOTS + 1);
	mas_node_count(mas, MAPLE_ALLOC_SLOTS * 2 + 2);

This is because there may be some full maple_alloc node in current maple
state.  Use full maple_alloc node will make max_req equal to 0.  And it
leads to mt_alloc_bulk return 0.  As a result, mas_node_count set mas.node
to MA_ERROR(-ENOMEM).

Find a non-full maple_alloc node, and if necessary, use this non-full node
in the next while loop.

Link: https://lkml.kernel.org/r/20240626160631.3636515-1-Liam.Howlett@oracle.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-fix-alloc-node-fail-issue
+++ a/lib/maple_tree.c
@@ -1285,7 +1285,10 @@ static inline void mas_alloc_nodes(struc
 
 		node->node_count += count;
 		allocated += count;
-		node = node->slot[0];
+		/* find a non-full node*/
+		do {
+			node = node->slot[0];
+		} while (unlikely(node->node_count == MAPLE_ALLOC_SLOTS));
 		requested -= count;
 	}
 	mas->alloc->total = allocated;
_

Patches currently in -mm which might be from jqqlijiazi@gmail.com are


