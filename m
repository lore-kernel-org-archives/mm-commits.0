Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09CA27FD5D
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760044606; cv=none; b=BNN19U9sm+I3WjznyBCdoQmweWyO/mKqVOY/QDW5TxGZ6aVtudspiZAvNjxAWbEkfE5Kp96KSzz6Mlf/r4TignGj8SvwMw7GnjBp9U3Foud5LcKlEwEjoWeRWrNCFHCvxfizJnnv/KtvbvGYiOYt6lXWC+D9ADYfYYiYs5ghR3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760044606; c=relaxed/simple;
	bh=Nx+hfCRJ2YB/AYD0KQ//4HXn6N3As5pZHXRE/94wn4s=;
	h=Date:To:From:Subject:Message-Id; b=URg8zjnM2Mx0NiA3xUhUi0/E6qtq/5ZwLBywUwO/83cmBkeClJV9xZrSvpLsRTet31KMwINmv4CRW67YFpFeS8Sr46LhJ4PzokkMXu7clIHX6BZKd1HL7JOavh5rGWkFZ841e6vmSy9YM4N1S+v8+Ft8mAUonG8/dT3x7ivO0A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qYAQTSEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qYAQTSEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475E7C4CEE7;
	Thu,  9 Oct 2025 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760044606;
	bh=Nx+hfCRJ2YB/AYD0KQ//4HXn6N3As5pZHXRE/94wn4s=;
	h=Date:To:From:Subject:From;
	b=qYAQTSEePsiAQL5pgCODc6BB4lFx0hA9LpgJzTlspRumubcF1fP/PfNbw5hpKQ55p
	 oc6/P2ujYzdvhvTWASm3xJdgilBP0dKje+5/DCEIdzVUDkghw8RFrjByHSFkhJTNHg
	 VtQ2SEAfe9rEPZpWiDduDxVQQRWDUV9y5o+hZ1Cw=
Date: Thu, 09 Oct 2025 14:16:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,dave.hansen@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch added to mm-new branch
Message-Id: <20251009211646.475E7C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: Prevent reporting pcp->batch = 0
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch

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
Subject: mm/page_alloc: Prevent reporting pcp->batch = 0
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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-prevent-reporting-pcp-batch-=-0
+++ a/mm/page_alloc.c
@@ -5917,8 +5917,8 @@ static int zone_batchsize(struct zone *z
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
-	if (batch < 1)
-		batch = 1;
+	if (batch <= 1)
+		return 1;
 
 	/*
 	 * Clamp the batch to a 2^n - 1 value. Having a power
@@ -6069,7 +6069,7 @@ static void zone_set_pageset_high_and_ba
 {
 	int new_high_min, new_high_max, new_batch;
 
-	new_batch = max(1, zone_batchsize(zone));
+	new_batch = zone_batchsize(zone);
 	if (percpu_pagelist_high_fraction) {
 		new_high_min = zone_highsize(zone, new_batch, cpu_online,
 					     percpu_pagelist_high_fraction);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch
mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch
mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch

