Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEB923A115;
	Tue, 14 Jan 2025 06:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836965; cv=none; b=j9f+KlisY9SSA2xkDJ0KXux90wSGPMzUoqXOP6LiqCmym64+FM9tiKlQZPqQiuOJOZ3FRwkqBoPaju2wjSQ5pmtkR9beVPESdF/rCGlTAOvufkpLDEQglITM0sUotgIN4MTuYEUQC6L1suWATLNAcXHGyDsoylZQZ8bj8oL4SFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836965; c=relaxed/simple;
	bh=cxjl2dKQjE2T3sE0Qk8Ni909AJcdJRbX8+4XuwMcNe0=;
	h=Date:To:From:Subject:Message-Id; b=ESLPRepSC59Zv0vs6UGsuyBcHMlGgNHe69u1ZnnIXsSoq0ZfZy+3+uU3YIJTt2ke8c8LqjHSaa3Eq7tNqM0TFtkRwNam0EiLTEPE5cqbj2f20ZUI0kbvIuaELuxUrm5pTQ4NcRlFzF709iY/7wrt3jGSBMogY+R31vLkSFfLtVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+DINK9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+DINK9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10459C4CEDD;
	Tue, 14 Jan 2025 06:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836965;
	bh=cxjl2dKQjE2T3sE0Qk8Ni909AJcdJRbX8+4XuwMcNe0=;
	h=Date:To:From:Subject:From;
	b=Y+DINK9L7KgV48bNkqIVKMzkSlZl/a3kOuTUjX7Hs63UXZeBUdRw0rSNZeIZJ+15V
	 WyRN0WPTEMirI5QsqpF6A1xBhN2rt25OjA7pwL1/Gyu7niwBWStclikmLPVLbYHs1v
	 qMsmeCmYS3OwL3HHXl8nfD9L79AWVPSKbTdrbSB8=
Date: Mon, 13 Jan 2025 22:42:44 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-simplify-split-calculation.patch removed from -mm tree
Message-Id: <20250114064245.10459C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: simplify split calculation
has been removed from the -mm tree.  Its filename was
     maple_tree-simplify-split-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


