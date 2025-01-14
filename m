Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC40723A577
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836986; cv=none; b=lbAOoUWhX1TwXJb2kLvKAg7tcyrdX/tZuzL4u4d4fNtBIGBPgTb5KVYOfo1NI02Yfr+gp+qv/x7nkKYVAySBDMFNLFK3CC/XgJ82JJO5dEYjIjTD0eTAFXISd/PfMb1yVtALufNddxEstxv5o3NrUh9Q5j0MxzOuZij3pdLGY44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836986; c=relaxed/simple;
	bh=d6geG0+cI7ocKQw3dSWI4nlMiyU42IQDrInbTSWfde8=;
	h=Date:To:From:Subject:Message-Id; b=E8jEYnHQfYE+P94NcHrkHMJ2Ey4I37MX3IhBjfuZ9teaL3OwSngt3UkTwIJIXrFuEW8QaPL2ypma61tMPhUEc+cwnTs939R9Km2p6JWggssyZLTSUlSvQjqDUNF3Y2DWldjhC3NOqbkOVWjdigpEQZgv+OcsfC8R0U73Ct5fQIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMGAXjnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMGAXjnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B4EC4CEDD;
	Tue, 14 Jan 2025 06:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836986;
	bh=d6geG0+cI7ocKQw3dSWI4nlMiyU42IQDrInbTSWfde8=;
	h=Date:To:From:Subject:From;
	b=NMGAXjnMk9RdyPVgoc9cGhV7E5a1dgRHI5/IKUzoF9Qv5cgsn4iQp3GytnGDlQwig
	 VQASxCeVAueVT2wzmUjgmQ+B3HdRdcV6nl9wUsqVHYy/LL0woMKB5ZDyY5cU7gUQkS
	 mTklOc/bx7h4eieAaUpZQ4FSiWE//sNHar4tNmTI=
Date: Mon, 13 Jan 2025 22:43:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch removed from -mm tree
Message-Id: <20250114064306.90B4EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: sort out the alloc_contig_range() gfp flags mess
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: sort out the alloc_contig_range() gfp flags mess
Date: Tue, 3 Dec 2024 10:47:30 +0100

It's all a bit complicated for alloc_contig_range().  For example, we
don't support many flags, so let's start bailing out on unsupported ones
-- ignoring the placement hints, as we are already given the range to
allocate.

While we currently set cc.gfp_mask, in __alloc_contig_migrate_range() we
simply create yet another GFP mask whereby we ignore the reclaim flags
specify by the caller.  That looks very inconsistent.

Let's clean it up, constructing the gfp flags used for
compaction/migration exactly once.  Update the documentation of the
gfp_mask parameter for alloc_contig_range() and alloc_contig_pages().

Link: https://lkml.kernel.org/r/20241203094732.200195-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   48 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-sort-out-the-alloc_contig_range-gfp-flags-mess
+++ a/mm/page_alloc.c
@@ -6290,7 +6290,7 @@ static int __alloc_contig_migrate_range(
 	int ret = 0;
 	struct migration_target_control mtc = {
 		.nid = zone_to_nid(cc->zone),
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+		.gfp_mask = cc->gfp_mask,
 		.reason = MR_CONTIG_RANGE,
 	};
 	struct page *page;
@@ -6386,6 +6386,39 @@ static void split_free_pages(struct list
 	}
 }
 
+static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
+{
+	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
+	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
+
+	/*
+	 * We are given the range to allocate; node, mobility and placement
+	 * hints are irrelevant at this point. We'll simply ignore them.
+	 */
+	gfp_mask &= ~(GFP_ZONEMASK | __GFP_RECLAIMABLE | __GFP_WRITE |
+		      __GFP_HARDWALL | __GFP_THISNODE | __GFP_MOVABLE);
+
+	/*
+	 * We only support most reclaim flags (but not NOFAIL/NORETRY), and
+	 * selected action flags.
+	 */
+	if (gfp_mask & ~(reclaim_mask | action_mask))
+		return -EINVAL;
+
+	/*
+	 * Flags to control page compaction/migration/reclaim, to free up our
+	 * page range. Migratable pages are movable, __GFP_MOVABLE is implied
+	 * for them.
+	 *
+	 * Traditionally we always had __GFP_HARDWALL|__GFP_RETRY_MAYFAIL set,
+	 * keep doing that to not degrade callers.
+	 */
+	*gfp_cc_mask = (gfp_mask & (reclaim_mask | cc_action_mask)) |
+			__GFP_HARDWALL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+	return 0;
+}
+
 /**
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
@@ -6394,7 +6427,9 @@ static void split_free_pages(struct list
  *			#MIGRATE_MOVABLE or #MIGRATE_CMA).  All pageblocks
  *			in range must have the same migratetype and it must
  *			be either of the two.
- * @gfp_mask:	GFP mask to use during compaction
+ * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
+ *		action and reclaim modifiers are supported. Reclaim modifiers
+ *		control allocation behavior during compaction/migration/reclaim.
  *
  * The PFN range does not have to be pageblock aligned. The PFN range must
  * belong to a single zone.
@@ -6420,11 +6455,14 @@ int alloc_contig_range_noprof(unsigned l
 		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
-		.gfp_mask = current_gfp_context(gfp_mask),
 		.alloc_contig = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 
+	gfp_mask = current_gfp_context(gfp_mask);
+	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
+		return -EINVAL;
+
 	/*
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
@@ -6567,7 +6605,9 @@ static bool zone_spans_last_pfn(const st
 /**
  * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
  * @nr_pages:	Number of contiguous pages to allocate
- * @gfp_mask:	GFP mask to limit search and used during compaction
+ * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
+ *		action and reclaim modifiers are supported. Reclaim modifiers
+ *		control allocation behavior during compaction/migration/reclaim.
  * @nid:	Target node
  * @nodemask:	Mask for other possible nodes
  *
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

