Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82823A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836991; cv=none; b=pdZOnYOBh+sqhirFZSIxR22DjQc5Sxjl3DwZ3nbRrYcm8HWf/ysMPchm1p+7MR6d2WZAfsm3BFMr3zzBkbR3yy3nv1MZ2AzO5UzZ/w4vaY/b53GumyzLWIG0aVZR8GjJg2MP1WSeXo7ztHA+sRe2Fwen3Lb5kPaiuZuxuCzCDJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836991; c=relaxed/simple;
	bh=DDKYhvc2WhiCiFGx4F++uqS40vLe1WCEIfe8V32ujV0=;
	h=Date:To:From:Subject:Message-Id; b=q1AKWOBQYjpR+ZMUIakMVBqEv2vAfn3cd39vQmgMFTIfOPzFZmzctUv7RC0/+ihP5xmYK1Y6EbCoqGTiyfsCN0BTJX4MMGXXomiIWfMtxGDPLCKoJVcCVQfXmfK7SvgR0mV9rSjbq/GRQLmJ4bXQ8ZOcZx0g6ZR412LYYVSOuEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dyLMFhn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dyLMFhn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42664C4CEDD;
	Tue, 14 Jan 2025 06:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836991;
	bh=DDKYhvc2WhiCiFGx4F++uqS40vLe1WCEIfe8V32ujV0=;
	h=Date:To:From:Subject:From;
	b=dyLMFhn2JGX3/c2y6Hi//T6aId6w3ke7d0QNaLlOpZKVmuyCZPzMOakwFWLZtyU2s
	 SAmIREI71tRIFg+etkOubFTwWno/v0NkQdqeIePtch9QpY0Egyu1ONMWVWeIHVEDTP
	 1nhMM7PcCMhK8mnKaa3Opb2pnElJlN9qj389GDr8=
Date: Mon, 13 Jan 2025 22:43:10 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] readahead-dont-shorted-readahead-window-in-read_pages.patch removed from -mm tree
Message-Id: <20250114064311.42664C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: readahead: don't shorten readahead window in read_pages()
has been removed from the -mm tree.  Its filename was
     readahead-dont-shorted-readahead-window-in-read_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: readahead: don't shorten readahead window in read_pages()
Date: Wed, 4 Dec 2024 19:10:15 +0100

Patch series "readahead: Reintroduce fix for improper RA window sizing".

This small patch series reintroduces a fix of readahead window confusion
(and thus read throughput reduction) when page_cache_ra_order() ends up
failing due to folios already present in the page cache.  After thinking
about this for a while I have ended up with a dumb fix that just rechecks
if we have something to read before calling do_page_cache_ra().  This
fixes the problem reported in [1].  I still think it doesn't make much
sense to update readahead window size in read_pages() so patch 1 removes
that but the real fix in patch 2 does not depend on it.

[1] https://lore.kernel.org/all/49648605-d800-4859-be49-624bbe60519d@gmail.com
								

This patch (of 2):

When ->readahead callback doesn't read all requested pages, read_pages()
shortens the readahead window (ra->size).  However we don't know why pages
were not read and what appropriate window size is.  So don't try to
secondguess the filesystem.  If it needs different readahead window, it
should set it manually similarly as during expansion the filesystem can
use readahead_expand().

Link: https://lkml.kernel.org/r/20241204181016.15273-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20241204181016.15273-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/mm/readahead.c~readahead-dont-shorted-readahead-window-in-read_pages
+++ a/mm/readahead.c
@@ -158,20 +158,10 @@ static void read_pages(struct readahead_
 
 	if (aops->readahead) {
 		aops->readahead(rac);
-		/*
-		 * Clean up the remaining folios.  The sizes in ->ra
-		 * may be used to size the next readahead, so make sure
-		 * they accurately reflect what happened.
-		 */
+		/* Clean up the remaining folios. */
 		while ((folio = readahead_folio(rac)) != NULL) {
-			unsigned long nr = folio_nr_pages(folio);
-
 			folio_get(folio);
-			rac->ra->size -= nr;
-			if (rac->ra->async_size >= nr) {
-				rac->ra->async_size -= nr;
-				filemap_remove_folio(folio);
-			}
+			filemap_remove_folio(folio);
 			folio_unlock(folio);
 			folio_put(folio);
 		}
_

Patches currently in -mm which might be from jack@suse.cz are


