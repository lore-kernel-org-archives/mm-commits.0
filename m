Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E956742
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247838; cv=none; b=q0U3SHlCtXjpacYnBj6kSkI0i2ZYE/m1P6jS+zOe4iKbzstOValNvspeGTIam3xi3JuARpBNyY/E6RVEB1WR8U9mladayxMY9rEj/72FYGUCRiKMMyDlPr6KqHrn2lyUSxYpKJWsPrJ30tqOo7LKQFzUVCq2Q5Gowyly7K+PRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247838; c=relaxed/simple;
	bh=vNh2l2X2eF0P+vBSs2b+VYy4g2RZxbhpfKqAT8ERoHM=;
	h=Date:To:From:Subject:Message-Id; b=aQUV0CYZkBYaT0oDyRk0qp3srYXRHumio5Am8pyeIJjKiNDmjB8x4ffvHhPMb3hIBHnDRyuUuXhjVyBhy8csg27aJWyLvj372DnOXY64VmXzJCE6nQ4e4akni2dUaw61Mz5ou5n+iQoVe2CJnFQseBvmALM6xKsK2T6QBcqVTSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ox8s15z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ox8s15z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFB8C4CEC2;
	Mon,  2 Sep 2024 03:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247838;
	bh=vNh2l2X2eF0P+vBSs2b+VYy4g2RZxbhpfKqAT8ERoHM=;
	h=Date:To:From:Subject:From;
	b=Ox8s15z/1p0xKCAqHZNq6DrCv0Hj47a9/Eqa/GRya94Z/dmkA7E06F6Vw6uWr9rlo
	 eBBPyNGk/At19bZl1t9MDtT4NnDIYsxGYecXUz+asCXb0PGj3C/wIpHI7uKOOOOdYv
	 3I6d5Bnbd6BJ+2F4wa8gs7PabvaDxBnOyzpBslg8=
Date: Sun, 01 Sep 2024 20:30:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-mas_wr_modify.patch removed from -mm tree
Message-Id: <20240902033038.3DFB8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove mas_wr_modify()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-mas_wr_modify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove mas_wr_modify()
Date: Wed, 14 Aug 2024 12:19:39 -0400

There are no more users of the function, safely remove it.

Link: https://lkml.kernel.org/r/20240814161944.55347-13-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-mas_wr_modify
+++ a/lib/maple_tree.c
@@ -4108,44 +4108,6 @@ static void mas_wr_bnode(struct ma_wr_st
 	mas_commit_b_node(wr_mas, &b_node);
 }
 
-static inline void mas_wr_modify(struct ma_wr_state *wr_mas)
-{
-	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end;
-
-	/* Direct replacement */
-	if (wr_mas->r_min == mas->index && wr_mas->r_max == mas->last) {
-		rcu_assign_pointer(wr_mas->slots[mas->offset], wr_mas->entry);
-		if (!!wr_mas->entry ^ !!wr_mas->content)
-			mas_update_gap(mas);
-		return;
-	}
-
-	/*
-	 * new_end exceeds the size of the maple node and cannot enter the fast
-	 * path.
-	 */
-	new_end = mas_wr_new_end(wr_mas);
-	if (new_end >= mt_slots[wr_mas->type])
-		goto slow_path;
-
-	/* Attempt to append */
-	if (mas_wr_append(wr_mas, new_end))
-		return;
-
-	if (new_end == mas->end && mas_wr_slot_store(wr_mas))
-		return;
-
-	if (mas_wr_node_store(wr_mas, new_end))
-		return;
-
-	if (mas_is_err(mas))
-		return;
-
-slow_path:
-	mas_wr_bnode(wr_mas);
-}
-
 /*
  * mas_wr_store_entry() - Internal call to store a value
  * @mas: The maple state
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


