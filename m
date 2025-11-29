Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58C7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441700; cv=none; b=SLpBVHaNezDgRO2vUO5NnVOkEoZOYjjLkfn+ky8Fotpi4PpjW8O2InXauK+jA4tRFvS5mNByygmP7eJ0dr76MSGAGePz8P7NmxUZbTQp7UskX8fYwFp9uUjYRp2exew4wuElq1i8P4rxA6XG7R6Gf5RkuumWJtKlwL+k0dH8fxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441700; c=relaxed/simple;
	bh=w4vvbllAEna4gu3W7EHrfHFNSIhqzraHskHVfc/0zwA=;
	h=Date:To:From:Subject:Message-Id; b=nstCLiluMljx+pGzvwkIv1SHhW78uUy4e3jmGwk68P8Z4WBawlv7O9j0OGKsB4Lr1QNRhih+Fjx9Db/fV4xUkPBSeDyWU69ewhZ5+ggx+lAKOAx+Lyd4RUrrmJjpC9zqlJ7boquxI+/72C/wY9O43AsW7I56+GDWwKd4Vf5oZho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wd8p/BA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wd8p/BA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C1C4CEF7;
	Sat, 29 Nov 2025 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441700;
	bh=w4vvbllAEna4gu3W7EHrfHFNSIhqzraHskHVfc/0zwA=;
	h=Date:To:From:Subject:From;
	b=Wd8p/BA+JsmFAtfGr1Rf1+qp75k+g8WTfGYlXkhb/TjK2cmLTFK8l8u47bPlQHJrQ
	 BDqRBg+xepK1JcJSZO4gQ+4YRkuuICVDA/fwPj90gDVs2glfLXONwyKhzosfd0keAD
	 FS6qYT6jFF/TUEjMUCEQrd7Nns+BAIf3C62yEc5k=
Date: Sat, 29 Nov 2025 10:41:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,fujunjie1@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch removed from -mm tree
Message-Id: <20251129184140.727C1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: optimize lowmem_reserve max lookup using its semantic monotonicity
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-optimize-lowmem_reserve-max-lookup-using-its-semantic-monotonicity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


