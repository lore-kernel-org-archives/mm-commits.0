Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9971A23A6
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 02:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638573; cv=none; b=GtFGu5iztYfcE2E4D1Om0JYcX6pN3SEjSO/nl+xx1+gkYMoIyqKWpp9PCLgxL5chKTQSlyWT7udq/tuXPk6IKQnZkbmbIfb8quDRC8W/HWhDhinUHRsVYPnuYBBujjH80z9PtYygUayPELP99e8gQVBN6ZxL1KmhhDQEIYhI7f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638573; c=relaxed/simple;
	bh=j4uOvkqnqNgOJxI0xPSL/NBVgHsKRr3y+SK/mJ2+N/g=;
	h=Date:To:From:Subject:Message-Id; b=Heamrb0OStkfNOUegduaQopCbEWLpOAKIgUzkQuJ/aA5U7bsYzENOzGZ/BJN+mGgK1vqsLXktPU5UUUVYX0O1AIQNgPlRcfnzXbdy2Teea0ptXbk4mw8SoaVU9eKZCpeHHEMJ2wzCB44yx909tnasxwUgS3kgneSEExM2nsRcIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2iZeNB84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2iZeNB84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856F5C2BCB0;
	Wed, 13 May 2026 02:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778638572;
	bh=j4uOvkqnqNgOJxI0xPSL/NBVgHsKRr3y+SK/mJ2+N/g=;
	h=Date:To:From:Subject:From;
	b=2iZeNB84b2jrBanrzk9UhBvNVK4MovIcxEI/vR/+NdtdWQWW4YmEz34FpDUucTpXx
	 IXtuzPZUvwjzI9fuLyNpYQ2ohC6/z8jEpMUNJOJwrlyfpiNmQLzZ5klzBaPyf0xKHy
	 6d+w27RIoTCF/ekfisEfuAscj9ctVc9Xfmgq9m/U=
Date: Tue, 12 May 2026 19:16:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,fmayle@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch added to mm-new branch
Message-Id: <20260513021612.856F5C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/readahead: simplify page_cache_ra_unbounded loop counter reset
has been added to the -mm mm-new branch.  Its filename is
     mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch

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

mm-limit-filemap_fault-readahead-to-vma-boundaries.patch
mm-readahead-add-kerneldoc-for-read_pages.patch
mm-readahead-simplify-page_cache_ra_unbounded-loop-counter-reset.patch

