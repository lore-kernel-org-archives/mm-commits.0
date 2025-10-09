Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A595D27FD5D
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 21:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760044605; cv=none; b=VLSdYFPwCg0bzHM9KMu2JSiBVYaaHlq5c+HpsPngCdD8bZq80ROuOl8Ew5MbwN0C8skCLZZjZ56OP3tv038+Z7qbXseaMl0Gkc3ds6kGhYQaFpBmKVkMRo5a/hXiKUVGFiAp9GHi2ro5V9V61koeatyYlks6WIJIG50pKyJeMCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760044605; c=relaxed/simple;
	bh=vxk5Nw3J6jkhsQ4dtBfYqmQxRl1EjwrAlL+cGaQ1SCY=;
	h=Date:To:From:Subject:Message-Id; b=FLK9xu6lj5JGF/yx/kruEPBOpsjSprR+9eQDtBmbN+FQrTKNEhnzzJhHVAvDwfQF0m3VnnobD9krXnH6q8HgHXYLocgYM+GBgyFZB8+FmkRCyR/sN7F+HewGJGdxVZ9DIVIwb/Y2MWAVZLggEWlXVcc6mwS7I8PH8hlsEFhSpts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MbmueC65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MbmueC65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12853C4CEE7;
	Thu,  9 Oct 2025 21:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760044605;
	bh=vxk5Nw3J6jkhsQ4dtBfYqmQxRl1EjwrAlL+cGaQ1SCY=;
	h=Date:To:From:Subject:From;
	b=MbmueC65WGBeZ+bobGH8kMNcsnaPK7b4ogqmwjE2feqJc/VBUFVQikzCdgYMkM+06
	 U8u9TEOedb4H9/y8Xjb2mhcHwawHnaN9boEQHy01EuuE8xml7AdXguhFYVit9BHStC
	 s+WnglpC3KRP3+ORNZ6n1Ik3q1PEE8S91V0/4s1g=
Date: Thu, 09 Oct 2025 14:16:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,dave.hansen@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch added to mm-new branch
Message-Id: <20251009211645.12853C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: clarify batch tuning in zone_batchsize
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch

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
Subject: mm/page_alloc: clarify batch tuning in zone_batchsize
Date: Thu, 9 Oct 2025 12:29:30 -0700

Patch series "mm/page_alloc: pcp->batch cleanups", v2.

Two small cleanups for mm/page_alloc.

Patch 1 cleans up a misleading comment about how pcp->batch is calculated,
and folds in the calculation to increase clarity. No functional change
intended.

Patch 2 corrects zones from reporting that their pcp->batch is 0 when it
is actually 1. Namely, corrects ZONE_DMA from reporting that its batch
size is 0.


This patch (of 2):

Recently while working on another patch about batching free_pcppages_bulk
[1], I was curious why pcp->batch was always 63 on my machine.  This led
me to zone_batchsize(), where I found this set of lines to determine what
the batch size should be for the host:

	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
	batch /= 4;		/* We effectively *= 4 below */
	if (batch < 1)
		batch = 1;

All of this is good, except the comment above which says "We effectively
*= 4 below".  Nowhere else in the function zone_batchsize(), is there a
corresponding multipliation by 4.  Looking into the history of this, it
seems like Dave Hansen had also noticed this back in 2013 [1].  Turns out
there *used* to be a corresponding *= 4, which was turned into a *= 6
later on to be used in pageset_setup_from_batch_size(), which no longer
exists.

Despite this mismatch not being corrected in the comments, it seems that
getting rid of the /= 4 leads to a performance regression on machines with
less than 250G memory and 176 processors.  As such, let us preserve the
functionality but clean up the comments.

Fold the /= 4 into the calculation above: bitshift by 10+2=12, and instead
of dividing 1MB, divide 256KB and adjust the comments accordingly.  No
functional change intended.

Link: https://lkml.kernel.org/r/20251009192933.3756712-1-joshua.hahnjy@gmail.com
Link: https://lkml.kernel.org/r/20251009192933.3756712-2-joshua.hahnjy@gmail.com
Link: https://lore.kernel.org/all/20251002204636.4016712-1-joshua.hahnjy@gmail.com/ [1]
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clarify-batch-tuning-in-zone_batchsize
+++ a/mm/page_alloc.c
@@ -5911,13 +5911,12 @@ static int zone_batchsize(struct zone *z
 	int batch;
 
 	/*
-	 * The number of pages to batch allocate is either ~0.1%
-	 * of the zone or 1MB, whichever is smaller. The batch
+	 * The number of pages to batch allocate is either ~0.025%
+	 * of the zone or 256KB, whichever is smaller. The batch
 	 * size is striking a balance between allocation latency
 	 * and zone lock contention.
 	 */
-	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
-	batch /= 4;		/* We effectively *= 4 below */
+	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
 	if (batch < 1)
 		batch = 1;
 
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-page_alloc-vmstat-simplify-refresh_cpu_vm_stats-change-detection.patch
mm-page_alloc-batch-page-freeing-in-decay_pcp_high.patch
mm-page_alloc-batch-page-freeing-in-free_frozen_page_commit.patch
mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch
mm-page_alloc-prevent-reporting-pcp-batch-=-0.patch

