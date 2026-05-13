Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91B43921D0
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778696617; cv=none; b=k2OpqcNjSIEF2L9jgKHTcHaRQK/f8ktUWXO3I62cKXLng2ckYyj671SWubAlxjfkLxBPoFB27LZez2WfkqI1tMpUzriNRtdskkxGi7ZvC0YYs87fi5/3dzIuHq/HdCykO1z/fWMUMPDMlzGxg0SPPfsxWQLvTdhvOyh1LPVnkW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778696617; c=relaxed/simple;
	bh=Y6IiloJ/8PgvuH3arIgd5AiazoxQizdtMrLqg+3n2bY=;
	h=Date:To:From:Subject:Message-Id; b=Fl6T2yhucoa7VJVifR9JnfNyceyrYnduPPPrjyazC+GZwYF0CXSss4pGzxAxYZIMvOFc7uT/DcyuhKH1aRy1xiRYAu95Nh/C/sXUmp5N3KiaqBFlWWti0xhT7LXs4S+WVYQmaG1ENYnB7WoQm3CRPtD97i4+HC4MidBdz9WE7BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SdG/LzDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdG/LzDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46473C19425;
	Wed, 13 May 2026 18:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778696617;
	bh=Y6IiloJ/8PgvuH3arIgd5AiazoxQizdtMrLqg+3n2bY=;
	h=Date:To:From:Subject:From;
	b=SdG/LzDdR5yf0434ouSSwbYXFDErivundx1yvUpZLjr39jHZr5BnRqNY3YwsHAu8y
	 OjeMvmS+NMchEg6dS8Tfsfrpgeue3geCx4U5kH/NIeVpVDHTwPaDoOfSYAwVo+5BXe
	 AjJ+1e9rk3fnMe+riCzcyfW/8TxSJMRSifFvZOq0=
Date: Wed, 13 May 2026 11:23:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,kaleshsingh@google.com,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-no-pg_readahead-on-eof.patch added to mm-new branch
Message-Id: <20260513182337.46473C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: no PG_readahead on EOF
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-no-pg_readahead-on-eof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-no-pg_readahead-on-eof.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Frederick Mayle <fmayle@google.com>
Subject: mm/readahead: no PG_readahead on EOF
Date: Fri, 8 May 2026 11:12:31 -0700

When readahead pulls in all the remaining pages for a file, setting the
readahead bit is counter productive.  The async readahead it would trigger
would almost certainly be a no-op.  Additionally, for mmap'd file IO, the
readahead bit limits the fault around [1], causing an extra minor fault
when the page is accessed.

This was discovered when looking at /sys/kernel/tracing/events/readahead
traces for a simple program.  With the patch applied, fewer
page_cache_ra_unbounded calls are observed.

[1] do_fault_around calls filemap_map_pages, which finds eligible pages
    by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
    with PG_readahead set [3].

Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3939 [2]
Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3722 [3]
Link: https://lore.kernel.org/20260508181237.670645-1-fmayle@google.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/readahead.c~mm-readahead-no-pg_readahead-on-eof
+++ a/mm/readahead.c
@@ -340,8 +340,11 @@ static void do_page_cache_ra(struct read
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
-	if (nr_to_read > end_index - index)
+	if (nr_to_read > end_index - index) {
 		nr_to_read = end_index - index + 1;
+		/* We've reached the end, so don't set a readahead marker. */
+		lookahead_size = 0;
+	}
 
 	filemap_invalidate_lock_shared(mapping);
 	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
@@ -485,7 +488,7 @@ void page_cache_ra_order(struct readahea
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
 	pgoff_t limit;
-	pgoff_t mark = index + ra->size - ra->async_size;
+	pgoff_t mark;
 	unsigned int nofs;
 	int err = 0;
 	gfp_t gfp = readahead_gfp_mask(mapping);
@@ -499,7 +502,13 @@ void page_cache_ra_order(struct readahea
 
 	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
 	limit = min(limit, ractl->_max_index);
-	limit = min(limit, index + ra->size - 1);
+	if (limit > index + ra->size - 1) {
+		limit = index + ra->size - 1;
+		mark = index + ra->size - ra->async_size;
+	} else {
+		/* We've reached the end, so don't set a readahead marker. */
+		mark = ULONG_MAX;
+	}
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);
 	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
_

Patches currently in -mm which might be from fmayle@google.com are

mm-limit-filemap_fault-readahead-to-vma-boundaries.patch
mm-readahead-add-kerneldoc-for-read_pages.patch
mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch
mm-readahead-no-pg_readahead-on-eof.patch

