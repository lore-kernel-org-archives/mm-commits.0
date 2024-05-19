Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF771B4C
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154946; cv=none; b=g5xOJKcZN/oG8KnAC+OLUrnpTTvQLKE1ndXu3o1qIuqDxIpzWxQohMhOzfR2vGBAeEEgHWD61cmHIKKz8fKkghRpl+9ZuU1XKN9kmlqQ4R0rJBt98OuwQDgXTNwVWRy8rv2IBw36JrD/iI71DjZrL1v2JOdCO8ylFTUEhmxcY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154946; c=relaxed/simple;
	bh=JJHg+yERqczmOvaTzMNPPb7pbU236VVDUtkZv8bCNmU=;
	h=Date:To:From:Subject:Message-Id; b=oZu98Ml1PctsbJu0NFx77KpY/MjMDMGktlUKih72LZE6CcPqGID6wUoVBV8/kIlq7iMjlkXRdmsx6GiYfyBCSUAsJFy8GNF/WUxt30Htlg8g0Aw3+U+wUkZbA5Cnbtd7nJ/LcoHvrSRZzGcxnm2382IX9EzuKTF/VLdC4/Z3E+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zY45QkVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zY45QkVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3E0C32781;
	Sun, 19 May 2024 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154945;
	bh=JJHg+yERqczmOvaTzMNPPb7pbU236VVDUtkZv8bCNmU=;
	h=Date:To:From:Subject:From;
	b=zY45QkVXhInS5/+J9qi8F4QNtm27dN82051Dr2Wa5519ld6mKj86PGquY1/EgeG/M
	 lMWFHOBJtQurINNdxc4LKQzNg3bNa9b6fGKyqKtOfIyMlgGjipu2OXoIJa7QvEC6SE
	 hl5ZaV6zHBm7VtMuLGlH6rRkTfkjLF3eoon8Y+4g=
Date: Sun, 19 May 2024 14:42:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hch@lst.de,elver@google.com,dchinner@redhat.com,andreyknvl@gmail.com,david@fromorbit.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch removed from -mm tree
Message-Id: <20240519214225.5F3E0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-owner: use gfp_nested_mask() instead of open coded masking
has been removed from the -mm tree.  Its filename was
     mm-page-owner-use-gfp_nested_mask-instead-of-open-coded-masking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


