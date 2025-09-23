Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A45E26F2BE
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 21:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758663050; cv=none; b=ld6bOVKUQh+KxTuG1Ft5Dkgt5gvQ3bVTe8A8X02+Tzr7oKhspy/gfLy+S4DoSXV+kKYTLVc3rxXKhRm+WP6AFHqEaa4qQFP/zumy42+K0YMUuxcNFhaW6VNbP72xTkcAOZ9xxZ1/VxcNOKBc1iAKUhf2FJiIPphEb0YtLBQBCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758663050; c=relaxed/simple;
	bh=s1JL7SZQg77yDMcEOebOVZKGVeTPKmLXdKfgaSDyEf0=;
	h=Date:To:From:Subject:Message-Id; b=eXyxXGSsTZPLgOKig8cJyFdZxOdlEGNsE2oSAF5UY0rYU7Jkxd/Yrx+K+ByD5P4FOy4dOMfsyjsThkbwJZrY8Zw5oFblCi5KTJnVLUMvswKC9MHL+XX2oQrl3bMvy9rY4g4Q5230wF+5zlSD8r4QoqYYnsYYzwN//KSjHrsIJGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQMoR+Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQMoR+Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CB1C4CEF5;
	Tue, 23 Sep 2025 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758663050;
	bh=s1JL7SZQg77yDMcEOebOVZKGVeTPKmLXdKfgaSDyEf0=;
	h=Date:To:From:Subject:From;
	b=pQMoR+DbfpkpWBVf5tNVzGClXw70lDAhobN4+/Xlp4UMoRsxmX0DrQCHXdBNYOcFB
	 vW0XEw1JrKIZT4OVTZmaq0YENWc3NCRU/9XBelXMgx/jcF6ZlcY0FzJjcdL+Alhbcf
	 tclJij7tWU2oiCAAA+J6JlRRFr5ierMU87JUDP14=
Date: Tue, 23 Sep 2025 14:30:49 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-improve-mlock-tracking-for-large-folios.patch added to mm-unstable branch
Message-Id: <20250923213050.09CB1C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: improve mlock tracking for large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-improve-mlock-tracking-for-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-improve-mlock-tracking-for-large-folios.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: improve mlock tracking for large folios
Date: Tue, 23 Sep 2025 12:07:11 +0100

The kernel currently does not mlock large folios when adding them to rmap,
stating that it is difficult to confirm that the folio is fully mapped and
safe to mlock it.

This leads to a significant undercount of Mlocked in /proc/meminfo,
causing problems in production where the stat was used to estimate system
utilization and determine if load shedding is required.

However, nowadays the caller passes a number of pages of the folio that
are getting mapped, making it easy to check if the entire folio is mapped
to the VMA.

mlock the folio on rmap if it is fully mapped to the VMA.

Mlocked in /proc/meminfo can still undercount, but the value is closer the
truth and is useful for userspace.

Link: https://lkml.kernel.org/r/20250923110711.690639-7-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/mm/rmap.c~mm-rmap-improve-mlock-tracking-for-large-folios
+++ a/mm/rmap.c
@@ -1463,12 +1463,12 @@ static __always_inline void __folio_add_
 	}
 
 	/*
-	 * For large folio, only mlock it if it's fully mapped to VMA. It's
-	 * not easy to check whether the large folio is fully mapped to VMA
-	 * here. Only mlock normal 4K folio and leave page reclaim to handle
-	 * large folio.
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
 	 */
-	if (!folio_test_large(folio))
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
@@ -1601,8 +1601,13 @@ static __always_inline void __folio_add_
 
 	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
-	/* See comments in folio_add_anon_rmap_*() */
-	if (!folio_test_large(folio))
+	/*
+	 * Only mlock it if the folio is fully mapped to the VMA.
+	 *
+	 * Partially mapped folios can be split on reclaim and part outside
+	 * of mlocked VMA can be evicted or freed.
+	 */
+	if (folio_nr_pages(folio) == nr_pages)
 		mlock_vma_folio(folio, vma);
 }
 
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-filemap-map-entire-large-folio-faultaround.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

