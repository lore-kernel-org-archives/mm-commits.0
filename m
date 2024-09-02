Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508E02C80
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247843; cv=none; b=uRbwJXEEf3Nua0HXoTsDLMVGBTCS65Jtbwf6L96XL0qeddTwR0oNWVABqDfKk0wiefauc/vFia9CgLxpKy0hqfcKORAMPSqKckKO8bcYMHNlNTgcALj6vo8c5rOtICDzhWT7YxVKznJEkP42uX3brbqv7Wn6MpmBAm9w2CMEstI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247843; c=relaxed/simple;
	bh=72vDfwmDthvnmWgtuofawiKnzO5ShnybrfHTpqRPg3I=;
	h=Date:To:From:Subject:Message-Id; b=hhty7MxMFQ3bA+4ZqUqQo/iXlxR5UlVTFVilm4JgN7fRyFJcjggzWZynjnOBk8wys4J0gX8yNRyKYypNn+o+VMWYYMQOXhH3G+PXJSfhEkeeGh+tQF9BcYptC2SwZXzreH5j0mzTA46UsHX/7gocTWUvWn2iPzRcC864aWFxWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=buDePL4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="buDePL4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F9C4CEC2;
	Mon,  2 Sep 2024 03:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247843;
	bh=72vDfwmDthvnmWgtuofawiKnzO5ShnybrfHTpqRPg3I=;
	h=Date:To:From:Subject:From;
	b=buDePL4eMv1JipEZuKC4LAIT4WGt9bNwQ7b3UnJrjpPJrUEv6cP2nbdLNq7+pfyWA
	 vEDTbUD92RN96NrED6Me8Spw/HNfRqzP1zSHzJ1zNtoOAxRUbk1atQYD8y4DSrZ2e7
	 jP1PWHF2bwqCaVDUh23MUU1ygMsIj2R/ZxKgVld0=
Date: Sun, 01 Sep 2024 20:30:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch removed from -mm tree
Message-Id: <20240902033043.277F9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove unneeded mas_wr_walk() in mas_store_prealloc()
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove unneeded mas_wr_walk() in mas_store_prealloc()
Date: Wed, 14 Aug 2024 12:19:43 -0400

Users of mas_store_prealloc() enter this function with nodes already
preallocated. This means the store type must be already set. We can then
remove the call to mas_wr_store_type() and initialize the write state to
continue the partial walk that was done when determining the store type.

Link: https://lkml.kernel.org/r/20240814161944.55347-17-sidhartha.kumar@oracle.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-unneeded-mas_wr_walk-in-mas_store_prealloc
+++ a/lib/maple_tree.c
@@ -3979,9 +3979,6 @@ static inline void mas_wr_end_piv(struct
 		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
 	else
 		wr_mas->end_piv = wr_mas->mas->max;
-
-	if (!wr_mas->entry)
-		mas_wr_extend_null(wr_mas);
 }
 
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
@@ -5532,8 +5529,19 @@ void mas_store_prealloc(struct ma_state
 {
 	MA_WR_STATE(wr_mas, mas, entry);
 
-	mas_wr_prealloc_setup(&wr_mas);
-	mas_wr_store_type(&wr_mas);
+	if (mas->store_type == wr_store_root) {
+		mas_wr_prealloc_setup(&wr_mas);
+		goto store;
+	}
+
+	mas_wr_walk_descend(&wr_mas);
+	if (mas->store_type != wr_spanning_store) {
+		/* set wr_mas->content to current slot */
+		wr_mas.content = mas_slot_locked(mas, wr_mas.slots, mas->offset);
+		mas_wr_end_piv(&wr_mas);
+	}
+
+store:
 	trace_ma_write(__func__, mas, 0, entry);
 	mas_wr_store_entry(&wr_mas);
 	MAS_WR_BUG_ON(&wr_mas, mas_is_err(mas));
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


