Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6860D2391A0
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 21:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733348746; cv=none; b=jhXP3Z8oLBp4ff9tm9htz/EuLjYvKt7uCfJoMePtNZql4gdncjTkNL1sIKfpO//VbJPz8Mdey1u4IILbs7PjWY2pNn9q9jeO0pb8s/5RfL1JIDIFvdX/Bc/9kuTdKUdmEIPFtoAsuAC66lx3JmOaWcf7DfJXuLxPiOTt2jrICqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733348746; c=relaxed/simple;
	bh=BAv2LmCDiw6ZkJqNsHEyEB8KCQGmTL7gDmVP9UBEqQc=;
	h=Date:To:From:Subject:Message-Id; b=pfWTIHML2RQawiw9LDXT2ONN5wrhlZkORC8vbCnlubN6P03xGTfZJAw4UZMKFyL+fvm3vb6j7eT3NvqU/DFGeY6mBlwFH9HwnCGEMjss+KsWPYCmaf0EvuDTx4cIxbgjZRZWtjz9iJ7rNRESG6uFtyvsULJuIoG0uVD3H1mgOl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kkUqRvYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kkUqRvYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F5C4CECD;
	Wed,  4 Dec 2024 21:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733348745;
	bh=BAv2LmCDiw6ZkJqNsHEyEB8KCQGmTL7gDmVP9UBEqQc=;
	h=Date:To:From:Subject:From;
	b=kkUqRvYNEF0Dqt9zNVzN6GGDgUkWwoV3Pd2IANWn3lEdK4dqyZ5caWiu3DLCysCFm
	 oJdB0O6buItdxaYN+30ceDvyWewzWRplTyLkY/B6CpXUTu0uFtVFHtAk903OWf1Jqo
	 mHaVqTlSLRZnXMRlM2jeXw24+KVQqYkDOcQLK5bQ=
Date: Wed, 04 Dec 2024 13:45:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-dont-shorted-readahead-window-in-read_pages.patch added to mm-unstable branch
Message-Id: <20241204214545.D72F5C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: don't shorten readahead window in read_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     readahead-dont-shorted-readahead-window-in-read_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-dont-shorted-readahead-window-in-read_pages.patch

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
should set it manually similary as during expansion the filesystem can use
readahead_expand().

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

revert-readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch
readahead-dont-shorted-readahead-window-in-read_pages.patch
readahead-properly-shorten-readahead-when-falling-back-to-do_page_cache_ra.patch

