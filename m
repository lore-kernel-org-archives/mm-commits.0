Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD541FAC4A
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 20:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744317602; cv=none; b=Ibnro7DKEdyKSF/3FCTZzLD4BNBj8+ZnU9KlsoGZB0WfBLsRHlKIV92LPnUOmdu4B0vsdmruka3ntxLDPWtCYSJSvB//SCyhNJGpDQC1q1XiaMFu7ImSW1ET+anwUi8BrJbJmvWBIYUgxH72N54Dt/8Q18jxPlO6WxhdfMnjtcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744317602; c=relaxed/simple;
	bh=679pAqlA+nRVN+6YzPPAMpWT672PJpnTdQSnNe8V8Rs=;
	h=Date:To:From:Subject:Message-Id; b=A/CYTBmauouZ7i19aW5DW5LX1slOVxEKR4dAdbPr92VnXtS4t0G/22BzOwfOv3W/u7oAS1+bwI+Z0rOTQnj1R4vH9m8TZtsfKiAO+zDicKl08PPs3wbEi4mY51asr/HpHi5SK8nKBI4dhVQqpk0itgG5LcXES5xCQRCzjESErNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHsexxpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHsexxpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE10C4CEDD;
	Thu, 10 Apr 2025 20:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744317601;
	bh=679pAqlA+nRVN+6YzPPAMpWT672PJpnTdQSnNe8V8Rs=;
	h=Date:To:From:Subject:From;
	b=PHsexxpKdJmAHfHSyz3Mw0GFnGY0qB55AH56yqCLvtezfYZGtjXEh/HKbPkZhOWSm
	 D4rmUGdgByGF13WJJLGfWCvy2Gs1kQR5Dyc7xBq8BuXrOoDE+M1300SmfoQPDQW5KL
	 kLOSc60u4HYFWlUGhNOiZFC5lbljdqJlR0uVYvsQ=
Date: Thu, 10 Apr 2025 13:40:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reorder-mas-store_type-case-statements.patch added to mm-new branch
Message-Id: <20250410204001.CDE10C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: reorder mas->store_type case statements
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-reorder-mas-store_type-case-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reorder-mas-store_type-case-statements.patch

This patch will later appear in the mm-new branch at
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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: reorder mas->store_type case statements
Date: Thu, 10 Apr 2025 19:14:46 +0000

Move the unlikely case that mas->store_type is invalid to be the last
evaluated case and put liklier cases higher up.

Link: https://lkml.kernel.org/r/20250410191446.2474640-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam R. Howlett <liam.howlett@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   51 ++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reorder-mas-store_type-case-statements
+++ a/lib/maple_tree.c
@@ -4083,15 +4083,6 @@ static inline void mas_wr_store_entry(st
 	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
-	case wr_invalid:
-		MT_BUG_ON(mas->tree, 1);
-		return;
-	case wr_new_root:
-		mas_new_root(mas, wr_mas->entry);
-		break;
-	case wr_store_root:
-		mas_store_root(mas, wr_mas->entry);
-		break;
 	case wr_exact_fit:
 		rcu_assign_pointer(wr_mas->slots[mas->offset], wr_mas->entry);
 		if (!!wr_mas->entry ^ !!wr_mas->content)
@@ -4113,6 +4104,14 @@ static inline void mas_wr_store_entry(st
 	case wr_rebalance:
 		mas_wr_bnode(wr_mas);
 		break;
+	case wr_new_root:
+		mas_new_root(mas, wr_mas->entry);
+		break;
+	case wr_store_root:
+		mas_store_root(mas, wr_mas->entry);
+		break;
+	case wr_invalid:
+		MT_BUG_ON(mas->tree, 1);
 	}
 
 	return;
@@ -4177,19 +4176,10 @@ static inline int mas_prealloc_calc(stru
 	unsigned char delta = height - wr_mas->vacant_height;
 
 	switch (mas->store_type) {
-	case wr_invalid:
-		WARN_ON_ONCE(1);
-		break;
-	case wr_new_root:
-		ret = 1;
-		break;
-	case wr_store_root:
-		if (likely((mas->last != 0) || (mas->index != 0)))
-			ret = 1;
-		else if (((unsigned long) (entry) & 3) == 2)
-			ret = 1;
-		else
-			ret = 0;
+	case wr_exact_fit:
+	case wr_append:
+	case wr_slot_store:
+		ret = 0;
 		break;
 	case wr_spanning_store:
 		if (wr_mas->sufficient_height < wr_mas->vacant_height)
@@ -4209,10 +4199,19 @@ static inline int mas_prealloc_calc(stru
 	case wr_node_store:
 		ret = mt_in_rcu(mas->tree) ? 1 : 0;
 		break;
-	case wr_append:
-	case wr_exact_fit:
-	case wr_slot_store:
-		ret = 0;
+	case wr_new_root:
+		ret = 1;
+		break;
+	case wr_store_root:
+		if (likely((mas->last != 0) || (mas->index != 0)))
+			ret = 1;
+		else if (((unsigned long) (entry) & 3) == 2)
+			ret = 1;
+		else
+			ret = 0;
+		break;
+	case wr_invalid:
+		WARN_ON_ONCE(1);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-convert-mas_prealloc_calc-to-take-in-a-maple-write-state.patch
maple_tree-use-height-and-depth-consistently.patch
maple_tree-use-vacant-nodes-to-reduce-worst-case-allocations.patch
maple_tree-break-on-convergence-in-mas_spanning_rebalance.patch
maple_tree-add-sufficient-height.patch
maple_tree-reorder-mas-store_type-case-statements.patch

