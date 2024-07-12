Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048A3127E0F;
	Fri, 12 Jul 2024 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824916; cv=none; b=VDhHsPHkCeqZTOL8Df5QWjg5PdjhCuZ7hD1Yo03olG4pkzvdnRn5z8F3gmwz9zufkbTRNckRhgnCWQVQWuMP1I+F2SB8/rA/Fgu47gnVVyyi6lREu4glJZWICrfz8zGa8NWcuuxDO/hkN/vfEWVIFffVl8/59RGcoNEE0nuc6Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824916; c=relaxed/simple;
	bh=v9vUC18iYGj0ah6dFsm/jo2Rl2nMXZfTyTexWJoNDvM=;
	h=Date:To:From:Subject:Message-Id; b=Iy7yJqV7+Y64nlNttjOrZ5QynA2n9sYwyvm/Xw2ZHWHwcrSnnNstEelWlNXMoiDz443LZJUmobublq86Cu3xQBSHaz3YnS28xPApktIrSNgVP7fOXzQ4kqx9DLbhzoGy5T1d9+KjLKper9IrMcCbbkg+4Q2T3/njpnFQqD+iyzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lc0Zfl1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lc0Zfl1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2313C4AF0B;
	Fri, 12 Jul 2024 22:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824915;
	bh=v9vUC18iYGj0ah6dFsm/jo2Rl2nMXZfTyTexWJoNDvM=;
	h=Date:To:From:Subject:From;
	b=lc0Zfl1f9J+ALZA4VEozW3rxDZhAuRIt2iwFdcmTh/uEooMrijXL70TWuHPJM9weU
	 uErSq37FUWQspmkbnd0CXqdZxPuy9S7qwphDhu6Yzchjcc2BlZtbX2AAZ+7O1MYzrT
	 fzJSl84P+58ylaAwpfplNXt15GW2SOoBXk2OozR0=
Date: Fri, 12 Jul 2024 15:55:15 -0700
To: mm-commits@vger.kernel.org,weixugc@google.com,stable@vger.kernel.org,mav@ixsystems.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-overshooting-shrinker-memory.patch removed from -mm tree
Message-Id: <20240712225515.D2313C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix overshooting shrinker memory
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-overshooting-shrinker-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


