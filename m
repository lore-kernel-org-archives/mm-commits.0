Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9357F55D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i4/OJAGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5353EC433C8;
	Tue, 12 Dec 2023 18:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407543;
	bh=7zX9OXy94gGpeNAclYeVocKBmOY+wTieqOStZDr/hkQ=;
	h=Date:To:From:Subject:From;
	b=i4/OJAGvG8eJvg8T2iT2HRH8OKqrWtVtpYPE5djXfcK+M3C7+s6baZCxq+l4lkSqt
	 Q+2A/9Hz6pRfU6sMpZNj7IN7db4Y976nNPmOOdpwoeLtLuL6LMAfVgy6YfXPfQJppv
	 LFMCWdvFLm8Ol/F1PLAK+s5WkBFzQFfRDUFTIZLY=
Date: Tue, 12 Dec 2023 10:59:02 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-cached-node-end-in-mas_next.patch removed from -mm tree
Message-Id: <20231212185903.5353EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use cached node end in mas_next()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-cached-node-end-in-mas_next.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: use cached node end in mas_next()
Date: Wed, 1 Nov 2023 13:16:22 -0400

When looking for the next entry, don't recalculate the node end as it is
now tracked in the maple state.

Link: https://lkml.kernel.org/r/20231101171629.3612299-6-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-cached-node-end-in-mas_next
+++ a/lib/maple_tree.c
@@ -4539,6 +4539,7 @@ static inline int mas_next_node(struct m
 	unsigned long min;
 	unsigned long *pivots;
 	struct maple_enode *enode;
+	struct maple_node *tmp;
 	int level = 0;
 	unsigned char node_end;
 	enum maple_type mt;
@@ -4591,6 +4592,10 @@ static inline int mas_next_node(struct m
 		pivots = ma_pivots(node, mt);
 
 	mas->max = mas_safe_pivot(mas, pivots, mas->offset, mt);
+	tmp = mte_to_node(enode);
+	mt = mte_node_type(enode);
+	pivots = ma_pivots(tmp, mt);
+	mas->end = ma_data_end(tmp, mt, pivots, mas->max);
 	if (unlikely(ma_dead_node(node)))
 		return 1;
 
@@ -4625,7 +4630,6 @@ static void *mas_next_slot(struct ma_sta
 	unsigned long pivot;
 	enum maple_type type;
 	struct maple_node *node;
-	unsigned char data_end;
 	unsigned long save_point = mas->last;
 	void *entry;
 
@@ -4633,12 +4637,11 @@ retry:
 	node = mas_mn(mas);
 	type = mte_node_type(mas->node);
 	pivots = ma_pivots(node, type);
-	data_end = ma_data_end(node, type, pivots, mas->max);
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
 	if (mas->max >= max) {
-		if (likely(mas->offset < data_end))
+		if (likely(mas->offset < mas->end))
 			pivot = pivots[mas->offset];
 		else
 			goto overflow;
@@ -4650,11 +4653,11 @@ retry:
 			goto overflow;
 	}
 
-	if (likely(mas->offset < data_end)) {
+	if (likely(mas->offset < mas->end)) {
 		mas->index = pivots[mas->offset] + 1;
 again:
 		mas->offset++;
-		if (likely(mas->offset < data_end))
+		if (likely(mas->offset < mas->end))
 			mas->last = pivots[mas->offset];
 		else
 			mas->last = mas->max;
@@ -4691,7 +4694,6 @@ again:
 			goto overflow;
 
 		mas->index = mas->last + 1;
-		/* Node cannot end on NULL, so it's safe to short-cut here */
 		goto again;
 	}
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


