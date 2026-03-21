Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76CE2FD1BF
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774117519; cv=none; b=RiOGn2aK91i3LRn2DamWnG0k2MTLSor1ZGa/T5piITpSIg/UQjWKm2qQ+SnbOapoCfxG83bZubU/bSHK8X07BKJ5yA6hAakCNOBrx31RGRST9GWD7hsYTM1wieRf1roWSOIoz+Bnvl58JbzDMAp3ulZU13dhyGtg+Y7NG2J9mbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774117519; c=relaxed/simple;
	bh=4haSbcXmyozq8xnRjf7Q/LHHrfm7MBYLjp794JEa2zo=;
	h=Date:To:From:Subject:Message-Id; b=FAEU2Dlbvk2S3SrphtIcmrsebAMHsePV3SgdYsQ1br0FrcAw6YeJ0OaobBOBVZtkVPxVMDBDtAU7puKepQrm9o/7Bh3QjADKOk048ZTLSWGtntUMZk5OJwUKOrMpBcElmYNd18OWHaWuvstdL2SoNKmjvjA8d8MIthnTbl5qpnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lIrT1fE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lIrT1fE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DBAC19421;
	Sat, 21 Mar 2026 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774117518;
	bh=4haSbcXmyozq8xnRjf7Q/LHHrfm7MBYLjp794JEa2zo=;
	h=Date:To:From:Subject:From;
	b=lIrT1fE3yTuz2IzF4rRZVrVMFitoemQnPLNtZyVnQ/ZsPEM1cHiv9U8rKwhWQV01J
	 8sMnyGbJMRZm/HXbd1sEzUfDgi41/OvglmgOYt0lHC+1tliAz4b7XhTFPzK4eyXrlT
	 HnqlMzSaC3OBY1QCgC5Lf44Yo2TH6u0CIAKDBths=
Date: Sat, 21 Mar 2026 11:25:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@kernel.org,justinjiang@vivo.com,jackmanb@google.com,hannes@cmpxchg.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch added to mm-new branch
Message-Id: <20260321182518.91DBAC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: don't increase highatomic reserve after pcp alloc
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch

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
From: Frank van der Linden <fvdl@google.com>
Subject: mm/page_alloc: don't increase highatomic reserve after pcp alloc
Date: Fri, 20 Mar 2026 17:34:25 +0000

Higher order GFP_ATOMIC allocations can be served through a PCP list with
ALLOC_HIGHATOMIC set.  Such an allocation can e.g.  happen if a zone is
between the low and min watermarks, and get_page_from_freelist is retried
after the alloc_flags are relaxed.

The call to reserve_highatomic_pageblock() after such a PCP allocation
will result in an increase every single time: the page from the
(unmovable) PCP list will never have migrate type MIGRATE_HIGHATOMIC,
since MIGRATE_HIGHATOMIC pages do not appear on the unmovable PCP list. 
So a new pageblock is converted to MIGRATE_HIGHATOMIC.

Eventually that leads to the maximum of 1% of the zone being used up by
(often mostly free) MIGRATE_HIGHATOMIC pageblocks, for no good reason. 
Since this space is not available for normal allocations, this wastes
memory and will push things in to reclaim too soon.

This was observed on a system that ran a test with bursts of memory
activity, pared with GFP_ATOMIC SLUB activity.  These would lead to a new
slab being allocated with GFP_ATOMIC, sometimes hitting the
get_page_from_freelist retry path by being below the low watermark.  While
the frequency of those allocations was low, it kept adding up over time,
and the number of MIGRATE_ATOMIC pageblocks kept increasing.

If a higher order atomic allocation can be served by the unmovable PCP
list, there is probably no need yet to extend the reserves.  So, move the
check and possible extension of the highatomic reserves to the buddy case
only, and do not refill the PCP list for ALLOC_HIGHATOMIC if it's empty. 
This way, the PCP list is tried for ALLOC_HIGHATOMIC for a fast atomic
allocation.  But it will immediately fall back to rmqueue_buddy() if it's
empty.  In rmqueue_buddy(), the MIGRATE_HIGHATOMIC buddy lists are tried
first (as before), and the reserves are extended only if that fails.

With this change, the test was stable.  Highatomic reserves were built up,
but to a normal level.  No highatomic failures were seen.

This is similar to the patch proposed in [1] by Zhiguo Jiang, but
re-arranged a bit.

Link: https://lkml.kernel.org/r/20260320173426.1831267-1-fvdl@google.com
Link: https://lore.kernel.org/all/20231122013925.1507-1-justinjiang@vivo.com/ [1]
Fixes: 44042b4498728 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zhiguo Jiang <justinjiang@vivo.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc
+++ a/mm/page_alloc.c
@@ -208,6 +208,8 @@ unsigned int pageblock_order __read_most
 
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
+static void reserve_highatomic_pageblock(struct page *page, int order,
+					 struct zone *zone);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -3240,6 +3242,13 @@ struct page *rmqueue_buddy(struct zone *
 		zone_unlock_irqrestore(zone, flags);
 	} while (check_new_pages(page, order));
 
+	/*
+	 * If this is a high-order atomic allocation then check
+	 * if the pageblock should be reserved for the future
+	 */
+	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+		reserve_highatomic_pageblock(page, order, zone);
+
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
 
@@ -3311,6 +3320,20 @@ struct page *__rmqueue_pcplist(struct zo
 			int batch = nr_pcp_alloc(pcp, zone, order);
 			int alloced;
 
+			/*
+			 * Don't refill the list for a higher order atomic
+			 * allocation under memory pressure, as this would
+			 * not build up any HIGHATOMIC reserves, which
+			 * might be needed soon.
+			 *
+			 * Instead, direct it towards the reserves by
+			 * returning NULL, which will make the caller fall
+			 * back to rmqueue_buddy. This will try to use the
+			 * reserves first and grow them if needed.
+			 */
+			if (alloc_flags & ALLOC_HIGHATOMIC)
+				return NULL;
+
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
 					migratetype, alloc_flags);
@@ -3925,13 +3948,6 @@ try_this_zone:
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
-			/*
-			 * If this is a high-order atomic allocation then check
-			 * if the pageblock should be reserved for the future
-			 */
-			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, order, zone);
-
 			return page;
 		} else {
 			if (cond_accept_memory(zone, order, alloc_flags))
_

Patches currently in -mm which might be from fvdl@google.com are

mm-page_alloc-dont-increase-highatomic-reserve-after-pcp-alloc.patch

