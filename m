Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ECE71757
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716154944; cv=none; b=h3B0TaPDetjSi5x6rbzm3URiKGdqvNvE4Vg91kvxVrjWiEQwmxI7NIpUUtEi191Fdr1bN+eOzqKRnzoP1fmWQe38yIVXA8ZLabLmWTFAiHCK6tHwMQ5RAtQ8TVCc3GUlhtuuAVyV6xMmeebomABEFQqa6lr3LM1Aj8JwaiT+n6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716154944; c=relaxed/simple;
	bh=hLinZX4vHyLhnQNQ2YJRZNtyuE17lsmnYw3m0SCbZuQ=;
	h=Date:To:From:Subject:Message-Id; b=n80IicgHgH2sOp+sP8GdScYcBjjaUHhz+spiL3iFPuU5b55Lk8rIU7Id9QVhf/7YPLKenzEcW4f8k+/nKYetTEHCRSsB5PQoxmSCSuO2cm1BkOuEhwMI6RgDSqw9F8OZESepCgV4zUDtATy13D1R6Ppd/QyOIUsYZgd7wZbxiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NoGc4c6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NoGc4c6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C90C32781;
	Sun, 19 May 2024 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716154944;
	bh=hLinZX4vHyLhnQNQ2YJRZNtyuE17lsmnYw3m0SCbZuQ=;
	h=Date:To:From:Subject:From;
	b=NoGc4c6AOUN+M1qK7pWGe1P4Ecm3CT4ntDRG+H28pBLyv/ktXGPFQLNKzFECefmLa
	 zkF+G8e3nMVYpbe3NueaQ/GuG+5FrFfGuNNQ9jAanZ6gL7K/0iWZ2QAFVOVaqUNN8j
	 dJAq3UZ4TLyWt17cf/UDkLn+Wla7vS549kX7KFT0=
Date: Sun, 19 May 2024 14:42:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,hch@lst.de,elver@google.com,andreyknvl@gmail.com,dchinner@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch removed from -mm tree
Message-Id: <20240519214224.42C90C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: stackdepot: use gfp_nested_mask() instead of open coded masking
has been removed from the -mm tree.  Its filename was
     stackdepot-use-gfp_nested_mask-instead-of-open-coded-masking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


