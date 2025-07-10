Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773784C97
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 22:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752186817; cv=none; b=ANVgX5OIVCb1s3VKlNnKv5bR7z1yltDaWDnx+A+j+bvg+R+QKyoMMLrxHBN8jzh2geZVsY34zctB8FwtAXIzM1DiV2PA5nvKopj4v9kX+dS2FtN/bJ7vRHfjF6wNd2giCYbqnki3HqobGA1/bpkVnIyuDuq9mStFxscm8G/fbws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752186817; c=relaxed/simple;
	bh=QRGUweNOqO4F0fjNe95Vmk5VDpYZYkIVKQUwmT/DwYE=;
	h=Date:To:From:Subject:Message-Id; b=ttjNvJLNrBBRAGwaCPMcYtNVlSibHlKqKqaO0Gpq+HwUU5bb8VVUjjhoHcnz+w5Pe2SuksapOJqdioR+mwHxeEiFCJjibRPkTTexlmPu1jkeabyz/kk9Rhk2gN+PZeDfwRb2b2dSGfxNSPPqMzID85MMkWBGmGpGmr9MigAO7T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iI8D1iQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iI8D1iQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032F6C4CEED;
	Thu, 10 Jul 2025 22:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752186817;
	bh=QRGUweNOqO4F0fjNe95Vmk5VDpYZYkIVKQUwmT/DwYE=;
	h=Date:To:From:Subject:From;
	b=iI8D1iQblwSKsPsfNMTwyHlv2mlLdlYyYdoDsKmGmdFq1oJpzHoLE6y0tB6SP+6wo
	 WCgKg5hJkxYtZ8qtPmsChvIVdlrBJS2Zb4LNQoDfilbWCYX+NPz0aB6dzlRUMufIdF
	 e91YAMbklRtzLjaJMH6g+SOrcRhk9dNKqA7IXwaA=
Date: Thu, 10 Jul 2025 15:33:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,chizhiling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + readahead-use-folio_nr_pages-instead-of-shift-operation.patch added to mm-new branch
Message-Id: <20250710223337.032F6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: readahead: use folio_nr_pages() instead of shift operation
has been added to the -mm mm-new branch.  Its filename is
     readahead-use-folio_nr_pages-instead-of-shift-operation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/readahead-use-folio_nr_pages-instead-of-shift-operation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Chi Zhiling <chizhiling@kylinos.cn>
Subject: readahead: use folio_nr_pages() instead of shift operation
Date: Thu, 10 Jul 2025 14:04:51 +0800

folio_nr_pages() is faster helper function to get the number of pages when
NR_PAGES_IN_LARGE_FOLIO is enabled.

Link: https://lkml.kernel.org/r/20250710060451.3535957-1-chizhiling@163.com
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~readahead-use-folio_nr_pages-instead-of-shift-operation
+++ a/mm/readahead.c
@@ -649,7 +649,7 @@ void page_cache_async_ra(struct readahea
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
 	expected = round_down(ra->start + ra->size - ra->async_size,
-			1UL << folio_order(folio));
+			folio_nr_pages(folio));
 	if (index == expected) {
 		ra->start += ra->size;
 		/*
_

Patches currently in -mm which might be from chizhiling@kylinos.cn are

readahead-use-folio_nr_pages-instead-of-shift-operation.patch

