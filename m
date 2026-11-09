Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794266661;
	b=taeGIGKy7pMcVrXNUz1VJw3YWg6nvNj5nSo8xZVvkxyRxaVgmErcXSLQ9ypgLnky67oj
	 D3LmqqhIC4ipriQ2hXwhKtZEulEOSs0D8MlFpocpcnlcj0yrSR9gxGn1tImbTJouvme3s
	 i8NG//WzWLAXHB7rCbvph3GbqA1TVUf9YzQ1p+N48D/kVgp/MaRPlgFv4ewA2xRFqU85j
	 bOYAMaT/C4lL4pPt10+KieYtwiuIQq0OoAqCpXRDwbBtVC+SStAuPcRj2dhbBSUb5WoyG
	 3YGVkxS3xhSMwx2s/kYqOC5fqpKGD9vrr8iGiuoX4F/J1RKyWqul8kD8aSEb3fHCXjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794266661;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Rzt1F3EoRYhwGwpwNOH94Zqcq6o0Rk2yapNouNW/X+c=;
	b=GcS//jFDk2p16SEY2Y147Riauinu9gW4X4uw6PH0+C3KlcGcArxV7/aR0Th5IxAsS0Bu
	 sZhzxy4H3XY8Y1To/g6/Kl90yNUCa5TJ78t7rQQyr3g/Aq6rC7SXVh5D9SxTvxM7/ud0a
	 UkBarMfiFtZovhermmUJ6MoyzOSPaRnjaGZPn8tNV09x+TprP5qZ/AX0LmIZvLngP1g1D
	 KAkLRNeO3Rd07NCT478YaSTBRcuGIHMTWoAg5iwj0qWz6OWJOK+BXTK6AMqFhZSbaHfgy
	 2lRPy6QcftGcU2mNeNaeA/JsIdx3V5J9arDUpkPnDpg2GZPXMcIStwCd1m9kRuvPedg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="z/iessp6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D16606A321;
	Mon,  9 Nov 2026 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z/iessp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188E21F0089F;
	Mon,  9 Nov 2026 23:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794266660;
	bh=Rzt1F3EoRYhwGwpwNOH94Zqcq6o0Rk2yapNouNW/X+c=;
	h=Date:To:From:Subject;
	b=z/iessp6dXMrpRkU+nj0YwtFJzOF4mZZaqJ+QXOryub/yf8O/3DnIRLD5I0EVcMKT
	 R/r1okV0Hi13l/FPelsyfllEJuADSDBeh9zxYM6BQsMjP9arbqIZ0R2h80AbmMSDMl
	 2rp7U9cIeUTZTwQHTfgY5aEdWIThPaTMmD/GPPfM=
Date: Mon, 09 Nov 2026 15:24:19 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,
	kasong@tencent.com,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch added to mm-hotfixes-unstable branch
Message-Id: <20261109232420.188E21F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: only prefer nonfull clusters on synchronous devices
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm, swap: only prefer nonfull clusters on synchronous devices
Date: Mon, 09 Nov 2026 15:18:32 -0800

Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
the allocator fill nonfull clusters before taking free ones on swap
devices without discard.  Commit 3cedb745d354 ("mm: clarify the
folio_free_swap() for do_swap_page()") frees the swap slot on an exclusive
write fault.  Such faults now leave holes in formerly full clusters,
putting those clusters back on the nonfull list.  Reclaim allocates slots
one folio at a time, scattering a batch across the holes instead of
producing mergeable writes.  Later swapin can also require more read
requests.

On a mysql/sysbench workload in a 256 MiB memcg swapping to an NVMe
partition, 7.3 compared with the previous version produced 59% more device
read requests and 27% more write requests per transaction.  Throughput was
unchanged without iocost and fell 19% with iocost.

Prefer free clusters first on nonsynchronous devices, preserving
contiguous swap slots for merging I/O.  Keep nonfull-first on synchronous
devices such as zram: they do not merge I/O, and filling holes saves free
clusters for large folios.  Keep free-cluster preference on discard
devices to spread writes.

In the same workload, v2 reduced read requests per transaction by 14% and
write requests by 48% against its base kernel.  Throughput was unchanged
without iocost and improved 33% with iocost.  The RFC's batch-aware
allocator also improved this workload, but this policy needs no batch
information from reclaim.  Reverting the slot-freeing change would keep
swap space pinned under dirty pages; a proposed 50% swap-usage cutoff for
free-cluster preference was arbitrary and would stop helping as swap
filled.

The 7.0 to 7.2 kernels retained the swap slot after a write fault as a
side effect of 4b34f1d82c65 ("mm, swap: free the swap cache after folio is
mapped").  The observed regression requires both 9a42aed48421 and
3cedb745d354; stable backports should target trees containing both.

Link: https://lore.kernel.org/r/20261105155032.240457-1-alex@ghiti.fr
Link: https://lore.kernel.org/r/20261105155032.240457-2-alex@ghiti.fr
Link: https://lore.kernel.org/r/20261022145615.2184343-1-alex@ghiti.fr
Link: https://lore.kernel.org/r/CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com
Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kairui Song <kasong@tencent.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/swapfile.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices
+++ a/mm/swapfile.c
@@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries
 	return true;
 }
 
+/*
+ * Prefer a new cluster over a nonfull one if the device needs discard, to
+ * spread out the writes, or if it is not synchronous, to keep the slots
+ * of a swapout batch contiguous so that its writes can be merged.
+ */
+static bool swap_prefer_free_cluster(struct swap_info_struct *si)
+{
+	return (si->flags & SWP_PAGE_DISCARD) ||
+	       !(si->flags & SWP_SYNCHRONOUS_IO);
+}
+
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
@@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_
 	}
 
 new_cluster:
-	/*
-	 * If the device need discard, prefer new cluster over nonfull
-	 * to spread out the writes.
-	 */
-	if (si->flags & SWP_PAGE_DISCARD) {
+	if (swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
@@ -1159,7 +1166,7 @@ new_cluster:
 			goto done;
 	}
 
-	if (!(si->flags & SWP_PAGE_DISCARD)) {
+	if (!swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
_

Patches currently in -mm which might be from alex@ghiti.fr are

mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch
mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch
mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch
mm-bypass-swap-readahead-for-zswap.patch

