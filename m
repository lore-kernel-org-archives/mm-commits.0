Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579331C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836910; cv=none; b=lqWcpRfQHfPmdHx9RQv+yeoJ55C4T5pW7iYdq5J9QBHG/ABDEBvERsaPurhsqUdzHTidTim2+mzkxS0hHIeiPe65WaHh8xVBIAECOISH7KdCmudhtsnVsYyOmuqW/c4tCWOPASlI+37AOTopY6D5OCTlAA0hfwc7Eo3PfoCIo7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836910; c=relaxed/simple;
	bh=Txq2ZH8czoTHbOkilNNBisuKG20G52BEj7bITbbuOio=;
	h=Date:To:From:Subject:Message-Id; b=Uv1ZvyQbhsflhpRTolqnzz7XTtpxfT1lzHJH5j8N2BhohdHqmFynp/Q3mhoSqBwNyi/a1w+QwLg8kgs8BUKgPtKY65F5aMPRiwl0BiqqejEKC8ig/XHPypGz/t899CXzvUyfV+51fyS8DumRmNffm+nlsJtsTbUh7/aP18CIxeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3uFN9RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3uFN9RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9B5C4CEDD;
	Tue, 14 Jan 2025 06:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836909;
	bh=Txq2ZH8czoTHbOkilNNBisuKG20G52BEj7bITbbuOio=;
	h=Date:To:From:Subject:From;
	b=o3uFN9RL7wCWPEzkJ2/NeRX5Cvr3lYCILS4G9htix/DwvhQas4qDtxRCpN9Y1VR1B
	 PkefRFcP+vvBf0kfEORD5VU8wLTCG7ZbgF9R9uoXjMShTl8W1tP59CSNi4uxGOq7f/
	 2o9/UIlXonj8r4lXqydWG5VLlKDCO3AmJ1YY1QRc=
Date: Mon, 13 Jan 2025 22:41:49 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-mas_next_slot-directly.patch removed from -mm tree
Message-Id: <20250114064149.9C9B5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use mas_next_slot() directly
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_next_slot-directly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4746,29 +4746,6 @@ again:
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
@@ -6938,7 +6915,7 @@ retry:
 		goto unlock;
 
 	while (mas_is_active(&mas) && (mas.last < max)) {
-		entry = mas_next_entry(&mas, max);
+		entry = mas_next_slot(&mas, max, false);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


