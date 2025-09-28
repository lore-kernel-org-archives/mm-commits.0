Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3627034BA24
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085275; cv=none; b=ZKh0kMCon4QbxURhBDQeOdfCQose3VbyYbacKAE3MhEjQcCQCHHRFqi4yxeAsN51Diw/m5NIVRF4g9h5v9vW/qd7jxOK38WtZjK5MClnfdj+KGpTSbrkBhcsWWbraxsbn8MyWksw8Y0Okprigl0z9ih8ACm2aISxYb+kydUcJ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085275; c=relaxed/simple;
	bh=rntTdh5fFN7K/ReNXKkgipf5GcN4VhHbGnw1AMIZ0p4=;
	h=Date:To:From:Subject:Message-Id; b=Wfu16uEzBFdE1hYf5GqSWaAfiQSTDDvFmYUZnzY6UoZXX6YxAdVVp7AVUqiuQowu8icgVZQeMXZ+/XJsfsGWLI641pwIYLz6xg8j4K+6LHphWmp2uF6UBwtmFSiFiAZ0zNAag5CfqBOMAXAePvzVnAnno1stFCMUOIDlVoTiuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1cpo+e8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1cpo+e8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD29C4CEF0;
	Sun, 28 Sep 2025 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085274;
	bh=rntTdh5fFN7K/ReNXKkgipf5GcN4VhHbGnw1AMIZ0p4=;
	h=Date:To:From:Subject:From;
	b=1cpo+e8t9x34tlNS02Ji0Q/jtVqnn+sPK9igWjliESXKfYPk5leD7kUMSWBFLKbUM
	 PVlf0wb8ZlC+nvNrpu5/R2ucinAmQ2onduHYuMsac1QMrMKn8RyV/Rnb/l5JII1FD9
	 /FBX02KGo4CuuWRU8ZW8f1L6ClDMEenU2uFP5pI8=
Date: Sun, 28 Sep 2025 11:47:54 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,kas@kernel.org,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch removed from -mm tree
Message-Id: <20250928184754.8AD29C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix.patch

This patch was dropped because it was folded into mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
Date: Tue Sep 23 02:27:40 PM PDT 2025

s/CROSSSED/CROSSED/

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 +-
 mm/page_vma_mapped.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
+++ a/include/linux/rmap.h
@@ -925,7 +925,7 @@ struct page *make_device_exclusive(struc
 /* Result flags */
 
 /* The page is mapped across page table boundary */
-#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+#define PVMW_PGTABLE_CROSSED	(1 << 16)
 
 struct page_vma_mapped_walk {
 	unsigned long pfn;
--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary-fix
+++ a/mm/page_vma_mapped.c
@@ -309,7 +309,7 @@ next_pte:
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
-				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
+				pvmw->flags |= PVMW_PGTABLE_CROSSED;
 				goto restart;
 			}
 			pvmw->pte++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one-fix.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

