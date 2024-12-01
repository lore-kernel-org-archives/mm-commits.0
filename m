Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8B14A84
	for <mm-commits@vger.kernel.org>; Sun,  1 Dec 2024 07:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733036767; cv=none; b=Wf1gn611X/uxcYu5Pi4xuAHuvrD/R0UNDUDGmdZ1SH8gHvS+kpoefX3d0qBGOeYWDfFpt+iro0thTpZP4OQCnD8xD0rY3EYE8gISMox5/O/32ZVA590lq3OSGRq4pVc02sPqTBevqZSTjhcZ+Ez3wzFAZ89p4PfBZK2oTxONlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733036767; c=relaxed/simple;
	bh=n88qmnLUN5VRIxg/EOi00CyzH/1zKzz1/XAlA5bbTWM=;
	h=Date:To:From:Subject:Message-Id; b=B2kIoX/RXDvxyJnmFc0oV+r/Di6Kk5EpNGQqC5cktJ9lCw/XTpJ9a5+MkPeYPdf+OKU1oDoVCYIn7/GSDcnTq8VFnaDEFI3uf4y9Biczv0jl12DYFTMV7eAD1lkHmVE3VqIzVY5K3TRW3zW66FbuZoeSpQ3hBOxMnJKQgT7wnwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYEyhKjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYEyhKjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F395C4CECF;
	Sun,  1 Dec 2024 07:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733036767;
	bh=n88qmnLUN5VRIxg/EOi00CyzH/1zKzz1/XAlA5bbTWM=;
	h=Date:To:From:Subject:From;
	b=IYEyhKjrDcd02vyObT6JPvgA5Z7yt9QnWLVtyaIyDzSWH1rGZQGwyzc+GiykhofuE
	 Aqx18yAbeWt99/BGIF3ChMCpe4ccXrhhtS6luAaSkHjHh+VTXImCuoUw0NL9xoHEFs
	 H35oPfarMot75maWE5RV8lUWVCxh/idqHYw3RAtg=
Date: Sat, 30 Nov 2024 23:06:06 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-use-mas_next_slot-directly.patch added to mm-unstable branch
Message-Id: <20241201070607.4F395C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: use mas_next_slot() directly
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-use-mas_next_slot-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-use-mas_next_slot-directly.patch

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
Subject: maple_tree: use mas_next_slot() directly
Date: Mon, 25 Nov 2024 02:41:56 +0000

The loop condition makes sure (mas.last < max), so we can directly use
mas_next_slot() here.

Since no other use of mas_next_entry(), it is removed.

Link: https://lkml.kernel.org/r/20241125024156.26093-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-mas_next_slot-directly
+++ a/lib/maple_tree.c
@@ -4745,29 +4745,6 @@ again:
 }
 
 /*
- * mas_next_entry() - Internal function to get the next entry.
- * @mas: The maple state
- * @limit: The maximum range start.
- *
- * Set the @mas->node to the next entry and the range_start to
- * the beginning value for the entry.  Does not check beyond @limit.
- * Sets @mas->index and @mas->last to the range, Does not update @mas->index and
- * @mas->last on overflow.
- * Restarts on dead nodes.
- *
- * Return: the next entry or %NULL.
- */
-static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
-{
-	if (mas->last >= limit) {
-		mas->status = ma_overflow;
-		return NULL;
-	}
-
-	return mas_next_slot(mas, limit, false);
-}
-
-/*
  * mas_rev_awalk() - Internal function.  Reverse allocation walk.  Find the
  * highest gap address of a given size in a given node and descend.
  * @mas: The maple state
@@ -6937,7 +6914,7 @@ retry:
 		goto unlock;
 
 	while (mas_is_active(&mas) && (mas.last < max)) {
-		entry = mas_next_entry(&mas, max);
+		entry = mas_next_slot(&mas, max, false);
 		if (likely(entry && !xa_is_zero(entry)))
 			break;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-use-mas_next_slot-directly.patch
maple_tree-index-has-been-checked-to-be-smaller-than-pivot.patch
maple_tree-not-possible-to-be-a-root-node-after-loop.patch
maple_tree-we-dont-set-offset-to-maple_node_slots-on-error.patch
maple_tree-simplify-split-calculation.patch
maple_tree-add-a-test-check-deficient-node.patch
maple_tree-only-root-node-could-be-deficient.patch

