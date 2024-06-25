Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A20317837A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340191; cv=none; b=hb75EC11zq8m1X32mCBYNdOgdZbmIvTMkVcMfoB1ZdY1IvdBZ5SvDoeZtBXE4KPBGgo9UgKHSg3CAK/KUjScOG4iky3GrFCVN7lIIjJ9R/jtjD9bHRUXq1bh+Hmn570Jid2EcGDqjXggNXPINksBfEFDhQSsUEKI5oJnIlROfdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340191; c=relaxed/simple;
	bh=TsySpuxboE3WgaUxjrzQ2uj6Vrcc/8Az7/v2mn6nWcw=;
	h=Date:To:From:Subject:Message-Id; b=OIM3XwtROBUjAUJsT1gLFebCfrhgZI7FlTb4hS3AkqRpo9uu566Db++mXGYhVQhoqL9PpdWRRUtxrfllaKDmpf0LXMNdlwxQiKSjWelD8LNrTZW6K3vLIzlo4iAUDaf3urhqZfHVCZRKmQ2n3xGplNkJcP6k8q5/8qO7tBgyoOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GMcBSRNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GMcBSRNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DDBC32781;
	Tue, 25 Jun 2024 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340191;
	bh=TsySpuxboE3WgaUxjrzQ2uj6Vrcc/8Az7/v2mn6nWcw=;
	h=Date:To:From:Subject:From;
	b=GMcBSRNoXwASDFfMFQo6T6ygfVqIV5ubqhVv+MM0VKitezn3IwCtT6KaggtBViasD
	 1bUY4dNgor1h6Suo2zRl9ca3msVbFSltE3hj+HfZqQpaAelDcmZg9PgJwx/TUzQ0Ht
	 acAgLnuVWOM9Z0E1ML6BpZVjVZR/QoOR9uErKQL8=
Date: Tue, 25 Jun 2024 11:29:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-simplify-gotos-in-page_cache_sync_ra.patch added to mm-unstable branch
Message-Id: <20240625182951.25DDBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: simplify gotos in page_cache_sync_ra()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-simplify-gotos-in-page_cache_sync_ra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-simplify-gotos-in-page_cache_sync_ra.patch

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
Subject: readahead: simplify gotos in page_cache_sync_ra()
Date: Tue, 25 Jun 2024 12:19:00 +0200

Unify all conditions for initial readahead to simplify goto logic in
page_cache_sync_ra().  No functional changes.

Link: https://lkml.kernel.org/r/20240625101909.12234-10-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/mm/readahead.c~readahead-simplify-gotos-in-page_cache_sync_ra
+++ a/mm/readahead.c
@@ -532,20 +532,19 @@ void page_cache_sync_ra(struct readahead
 	}
 
 	max_pages = ractl_max_pages(ractl, req_count);
+	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
 	/*
-	 * start of file or oversized read
-	 */
-	if (!index || req_count > max_pages)
-		goto initial_readahead;
-
-	/*
-	 * sequential cache miss
+	 * A start of file, oversized read, or sequential cache miss:
 	 * trivial case: (index - prev_index) == 1
 	 * unaligned reads: (index - prev_index) == 0
 	 */
-	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
-	if (index - prev_index <= 1UL)
-		goto initial_readahead;
+	if (!index || req_count > max_pages || index - prev_index <= 1UL) {
+		ra->start = index;
+		ra->size = get_init_ra_size(req_count, max_pages);
+		ra->async_size = ra->size > req_count ? ra->size - req_count :
+							ra->size >> 1;
+		goto readit;
+	}
 
 	/*
 	 * Query the page cache and look for the traces(cached history pages)
@@ -572,13 +571,6 @@ void page_cache_sync_ra(struct readahead
 	ra->start = index;
 	ra->size = min(contig_count + req_count, max_pages);
 	ra->async_size = 1;
-	goto readit;
-
-initial_readahead:
-	ra->start = index;
-	ra->size = get_init_ra_size(req_count, max_pages);
-	ra->async_size = ra->size > req_count ? ra->size - req_count :
-						ra->size >> 1;
 readit:
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra, 0);
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

