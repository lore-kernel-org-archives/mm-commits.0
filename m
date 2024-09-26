Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C90D12F59C;
	Thu, 26 Sep 2024 21:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384652; cv=none; b=TAswbs3svDHqlypI4f3c/0ikhQbpEmkc0fuU5m3nQqVY/lYpOJ4KNWVF4hqVIHwv4uFd8BUOU9nA72BuanGYcTskvxdvx1H3cq/x57Vtew5wPcX1axkP/mb82bb2trGJn+IrM/sOjcdMlRiPY9WlxHVmrq3mgxVfwafiHHII7dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384652; c=relaxed/simple;
	bh=OYcDJRb+r8gmF8bEA3cJdw65i9Wpmql0YEGqkhKHHL8=;
	h=Date:To:From:Subject:Message-Id; b=YpHR/12m0zKUpExLs1XrYuoSubA3/r1Dy9UW5IDUwlHbpyAIhXTwaZuE9Sij5nl0YGRi/7dDkz0TllukKa2rHe6wXpnnA3Q7DcXUQ1kDSULcSKriJSwjWnnQMIfJ2fo8XMPf6o60vn++lFQkOVWJj0z84kVKbb3DMxtG+ENoFSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v+VVUEJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v+VVUEJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1EAC4CEC5;
	Thu, 26 Sep 2024 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384652;
	bh=OYcDJRb+r8gmF8bEA3cJdw65i9Wpmql0YEGqkhKHHL8=;
	h=Date:To:From:Subject:From;
	b=v+VVUEJ+b+lIWlG43b/Oi7N2JFzQqFWSGo1psby8vX1r7NI0Y4gp0e1zmexgIyDAe
	 wKx47kCic8ajiKf+qPdxen8PMXvispXJHxnCfmooB6AokbgCOXu4Dm/fYX4if9a+ct
	 xqTKYVOV+F+vNrAWqViCQ+wnBuKNrs4KDzHrrkFM=
Date: Thu, 26 Sep 2024 14:04:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch removed from -mm tree
Message-Id: <20240926210412.4D1EAC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix memfd_pin_folios hugetlb page allocation
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
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


