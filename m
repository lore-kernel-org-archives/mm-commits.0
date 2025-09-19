Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F3722B8B6
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313175; cv=none; b=WSv82LD7Qsox2ZzBDwyul23m47RCfFj+i2Uuwt9h/+WHsH2XibtxPqvKA9HlAcer/VqMpHpKcSV1VZkEQfmqJkoQSjYhs4Lq6wSPQL58NTFnaN30ZC5rMDLZovxG2ohv3mHXDtOYZ1qndNDSgOfv4rEEEU2XhQgCJsT/lNETSnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313175; c=relaxed/simple;
	bh=nrl0Ymy5V/7SVCgYLO1an0Sq7fCISpQ2BiOLW1V0G+Y=;
	h=Date:To:From:Subject:Message-Id; b=RZ18z7WukqhF78nEtY5rptXgmvXJumBJIzyC+4asnhu7SDjPhibTwyLJ7ASnZZey+IEJnBjoA/XDhLxMvhkrNs+JTu2yjglDTFcNX5fCc20l6Nsajdesyl+eiwJYzQgk8OQ3YjXYPfkHsKnjvoqJoL7gKlJHb4DFAd4D/UzmkPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/vZDwul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/vZDwul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5FDC4CEF7;
	Fri, 19 Sep 2025 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758313174;
	bh=nrl0Ymy5V/7SVCgYLO1an0Sq7fCISpQ2BiOLW1V0G+Y=;
	h=Date:To:From:Subject:From;
	b=O/vZDwulOHW+ZayOQEVVl0I38fjYEJlVPzVdwziCoSRmQtfAOVyzN8bzLmErOoz4D
	 I6hXuLUWmsaNLLmPbV9zgeexMxSqfXp06rB7cVMaRbjO1W71HlqqXcA8TfJgRTDHsd
	 bzbVVREib5n7IjN7p+QHZTNqKd2ydBbyMvIaWNPk=
Date: Fri, 19 Sep 2025 13:19:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-improve-mlock-tracking-for-large-folios.patch added to mm-unstable branch
Message-Id: <20250919201934.9E5FDC4CEF7@smtp.kernel.org>
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
Date: Fri, 19 Sep 2025 13:40:36 +0100

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

Link: https://lkml.kernel.org/r/20250919124036.455709-6-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

