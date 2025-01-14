Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7DC23C6E5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836983; cv=none; b=icRQ0xqDMEpM7Yz9EDnyTjABiAtwHl0g6tcZBtNJvK01OyDCBxBg0DG5WOslvXhoZhxUVAr09WsNVmdyTZ+BWS8e0TV0V2H6NaLtVxk+ziswrIBU6eGY9JeARD1cRBtmd4k7WF/3cauQgqbfPVP18bcwCqrm4VZdrFyX4naUkz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836983; c=relaxed/simple;
	bh=X/wdpRVzJdX+iGFDRxB8WrptjOIFw4Wwx93uBo7v6qs=;
	h=Date:To:From:Subject:Message-Id; b=XLepX4MkEXCKv7W/CCufAF2obovbZuPQBTf+tVRASJ5rOU77JhEnlTTAyy45ZDoJ3Yfue0qAVCBL1+PxMxU5csqGmrlDUW4zHNAR3nhcG0SJVQToE8d0qsPx6Ywf+UoCELyAth6QudB8KzSzTnDFUm7x3c8Fni2MNUbPqqd4+vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzL0h2V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzL0h2V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB3EC4CEDD;
	Tue, 14 Jan 2025 06:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836983;
	bh=X/wdpRVzJdX+iGFDRxB8WrptjOIFw4Wwx93uBo7v6qs=;
	h=Date:To:From:Subject:From;
	b=RzL0h2V1oQtEYuSXZkmYaD2GdCAKQvy8Q4e79eA3hSrGLds0rQFd5Cy5FDOST4Np6
	 6vCW4uHtoUfuSfzN2jSR54+SCCuf+aiLv56maFY5f1BubWOInnQ/TSIwCm9b0546Z9
	 b+pCmpkNtCKkOLsOovzqugkJ/IQJzQeQ9OhGKUqU=
Date: Mon, 13 Jan 2025 22:43:02 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch removed from -mm tree
Message-Id: <20250114064303.0EB3EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: don't pass gfp flags to start_isolate_page_range()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: don't pass gfp flags to start_isolate_page_range()
Date: Tue, 3 Dec 2024 10:47:28 +0100

The parameter is unused, so let's stop passing it.

Link: https://lkml.kernel.org/r/20241203094732.200195-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    2 +-
 mm/memory_hotplug.c            |    3 +--
 mm/page_alloc.c                |    2 +-
 mm/page_isolation.c            |    4 +---
 4 files changed, 4 insertions(+), 7 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range
+++ a/include/linux/page-isolation.h
@@ -31,7 +31,7 @@ bool move_freepages_block_isolate(struct
 				  int migratetype);
 
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     int migratetype, int flags, gfp_t gfp_flags);
+			     int migratetype, int flags);
 
 void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     int migratetype);
--- a/mm/memory_hotplug.c~mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range
+++ a/mm/memory_hotplug.c
@@ -2000,8 +2000,7 @@ int offline_pages(unsigned long start_pf
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE,
-				       MEMORY_OFFLINE | REPORT_FAILURE,
-				       GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL);
+				       MEMORY_OFFLINE | REPORT_FAILURE);
 	if (ret) {
 		reason = "failure to isolate range";
 		goto failed_removal_pcplists_disabled;
--- a/mm/page_alloc.c~mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range
+++ a/mm/page_alloc.c
@@ -6447,7 +6447,7 @@ int alloc_contig_range_noprof(unsigned l
 	 * put back to page allocator so that buddy can use them.
 	 */
 
-	ret = start_isolate_page_range(start, end, migratetype, 0, gfp_mask);
+	ret = start_isolate_page_range(start, end, migratetype, 0);
 	if (ret)
 		goto done;
 
--- a/mm/page_isolation.c~mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range
+++ a/mm/page_isolation.c
@@ -442,8 +442,6 @@ failed:
  *					 and PageOffline() pages.
  *			REPORT_FAILURE - report details about the failure to
  *			isolate the range
- * @gfp_flags:		GFP flags used for migrating pages that sit across the
- *			range boundaries.
  *
  * Making page-allocation-type to be MIGRATE_ISOLATE means free pages in
  * the range will never be allocated. Any free pages and pages freed in the
@@ -476,7 +474,7 @@ failed:
  * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     int migratetype, int flags, gfp_t gfp_flags)
+			     int migratetype, int flags)
 {
 	unsigned long pfn;
 	struct page *page;
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

