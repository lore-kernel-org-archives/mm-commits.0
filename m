Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415088;
	b=uPykOTAsJXWJniYx59OXSm7VeNTaotcYu/ENzQINdkEB2TBzIpOZLc9uc2YNf0L+XkXW
	 +7yf0VkeBcUno7KtfIq+rpAloqe2vPAa6BK3CMl/MCKiFuRuZJGb+g7L9/z02ZXjoVqx5
	 8ApCgNjCllcWL2qmLJhAWf8qdHM0qNSa9yiJz4ORjhzrwfF2kpkaj0SvhC8Quy26s07Mx
	 C4pZEpKkDhXLaA9FIDFyX8f/CnXyU+mjXIC/kVX7EZwjf6M98pls6SdrJq1wQBFC2qjHb
	 rBCTLy1EESSlf4SJJC0xCoqIY5OYi+Zlq1wqKdxUvz7N8vKkkxN8HpgmPNptiSy3WIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415088;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=y8IB1pTKi0tLVTsh2PEh2MZHFVxrUg0Y4YWklANPYKc=;
	b=GK0b6G6IglVmyv/kDvnPE6aSZKwiI2bCoekqhp9Epbv71pZBS4rSK/RCJWLjpIsNdgR4
	 iy2NqhuJZYOOdyOOu9D+VLfPrfgVjcWb/Luf8zX8UMqvBykDqeE7FH+KUgrHWozEnNPYC
	 8lAI4GXamgM3GbTYUhrjlm8Di1NNAlQHhEVqrFn6KYJSroKB4vmUI8nUPOoQZMbVDZn9K
	 30x/t9m2VxnxAI9k/903zBINa15vTuTwy3paRVsjl9yaWBcHUAf+ZWEYGAdb/hqQXQqEc
	 F5Jl53t07ZL2A4wunsJsgZzdtIr2M0RQONiCXIyaP26XajrWdQo/KtwksIeukmJMaOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FE4If5iH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEE0606A31E;
	Mon, 23 Nov 2026 06:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FE4If5iH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4951F000CA;
	Mon, 23 Nov 2026 06:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415088;
	bh=y8IB1pTKi0tLVTsh2PEh2MZHFVxrUg0Y4YWklANPYKc=;
	h=Date:To:From:Subject;
	b=FE4If5iHj38SmL8da9KGMbMTXWScgHI67U2aqpVCFKKOREHYCuI0b4qFGtarl/sae
	 frVaDlxwwpasY0l36926wNrq5EIvxiDIZNI3QyKAHRUVVES4eXeLaSqRczjZJJxh3Y
	 xMGI4EI0/6V+M4HJdONQzHsgIPcBRzYFGM27VDkg=
Date: Sun, 22 Nov 2026 22:24:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,
	kasong@tencent.com,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch removed from -mm tree
Message-Id: <20261123062448.1C4951F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm, swap: only prefer nonfull clusters on synchronous devices
has been removed from the -mm tree.  Its filename was
     mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-zswap-batch-the-writeback-io-of-consecutive-entries.patch
mm-zswap-plug-the-writeback-io-of-an-lru-walk.patch
mm-bypass-swap-readahead-for-zswap.patch

