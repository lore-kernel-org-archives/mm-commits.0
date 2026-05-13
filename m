Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3DF36D51D
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 23:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778716062; cv=none; b=IdV4XywfrE8IFSbyulW/7XkaGMZORd56gl57WBB3MRBl4ItbhDLI1VElmpxBd1tHofWt40iuc5bNNWnG516J6zd4pKx8gP0x/KakqjR0N1IABplo+SqK90cJhMA4Fq9pjNscc6rQsbAe//ia15AkEMPP9YR/gXow55QrVq/MwZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778716062; c=relaxed/simple;
	bh=ajuTFLZu49GzDH1wT3OydqV0vdUMRU1t3ZeczrcEBUg=;
	h=Date:To:From:Subject:Message-Id; b=TvMLu3bCEw8FaUU1lQ60jPwBbrRK1Ltu3gpjZfxNt56MsgNzIv92KIkFm4aUTA7lfH/3kACz4Lwi2MZqAyG49MCoDO6XbH0WkJNmnlKlNWYyMr8h49GpBS2GgWwCr86CcJX9DtFKiJnObmmqFuxqMgx7R6IOfzoih4Wrkqo8pgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQ6ffK4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQ6ffK4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05165C19425;
	Wed, 13 May 2026 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778716062;
	bh=ajuTFLZu49GzDH1wT3OydqV0vdUMRU1t3ZeczrcEBUg=;
	h=Date:To:From:Subject:From;
	b=GQ6ffK4AHeLbWmoyDlRwmdhRmtbo0vm6yoZ1aHvyWR7Z36wfHoqMT0BIv2hKDU9bV
	 MCxvrWqyVuIPd4fQFhwPDTlyTw2+Jmx63pKeBx84ZNgBOAxk5rZ8FBcaz7r17vMute
	 tRZR7CVbn9pNwI9gWS+thyZBZv26AU8TpnjulXwg=
Date: Wed, 13 May 2026 16:47:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,jack@suse.cz,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch added to mm-new branch
Message-Id: <20260513234742.05165C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: fix page_cache_prev_miss() when no hole is found
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/filemap: fix page_cache_prev_miss() when no hole is found
Date: Tue, 12 May 2026 16:45:59 -0400

page_cache_prev_miss() is documented to return a value outside the
searched range when no gap is found.  However, the no-gap-found path
returns xas.xa_index, which after a successful loop is the first index in
the range.  As such, that index is misreported as a gap.

The sole caller, page_cache_sync_ra(), uses the return value to estimate
the cached run preceding a sequential read.  In some cases, the buggy
return value can undercount the contiguous range by one, shrinking the
readahead window or pushing borderline requests into the small-random-read
branch.

Fix this by returning the start of the range - 1 when no hole is found. 
Update page_cache_next_miss() for clarity as well.

Both helpers were previously fixed together in commit 9425c591e06a ("page
cache: fix page_cache_next/prev_miss off by one"), but the fix was
reverted because it caused a hugetlb performance regression.  hugetlb no
longer uses these functions and next_miss was subsequently refixed in
commit 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no hole
found") and commit bbcaee20e03e ("readahead: fix return value of
page_cache_next_miss() when no hole is found"), but prev_miss was not
addressed.

This was found by pointing Claude Opus 4.7 at mm/filemap.c.

Link: https://lore.kernel.org/20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu
Fixes: 0d3f92966629 ("page cache: Convert hole search to XArray")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found
+++ a/mm/filemap.c
@@ -1807,9 +1807,8 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
-	unsigned long nr = max_scan;
 
-	while (nr--) {
+	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;
@@ -1817,7 +1816,8 @@ pgoff_t page_cache_next_miss(struct addr
 			return 0;
 	}
 
-	return index + max_scan;
+	/* Return end of the range + 1 when no hole is found */
+	return xas.xa_index + 1;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1848,12 +1848,13 @@ pgoff_t page_cache_prev_miss(struct addr
 	while (max_scan--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
+			return xas.xa_index;
 		if (xas.xa_index == ULONG_MAX)
-			break;
+			return ULONG_MAX;
 	}
 
-	return xas.xa_index;
+	/* Return start of the range - 1 when no hole is found */
+	return xas.xa_index - 1;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch

