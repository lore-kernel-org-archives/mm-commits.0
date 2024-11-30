Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D0529B0;
	Sat, 30 Nov 2024 04:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732941139; cv=none; b=fasyZpLwRKr8yWH71acwqiBfhjE4zbEGAE2m+MBJS3c/WL/ex7xHL2VnWVBHAK4DmiN2xCnflVg7MHqXCZGFzjMiVsNAFy7nD83OeoRUfhwN2qcN+VEsdZYoBrq1SYsfrVEhhibWRgmLQ9i3maUIIwi/3cTWcj/b1ZZKxCXzpII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732941139; c=relaxed/simple;
	bh=uVQFg49RVE099NWFD7Pq+Lm27GqMJfummGlcDfPufKA=;
	h=Date:To:From:Subject:Message-Id; b=U+SAskSYVO72py4u3zk2HRe+3fsFz9VeV9txBRpxg8jUg8a0IAHtU7lHYV8K4JvQvqaVSanlw0+oniarSJUaF+JaE23o9J3UnXUXMtkRp9jl1pzDxD87DjuGloVnrdmnKu5Uh2M0LZqqLehG4ku3oMWv54wYUrxsvOtZK1/c5/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+qSwV7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+qSwV7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA3EC4CECC;
	Sat, 30 Nov 2024 04:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732941138;
	bh=uVQFg49RVE099NWFD7Pq+Lm27GqMJfummGlcDfPufKA=;
	h=Date:To:From:Subject:From;
	b=C+qSwV7C0eEcP8P9xAjoLna9DOCvPPq/Q6U2AVU9+47/iKZPdta4aCRcLvYZygqlA
	 lHwN7jJN4SmnXoXXU7PVSpfqtvSrXsnj0NQQeBWHlzPVe3si7Ge+2fmz6WSPaOxF3M
	 wIx5nfPH6dctDidU0YwUX1gWH4M2VabzRgB5PGbs=
Date: Fri, 29 Nov 2024 20:32:17 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-simplify-split-calculation.patch added to mm-unstable branch
Message-Id: <20241130043218.4CA3EC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: simplify split calculation
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-simplify-split-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-simplify-split-calculation.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: simplify split calculation
Date: Wed, 13 Nov 2024 03:16:14 +0000

Patch series "simplify split calculation", v3.


This patch (of 3):

The current calculation for splitting nodes tries to enforce a minimum
span on the leaf nodes.  This code is complex and never worked correctly
to begin with, due to the min value being passed as 0 for all leaves.

The calculation should just split the data as equally as possible
between the new nodes.  Note that b_end will be one more than the data,
so the left side is still favoured in the calculation.

The current code may also lead to a deficient node by not leaving enough
data for the right side of the split. This issue is also addressed with
the split calculation change.

[Liam.Howlett@Oracle.com: rephrase the change log]
Link: https://lkml.kernel.org/r/20241113031616.10530-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241113031616.10530-2-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/lib/maple_tree.c~maple_tree-simplify-split-calculation
+++ a/lib/maple_tree.c
@@ -1863,11 +1863,11 @@ static inline int mab_no_null_split(stru
  * Return: The first split location.  The middle split is set in @mid_split.
  */
 static inline int mab_calc_split(struct ma_state *mas,
-	 struct maple_big_node *bn, unsigned char *mid_split, unsigned long min)
+	 struct maple_big_node *bn, unsigned char *mid_split)
 {
 	unsigned char b_end = bn->b_end;
 	int split = b_end / 2; /* Assume equal split. */
-	unsigned char slot_min, slot_count = mt_slots[bn->type];
+	unsigned char slot_count = mt_slots[bn->type];
 
 	/*
 	 * To support gap tracking, all NULL entries are kept together and a node cannot
@@ -1900,18 +1900,7 @@ static inline int mab_calc_split(struct
 		split = b_end / 3;
 		*mid_split = split * 2;
 	} else {
-		slot_min = mt_min_slots[bn->type];
-
 		*mid_split = 0;
-		/*
-		 * Avoid having a range less than the slot count unless it
-		 * causes one node to be deficient.
-		 * NOTE: mt_min_slots is 1 based, b_end and split are zero.
-		 */
-		while ((split < slot_count - 1) &&
-		       ((bn->pivot[split] - min) < slot_count - 1) &&
-		       (b_end - split > slot_min))
-			split++;
 	}
 
 	/* Avoid ending a node on a NULL entry */
@@ -2377,7 +2366,7 @@ static inline struct maple_enode
 static inline unsigned char mas_mab_to_node(struct ma_state *mas,
 	struct maple_big_node *b_node, struct maple_enode **left,
 	struct maple_enode **right, struct maple_enode **middle,
-	unsigned char *mid_split, unsigned long min)
+	unsigned char *mid_split)
 {
 	unsigned char split = 0;
 	unsigned char slot_count = mt_slots[b_node->type];
@@ -2390,7 +2379,7 @@ static inline unsigned char mas_mab_to_n
 	if (b_node->b_end < slot_count) {
 		split = b_node->b_end;
 	} else {
-		split = mab_calc_split(mas, b_node, mid_split, min);
+		split = mab_calc_split(mas, b_node, mid_split);
 		*right = mas_new_ma_node(mas, b_node);
 	}
 
@@ -2877,7 +2866,7 @@ static void mas_spanning_rebalance(struc
 		mast->bn->b_end--;
 		mast->bn->type = mte_node_type(mast->orig_l->node);
 		split = mas_mab_to_node(mas, mast->bn, &left, &right, &middle,
-					&mid_split, mast->orig_l->min);
+					&mid_split);
 		mast_set_split_parents(mast, left, middle, right, split,
 				       mid_split);
 		mast_cp_to_nodes(mast, left, middle, right, split, mid_split);
@@ -3365,7 +3354,7 @@ static void mas_split(struct ma_state *m
 		if (mas_push_data(mas, height, &mast, false))
 			break;
 
-		split = mab_calc_split(mas, b_node, &mid_split, prev_l_mas.min);
+		split = mab_calc_split(mas, b_node, &mid_split);
 		mast_split_data(&mast, mas, split);
 		/*
 		 * Usually correct, mab_mas_cp in the above call overwrites
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch
maple_tree-simplify-split-calculation.patch
maple_tree-add-a-test-check-deficient-node.patch
maple_tree-only-root-node-could-be-deficient.patch

