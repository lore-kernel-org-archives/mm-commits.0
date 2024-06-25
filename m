Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF5D17837A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340179; cv=none; b=t0FqUIPRqc3+GTklIdnkcroTCHfters+SCSp1IRnJEMVWZ62r2AlrOg4+Q6rINOfvLFkDPMd6QI50IdJsjj0aeASfz4jP15jKyPv6+eK7hNmQCx0Ww6w0EA8W0786w37QMbFCRz7le4AU688e1+ijffEd99+M9HKCvLyXmgv8Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340179; c=relaxed/simple;
	bh=qvaJAiOm1vmP8Kd4T1/9yK8SpESbkm6c8pJwsMHsPp0=;
	h=Date:To:From:Subject:Message-Id; b=GK0RUb0MXDOw+KnTL5fit2mEtqt+1stT1a+x3xj7Jyw0COpasNVk5PpySIKNexXeFM2O4MU0Vt2VKroZyr/PnWeQBfUGbk00vs5MApSfrt0lTerfrA0m7avsH/IE7QmoVrsXt/tHh6ZTXhL3UT/vfTl99SfFaJJpo7t98QxOgCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B3SaRK53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B3SaRK53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1A2C32781;
	Tue, 25 Jun 2024 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340179;
	bh=qvaJAiOm1vmP8Kd4T1/9yK8SpESbkm6c8pJwsMHsPp0=;
	h=Date:To:From:Subject:From;
	b=B3SaRK53l7g/KHUjtPWzFFdi6PmGrhKGWeeeyRmTJItZCtj+kU6f4AenI7TkOkkev
	 GqTbYS3TTcBg9ZmP4iqLN23g9PDUf0BlNaJ5l6M6arefrmtLJCbdYmVuhCwW+7Kb3t
	 MEcoD8wcRi4IycGWVb5NX7iBK81eYJa/GtYjKc3w=
Date: Tue, 25 Jun 2024 11:29:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-drop-pointless-index-from-force_page_cache_ra.patch added to mm-unstable branch
Message-Id: <20240625182939.5F1A2C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: drop pointless index from force_page_cache_ra()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-drop-pointless-index-from-force_page_cache_ra.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-drop-pointless-index-from-force_page_cache_ra.patch

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
Subject: readahead: drop pointless index from force_page_cache_ra()
Date: Tue, 25 Jun 2024 12:18:54 +0200

Current index to readahead is tracked in readahead_control and properly
updated by page_cache_ra_unbounded() (read_pages() in fact).  So there's
no need to track the index separately in force_page_cache_ra().

Link: https://lkml.kernel.org/r/20240625101909.12234-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/readahead.c~readahead-drop-pointless-index-from-force_page_cache_ra
+++ a/mm/readahead.c
@@ -313,7 +313,7 @@ void force_page_cache_ra(struct readahea
 	struct address_space *mapping = ractl->mapping;
 	struct file_ra_state *ra = ractl->ra;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	unsigned long max_pages, index;
+	unsigned long max_pages;
 
 	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
 		return;
@@ -322,7 +322,6 @@ void force_page_cache_ra(struct readahea
 	 * If the request exceeds the readahead window, allow the read to
 	 * be up to the optimal hardware IO size
 	 */
-	index = readahead_index(ractl);
 	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
 	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
 	while (nr_to_read) {
@@ -330,10 +329,8 @@ void force_page_cache_ra(struct readahea
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		ractl->_index = index;
 		do_page_cache_ra(ractl, this_chunk, 0);
 
-		index += this_chunk;
 		nr_to_read -= this_chunk;
 	}
 }
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

