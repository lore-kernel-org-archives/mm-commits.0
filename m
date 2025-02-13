Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E1420D513
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 22:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484349; cv=none; b=uuRh0bsSXcK6AWDM9mEz+3jhP9iMUMnA2+T3GHUPSwtmRvpkWGF0RwTZyQ5akV03szAq5eYs5CxzGpZw9uvdUTFLaNrsif9RlHdzzF/7AieAqMiiPB66+STiUWI5vFHIR7pMIEWPY6yTfx28kVHla0Og4BAuMSVCaSOEAU7If0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484349; c=relaxed/simple;
	bh=uPmLGId7Rrf4+/i9+fHZBIuy8Uvs1fEH4RVLKe1OUlE=;
	h=Date:To:From:Subject:Message-Id; b=SZmH1usOaHT4iRF2MTsHXdfKWaSEt91mkw47EULPLXhZ20flVSreAdH+S4xANMI3HaYkoqYakzCTweDAiO1Bz6vdSfvJlb/QZIv9kGU5QmymtBQyz7l+eThB6+Xlohfr6ZzkVvYUhknbHRoA3XtZKARnGByNDrTbAvpA77GTjSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YXseTrLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YXseTrLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A3C4CED1;
	Thu, 13 Feb 2025 22:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739484348;
	bh=uPmLGId7Rrf4+/i9+fHZBIuy8Uvs1fEH4RVLKe1OUlE=;
	h=Date:To:From:Subject:From;
	b=YXseTrLzt9acd/N5UZTrbtHMizr5CaiEra2gQoiaSmmSvpoKUIfW+43cf2YXB+hz6
	 k3k1cqBBKL69rUFEYhM/ZFhC9rE9fIxu16xt1o8pZl8yc8MvvQ7VUDP38JEDxrtZo1
	 onM6BW7JUNc1QDgc1bpuCA5C4asIST1a3pafDITI=
Date: Thu, 13 Feb 2025 14:05:47 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,ptesarik@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch added to mm-unstable branch
Message-Id: <20250213220548.9D1A3C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove a BUG_ON() in mas_alloc_nodes()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch

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
From: Petr Tesarik <ptesarik@suse.com>
Subject: maple_tree: remove a BUG_ON() in mas_alloc_nodes()
Date: Thu, 13 Feb 2025 12:44:53 +0100

Remove a BUG_ON() right before a WARN_ON() with the same condition.

Calling WARN_ON() and BUG_ON() here is definitely wrong.  Since the goal is
generally to remove BUG_ON() invocations from the kernel, keep only the
WARN_ON().

Link: https://lkml.kernel.org/r/20250213114453.1078318-1-ptesarik@suse.com
Fixes: 067311d33e65 ("maple_tree: separate ma_state node from status")
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-a-bug_on-in-mas_alloc_nodes
+++ a/lib/maple_tree.c
@@ -1242,7 +1242,6 @@ static inline void mas_alloc_nodes(struc
 	if (mas->mas_flags & MA_STATE_PREALLOC) {
 		if (allocated)
 			return;
-		BUG_ON(!allocated);
 		WARN_ON(!allocated);
 	}
 
_

Patches currently in -mm which might be from ptesarik@suse.com are

maple_tree-remove-a-bug_on-in-mas_alloc_nodes.patch

