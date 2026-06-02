Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56B530C37A
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439037; cv=none; b=os4Jq3c9COc7cpF31cXNX7J9+g2YMjqc1enlfEGzJqtit4HwQC4DSRVUOn0bjUFl31M0xNYZGlz0402rCQ7ssVKKa6GJ3okrgW/eH+ogCf7ZiyVqbLHgc6O71Nw383Q9ITdKLShDkPPQoCZBjPR5Js/rsTIrpdw1EwegRb/V7pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439037; c=relaxed/simple;
	bh=psVYnE9G2I9GUNek3XK5T3Yke8opySGNwHKbb6MAmPo=;
	h=Date:To:From:Subject:Message-Id; b=jdVI14exSYk+nRuQFvgY4n9vAK6Y3jW3zn2wHPt6GkQUrDGw0pjuhqtg7WuxlJn1/U2Jg+EgOOvMioUArWoYxxZVCsakJKky8VdAvzL4xXbdydJKYfUtT1uiUQcCIwLd8S64Z6GaKAs/pRPJ+3LmeoaFUvtzc7aqdZxHmKb8pBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cLOuwRlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cLOuwRlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F61F00893;
	Tue,  2 Jun 2026 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439036;
	bh=bepBAU+krAy0MWa1xeyWudWlUlXNzXhE9+qJYNxhznI=;
	h=Date:To:From:Subject;
	b=cLOuwRlSwnKUrHyAH/4UKs89MMhLBPcODDxthybzff7uievT+mZc2r8sqAjifFlgV
	 4O+4FoGyJqg/4NcFFPevDA/ah7ZlXUnhZjMzrKGCopR6ko+/wBgPSUTMKaVLHFhAci
	 sl8Ila8kSEGYc+8e0KSdVVBWg6e2twqwR+xDS2Sc=
Date: Tue, 02 Jun 2026 15:23:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch removed from -mm tree
Message-Id: <20260602222356.6C5F61F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/readahead: simplify page_cache_ra_unbounded loop counter reset
has been removed from the -mm tree.  Its filename was
     mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frederick Mayle <fmayle@google.com>
Subject: mm/readahead: simplify page_cache_ra_unbounded loop counter reset
Date: Tue, 12 May 2026 13:31:36 -0700

Minor cleanup, no behavior change intended.

`read_pages` ensures that `ractl->_nr_pages` is zero before it returns, so
the `ractl->_nr_pages` term in these expressions contributes nothing. 
This seems to have been true since the statements were introduced in
commit f615bd5c4725f ("mm/readahead: Handle ractl nr_pages being
modified").

The new expression has an intuitive explanation.  When filesystems perform
readahead, they increment `ractl->_index` by the number of pages
processed, so, after `read_pages` returns, `ractl->_index` points to the
first page after those already processed.  `index` points to the first
page considered in the loop.  So, `ractl->_index - index` is the number of
pages processed by the loop so far.

Link: https://lore.kernel.org/20260512203154.754075-3-fmayle@google.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/readahead.c~mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset
+++ a/mm/readahead.c
@@ -281,7 +281,7 @@ void page_cache_ra_unbounded(struct read
 			 */
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 
@@ -297,7 +297,7 @@ void page_cache_ra_unbounded(struct read
 				break;
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 		if (i == mark)
_

Patches currently in -mm which might be from fmayle@google.com are


