Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7342F55C1A;
	Thu, 11 Jul 2024 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720727405; cv=none; b=XEZf3iJqLNt3rqsw9451PqQbJmoqX/fJYhyD+CL4uXbhbCPN044HMZnsVOJsKB5FJ9GJWmfj4aWZAdOOgzbr5htGYpKpuBNig55Jm0UuJ9fSfgZ/McvXSSv5AsBaPProRdINP4bnUMV7xr/wo2szccxVoKm+Jz+TUPNt8SdVUtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720727405; c=relaxed/simple;
	bh=IxxXwzaovHBYM9CVL0vz5h3kNZvgHowt4OCidHZ6cXk=;
	h=Date:To:From:Subject:Message-Id; b=fuBV4upGxQOaqvyCmxJx5tR0T0WROwmYVDiiRG37Aw8GSOB5+HYaoix+CUuMICZ7ygNg6yKqKh7bsAl5H75MaGba5fqRY1GP3syh6A2UeDRjRnsqRTtwgZoBJyWkvSWBKsisc3O/Ei13ZoEMXYWhpS0OzjaLFIx16Ihj0YFcruI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xil5mJsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xil5mJsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAA1C4AF09;
	Thu, 11 Jul 2024 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720727405;
	bh=IxxXwzaovHBYM9CVL0vz5h3kNZvgHowt4OCidHZ6cXk=;
	h=Date:To:From:Subject:From;
	b=Xil5mJsPmvzsYNdwlRq2AbgelBaezLymcn6GEzNPFLwM50psyFPIZPfCho1R0nqZf
	 UV9uA7vejL17xp9VQiO0rBwSThf5UkesNr7efVbrS4vFNVYarYr6LdoUZIPaVtsPId
	 ZbdeQyfdQOm+l4e1Jeu9cW7tPEm2hXNJwxC5bzoU=
Date: Thu, 11 Jul 2024 12:50:04 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stable@vger.kernel.org,mav@ixsystems.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-overshooting-shrinker-memory.patch added to mm-unstable branch
Message-Id: <20240711195004.EDAA1C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix overshooting shrinker memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-fix-overshooting-shrinker-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-overshooting-shrinker-memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: fix overshooting shrinker memory
Date: Thu, 11 Jul 2024 13:19:57 -0600

set_initial_priority() tries to jump-start global reclaim by estimating
the priority based on cold/hot LRU pages.  The estimation does not account
for shrinker objects, and it cannot do so because their sizes can be in
different units other than page.

If shrinker objects are the majority, e.g., on TrueNAS SCALE 24.04.0 where
ZFS ARC can use almost all system memory, set_initial_priority() can
vastly underestimate how much memory ARC shrinker can evict and assign
extreme low values to scan_control->priority, resulting in overshoots of
shrinker objects.

To reproduce the problem, using TrueNAS SCALE 24.04.0 with 32GB DRAM, a
test ZFS pool and the following commands:

  fio --name=mglru.file --numjobs=36 --ioengine=io_uring \
      --directory=/root/test-zfs-pool/ --size=1024m --buffered=1 \
      --rw=randread --random_distribution=random \
      --time_based --runtime=1h &

  for ((i = 0; i < 20; i++))
  do
    sleep 120
    fio --name=mglru.anon --numjobs=16 --ioengine=mmap \
      --filename=/dev/zero --size=1024m --fadvise_hint=0 \
      --rw=randrw --random_distribution=random \
      --time_based --runtime=1m
  done

To fix the problem:
1. Cap scan_control->priority at or above DEF_PRIORITY/2, to prevent
   the jump-start from being overly aggressive.
2. Account for the progress from mm_account_reclaimed_pages(), to
   prevent kswapd_shrink_node() from raising the priority
   unnecessarily.

Link: https://lkml.kernel.org/r/20240711191957.939105-2-yuzhao@google.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Alexander Motin <mav@ixsystems.com>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-fix-overshooting-shrinker-memory
+++ a/mm/vmscan.c
@@ -4930,7 +4930,11 @@ static void set_initial_priority(struct
 	/* round down reclaimable and round up sc->nr_to_reclaim */
 	priority = fls_long(reclaimable) - 1 - fls_long(sc->nr_to_reclaim - 1);
 
-	sc->priority = clamp(priority, 0, DEF_PRIORITY);
+	/*
+	 * The estimation is based on LRU pages only, so cap it to prevent
+	 * overshoots of shrinker objects by large margins.
+	 */
+	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
 static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *sc)
@@ -6754,6 +6758,7 @@ static bool kswapd_shrink_node(pg_data_t
 {
 	struct zone *zone;
 	int z;
+	unsigned long nr_reclaimed = sc->nr_reclaimed;
 
 	/* Reclaim a number of pages proportional to the number of zones */
 	sc->nr_to_reclaim = 0;
@@ -6781,7 +6786,8 @@ static bool kswapd_shrink_node(pg_data_t
 	if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
 		sc->order = 0;
 
-	return sc->nr_scanned >= sc->nr_to_reclaim;
+	/* account for progress from mm_account_reclaimed_pages() */
+	return max(sc->nr_scanned, sc->nr_reclaimed - nr_reclaimed) >= sc->nr_to_reclaim;
 }
 
 /* Page allocator PCP high watermark is lowered if reclaim is active. */
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-truncate-batch-clear-shadow-entries.patch
mm-truncate-batch-clear-shadow-entries-v2.patch
mm-mglru-fix-div-by-zero-in-vmpressure_calc_level.patch
mm-mglru-fix-overshooting-shrinker-memory.patch

