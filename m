Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2EB14A84
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 07:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036534; cv=none; b=b3LMu1XE7eVVLcPFwuRq75pFyGSyHkJLKWcakd7aNuGTznoLyyCIcR6Ne6rxX+RDOyTMZ1w7NOIbMLBiBGl3l9UtgrasSiU4WJXO1zffCErh1CWL1ADnGbbBoFntThUGh0XsURu9mBIITRL+OJmaR+rS8VDgvX0SKPZNxArvrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036534; c=relaxed/simple;
	bh=OH0CfI10dG9mipmyB8ZY9ee5u3ja0Y/zJ1L5CFnCM4g=;
	h=Date:To:From:Subject:Message-Id; b=rCZnH3T14JOVCVvXl2hdhU2u7F2x318BuVcpvDCQfcJr5X/JAy0eCGfQooVRZ+shBVb86UvBSRkpJaDSEufkQX+UQjVLh9xTQQHW6LRUPPBhdBix3aJmpSjqq5AMnQXrix/+g9TPTebU8JTutXBSlQD2hBcwHqZPD9UXxMcVYWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRkO2bwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRkO2bwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBA3C4CECF;
	Sun,  1 Dec 2024 07:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036533;
	bh=OH0CfI10dG9mipmyB8ZY9ee5u3ja0Y/zJ1L5CFnCM4g=;
	h=Date:To:From:Subject:From;
	b=lRkO2bwZh6J1vxkr/z3TWG9VGD6t0OfxN+rCEJo2AJ6f3gytFnEo800Ii4OaCDbQ9
	 e7x7X51UmWQ2tDfpQIaozqbIl3JxgZhET7mIhx385PIbCWo7/I7petXZZqF2bqKrTM
	 cWh+bIVV9VgevpwmTxR1lflO3QfndbTQtOr41Ruk=
Date: Sat, 30 Nov 2024 23:02:12 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maple_tree-use-mas_next_slot-directly.patch removed from -mm tree
Message-Id: <20241201070213.5BBA3C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use mas_next_slot() directly
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_next_slot-directly.patch

This patch was dropped because it was folded into docs-mm-add-vma-locks-documentation-v3.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: use mas_next_slot() directly
Date: Mon, 25 Nov 2024 02:41:56 +0000

The loop condition makes sure (mas.last < max), so we can directly use
mas_next_slot() here.

Since no other use of mas_next_entry(), it is removed.

Link: https://lkml.kernel.org/r/20241125024156.26093-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_next_slot-directly
+++ a/lib/maple_tree.c
@@ -4745,29 +4745,6 @@ again:
 }
 
 /*
- * mas_next_entry() - Internal function to get the next entry.
- * @mas: The maple state
- * @limit: The maximum range start.
- *
- * Set the @mas->node to the next entry and the range_start to
- * the beginning value for the entry.  Does not check beyond @limit.
- * Sets @mas->index and @mas->last to the range, Does not update @mas->index and
- * @mas->last on overflow.
- * Restarts on dead nodes.
- *
- * Return: the next entry or %NULL.
- */
-static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
-{
-	if (mas->last >= limit) {
-		mas->status = ma_overflow;
-		return NULL;
-	}
-
-	return mas_next_slot(mas, limit, false);
-}
-
-/*
  * mas_rev_awalk() - Internal function.  Reverse allocation walk.  Find the
  * highest gap address of a given size in a given node and descend.
  * @mas: The maple state
@@ -6937,7 +6914,7 @@ retry:
 		goto unlock;
 
 	while (mas_is_active(&mas) && (mas.last < max)) {
-		entry = mas_next_entry(&mas, max);
+		entry = mas_next_slot(&mas, max, false);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

docs-mm-add-vma-locks-documentation-v3.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch
maple_tree-simplify-split-calculation.patch
maple_tree-add-a-test-check-deficient-node.patch
maple_tree-only-root-node-could-be-deficient.patch

