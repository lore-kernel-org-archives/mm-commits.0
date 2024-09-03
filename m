Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BEE1DC745
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394967; cv=none; b=W/u6M4/7SG/tDz4vJ18srapBqMzGamF76i73hxmECM6untUu0ikxKZDEALKpNhOjC+5Bs4SIuWf114zaF4rfXsTZnXjMpeqTNaqesFaPaulwwdnrOEg1yz5NsZnR+i1I7tjVUFz+Wt3nEULh6zReXjA2trLb7NKpB+/d34CWEoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394967; c=relaxed/simple;
	bh=mq0qnmO/VSrY5lrhp6XgxsqxGModJiBLySlHZnIe/gY=;
	h=Date:To:From:Subject:Message-Id; b=jA+OA89xRAN5aPkhbgiRb1yqKO/q8E3UXy+f8ee+A9yZ0xikmQ7wXWb221sK/jionLhUIRngud23tifRyxA8Rud/XLnpJGnf3CxmxmSRYUdAclfIXVi8t4X0+A4AuBhp/dPLMBYbbYbpVKTBiL8v9jRtjP7tJbA72eUIP5ZMMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGND1j2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGND1j2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36948C4CEC4;
	Tue,  3 Sep 2024 20:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725394967;
	bh=mq0qnmO/VSrY5lrhp6XgxsqxGModJiBLySlHZnIe/gY=;
	h=Date:To:From:Subject:From;
	b=ZGND1j2fgK2G8nfzWb9D4guFkE5L3toqhGTXO7Y8AstTYeWwhYTqYmzUCFwaveglx
	 yti6c/jV8ug8SFIiI80pH05Aun5MwhMA4dBclhtqhqnNK1bFWTfgT+6nj33u/I3MAN
	 4FCFw8+UZ9RtLsFVkYYjAIou2YEnYi0uasnZcTJ0=
Date: Tue, 03 Sep 2024 13:22:46 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20240903202247.36948C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: fix memfd_pin_folios hugetlb page allocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm/gup: fix memfd_pin_folios hugetlb page allocation
Date: Tue, 3 Sep 2024 07:25:20 -0700

When memfd_pin_folios -> memfd_alloc_folio creates a hugetlb page, the
index is wrong.  The subsequent call to filemap_get_folios_contig thus
cannot find it, and fails, and memfd_pin_folios loops forever.  To fix,
adjust the index for the huge_page_order.

memfd_alloc_folio also forgets to unlock the folio, so the next touch of
the page calls hugetlb_fault which blocks forever trying to take the lock.
Unlock it.

Link: https://lkml.kernel.org/r/1725373521-451395-5-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation
+++ a/mm/memfd.c
@@ -79,10 +79,13 @@ struct folio *memfd_alloc_folio(struct f
 		 * alloc from. Also, the folio will be pinned for an indefinite
 		 * amount of time, so it is not expected to be migrated away.
 		 */
-		gfp_mask = htlb_alloc_mask(hstate_file(memfd));
+		struct hstate *h = hstate_file(memfd);
+
+		gfp_mask = htlb_alloc_mask(h);
 		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
+		idx >>= huge_page_order(h);
 
-		folio = alloc_hugetlb_folio_reserve(hstate_file(memfd),
+		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
@@ -95,6 +98,7 @@ struct folio *memfd_alloc_folio(struct f
 				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
+			folio_unlock(folio);
 			return folio;
 		}
 		return ERR_PTR(-ENOMEM);
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

