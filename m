Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFB831B80D
	for <mm-commits@vger.kernel.org>; Mon, 24 Aug 2026 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601621; cv=none; b=W5qGkGltSSvDi1AIvuhO8ruVkawKhpmQpm/UgqiWP69gYkK7NhLKHbV1fLgBsa89y4cXdLPu+Z3sEH/wg7iZ4mWo/Y43ZztDnfHwzXcueBtSJvp6f4R5Ux4nNOGyiJp7KMu2vwfrPWS7h7HBgOeYKLlA3fN/B+1yIXMX6PPXyw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601621; c=relaxed/simple;
	bh=MaQfz10xBecXRTtBhT5j6QBvzB7ysg67chxZpWlUY2c=;
	h=Date:To:From:Subject:Message-Id; b=cGm+2SrrN7i49Rn1i5dZi87SWEM2rir1Livi+vfu2s6p4ASrMAojHt6Ln9PO5PqbLrAUApIxD7JTYbpyXpS8BoHVWrJRZoKomp2Uq+fH71/0oNWlMr1GWQQF6/zrUYMnC5r/ddnBhxtuq2QkI43HCPp+aBQlGkI/jeYbkB17Ylg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s7C7UAeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s7C7UAeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2891F000E9;
	Mon, 24 Aug 2026 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787601619;
	bh=nRVwgHfaVPeT3Cy03qXQLy6J02U+t0CLRGfqMO9agt4=;
	h=Date:To:From:Subject;
	b=s7C7UAeu5TTktqJmSAihZOSPBG3RS8SKVklAtTXEyCfN6H6fid2nmQkFjuq8ZpSP9
	 W1bGqYG5RLCskhgukZl6O70V96jNcrUwsiUKTCohxrvjJb/d/2H/Y/yEjXsLTv/z77
	 hAjYRWAqbDenoPWrpnBi3Ky4/vJVJutMxlGtn9Kc=
Date: Mon, 24 Aug 2026 13:00:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-khugepaged-fix-outdated-comments-fix.patch removed from -mm tree
Message-Id: <20260824200019.CA2891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-fix-outdated-comments-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-outdated-comments-fix.patch

This patch was dropped because it was folded into mm-khugepaged-fix-outdated-comments.patch

------------------------------------------------------
From: Nico Pache (Red Hat) <nico.pache@linux.dev>
Subject: mm-khugepaged-fix-outdated-comments-fix
Date:   Fri Aug 21 04:27:28 2026 -0600

fix outdated comments

Link: https://lore.kernel.org/1c96e2f3-802f-472b-81e6-4af17a721a3c@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-outdated-comments-fix
+++ a/mm/khugepaged.c
@@ -1753,9 +1753,9 @@ static enum scan_result collapse_scan_pm
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check is racy, but such case is ephemeral and
-		 * we could always retry collapse later. Anyway the same
-		 * check will be done again later the risk seems low.
+		 * Here the check is racy, but such cases are ephemeral and
+		 * we can always retry collapse later. Anyway the same
+		 * check will be done again later, so the risk seems to be low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-khugepaged-refactor-per-scan-state-clearing-into-collapse_control_init_scan.patch
mm-khugepaged-extract-reference-check-into-folio_pte_referenced-helper.patch
mm-khugepaged-introduce-a-count_collapse_event-helper.patch
mm-khugepaged-fix-outdated-comments.patch
mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch
mm-documentation-clarify-where-the-mthp-stats-live.patch

