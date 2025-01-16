Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A3913B58A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006318; cv=none; b=tz393QHsSwxoeL9CA8Qc8pGdZ46viBh+pb7WNvLwkIECEQUJDHAaSniL9C8IyZMKol8EgspysPgIt9YRIkSmfo7nr6FE1MfYtZyG9b7t8XCzhNrwwY4G6i0eXVrg6+ll8ePP1wulqhZhhcqKXM5vQsRuV0/gcd1Yol/HGnIWshQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006318; c=relaxed/simple;
	bh=hcf3tRWEVYrX59Hw3mT6f8HYk79WHRo+VrRLGAxKtig=;
	h=Date:To:From:Subject:Message-Id; b=mtXb8IVH+elMvbDg0y0zCkDjYSq3v4TfkUDKdShNElnQvOxC0E7Ng016CzdVCjvLSEUztUlHU9YRAOOcaMaYguV26Jvfyl2XwQqHTdltwewyQukCcgpt8AAotikLRV8MnoWArCF4FSubEN3G9Ddy7m4Ql/1cMsN1IDKSw1ieZy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oJ6VSot9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oJ6VSot9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942E8C4CED6;
	Thu, 16 Jan 2025 05:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006316;
	bh=hcf3tRWEVYrX59Hw3mT6f8HYk79WHRo+VrRLGAxKtig=;
	h=Date:To:From:Subject:From;
	b=oJ6VSot9RBsAW7kHLE3XhxWaOku6oIcxM6+RZnV7dNPSSKz2loO6euiU9Po1EIQ8E
	 CB2T2/Q75RzjHDlgD7JMS2pXPaqxX4+K+Nd1sA0nKs08s7FG29kP2YMG2OSRjzeK0A
	 cemJ2nAJePeAZlLnogeyzGslyEqDTD23k0ZPUMUE=
Date: Wed, 15 Jan 2025 21:45:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,baolin.wang@linux.alibaba.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch removed from -mm tree
Message-Id: <20250116054516.942E8C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/hugetlb: use folio->lru int demote_free_hugetlb_folios()
Date: Mon, 13 Jan 2025 14:16:11 +0100

We are demoting hugetlb folios to smaller hugetlb folios; let's avoid
messing with pages where avoidable and handle it more similar to
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20250113131611.2554758-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios
+++ a/mm/hugetlb.c
@@ -3826,13 +3826,15 @@ static long demote_free_hugetlb_folios(s
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
 			struct page *page = folio_page(folio, i);
+			/* Careful: see __split_huge_page_tail() */
+			struct folio *new_folio = (struct folio *)page;
 
-			page->mapping = NULL;
 			clear_compound_head(page);
 			prep_compound_page(page, dst->order);
 
-			init_new_hugetlb_folio(dst, page_folio(page));
-			list_add(&page->lru, &dst_list);
+			new_folio->mapping = NULL;
+			init_new_hugetlb_folio(dst, new_folio);
+			list_add(&new_folio->lru, &dst_list);
 		}
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


