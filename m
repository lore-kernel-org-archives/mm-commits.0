Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DE33B9DAB
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439055; cv=none; b=oW3ibnlng4AyKGTl25wFEA3CK2btsA4j3eOTEDQ2TRZlsgkc1QdvqKp6yHXoBIujVPYXQ2+LuMiEyaq+QU5dwAnhFOgLkDpIQqy8/cBFPrAkmFbk0mx7GjEO/oArQrSNsZc5vdXHS+7udRoE5oQ4FHlhSqWRgbfZpiLwTNEW4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439055; c=relaxed/simple;
	bh=oPJe2eCsAyVviHB9wBz128wwhi5goKbBCBOEo/NjGiw=;
	h=Date:To:From:Subject:Message-Id; b=Gb5fG0mAP4fqFYMqdKojQuwOweynC57U2wdy30aUWzMcLbSslS6GFlXYMYgttVCUEcZ0sMSVxzE4n1zfEIRhzxWfWSsjit/3kl9OIaHkaF8hSE6Vp6SH5Duwvk16AmGDwadlp22DZLiChQrKt3sZWIChHGq0lwasYf6BqmF2h28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gaKfnmSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gaKfnmSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD01F00893;
	Tue,  2 Jun 2026 22:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439053;
	bh=P4OQXqQ8OgBrY983hPjH941Os2aWS3Nn948q1nzYI64=;
	h=Date:To:From:Subject;
	b=gaKfnmSguVj/QtrWpYDsBU5FK/NXDLcG8mCpRG9SH7sliRtcR3VsBTDkTvmXdeEpq
	 u+oAPbV/sbJJKRmTbdaAGUY5b9Tqld4VYBZe3//XITaUb5tR8spnf0wHEwiTE+gQEs
	 mIUhnXc15Cm1Cp8iWm7dlusxcp9GYtE5mk7FB4oY=
Date: Tue, 02 Jun 2026 15:24:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,jack@suse.cz,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch removed from -mm tree
Message-Id: <20260602222413.89CD01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: fix page_cache_prev_miss() when no hole is found
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-page_cache_prev_miss-when-no-hole-is-found.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1808,9 +1808,8 @@ pgoff_t page_cache_next_miss(struct addr
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
-	unsigned long nr = max_scan;
 
-	while (nr--) {
+	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;
@@ -1818,7 +1817,8 @@ pgoff_t page_cache_next_miss(struct addr
 			return 0;
 	}
 
-	return index + max_scan;
+	/* Return end of the range + 1 when no hole is found */
+	return xas.xa_index + 1;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1849,12 +1849,13 @@ pgoff_t page_cache_prev_miss(struct addr
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


