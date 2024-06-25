Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2F17B41E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340184; cv=none; b=W/VwLYCNxTSfuvQvN0ThYLg+SiCmHW5j0zrYhj9eoWY9X0reQv9eP9HqRMQja3WKVdZQVTZpQP1hVmd5ZVjTAhqyxjjEZH0DwbaaFlDeAV5uGAyCilFRYGG5pG9muBDhvzLifBUOppOXV9dw0KgtVCfLox4BBFGFJKsu81LlyVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340184; c=relaxed/simple;
	bh=pr7fbIbbdJaVVokqJo0Tz446TBvooOmkMX6FGgzk8gU=;
	h=Date:To:From:Subject:Message-Id; b=CYOPhpEpMOTKTXkUlPRtxPqPCHe+ll68ZumyuhEI6SXWEr1mmz8xUJEwWRqTqP8nheR0nlrJgpbIRpu2H/L6Xqg8wmaFoA3ibOfx3jyXAZzeEVWTfZzjnqcvrhHgRp6a004cbKzyNnk0p93U7xvRciCFlj1Bx+rNZL9o0RgcfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uW+NlH8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uW+NlH8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81ACC32781;
	Tue, 25 Jun 2024 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340183;
	bh=pr7fbIbbdJaVVokqJo0Tz446TBvooOmkMX6FGgzk8gU=;
	h=Date:To:From:Subject:From;
	b=uW+NlH8sjy5TxXaEGOQssm1jWAZRBSCQPJarEOPG+CSBWAutNtBpRlwu65pSRuMZf
	 UJUFwD3UccA/Kt+yam+PYehm+eEtuYp1x0+8/dy1Yb7Jlv6T8XQnrLyWwCJvdGRoEw
	 xV4kwiEBtGkMS5aIqBSvR022DhV9G8bpOW6+6w1M=
Date: Tue, 25 Jun 2024 11:29:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-drop-dead-code-in-page_cache_ra_order.patch added to mm-unstable branch
Message-Id: <20240625182943.C81ACC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: drop dead code in page_cache_ra_order()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-drop-dead-code-in-page_cache_ra_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-drop-dead-code-in-page_cache_ra_order.patch

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
From: Jan Kara <jack@suse.cz>
Subject: readahead: drop dead code in page_cache_ra_order()
Date: Tue, 25 Jun 2024 12:18:56 +0200

page_cache_ra_order() scales folio order down so that is fully fits within
readahead window.  Thus the code handling the case where we walked past
the readahead window is a dead code.  Remove it.

Link: https://lkml.kernel.org/r/20240625101909.12234-6-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/readahead.c~readahead-drop-dead-code-in-page_cache_ra_order
+++ a/mm/readahead.c
@@ -525,11 +525,6 @@ void page_cache_ra_order(struct readahea
 		index += 1UL << order;
 	}
 
-	if (index > limit) {
-		ra->size += index - limit - 1;
-		ra->async_size += index - limit - 1;
-	}
-
 	read_pages(ractl);
 	filemap_invalidate_unlock_shared(mapping);
 	memalloc_nofs_restore(nofs);
_

Patches currently in -mm which might be from jack@suse.cz are

revert-mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch
mm-avoid-overflows-in-dirty-throttling-logic.patch
readahead-make-sure-sync-readahead-reads-needed-page.patch
filemap-fix-page_cache_next_miss-when-no-hole-found.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-drop-pointless-index-from-force_page_cache_ra.patch
readahead-drop-index-argument-of-page_cache_async_readahead.patch
readahead-drop-dead-code-in-page_cache_ra_order.patch
readahead-drop-dead-code-in-ondemand_readahead.patch
readahead-disentangle-async-and-sync-readahead.patch
readahead-fold-try_context_readahead-into-its-single-caller.patch
readahead-simplify-gotos-in-page_cache_sync_ra.patch

