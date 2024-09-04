Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB223C17
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725414782; cv=none; b=LxqIEt+7G4JvD5YzIjN5AKmQVbYWZr9H5hpWO6QQmgrWGljpvt29ITBmIcP+rws2fowJ02GpcoJCT+N3XMF5MOY3y0h2x+znjvAZ6o89gkEbnGGidOQTdxOtiY6bMbHfTQPddM2K0vWbme1dW+/WgVsdp8yzAzzuT2bJzOz+KpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725414782; c=relaxed/simple;
	bh=cvrEeC7ZxBFqb7Ih/z5b29N8fmAze3MM1ca0rXPdRZo=;
	h=Date:To:From:Subject:Message-Id; b=jPalQGOTYpwtMKLshowHGXFnvxkm0Nh/9d3Vj6lTbHymXjPnPePS5zfOQmzsBONnd59A/NjW8IwVyVfEYCFpuZWolRNDhtXpWBjb6+stKZjUgsnLAvto0VL0m1+wJqknR8xEIIaa2yp796IrAmwsBB4jXU4G95IUmqBUHrwpt8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uu3aZHMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uu3aZHMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0561C4CEC4;
	Wed,  4 Sep 2024 01:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725414781;
	bh=cvrEeC7ZxBFqb7Ih/z5b29N8fmAze3MM1ca0rXPdRZo=;
	h=Date:To:From:Subject:From;
	b=Uu3aZHMvNVMR22SLy74kw49w94MgZlNXP2G6+1bGWPa3GV6R7TBTgJDB0FJZv9wvJ
	 7cIlGNoAWfe65c3qQiyoU8kSARl8Etp7ALljokb86kO4DN4MXOFkzef9CHH4Knlmb6
	 klRPJAsCVXiMJftFQ12ztt2N0ASvgiLVhpj5D1pk=
Date: Tue, 03 Sep 2024 18:53:01 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] maple_tree-local-variable-count-is-not-necessary.patch removed from -mm tree
Message-Id: <20240904015301.D0561C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: local variable 'count' is not necessary
has been removed from the -mm tree.  Its filename was
     maple_tree-local-variable-count-is-not-necessary.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: local variable 'count' is not necessary
Date: Sat, 31 Aug 2024 00:10:53 +0000

'count' is never changed after assignment and it looks a little
more direct to use mas->end to locate the offset.

Also ma_data_end() returns slot index instead of count.

Link: https://lkml.kernel.org/r/20240831001053.4751-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-local-variable-count-is-not-necessary
+++ a/lib/maple_tree.c
@@ -2203,7 +2203,7 @@ static inline void mas_node_or_none(stru
 static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char count, offset;
+	unsigned char offset;
 
 	if (unlikely(ma_is_dense(wr_mas->type))) {
 		wr_mas->r_max = wr_mas->r_min = mas->index;
@@ -2213,11 +2213,11 @@ static inline void mas_wr_node_walk(stru
 
 	wr_mas->node = mas_mn(wr_mas->mas);
 	wr_mas->pivots = ma_pivots(wr_mas->node, wr_mas->type);
-	count = mas->end = ma_data_end(wr_mas->node, wr_mas->type,
+	mas->end = ma_data_end(wr_mas->node, wr_mas->type,
 				       wr_mas->pivots, mas->max);
 	offset = mas->offset;
 
-	while (offset < count && mas->index > wr_mas->pivots[offset])
+	while (offset < mas->end && mas->index > wr_mas->pivots[offset])
 		offset++;
 
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, offset, wr_mas->type);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch

