Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A4E1D86FF
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754519223; cv=none; b=Y4AhEeCsPXsn12zA2UPwO4feCn5hH0FMO1/ezMdsUSl1XRzUbfCnUtgNJnCVNI/u1G2s4LuIc4nd+5fnRyijqnFEuuYwG6puozhNFI59zKMu9tUTLx2AA9vT2OXnO696xtcPM/xRXGbjO7ZadqNiShH90xqWFDxhW5Faz1pRfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754519223; c=relaxed/simple;
	bh=zb0+pW864E48TP/8nhnBO4fYBKRORe4iIUsnpU0uraw=;
	h=Date:To:From:Subject:Message-Id; b=keD00dEv+kZTtvUOLGJWGFswqx1RySwkjC6nT8N832jHj6VNA7HWrvGIi6r4ZGuvLwkmaKRlHRNYtmK8IuF++B4FJwOIv6lCfkRzU4m/upFbLFWmvlUYl7kW9bexzaID/roAlJ+AfmcJFH2PoDNB935W4ga0Z44rke0lEj5P00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XKbSFQcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XKbSFQcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D9AC4CEE7;
	Wed,  6 Aug 2025 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754519223;
	bh=zb0+pW864E48TP/8nhnBO4fYBKRORe4iIUsnpU0uraw=;
	h=Date:To:From:Subject:From;
	b=XKbSFQcsu6dPOto7RgnEHcTBOileUw26NurmotBE4U4x+uQchcLJvBNFUPhkq9REo
	 1zpNLcnCxbrIRFxw95umv/pZZGfgdFy1rBy5JkbVTx2GhlZxO3INcMcMa1iTEq4k8a
	 3DTGoM+MpO1XBAi8oiLNGMhumFOIlthbncIjZbm8=
Date: Wed, 06 Aug 2025 15:27:02 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-prefer-nonfull-over-free-clusters.patch added to mm-new branch
Message-Id: <20250806222703.50D9AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: prefer nonfull over free clusters
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-prefer-nonfull-over-free-clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-prefer-nonfull-over-free-clusters.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: prefer nonfull over free clusters
Date: Thu, 7 Aug 2025 00:17:48 +0800

We prefer a free cluster over a nonfull cluster whenever a CPU local
cluster is drained to respect the SSD discard behavior [1].  It's not a
best practice for non-discarding devices.  And this is causing a higher
fragmentation rate.

So for a non-discarding device, prefer nonfull over free clusters.  This
reduces the fragmentation issue by a lot.

Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:

Before: sys time: 6176.34s  64kB/swpout: 1659757  64kB/swpout_fallback: 139503
After:  sys time: 6194.11s  64kB/swpout: 1689470  64kB/swpout_fallback: 56147

Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:

After:  sys time: 5531.49s  64kB/swpout: 1791142  64kB/swpout_fallback: 17676
After:  sys time: 5587.53s  64kB/swpout: 1811598  64kB/swpout_fallback: 0

Performance is basically unchanged, and the large allocation failure rate
is lower. Enabling all mTHP sizes showed a more significant result.

Using the same test setup with 10G ZRAM and enabling all mTHP sizes:

128kB swap failure rate:
Before: swpout:451599 swpout_fallback:54525
After:  swpout:502710 swpout_fallback:870

256kB swap failure rate:
Before: swpout:63652  swpout_fallback:2708
After:  swpout:65913  swpout_fallback:20

512kB swap failure rate:
Before: swpout:11663  swpout_fallback:1767
After:  swpout:14480  swpout_fallback:6

2M swap failure rate:
Before: swpout:24     swpout_fallback:1442
After:  swpout:1329   swpout_fallback:7

The success rate of large allocations is much higher.

Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr.corp.intel.com/ [1]
Link: https://lkml.kernel.org/r/20250806161748.76651-4-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swap-prefer-nonfull-over-free-clusters
+++ a/mm/swapfile.c
@@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_
 	}
 
 new_cluster:
-	ci = isolate_lock_cluster(si, &si->free_clusters);
-	if (ci) {
-		found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
-						order, usage);
-		if (found)
-			goto done;
+	/*
+	 * If the device need discard, prefer new cluster over nonfull
+	 * to spread out the writes.
+	 */
+	if (si->flags & SWP_PAGE_DISCARD) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
 	}
 
-	/* Try reclaim from full clusters if free clusters list is drained */
-	if (vm_swap_full())
-		swap_reclaim_full_clusters(si, false);
-
 	if (order < PMD_ORDER) {
 		while ((ci = isolate_lock_cluster(si, &si->nonfull_clusters[order]))) {
 			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
@@ -927,7 +929,23 @@ new_cluster:
 			if (found)
 				goto done;
 		}
+	}
+
+	if (!(si->flags & SWP_PAGE_DISCARD)) {
+		ci = isolate_lock_cluster(si, &si->free_clusters);
+		if (ci) {
+			found = alloc_swap_scan_cluster(si, ci, cluster_offset(si, ci),
+							order, usage);
+			if (found)
+				goto done;
+		}
+	}
 
+	/* Try reclaim full clusters if free and nonfull lists are drained */
+	if (vm_swap_full())
+		swap_reclaim_full_clusters(si, false);
+
+	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
 		 * allocation will surely success, and large allocation
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-only-scan-one-cluster-in-fragment-list.patch
mm-swap-remove-fragment-clusters-counter.patch
mm-swap-prefer-nonfull-over-free-clusters.patch

