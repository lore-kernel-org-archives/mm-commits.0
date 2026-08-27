Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B0121ABAA
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 02:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787798909; cv=none; b=SuJ4+Dp7IIjJjY1vLfdD2GOceJWy4xoXS1KAvz0+/iA02bxUK7sZEDQjwklOShVMaCFkn/Ug/TtxbHarMuptvSEAhpafZG+Yrrklluu4rKApAmZn9eqjKDfH70JRdfAg8M7Glsx7cKqpr34IoCa2kCCRmDubUKqqGCXO5CdukPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787798909; c=relaxed/simple;
	bh=PbMuDn8whv9nON1jLMLEmbmsKMpSaFSjGLABZwfnw78=;
	h=Date:To:From:Subject:Message-Id; b=HYpczldStBJtUhB8QsYsrpsvJGaTc++Wp9y7RUaan5QhFmrwJDFxtpfyy1Ar7Y9vzFaJ7JXJLbrKBuxRaU4ABxpDaaWKqUFhjmLIxzyapuB7hxP8IZ3yLnc5nfmTIanL4eWljzzwvaqYpltc71yDCsRtYqq+7xwCbGIaqpzcP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hAmT1IYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hAmT1IYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0557D1F000E9;
	Thu, 27 Aug 2026 02:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787798908;
	bh=BXBrnxdqJeD1CV63iXJl0SOejE5IyXBqQ0S0kx8ozus=;
	h=Date:To:From:Subject;
	b=hAmT1IYK2kk8rwTIC6+p4kRaefAGPg0hghtWJr9bYMs2wuxnAO5nRuuw/f8E3Op2z
	 ouA6paJjBkpr5+s8e034vOgZr2UBLz3fyEy6ulBkJx7/5u1VYrflEjlQy5dnC411Qy
	 dnCKEPlTm++Fj4tbhZLtKI+SpBYV5JzUz+sbsLJo=
Date: Wed, 26 Aug 2026 19:48:27 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,steven.sistare@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch added to mm-new branch
Message-Id: <20260827024828.0557D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
Date: Tue, 25 Aug 2026 10:10:13 +0800

alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when dequeuing
a folio, but unlike the use_global_reservation handling in
hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the folio.

Its sole caller memfd_alloc_folio() pre-allocates a reservation via
hugetlb_reserve_pages() before allocating.  When
hugetlb_add_to_page_cache() fails, folio_put() drops the folio without
HPageRestoreReserve set, so free_huge_folio() does not restore the
reservation.  The subsequent hugetlb_unreserve_pages() on the err_unresv
path decrements the counter a second time, leaving resv_huge_pages off by
one for every failed allocation.

Set HPageRestoreReserve when consuming the reservation in
alloc_hugetlb_folio_reserve().  On the error path, free_huge_folio() then
restores the reservation before hugetlb_unreserve_pages() releases it. 
The success path is unaffected, as hugetlb_add_to_page_cache() clears the
flag once the folio is added to the page cache.

Link: https://lore.kernel.org/20260825021013.25672-1-hongfu.li@linux.dev
Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path
+++ a/mm/hugetlb.c
@@ -2178,8 +2178,10 @@ struct folio *alloc_hugetlb_folio_reserv
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
 					       nmask);
-	if (folio)
+	if (folio) {
+		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
+	}
 
 	spin_unlock_irq(&hugetlb_lock);
 	return folio;
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch

