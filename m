Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73A29A2
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 01:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725414773; cv=none; b=DY+boh4viiI/2/TOpdUhRG5ZAvVviPEnkZ3SuWF/CM4EH0J6T1AH2+U6325TOyj00nMAh3wa2WlPx7v0meoA5Go5fGYjkV7SUJ3PJmMpVPVh7ZO1tcTsEisky7Fo21HQDJz0J/HN0+KQ5ZQKeDevdwEqZr8jutum+MRkHhE1Q24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725414773; c=relaxed/simple;
	bh=3/+JAt4n42rrMHFtEkAY+Up/9kxft4g+CuLD/6WO28w=;
	h=Date:To:From:Subject:Message-Id; b=iM9MTR0459mTDKk+AmTxIdtg5daD3DpOLB4y81LubYIrVZHC+rUsF1nPHVOS1mP+6E7XV62Lgi4VVRyIEZWUflq/TO2/EKGQSI4G+lXs01cPrPjfhQ3Tj7LKKwIabd8e1E7uLv3BoLBw/XC6CoUYjvxiZ1jDQiBtEmYOfWQ2dO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcYq8JIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcYq8JIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F43C4CEC4;
	Wed,  4 Sep 2024 01:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725414772;
	bh=3/+JAt4n42rrMHFtEkAY+Up/9kxft4g+CuLD/6WO28w=;
	h=Date:To:From:Subject:From;
	b=FcYq8JIuHfmHrdH8AX8H1ijEnnvT7rgiIyK8LXmFq/JWh9Gzu1RGOs58T57B2qjsa
	 FIYv6KiZWrAvd+VWtovoZym+0h6jbmkok3tEi3Qv4S4WYtbaPR0b51QZp0Y+TXpWKR
	 okD8U6heYjJM1yf5/EbTXD1U4x22HktZ5t5O+M1Y=
Date: Tue, 03 Sep 2024 18:52:51 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch removed from -mm tree
Message-Id: <20240904015252.88F43C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use mas_safe_pivot() to get the pivot range
has been removed from the -mm tree.  Its filename was
     maple_tree-use-mas_safe_pivot-to-get-the-pivot-range.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: use mas_safe_pivot() to get the pivot range
Date: Sat, 31 Aug 2024 00:10:52 +0000

Before modifying data, we need to walk the tree to locate the
maple_node. Also we get the range boundary at offset/offset_end.

For the upper boundary at offset, we have defined function
mas_safe_pivot() to get it. Let's leverage it.

Link: https://lkml.kernel.org/r/20240831001053.4751-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_safe_pivot-to-get-the-pivot-range
+++ a/lib/maple_tree.c
@@ -2220,7 +2220,7 @@ static inline void mas_wr_node_walk(stru
 	while (offset < count && mas->index > wr_mas->pivots[offset])
 		offset++;
 
-	wr_mas->r_max = offset < count ? wr_mas->pivots[offset] : mas->max;
+	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, offset, wr_mas->type);
 	wr_mas->r_min = mas_safe_min(mas, wr_mas->pivots, offset);
 	wr_mas->offset_end = mas->offset = offset;
 }
@@ -3927,11 +3927,9 @@ static inline void mas_wr_extend_null(st
 		    (mas->end != wr_mas->offset_end) &&
 		    !wr_mas->slots[wr_mas->offset_end + 1]) {
 			wr_mas->offset_end++;
-			if (wr_mas->offset_end == mas->end)
-				mas->last = mas->max;
-			else
-				mas->last = wr_mas->pivots[wr_mas->offset_end];
-			wr_mas->end_piv = mas->last;
+			wr_mas->end_piv = mas->last =
+				mas_safe_pivot(mas, wr_mas->pivots,
+					wr_mas->offset_end, wr_mas->type);
 		}
 	}
 
@@ -3956,10 +3954,8 @@ static inline void mas_wr_end_piv(struct
 	       (wr_mas->mas->last > wr_mas->pivots[wr_mas->offset_end]))
 		wr_mas->offset_end++;
 
-	if (wr_mas->offset_end < wr_mas->mas->end)
-		wr_mas->end_piv = wr_mas->pivots[wr_mas->offset_end];
-	else
-		wr_mas->end_piv = wr_mas->mas->max;
+	wr_mas->end_piv = mas_safe_pivot(wr_mas->mas, wr_mas->pivots,
+				wr_mas->offset_end, wr_mas->type);
 }
 
 static inline unsigned char mas_wr_new_end(struct ma_wr_state *wr_mas)
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch
maple_tree-cleanup-function-descriptions.patch
maple_tree-fix-comment-typo-on-ma_flag-of-allocation-tree.patch
maple_tree-local-variable-count-is-not-necessary.patch

