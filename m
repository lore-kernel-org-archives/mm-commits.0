Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E84A06
	for <mm-commits@vger.kernel.org>; Wed,  4 Dec 2024 01:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733274182; cv=none; b=mIWAB59x/lH9k8vAU/Ph38/fHLjFyHsibctB5bvbxUCCa5YV+uXS/3/VDih0GmfHnwUKM+0U586De+8IUlWNmZSUpSt3r9moJWQjaJx337qehVmdPXN1RzKjBdyUi5piFl0FZhI0p6v+QUw/DqxHcg+kiXm4UtCZrIedtOuyra0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733274182; c=relaxed/simple;
	bh=RcLfVSDVst2J5M4RWQFyklAGlEtsKFCb8c0QM0H4YTg=;
	h=Date:To:From:Subject:Message-Id; b=YwSXRCfpxZIrUpI3kGvmxS+1xdSaazBRkJLedxB/Yt67gN71KLfCm9oZuFFl8riIg2nVmusr2Oj+/YQA7gxgZ9fIEw9IjseMqwl6pvq5Ihnvp2xxWiqf3RLcM13r/Trq3Mz6TLlawJ+heFRFvjHiTEK3cVrAlaTCZo6etTjAne4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WD8HchNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WD8HchNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB15C4CEDC;
	Wed,  4 Dec 2024 01:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733274181;
	bh=RcLfVSDVst2J5M4RWQFyklAGlEtsKFCb8c0QM0H4YTg=;
	h=Date:To:From:Subject:From;
	b=WD8HchNAUjzVSjdBrJQjgXmgiCz4D8sBQALprR7FgyBDJXva8sZ+gU5ODiqgultIn
	 QwfcpSkNFpq2ara/kT55sT9NMsHOGsZH7GW3twqXSreepW2Z1fwD2TFBkXCsA6V8vY
	 6snr9elRzqJZdFOWMLvTa5R8n2zi8Z/5NlwIZpSI=
Date: Tue, 03 Dec 2024 17:03:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch added to mm-unstable branch
Message-Id: <20241204010301.5EB15C4CEDC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: don't pass gfp flags to start_isolate_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch

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
@@ -6445,7 +6445,7 @@ int alloc_contig_range_noprof(unsigned l
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

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch
mm-memory_hotplug-move-debug_pagealloc_map_pages-into-online_pages_range.patch
mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch
mm-page_isolation-dont-pass-gfp-flags-to-start_isolate_page_range.patch
mm-page_alloc-make-__alloc_contig_migrate_range-static.patch
mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch
mm-page_alloc-forward-the-gfp-flags-from-alloc_contig_range-to-post_alloc_hook.patch
powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch

