Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883D9272937
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 22:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740695012; cv=none; b=Q2UgW+qeTw4uHX6X8PMxwvK76VAs5pbrp3RtF6oCw3VpUUbfZZMkAa7E/YVEmvFt9iQGbNryZIAgKiWQLDEIuB7GHYXVRK9HzYObnl/9pqUQ2sNd9HcUj4EGSuY4pO3y+PHJqDZTfmzwUeNYhHCUOU/HntxL4MVa4PJkzcN/c6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740695012; c=relaxed/simple;
	bh=HbGniN4bsGgpRKIH6JAL1IraOl2JGGQNUr/HDeXlS/0=;
	h=Date:To:From:Subject:Message-Id; b=ou+BRKgEenO1l986icDuXIxBCVmEVkEmAvjH+8TpAPVolsbymepdpfB+h4mba+1bH469/AOZq+xaS5knfsaVOPIn62Nw65WO7AGydtkEyCmx+X8CMTAgCupXnj9d3TpO/nPmcUUO9M3eE75PAoUKe2//WYZFnsXLgM36HzW4vlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GYh3252A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GYh3252A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A85AC4CEDD;
	Thu, 27 Feb 2025 22:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740695012;
	bh=HbGniN4bsGgpRKIH6JAL1IraOl2JGGQNUr/HDeXlS/0=;
	h=Date:To:From:Subject:From;
	b=GYh3252AaReM+NxQioIVHa7SBGmUJYJ8RQdx+DkoHU9pWkMcDlp5QB4YvS2wS9jnV
	 526XiIxw8rp9AqnmVM/SOG8TEj3Pwu7ldRrEA7+89f0Pyn0aRuNf/QmnMxqdZKIEkK
	 +xQMbFvwc8HUWMhv6PSylOXXYRDnK2agRcZOqxBo=
Date: Thu, 27 Feb 2025 14:23:31 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reorder-mas-store_type-case-statements.patch added to mm-unstable branch
Message-Id: <20250227222332.4A85AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: reorder mas->store_type case statements
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-reorder-mas-store_type-case-statements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reorder-mas-store_type-case-statements.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: reorder mas->store_type case statements
Date: Thu, 27 Feb 2025 20:48:23 +0000

Move the unlikely case that mas->store_type is invalid to be the last
evaluated case and put liklier cases higher up.

Link: https://lkml.kernel.org/r/20250227204823.758784-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by: Liam R. Howlett <liam.howlett@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   51 ++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reorder-mas-store_type-case-statements
+++ a/lib/maple_tree.c
@@ -4089,15 +4089,6 @@ static inline void mas_wr_store_entry(st
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
@@ -4119,6 +4110,14 @@ static inline void mas_wr_store_entry(st
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
@@ -4183,19 +4182,10 @@ static inline int mas_prealloc_calc(stru
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
@@ -4215,10 +4205,19 @@ static inline int mas_prealloc_calc(stru
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

