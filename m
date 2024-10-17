Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5D51D618A
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201712; cv=none; b=rhTt52S8sFTgKYITs1BuJRA03nE0DkZDa8psO759mk+Zvp34RRcwIt6waFicKjkqSM+T63/fzIX/UFLNerYSg/KBa3F51m63fWNalGDHrLPQaKJNYt4wr4hBWXfpLvkPR2kTsIxXBlR6vsXlmAGmRjYiGRgXi8sjMXzqSVrxx1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201712; c=relaxed/simple;
	bh=MZJ4vkU7HlZbjCVhOCyf+UfQDzGW0OuQK8LRrjpq+ig=;
	h=Date:To:From:Subject:Message-Id; b=u9XbbBmbBh0/mCV78HSTAf6XzeDWVxFYXTZyu8lF22FU6kNjizLoMctGmxagrpkFcXpOqQZRIecez/IGUMvmJarSRsQ5jTEwyDtq9UZTIPjWKGM9kdSCGDa79EYIMf3dYaOD1crunE7+CxD72kDhIUKP5pZNe2R0ZO2/Xoxcr6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F1LYgtzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F1LYgtzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE3EC4CEC3;
	Thu, 17 Oct 2024 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729201712;
	bh=MZJ4vkU7HlZbjCVhOCyf+UfQDzGW0OuQK8LRrjpq+ig=;
	h=Date:To:From:Subject:From;
	b=F1LYgtzgW4vpNouk2wLG/2m4wf/L5cv0w3LK1JCD5arXkMepv5cICt6viygDC43Lw
	 ImUUh+gHSXqGAmuGUbGTwQqgHqG2fq67ULLSmu49sh/7MwJvzusJaWsP6u45OQIsgW
	 +pTVMdXK33yQ9RG51XOj18cmOt7G2+kLzAb+aM2A=
Date: Thu, 17 Oct 2024 14:48:31 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-calculate-new_end-when-needed.patch added to mm-unstable branch
Message-Id: <20241017214832.3DE3EC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: calculate new_end when needed
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-calculate-new_end-when-needed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-calculate-new_end-when-needed.patch

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
Subject: maple_tree: calculate new_end when needed
Date: Thu, 17 Oct 2024 01:58:08 +0000

Patch series "Following cleanup after introduce mas_wr_store_type()", v2.

Patch 1 postpone new_end calculation when needed.
Patch 2 removes a unnecessary sanity check in mas_wr_slot_store().


This patch (of 2):

For wr_exact_fit/wr_new_root, we don't need to calculate new_end.

Let's postpone it until necessary.

Link: https://lkml.kernel.org/r/20241017015809.23392-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241017015809.23392-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-calculate-new_end-when-needed
+++ a/lib/maple_tree.c
@@ -4211,13 +4211,13 @@ static inline enum store_type mas_wr_sto
 	if (!wr_mas->entry)
 		mas_wr_extend_null(wr_mas);
 
-	new_end = mas_wr_new_end(wr_mas);
 	if ((wr_mas->r_min == mas->index) && (wr_mas->r_max == mas->last))
 		return wr_exact_fit;
 
 	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		return wr_new_root;
 
+	new_end = mas_wr_new_end(wr_mas);
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
 		if (!mte_is_root(mas->node) && !(mas->mas_flags & MA_STATE_BULK))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

