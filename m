Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66677211499
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343115; cv=none; b=Yu1y8Ju0F2o1KFMTNoL//f76it27WHDw2cR0roENbOnF4ew61jxGPJIX+/Ps0hE8Pg13ugFiq10hCZfTlU8R1UR8C51qduvpVWEPqnVgxRGNS2qNbFGnk0jPAJc/lF8mUujzpPm8CSVkG0XbTS4/Gx3tx+Drsf2WTmDlbpBOrig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343115; c=relaxed/simple;
	bh=hRxaFhY6Gxe0iYeV4K6HPTqrU8nG3pCI7ynlLPULAQg=;
	h=Date:To:From:Subject:Message-Id; b=kY8eRLyoCtKHIGrVqACTkJ9xiLv10C7PyfNMQr03Lfox4hoB0E4cM1WH6H4/2IgA2HUWB4lMwBTK/N8OkYm8n59xOvmes+rGc8CWEgfslB3NKE23EjIz42U8Az8Jq5Gtvi78AsIxl3iw1BUzONbTgpYTRFRJ4PyDpt3GCwe2RT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uq5Jmf52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uq5Jmf52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0710C16AAE;
	Mon, 17 Nov 2025 01:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343115;
	bh=hRxaFhY6Gxe0iYeV4K6HPTqrU8nG3pCI7ynlLPULAQg=;
	h=Date:To:From:Subject:From;
	b=uq5Jmf5271RxJK1Q3XQYJjYAWJGpmym1xCteeje0A9kTLWFN7Eaka20vuSNJ2dSbJ
	 yRsJIg9G1jJDnTYHXekIHMBelyOo4lSbN04pqSFj5hfPABnrsegVHMUVVIOEpMARF5
	 5s9aKgUttMpW3NexSTq+0yT6DGjtj3QHKCoZcNxU=
Date: Sun, 16 Nov 2025 17:31:54 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,dave.hansen@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch removed from -mm tree
Message-Id: <20251117013154.E0710C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: prevent reporting pcp->batch = 0
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/page_alloc: prevent reporting pcp->batch = 0
Date: Thu, 9 Oct 2025 12:29:31 -0700

zone_batchsize returns the appropriate value that should be used for
pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
1M, however, it leads to some incorrect math.

In the above case, we will get an intermediary value of 1, which is then
rounded down to the nearest power of two, and 1 is subtracted from it.
Since 1 is already a power of two, we will get batch = 1-1 = 0:

	batch = rounddown_pow_of_two(batch + batch/2) - 1;

A pcp->batch value of 0 is nonsensical. If this were actually set, then
functions like drain_zone_pages would become no-ops, since they could
only free 0 pages at a time.

Of the two callers of zone_batchsize, the one that is actually used to
set pcp->batch works around this by setting pcp->batch to the maximum
of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
incorrectly prints out the batch size of the zone to be 0.

This is probably rare in a typical zone, but the DMA zone can often have
less than 4096 pages, which means it will print out "LIFO batch:0".

Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1

Instead of dealing with the error handling and the mismatch between the
reported and actual zone batchsize, just return 1 if the zone_batchsize
is 1 page or less before the rounding.

Link: https://lkml.kernel.org/r/20251009192933.3756712-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-prevent-reporting-pcp-batch-=-0
+++ a/mm/page_alloc.c
@@ -5866,8 +5866,8 @@ static int zone_batchsize(struct zone *z
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-	if (batch < 1)
-		batch = 1;
+	if (batch <= 1)
+		return 1;
 
 	/*
 	 * Clamp the batch to a 2^n - 1 value. Having a power
@@ -6018,7 +6018,7 @@ static void zone_set_pageset_high_and_ba
 {
 	int new_high_min, new_high_max, new_batch;
 
-	new_batch = max(1, zone_batchsize(zone));
+	new_batch = zone_batchsize(zone);
 	if (percpu_pagelist_high_fraction) {
 		new_high_min = zone_highsize(zone, new_batch, cpu_online,
 					     percpu_pagelist_high_fraction);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are


