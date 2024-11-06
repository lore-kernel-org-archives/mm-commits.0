Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7CF17CA1B
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854825; cv=none; b=OEeLK+h225c2Nm/rSbgo+0SeDQlQ+1/L4qFzV3X2KxmT5+HHZYQnN8/6WP0ZB4ETShVghtn+B3KwgGttdjWU+wcLCJoidp2SU7xyVglPrhu+e/5Ousa1LdkvbuPTQAy2sxzUqBTiTlqFjNG++cI1dxKZUteE/Pk42qh71A95rA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854825; c=relaxed/simple;
	bh=oddR3r2KkWeYgKOwiwFJChDIKj44rKCfgiY8zDieAoU=;
	h=Date:To:From:Subject:Message-Id; b=DyeKa7HgpHDb9uTl+/SCDvMMGmwS2wzlVykoDnC0o7MeLrqgovTIKVMnr9vf9NKlM0ePSTKj625UvNwTa1wO1A8iF8/0zvraAGKcaeScgqCyyKQG6YouVqaRKtYA5cFDtsEU5SG0KD8OnBjUMHqikaA4MEWyd1EsLZ4XrmRMqoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CavygdYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CavygdYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E0FC4CECF;
	Wed,  6 Nov 2024 01:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854824;
	bh=oddR3r2KkWeYgKOwiwFJChDIKj44rKCfgiY8zDieAoU=;
	h=Date:To:From:Subject:From;
	b=CavygdYZ7iKF2KzLp3dL+5yVTSi78hUmHno0bun9d/piOiX/wMwxIkKjaml0Nizg8
	 b+ekPw0dYu1VFPEmI3ddrSijIUtAxBKzklsarOFuw2i9DUroFZdNDNduVP/eZZ6aIT
	 yNKBUW/MHb7PSSEeWQzyRqcnWrNQty8/8fhJzkoE=
Date: Tue, 05 Nov 2024 17:00:24 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-calculate-new_end-when-needed.patch removed from -mm tree
Message-Id: <20241106010024.C5E0FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: calculate new_end when needed
has been removed from the -mm tree.  Its filename was
     maple_tree-calculate-new_end-when-needed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

