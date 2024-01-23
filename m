Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A1554BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970613; cv=none; b=UYbEAZywIVKITyFMIPBBt6mpyf7FdXrLVEAm59dP8lz9uXNuuTJQYh7gN28sy4A0azBEOXMwieB6jqoOH1oejO5+ISNXpY+DRoUKuQ0EnEhZPnEIQsdB0J0dAjs7e9/uLgSO0BIFS5Wq7DGsLCajO6QnJQwtJdyNIyA2qSwtpxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970613; c=relaxed/simple;
	bh=rMvpE6W6S4y/nXUrfNpJkxDoHfCGGyzz7Wcx4aiuNTA=;
	h=Date:To:From:Subject:Message-Id; b=FYvCzcJaXV008Bkp+me8OZo6JgnZIceMFq8eRxi7o/OmqWyDUHLG+Btrmpd9TeBVS0GZvKjse3UXgkgPEZRvpNHnDlT9+q+UvHLx6h2Q9+ZRWUwi1JZmLSWFUCp/LxiEjanxA7kLLQ6ABi7/WZyr9pvXgdseXZWNM6IizfoQtbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cu2nhRzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cu2nhRzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E0CC433F1;
	Tue, 23 Jan 2024 00:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970613;
	bh=rMvpE6W6S4y/nXUrfNpJkxDoHfCGGyzz7Wcx4aiuNTA=;
	h=Date:To:From:Subject:From;
	b=Cu2nhRzOxEdzrzh9BR1jBMMHs0Ugerc/vcHdK8TPLWpqj7wnSZa88M9q6CWo0IKv2
	 rNyM5NskMKqNOa20F+nD6UemG0iczmiQUdLc9RLkCPkbwkJXzt38Er/ksb0d7VlDMA
	 coDy349giJamv0BrSnAkq7PIf6glXuQP0NzsbOp0=
Date: Mon, 22 Jan 2024 16:43:29 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch added to mm-unstable branch
Message-Id: <20240123004332.95E0CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mempolicy: clean up minor dead code in queue_pages_test_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch

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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mempolicy: clean up minor dead code in queue_pages_test_walk()
Date: Mon, 22 Jan 2024 10:25:04 +0100

Commit 2cafb582173f ("mempolicy: remove confusing MPOL_MF_LAZY dead code")
removes MPOL_MF_LAZY handling in queue_pages_test_walk(), and with that,
there is no effective use of the local variable endvma in that function
remaining.

Remove the local variable endvma and its dead code. No functional change.

This issue was identified with clang-analyzer's dead stores analysis.

Link: https://lkml.kernel.org/r/20240122092504.18377-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/mempolicy.c~mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk
+++ a/mm/mempolicy.c
@@ -676,7 +676,6 @@ static int queue_pages_test_walk(unsigne
 {
 	struct vm_area_struct *next, *vma = walk->vma;
 	struct queue_pages *qp = walk->private;
-	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
 
 	/* range check first */
@@ -704,9 +703,6 @@ static int queue_pages_test_walk(unsigne
 	    !(flags & MPOL_MF_STRICT))
 		return 1;
 
-	if (endvma > end)
-		endvma = end;
-
 	/*
 	 * Check page nodes, and queue pages to move, in the current vma.
 	 * But if no moving, and no strict checking, the scan can be skipped.
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch
mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch

