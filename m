Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9544028FC
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669685; cv=none; b=N2I0uJ07e5IuwiVT1oYbL7weS48WpULe2ziD7WGKAyzdr50uuBcEeSRDe4b12ZuxyHFwu2l+i0pQRNBhHhuDAc5uMDPryx9zbtQV1OKrGtCL3k8lwQwVJfvhL6zQIOiNxDQy50xKAaCap2aOm4AZ4DCCnrUqYFw0tovx3OpVa8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669685; c=relaxed/simple;
	bh=7YQA4BhsrIblVQmYOQI14CduyewjNolCTm0hOMLzCjo=;
	h=Date:To:From:Subject:Message-Id; b=fO9Af2YbUtlHtM7gNsK4hn5Vjaj8pTO7pKHzQk1pZQPE3cVIu/py4OUAUAt9jUX4u4vEPBBuI2C5byYv+HlhxVt6u8J63uVWCkz9xLUu7zLvI4PHACRNiyZPSJApqpvC+VUHmiBI1SrTCfaLlazByjLUzV4amAbOrCluF22zsnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqH8gtex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqH8gtex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAB2C113CC;
	Thu,  2 May 2024 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669685;
	bh=7YQA4BhsrIblVQmYOQI14CduyewjNolCTm0hOMLzCjo=;
	h=Date:To:From:Subject:From;
	b=lqH8gtexnDBO37/HomwvPHHQ97aSiC6aJ4cb8piQ/ZcDEVxhhGXWwW6DdKF43SI6N
	 EkLZb0k72kebTcIxfkFOy+MZpP8WS1to2fcDCKETnlc2P5jrPYG1uv99trIs1aJZos
	 X170Hpj4GHjdoRDa+797NjoRsQSxRO/b/4D7hprk=
Date: Thu, 02 May 2024 10:08:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hch@lst.de,elver@google.com,andreyknvl@gmail.com,dchinner@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch added to mm-unstable branch
Message-Id: <20240502170804.ECAB2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: stackdepot: use gfp_nested_mask() instead of open coded masking
has been added to the -mm mm-unstable branch.  Its filename is
     stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch

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
From: Dave Chinner <dchinner@redhat.com>
Subject: stackdepot: use gfp_nested_mask() instead of open coded masking
Date: Tue, 30 Apr 2024 15:28:24 +1000

The stackdepot code is used by KASAN and lockdep for recoding stack
traces.  Both of these track allocation context information, and so their
internal allocations must obey the caller allocation contexts to avoid
generating their own false positive warnings that have nothing to do with
the code they are instrumenting/tracking.

We also don't want recording stack traces to deplete emergency memory
reserves - debug code is useless if it creates new issues that can't be
replicated when the debug code is disabled.

Switch the stackdepot allocation masking to use gfp_nested_mask() to
address these issues.  gfp_nested_mask() also strips GFP_ZONEMASK
naturally, so that greatly simplifies this code.

Link: https://lkml.kernel.org/r/20240430054604.4169568-3-david@fromorbit.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/lib/stackdepot.c~stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking
+++ a/lib/stackdepot.c
@@ -624,15 +624,8 @@ depot_stack_handle_t stack_depot_save_fl
 	 * we won't be able to do that under the lock.
 	 */
 	if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
-		/*
-		 * Zero out zone modifiers, as we don't have specific zone
-		 * requirements. Keep the flags related to allocation in atomic
-		 * contexts, I/O, nolockdep.
-		 */
-		alloc_flags &= ~GFP_ZONEMASK;
-		alloc_flags &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
-		alloc_flags |= __GFP_NOWARN;
-		page = alloc_pages(alloc_flags, DEPOT_POOL_ORDER);
+		page = alloc_pages(gfp_nested_mask(alloc_flags),
+				   DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
_

Patches currently in -mm which might be from dchinner@redhat.com are

mm-lift-gfp_kmemleak_mask-to-gfph.patch
stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch

