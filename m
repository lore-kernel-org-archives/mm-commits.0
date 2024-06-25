Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BE517CA0F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340189; cv=none; b=mFDQCpRI5DCTtdG6ixPGEjKqS5DJEkbyK34G8uVBsjRKIF39hwWDRyOvl83Mv735YTYleymbcip3x0a2zOCbiMuOQueMElOkXILl/VynoY/81Pq7G19nQuN6TJ6Fd28FZUmwVIy1Ml5P3aJNqO67LKMFfaEl66N0lKHm0GSz8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340189; c=relaxed/simple;
	bh=9NkW3XqIPUOxLjFJADti8AOqOXwvvMyyOgCFY6lTwm8=;
	h=Date:To:From:Subject:Message-Id; b=f67Qi28CLkgZgxhCQhSfuwfYWIlELLeuh5y4ZeiSRPu9CeZT/nUb4ril5BPZkybFbaQzjhNP59VFuP83f3FW5kDeOEa62k2V1UwaA94joEKVGz3v/7dOe1HtfrkmCimJAFy5FJWskFRY3LQv/QXJ9Jx64OQwEOVAwMICrQWodAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hF99TTgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hF99TTgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50803C32781;
	Tue, 25 Jun 2024 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340189;
	bh=9NkW3XqIPUOxLjFJADti8AOqOXwvvMyyOgCFY6lTwm8=;
	h=Date:To:From:Subject:From;
	b=hF99TTgGzI6URpDD7NAdxfrtZrY5XP59FXrUFTenOZtoXfQrpAhWxyyQ3HLFqp2wk
	 JQFk2fINFSBVYEFxzglGteKFGRTpvtW6Q2X8rS9KSeRbPfRzh6grhHNoA6pixU1eXu
	 XUDGchtTOFjw2kz4c8wzqV/bGo2wEfg4RngQr2l8=
Date: Tue, 25 Jun 2024 11:29:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-fold-try_context_readahead-into-its-single-caller.patch added to mm-unstable branch
Message-Id: <20240625182949.50803C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: fold try_context_readahead() into its single caller
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-fold-try_context_readahead-into-its-single-caller.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-fold-try_context_readahead-into-its-single-caller.patch

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
Subject: readahead: fold try_context_readahead() into its single caller
Date: Tue, 25 Jun 2024 12:18:59 +0200

try_context_readahead() has a single caller page_cache_sync_ra().  Fold
the function there to make ra state modifications more obvious.  No
functional changes.

Link: https://lkml.kernel.org/r/20240625101909.12234-9-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   84 ++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 62 deletions(-)

--- a/mm/readahead.c~readahead-fold-try_context_readahead-into-its-single-caller
+++ a/mm/readahead.c
@@ -410,58 +410,6 @@ static unsigned long get_next_ra_size(st
  * it approaches max_readhead.
  */
 
-/*
- * Count contiguously cached pages from @index-1 to @index-@max,
- * this count is a conservative estimation of
- * 	- length of the sequential read sequence, or
- * 	- thrashing threshold in memory tight systems
- */
-static pgoff_t count_history_pages(struct address_space *mapping,
-				   pgoff_t index, unsigned long max)
-{
-	pgoff_t head;
-
-	rcu_read_lock();
-	head = page_cache_prev_miss(mapping, index - 1, max);
-	rcu_read_unlock();
-
-	return index - 1 - head;
-}
-
-/*
- * page cache context based readahead
- */
-static int try_context_readahead(struct address_space *mapping,
-				 struct file_ra_state *ra,
-				 pgoff_t index,
-				 unsigned long req_size,
-				 unsigned long max)
-{
-	pgoff_t size;
-
-	size = count_history_pages(mapping, index, max);
-
-	/*
-	 * not enough history pages:
-	 * it could be a random read
-	 */
-	if (size <= req_size)
-		return 0;
-
-	/*
-	 * starts from beginning of file:
-	 * it is a strong indication of long-run stream (or whole-file-read)
-	 */
-	if (size >= index)
-		size *= 2;
-
-	ra->start = index;
-	ra->size = min(size + req_size, max);
-	ra->async_size = 1;
-
-	return 1;
-}
-
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
 		pgoff_t mark, unsigned int order, gfp_t gfp)
 {
@@ -561,8 +509,8 @@ void page_cache_sync_ra(struct readahead
 	pgoff_t index = readahead_index(ractl);
 	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
 	struct file_ra_state *ra = ractl->ra;
-	unsigned long max_pages;
-	pgoff_t prev_index;
+	unsigned long max_pages, contig_count;
+	pgoff_t prev_index, miss;
 
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
@@ -603,16 +551,28 @@ void page_cache_sync_ra(struct readahead
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(ractl->mapping, ra, index, req_count,
-			max_pages))
-		goto readit;
-
+	rcu_read_lock();
+	miss = page_cache_prev_miss(ractl->mapping, index - 1, max_pages);
+	rcu_read_unlock();
+	contig_count = index - miss - 1;
+	/*
+	 * Standalone, small random read. Read as is, and do not pollute the
+	 * readahead state.
+	 */
+	if (contig_count <= req_count) {
+		do_page_cache_ra(ractl, req_count, 0);
+		return;
+	}
 	/*
-	 * standalone, small random read
-	 * Read as is, and do not pollute the readahead state.
+	 * File cached from the beginning:
+	 * it is a strong indication of long-run stream (or whole-file-read)
 	 */
-	do_page_cache_ra(ractl, req_count, 0);
-	return;
+	if (miss == ULONG_MAX)
+		contig_count *= 2;
+	ra->start = index;
+	ra->size = min(contig_count + req_count, max_pages);
+	ra->async_size = 1;
+	goto readit;
 
 initial_readahead:
 	ra->start = index;
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

