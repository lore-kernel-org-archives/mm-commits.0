Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AC717920C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340178; cv=none; b=AzpE1BF+pxX6pT25wisjx8TFMhLBn50URrUJWBgkX0uuJuaEZFIaQBHNj5wnTQ2a+dp1W4YfAKf3O8/0YYFHvnCDrHiRJx/fUQ0I1L6UDlJvS44hNtYxf1CslEoYeYtbhhgsr+br27J4tyI4+QbPue3D5Myl1LXQCDSzcIopXYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340178; c=relaxed/simple;
	bh=8wIC3/pijOaKmKiCAo9+4bewdTfJJjG1SmI/egxt/ec=;
	h=Date:To:From:Subject:Message-Id; b=CYg9PDg7y5ZLgBt2jJg1KZO6LL8dzcZRj8E1W6MWdQqE2rIHhjhh6piKWHp+PUAmc0/ZD0cL7ThwR+gBXye5jGcqrIL/KK7NIsZNbTQ2p1F6KM+G7lA1DWmrdZEzqk/tW9SqzIKqV8NZLMmv/Wfzra5q7XK5ePrVSwHsNqRmb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w489caNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w489caNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5535EC32781;
	Tue, 25 Jun 2024 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340177;
	bh=8wIC3/pijOaKmKiCAo9+4bewdTfJJjG1SmI/egxt/ec=;
	h=Date:To:From:Subject:From;
	b=w489caNftN+cq4I0t7KYXiozlJEyUWgKU1rI9138THIeDXYHxflhvklWOZgxaEddT
	 eaDLjg4L+5EdnzS8v/W4Lq5f0iaLRlBBz0/DXMNnZW8txslwWJ+oD8+mjZ10c3wmri
	 dA7z2eE+zB+azw30XZ/eGD+YWZi/DSaAjZWuWXhw=
Date: Tue, 25 Jun 2024 11:29:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch added to mm-unstable branch
Message-Id: <20240625182937.5535EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

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
Subject: readahead: properly shorten readahead when falling back to do_page_cache_ra()
Date: Tue, 25 Jun 2024 12:18:53 +0200

When we succeed in creating some folios in page_cache_ra_order() but then
need to fallback to single page folios, we don't shorten the amount to
read passed to do_page_cache_ra() by the amount we've already read.  This
then results in reading more and also in placing another readahead mark in
the middle of the readahead window which confuses readahead code.  Fix the
problem by properly reducing number of pages to read.

Link: https://lkml.kernel.org/r/20240625101909.12234-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra
+++ a/mm/readahead.c
@@ -491,7 +491,8 @@ void page_cache_ra_order(struct readahea
 		struct file_ra_state *ra, unsigned int new_order)
 {
 	struct address_space *mapping = ractl->mapping;
-	pgoff_t index = readahead_index(ractl);
+	pgoff_t start = readahead_index(ractl);
+	pgoff_t index = start;
 	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
@@ -544,7 +545,7 @@ void page_cache_ra_order(struct readahea
 	if (!err)
 		return;
 fallback:
-	do_page_cache_ra(ractl, ra->size, ra->async_size);
+	do_page_cache_ra(ractl, ra->size - (index - start), ra->async_size);
 }
 
 /*
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

