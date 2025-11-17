Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FF61FCE
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343113; cv=none; b=qYbbhFWkDXKmzItK2zI7afP+O9UrCQ2SHaox8LtC1d/Jb1Tp8/NJdRJw8ppdyRChF7j4abphl6itShJIePq/jthvjugEIHTZzI0HL2KfK5K/Ud8X4oDM8dp3nZGjpsRvCRC6GsNaadJTnghotzxYGzCkOxkdpAULz6oNzbcKhHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343113; c=relaxed/simple;
	bh=gXxbfoWvZ/ZR9jX+grWi4xLetT5wdoEMswnaY6JYriY=;
	h=Date:To:From:Subject:Message-Id; b=lv7acBB+M8P0AecEDXeydrUuKB3/vyx2YnkN4XGDL9FCzHnus6bPSEPThKIeRP9lDVIa0CuWCJ8ZvUF1DShLHWnK7mggD0q3vrq+wC9/mW3Tw4JO2RDUd4RtUxr58TBs44T67GCnCaJjmDmrWgO4fNQaNPVl0U++NZisV+s+m7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OQDx19Bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OQDx19Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E43BC113D0;
	Mon, 17 Nov 2025 01:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343113;
	bh=gXxbfoWvZ/ZR9jX+grWi4xLetT5wdoEMswnaY6JYriY=;
	h=Date:To:From:Subject:From;
	b=OQDx19Bko6e6Uf8OgN9d2uU+L+MWHPRiidpct4Xjf7FSoMUT07G6KZCn1tL1oqAYC
	 AT0+hQ+hab2NUudZaxUH/aQc4aTdCoYK4SPyAGMiEQzAEbdb2zSoMntXsYNcxAiIgA
	 cwPVupDOYdbYWtlMcPQlj+X7AJ2tj8NhjxxXjX+8=
Date: Sun, 16 Nov 2025 17:31:53 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,dave.hansen@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch removed from -mm tree
Message-Id: <20251117013153.8E43BC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: clarify batch tuning in zone_batchsize
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-clarify-batch-tuning-in-zone_batchsize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-clarify-batch-tuning-in-zone_batchsize
+++ a/mm/page_alloc.c
@@ -5860,13 +5860,12 @@ static int zone_batchsize(struct zone *z
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


