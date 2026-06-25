Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5637B020
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 01:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782351867; cv=none; b=LE7YZXsTxc807VN2FE2MAPO/Ng/wQ2Ib+wBv1txcZVAW5nlvqPITmnOSpYczOmu9CSmdweYkMXbw6rD88eJdkE8SVp8NDm7r4YNKNIvskc8qAkQRryiacLvs89ncs6hZOEBBlL3maYhWVsLFwXyToakFmCGafJvUarUOlCukFTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782351867; c=relaxed/simple;
	bh=+9jpwTIOEZctUDbFGPZHjQ9+20zp0oUpSGmsmrzvrIE=;
	h=Date:To:From:Subject:Message-Id; b=Ir1mM+C8tdzsFRQfxKf9/w60sYVK7pzKfZSSRpfRZVm5bbfSob8i7zGfjup9IaV7xlLjNLqqmnZlJ5o5mryk+y+yYDaFy+BvAKEDUUh2LjYNpvVD0ijojOYL/plWvvSqQqEcjuXkT/VLB9hIDUcg0v5iSOloJb3v+YLOxoOjHsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUVABBmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUVABBmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEB41F000E9;
	Thu, 25 Jun 2026 01:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782351864;
	bh=fgj+XplLeB0hLxseDrIXLGOYa/bKiwFxJew05oJVi74=;
	h=Date:To:From:Subject;
	b=AUVABBmFSgrsGUX3GP2ARLhBN3iQP/j0BokNp+p3bM9YzGdZwd8eP53BKwtnN+XNs
	 QhqmvPgccIqlHHsYdRfkyVIgYOSh1/TZeTaV4n6GM6cbrYR+X4EMsyOmF2CvPu20Zb
	 oKHKoo0rB942sjbddcdP8Sn/qTIhwBatLKXRvrIo=
Date: Wed, 24 Jun 2026 18:44:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch added to mm-new branch
Message-Id: <20260625014424.9BEB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: reduce unnecessary xarray lookups when read cached pages
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: mm/filemap: reduce unnecessary xarray lookups when read cached pages
Date: Sat, 20 Jun 2026 14:24:45 +0800

Patch series "mm/filemap: reduce unnecessary xarray lookups".

This series optimizes xarray lookups in filemap by avoiding redundant
iterations after obtaining the last needed folio.  The boundary check is
moved to before advancing the xarray iterator, eliminating unnecessary
lookups and branches in the fast path.  This reduces the overhead of
filemap_get_read_batch() from 2.91% to 2.53% in 4k read tests.


This patch (of 2):

When reading small amounts of data from the page cache, only a single
folio is typically returned from filemap_read_get_batch().  In this case,
calling xas_advance() or xas_next() after adding the folio to the batch is
unnecessary and only introduces extra branches.

The same issue exists for large reads, where one additional xarray walk is
always performed before termination.

Quit the loop once we get the last folio in the range, so the final
redundant xarray advancement can be avoided.

The xas_next() does not update xa_index when xas->xa_node is set to
XAS_RESTART, so the put and retry path would not update xa_index, hence
the warning should therefore never trigger.

During the 4k reads test, the overhead of this function dropped from 2.91%
to 2.53%.

Link: https://lore.kernel.org/20260620062446.351475-2-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages
+++ a/mm/filemap.c
@@ -2467,11 +2467,14 @@ static void filemap_get_read_batch(struc
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
 
+	if (index > max)
+		return;
+
 	rcu_read_lock();
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		if (xa_is_value(folio))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2488,6 +2491,8 @@ static void filemap_get_read_batch(struc
 		if (folio_test_readahead(folio))
 			break;
 		xas_advance(&xas, folio_next_index(folio) - 1);
+		if (xas.xa_index >= max)
+			break;
 		continue;
 put_folio:
 		folio_put(folio);
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

mm-filemap-reduce-unnecessary-xarray-lookups-when-read-cached-pages.patch
mm-filemap-reduce-unnecessary-xarray-lookups-in-filemap_get_folios_contig.patch

