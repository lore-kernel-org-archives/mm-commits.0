Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5229D282
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763403748; cv=none; b=jjaYtrUatsOOmV1Kk5SXjOIQ75/sy15+bSOQx8k39/QXjmLQvQbYsHWn5g7h1RZGaqIyZ0ctObaRQF5SXRuo5paeBsLy9BdRaEkxNmVZAtOf9NIirj2/IDh8QDcyZRdNGBQsSHWnnwSxvbP0ZTMK0WYEyXWK0ckl8rrEwjYASgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763403748; c=relaxed/simple;
	bh=qj1BSix+e6VQBDaxSSPaSgciTagsKXTOPf01y635CiM=;
	h=Date:To:From:Subject:Message-Id; b=aeOT3oww7xdHZBCaEwz9JosgXnJHdS9ZpNP2KFCoHubRwQt/kMeO827yg31cSh/dn3DnUARvS4kEhDG1a6/pce4MyReAgVT84vVBQoYrOgxIeMdGRMJNLz8V0irCrw/WA0bF47Ov7UnKLXkgA5iuXndnFS6LcAVw/NVANdeqijQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7wniZmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7wniZmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAACC2BCB3;
	Mon, 17 Nov 2025 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763403748;
	bh=qj1BSix+e6VQBDaxSSPaSgciTagsKXTOPf01y635CiM=;
	h=Date:To:From:Subject:From;
	b=O7wniZmvgoTKG1JjUpW11StHVfcBUkoygty5D4pUkr7JPj64qjk2smAX2nkMnMJ7w
	 Xgzf98HCzK1V4EWxRridSzrt3lhqeGATU+yCHDAulIIAjYkVvX/HrwtfzbKADCdt8T
	 1fW+nYsFCSyofyKK9JUsEEqwnPxJ+BLndoox/m/8=
Date: Mon, 17 Nov 2025 10:22:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch added to mm-new branch
Message-Id: <20251117182227.EEAACC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: optimize lowmem_reserve max lookup using its semantic monotonicity
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch

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
From: fujunjie <fujunjie1@qq.com>
Subject: mm/page_alloc: optimize lowmem_reserve max lookup using its semantic monotonicity
Date: Sat, 15 Nov 2025 03:02:55 +0000

calculate_totalreserve_pages() currently finds the maximum
lowmem_reserve[j] for a zone by scanning the full forward range [j =
zone_idx ..  MAX_NR_ZONES).  However, for a given zone i, the
lowmem_reserve[j] array (for j > i) is naturally expected to form a
monotonically non-decreasing sequence in j, not as an implementation
detail, but as a consequence that naturally arises from the semantics of
lowmem_reserve[].

For zone "i", lowmem_reserve[j] expresses how many pages in zone i must
effectively be kept in reserve when deciding whether an allocation class
that may allocate from zones up to j is allowed to fall back into i.  It
protects less flexible allocation classes (which cannot use higher zones)
from being starved by more flexible ones.

Viewed from this semantics, it is natural to expect a partial ordering in
j: as j increases, the allocation class gains access to a strictly larger
set of fallback zones.  Therefore lowmem_reserve[j] is expected to be
monotonically non-decreasing in j: more flexible allocation classes must
not be allowed to deplete low zones more aggressively than less flexible
ones.

In other words, if lowmem_reserve[j] were ever observed to *decrease* as j
grows, that would be unexpected from the reserve semantics' point of view
and would likely indicate a semantic change or a misconfiguration.

The current implementation in setup_per_zone_lowmem_reserve() reflects
this policy by accumulating managed pages from higher zones and applying
the configured ratio, which results in a non-decreasing sequence.  This
patch makes calculate_totalreserve_pages() rely on that monotonicity
explicitly and finds the maximum reserve value by scanning backward and
stopping at the first non-zero entry.  This avoids unnecessary iteration
and reflects the conceptual model more directly.  No functional behavior
changes.

To maintain this assumption explicitly, a comment is added next to
setup_per_zone_lowmem_reserve() documenting the monotonicity expectation
and noting that calculate_totalreserve_pages() relies on it.

Link: https://lkml.kernel.org/r/tencent_EB0FED91B01B1F8B6DAEE96719C5F5797F07@qq.com
Signed-off-by: fujunjie <fujunjie1@qq.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity
+++ a/mm/page_alloc.c
@@ -6311,10 +6311,21 @@ static void calculate_totalreserve_pages
 			long max = 0;
 			unsigned long managed_pages = zone_managed_pages(zone);
 
-			/* Find valid and maximum lowmem_reserve in the zone */
-			for (j = i; j < MAX_NR_ZONES; j++)
-				max = max(max, zone->lowmem_reserve[j]);
-
+			/*
+			 * lowmem_reserve[j] is monotonically non-decreasing
+			 * in j for a given zone (see
+			 * setup_per_zone_lowmem_reserve()). The maximum
+			 * valid reserve lives at the highest index with a
+			 * non-zero value, so scan backwards and stop at the
+			 * first hit.
+			 */
+			for (j = MAX_NR_ZONES - 1; j > i; j--) {
+				if (!zone->lowmem_reserve[j])
+					continue;
+
+				max = zone->lowmem_reserve[j];
+				break;
+			}
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
@@ -6339,7 +6350,21 @@ static void setup_per_zone_lowmem_reserv
 {
 	struct pglist_data *pgdat;
 	enum zone_type i, j;
-
+	/*
+	 * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
+	 * represents how many pages in zone i must effectively be kept
+	 * in reserve when deciding whether an allocation class that is
+	 * allowed to allocate from zones up to j may fall back into
+	 * zone i.
+	 *
+	 * As j increases, the allocation class can use a strictly larger
+	 * set of fallback zones and therefore must not be allowed to
+	 * deplete low zones more aggressively than a less flexible one.
+	 * As a result, lowmem_reserve[j] is required to be monotonically
+	 * non-decreasing in j for each zone i. Callers such as
+	 * calculate_totalreserve_pages() rely on this monotonicity when
+	 * selecting the maximum reserve entry.
+	 */
 	for_each_online_pgdat(pgdat) {
 		for (i = 0; i < MAX_NR_ZONES - 1; i++) {
 			struct zone *zone = &pgdat->node_zones[i];
_

Patches currently in -mm which might be from fujunjie1@qq.com are

mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch

