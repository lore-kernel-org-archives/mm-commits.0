Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3059914F9F9;
	Wed, 11 Jun 2025 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606973; cv=none; b=ogIm67eBEUmDtlG8xEKdItlc/9sBbDBDOAiq7qpYj8/YUiSdSpcJUJCgBkMjg6S6yBB05Lb4Dr0PnIaAeBwv74a2yESo+3MKUGh1eSIMCkrwMX79Fc550bYPm6WkPaJV4d4MWI6E47hyUYa1FwfkeDOOwBnxEMkBioUFqquS79k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606973; c=relaxed/simple;
	bh=dYs7pXrbZbO77LjwnPJlOMYmWNiX/mDFmzkxHu9oWKM=;
	h=Date:To:From:Subject:Message-Id; b=lRCixkAJEPwvWEj8BnPm5mRgDACqX6QT8/WRV7AnLrTeLcbGkIMNX5+BxPt5ELGH/j8Jhp0Enqm4c18UmchKxfWy94dTnNgT6w5429/ie1/4ptasfJZsX4Ewzv0O3tNJlsRZgoyu4udCMVQbbhshO0khEYWZBKbgYQuBVIQH1J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t0ERzUHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t0ERzUHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AADCC4CEF0;
	Wed, 11 Jun 2025 01:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749606972;
	bh=dYs7pXrbZbO77LjwnPJlOMYmWNiX/mDFmzkxHu9oWKM=;
	h=Date:To:From:Subject:From;
	b=t0ERzUHNZmdT4N2WP65g/I1lBaPRUFdeIOwto+MP/E9ITw8QKA4wqGHvUclOV8Dur
	 ozk+qyfMjMo6N8n82ZQkUJ535F9+9zkuXwLLc/pDDcDgCPrILRh5rESFPdxQ0aumCY
	 vr849c+wlCjr3T5VozpZP+H7uxgsNxKYU2tXCFis=
Date: Tue, 10 Jun 2025 18:56:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch added to mm-new branch
Message-Id: <20250611015612.9AADCC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix mt_destroy_walk() on root leaf node
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: maple_tree: fix mt_destroy_walk() on root leaf node
Date: Wed, 11 Jun 2025 01:12:51 +0000

Patch series "maple_tree: Fix the replacement of a root leaf node", v3.

On destroy we should set each node dead.  But current code miss this when
the maple tree has only the root node.

The reason is that mt_destroy_walk() leverages mte_destroy_descend() to
set the node dead, but this is skipped since the only root node is a leaf.

Patch 1 fixes this.

When adding a test case, I found we always get the new value even when we
leave the old root node not dead.  It turns out we always re-walk the tree
in mas_walk().  It looks like a typo on the status check of mas_walk().

Patch 2 fixes this.

Patch 3 adds a test case to assert retrieving new value when overwriting
the whole range to a tree with only root node.


This patch (of 3):

On destroy, we should set each node dead.  But current code miss this when
the maple tree has only the root node.

The reason is mt_destroy_walk() leverage mte_destroy_descend() to set node
dead, but this is skipped since the only root node is a leaf.

Fixes this by setting the node dead if it is a leaf.

Link: https://lkml.kernel.org/r/20250611011253.19515-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250611011253.19515-2-richard.weiyang@gmail.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple_tree-fix-mt_destroy_walk-on-root-leaf-node
+++ a/lib/maple_tree.c
@@ -5319,6 +5319,7 @@ static void mt_destroy_walk(struct maple
 	struct maple_enode *start;
 
 	if (mte_is_leaf(enode)) {
+		mte_set_node_dead(enode);
 		node->type = mte_node_type(enode);
 		goto free_leaf;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
maple_tree-restart-walk-on-correct-status.patch
maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

