Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E62857EA
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759884486; cv=none; b=IrvA24wSnY1GVOqlkH8zlGgTWowhtEFlJPJkBE3ApTacJKt1AZtkG/irHOsLRE0Ww0kVzCOrP99IgDrkwhdsmkh/ThcBO6boNx8ScLOJPsiG3ou9lwcoueBYy7CvOE9CM5dB9xMooZu31OkX1O/Hl7T4Savf5DrroByhl/PeiwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759884486; c=relaxed/simple;
	bh=Iw0f1U513cHgQNk3ALMsLgWgTmkcseVCjom3D2EcFek=;
	h=Date:To:From:Subject:Message-Id; b=PTETV0tNwnPT6I2jOr4/23ywLNr58+wg8HCS164hSxSa60ofoSZnf/NKrc57qLKjQAuxYbXnFwW1KPRcFKwfY5DiTxShhG1bxylCMVzyX2RhTz3M+JxiVwS107RD8kzpAX2oiLklWBoYEAfRs+Itzv+sO4tKvpZlV7J7dV3IfQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVnEYsV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVnEYsV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B9C4CEF7;
	Wed,  8 Oct 2025 00:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759884484;
	bh=Iw0f1U513cHgQNk3ALMsLgWgTmkcseVCjom3D2EcFek=;
	h=Date:To:From:Subject:From;
	b=WVnEYsV1R464icPYkoDfEDOGtSKyasDuccKE8KDCQ5PrkoGczNlwMvQqgeGU/k0GF
	 TTpXu1uUDHeRPU66fDRU6Ou7kbQlEaMhcNf2heLlUyYp2RbPxXvARdXUkEIXUPEtDE
	 Jkng1rGZv/WIEzTOMy+QigZQEqykSDr8FFEsA3f4=
Date: Tue, 07 Oct 2025 17:48:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill@shutemov.name,jackmanb@google.com,hdanton@sina.com,hannes@cmpxchg.org,david@redhat.com,clm@fb.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch added to mm-new branch
Message-Id: <20251008004804.1D6B9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: batch page freeing in free_frozen_page_commit
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: batch page freeing in free_frozen_page_commit
Date: Thu, 2 Oct 2025 13:46:33 -0700

Before returning, free_frozen_page_commit calls free_pcppages_bulk using
nr_pcp_free to determine how many pages can appropritately be freed, based
on the tunable parameters stored in pcp.  While this number is an accurate
representation of how many pages should be freed in total, it is not an
appropriate number of pages to free at once using free_pcppages_bulk,
since we have seen the value consistently go above 2000 in the Meta fleet
on larger machines.

As such, perform batched page freeing in free_pcppages_bulk by using
pcp->batch member.  In order to ensure that other processes are not
starved of the zone lock, free both the zone lock and pcp lock to yield to
other threads.

Note that because free_frozen_page_commit now performs a spinlock inside
the function (and can fail), the function may now return with a freed pcp.
To handle this, return true if the pcp is locked on exit and false
otherwise.

In addition, since free_frozen_page_commit must now be aware of what UP
flags were stored at the time of the spin lock, and because we must be
able to report new UP flags to the callers, add a new unsigned long*
parameter UP_flags to keep track of this.

Link: https://lkml.kernel.org/r/20251002204636.4016712-4-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   66 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit
+++ a/mm/page_alloc.c
@@ -2818,12 +2818,21 @@ static int nr_pcp_high(struct per_cpu_pa
 	return high;
 }
 
-static void free_frozen_page_commit(struct zone *zone,
+/*
+ * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
+ * pcp's watermarks below high.
+ *
+ * May return a freed pcp, if during page freeing the pcp spinlock cannot be
+ * reacquired. Return true if pcp is locked, false otherwise.
+ */
+static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags)
+		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
 {
 	int high, batch;
+	int to_free, to_free_batched;
 	int pindex;
+	int cpu = smp_processor_id();
 	bool free_high = false;
 
 	/*
@@ -2861,15 +2870,20 @@ static void free_frozen_page_commit(stru
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return;
+		return true;
 	}
 
 	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count < high)
-		return;
+		return true;
 
-	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-			   pcp, pindex);
+	to_free = nr_pcp_free(pcp, batch, high, free_high);
+	if (to_free == 0)
+		return true;
+
+free_batch:
+	to_free_batched = min(to_free, batch);
+	free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 			      ZONE_MOVABLE, 0)) {
@@ -2887,6 +2901,35 @@ static void free_frozen_page_commit(stru
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			atomic_set(&pgdat->kswapd_failures, 0);
 	}
+	high = nr_pcp_high(pcp, zone, batch, free_high);
+	to_free -= to_free_batched;
+	if (pcp->count >= high) {
+		pcp_spin_unlock(pcp);
+		pcp_trylock_finish(*UP_flags);
+
+		pcp_trylock_prepare(*UP_flags);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		if (!pcp) {
+			pcp_trylock_finish(*UP_flags);
+			return false;
+		}
+
+		/*
+		 * Check if this thread has been migrated to a different
+		 * CPU. If that is the case, give up and indicate that
+		 * the pcp is returned in an unlocked state.
+		 */
+		if (smp_processor_id() != cpu) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(*UP_flags);
+			return false;
+		}
+	}
+
+	if (to_free > 0 && pcp->count >= high)
+		goto free_batch;
+
+	return true;
 }
 
 /*
@@ -2934,7 +2977,9 @@ static void __free_frozen_pages(struct p
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
+		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
+						order, fpi_flags, &UP_flags))
+			return;
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
@@ -3034,8 +3079,11 @@ void free_unref_folios(struct folio_batc
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
-					order, FPI_NONE);
+		if (!free_frozen_page_commit(zone, pcp, &folio->page,
+				migratetype, order, FPI_NONE, &UP_flags)) {
+			pcp = NULL;
+			locked_zone = NULL;
+		}
 	}
 
 	if (pcp) {
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch

