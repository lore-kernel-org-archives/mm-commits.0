Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310F17F394
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384245; cv=none; b=ojbYgZ8XRNzujfDRJ7OSCQCIHV6LiNFmWNnuLihEeeFc7PkTJuCyDRQo+RU/NZsNlTpaNKHOaZVlnzxKq3pgcN8Dc69wyFLkDF6/gfYHJqrvbWpZJW54HWiFZbKYxASMGWhRNCInR3fKYwwcDdN5p6loR5RKRjFxKDOLRM9AVio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384245; c=relaxed/simple;
	bh=ZoVLcwpFfpelYkoNKLsBhLJ5Oy9NirOizDbS5W6sCo4=;
	h=Date:To:From:Subject:Message-Id; b=uylmUWiQpEcw5rzNFKwZA3UBvMA/VOJ8vaeFGKG/uCh0StIsm5+/Bkdv9TRTVwTBfRZSnHTeh80zYqmgzFshtR6RmGZ/Xq+r+pwYUTuzFgM2ahWJCx5H28UDkbZZTpsbJDH1qwlHIf+DP7QFYKkhD5ZMg9HcHNMUwLJHAiMFEic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WYtLZUvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYtLZUvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFCC4CEC5;
	Thu, 26 Sep 2024 20:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384244;
	bh=ZoVLcwpFfpelYkoNKLsBhLJ5Oy9NirOizDbS5W6sCo4=;
	h=Date:To:From:Subject:From;
	b=WYtLZUvkcJTg1M0VvtrbS+WaYvCQ6tFwUdMpK3U96itTfnyC/a7tg67UYe2x+gil7
	 3MHV8+pWAYAQLf79p06Qu8OlXoCNIM3J3ij6ZdLvRoss8wbeNOJUaIhpBqtsXE9bc6
	 +dpYxjhoJLfEtI3R2RlwIKu89hWPM6cMPGTrpSIM=
Date: Thu, 26 Sep 2024 13:57:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch removed from -mm tree
Message-Id: <20240926205724.A4AFCC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch

This patch was dropped because it was folded into mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

------------------------------------------------------
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
Date: Wed, 4 Sep 2024 13:32:00 -0700

remove explicit call to free_huge_folio(), per Matthew

Link: https://lkml.kernel.org/r/Zti-7nPVMcGgpcbi@casper.infradead.org
Link: https://lkml.kernel.org/r/1725481920-82506-1-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memfd.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
+++ a/mm/memfd.c
@@ -95,7 +95,6 @@ struct folio *memfd_alloc_folio(struct f
 							idx);
 			if (err) {
 				folio_put(folio);
-				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
 			folio_unlock(folio);
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch
mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

