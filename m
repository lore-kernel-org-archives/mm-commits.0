Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C4D17837A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340186; cv=none; b=uF/tWuP1Cy08CZu4MdjjfWhzdvqWELsWhVkc8Dp2vaH1B6lCDuwdkakHZKQ3x431sCMpiDpnZddQ+Y9Lw2ZGfOlpwON8kzNht0TSE7WQdxuYtNG/SvArppIYJ2GXqT9mkQfLdZVZY3mkuroVghFKPjSTAVFJvhx16fC9NzKV4ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340186; c=relaxed/simple;
	bh=Cx/nzkgv4lxQgBb0SvIwTMfw3jAmt30IgHCWnF2NzYk=;
	h=Date:To:From:Subject:Message-Id; b=sE7ebCKSV3j6wm9FGhmws+Vex+ROWPd55N2C9NHleB5i81hKT8gKeX8foTDUXlQT//gpH3RefQP4FbCpoNimK5VAC1ViXByn6+avMJADcaneby38jMk0C2vfPIyzLPjBjUXFZIoRtBaMQGB37r9Qd0osSrfg85tylyNhQNgvo/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eTAwvtPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTAwvtPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940EDC32781;
	Tue, 25 Jun 2024 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719340185;
	bh=Cx/nzkgv4lxQgBb0SvIwTMfw3jAmt30IgHCWnF2NzYk=;
	h=Date:To:From:Subject:From;
	b=eTAwvtPfMnSUuAAU1yANvYU4bZ14rG1ZDsgevkJQqV1PjfaYnje1puJx189RaXeI5
	 REd7kBaxAHQmRQVKZANdSmDdsoZsNmjJwmYm40kJG6TowJFlgeazpgL/du0svD9HHr
	 5VIP9LmJph0nY0qIZscHGVeJ7qzDM1vfA6+S9f7A=
Date: Tue, 25 Jun 2024 11:29:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,josef@toxicpanda.com,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-drop-dead-code-in-ondemand_readahead.patch added to mm-unstable branch
Message-Id: <20240625182945.940EDC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: drop dead code in ondemand_readahead()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-drop-dead-code-in-ondemand_readahead.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-drop-dead-code-in-ondemand_readahead.patch

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
Subject: readahead: drop dead code in ondemand_readahead()
Date: Tue, 25 Jun 2024 12:18:57 +0200

ondemand_readahead() scales up the readahead window if the current read
would hit the readahead mark placed by itself.  However the condition is
mostly dead code because:

a) In case of async readahead we always increase ra->start so ra->start
   == index is never true.

b) In case of sync readahead we either go through
   try_context_readahead() in which case ra->async_size == 1 < ra->size or
   we go through initial_readahead where ra->async_size == ra->size iff
   ra->size == max_pages.

So the only practical effect is reducing async_size for large initial
reads.  Make the code more obvious.

Link: https://lkml.kernel.org/r/20240625101909.12234-7-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/mm/readahead.c~readahead-drop-dead-code-in-ondemand_readahead
+++ a/mm/readahead.c
@@ -549,7 +549,6 @@ static void ondemand_readahead(struct re
 	struct backing_dev_info *bdi = inode_to_bdi(ractl->mapping->host);
 	struct file_ra_state *ra = ractl->ra;
 	unsigned long max_pages = ra->ra_pages;
-	unsigned long add_pages;
 	pgoff_t index = readahead_index(ractl);
 	pgoff_t expected, prev_index;
 	unsigned int order = folio ? folio_order(folio) : 0;
@@ -638,26 +637,10 @@ static void ondemand_readahead(struct re
 initial_readahead:
 	ra->start = index;
 	ra->size = get_init_ra_size(req_size, max_pages);
-	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
+	ra->async_size = ra->size > req_size ? ra->size - req_size :
+					       ra->size >> 1;
 
 readit:
-	/*
-	 * Will this read hit the readahead marker made by itself?
-	 * If so, trigger the readahead marker hit now, and merge
-	 * the resulted next readahead window into the current one.
-	 * Take care of maximum IO pages as above.
-	 */
-	if (index == ra->start && ra->size == ra->async_size) {
-		add_pages = get_next_ra_size(ra, max_pages);
-		if (ra->size + add_pages <= max_pages) {
-			ra->async_size = add_pages;
-			ra->size += add_pages;
-		} else {
-			ra->size = max_pages;
-			ra->async_size = max_pages >> 1;
-		}
-	}
-
 	ractl->_index = ra->start;
 	page_cache_ra_order(ractl, ra, order);
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

