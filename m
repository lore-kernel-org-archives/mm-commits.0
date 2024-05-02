Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA4628FC
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669721; cv=none; b=ROJnfaAMXpM4RXHWhIyZsLZkZ6eEgkF/b6sxf9wQHPk4n7bQ+9q/bjtxvTrXhDmPTZnPHedcQAGBRxz9W6Z3R1TZGHJ3fpnvaeAjRCU2dD2rAO6OZtd5cN2TIF6J0VprYBxH9IcdR6vvwjN3VN+1rDztqNRGJ38PQD1QHWNvt4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669721; c=relaxed/simple;
	bh=6G/CkZdHepaH1dxbM3FZO3BGsKQr6zX37ueHKyoOc9Q=;
	h=Date:To:From:Subject:Message-Id; b=OfIDOPF31gLqLnoIVJjorqwSx98AvDGb9rv+ycCmujNcg+w1k5V7xFiKVJJBPNAJLLUH7eFIl6aHR2coGfp2C9MvOZuuLy1JEgCuWcoqthTPeX9DKbfphCdlG9n42JhIAifEJRSihx7WlzyzWs2pWDCCCZrk/LwOuXD6kArSFUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qeTCZMX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qeTCZMX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0D0C113CC;
	Thu,  2 May 2024 17:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714669720;
	bh=6G/CkZdHepaH1dxbM3FZO3BGsKQr6zX37ueHKyoOc9Q=;
	h=Date:To:From:Subject:From;
	b=qeTCZMX8VyE1A9y6s1M6TUXGzx34B1yqmLejJpM7bC41Q+f4A+IsvnDGmC98AJiN5
	 eeKlN8vZr7DNJii88AbkP8XhCSF1MWU21v8XJxlJw6wJiBpti7mX9Dugi1uGbqwopV
	 53LTgePytGgn62FMUHEgJ4Sqtd+ai3B0APr9MMq8=
Date: Thu, 02 May 2024 10:08:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hch@lst.de,elver@google.com,dchinner@redhat.com,andreyknvl@gmail.com,david@fromorbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch added to mm-unstable branch
Message-Id: <20240502170840.5B0D0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-owner: use gfp_nested_mask() instead of open coded masking
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch

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
From: Dave Chinner <david@fromorbit.com>
Subject: mm/page-owner: use gfp_nested_mask() instead of open coded masking
Date: Tue, 30 Apr 2024 15:28:25 +1000

The page-owner tracking code records stack traces during page allocation. 
To do this, it must do a memory allocation for the stack information from
inside an existing memory allocation context.  This internal allocation
must obey the high level caller allocation constraints to avoid generating
false positive warnings that have nothing to do with the code they are
instrumenting/tracking (e.g.  through lockdep reclaim state tracking)

We also don't want recording stack traces to deplete emergency memory
reserves - debug code is useless if it creates new issues that can't be
replicated when the debug code is disabled.

Switch the stack tracking allocation masking to use gfp_nested_mask() to
address these issues.  gfp_nested_mask() naturally strips GFP_ZONEMASK,
too, which greatly simplifies this code.

Link: https://lkml.kernel.org/r/20240430054604.4169568-4-david@fromorbit.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/page_owner.c~mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking
+++ a/mm/page_owner.c
@@ -168,13 +168,8 @@ static void add_stack_record_to_list(str
 	unsigned long flags;
 	struct stack *stack;
 
-	/* Filter gfp_mask the same way stackdepot does, for consistency */
-	gfp_mask &= ~GFP_ZONEMASK;
-	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL | __GFP_NOLOCKDEP);
-	gfp_mask |= __GFP_NOWARN;
-
 	set_current_in_page_owner();
-	stack = kmalloc(sizeof(*stack), gfp_mask);
+	stack = kmalloc(sizeof(*stack), gfp_nested_mask(gfp_mask));
 	if (!stack) {
 		unset_current_in_page_owner();
 		return;
_

Patches currently in -mm which might be from david@fromorbit.com are

mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch

