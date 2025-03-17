Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E162A1D8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188463; cv=none; b=kj2wnPGcrAkkDvK6p3bhTWfaQpxpF8vfNnsaxaj0NwdaRgPM81d9cgVbLY+f423nsTBxb+/97wy2sZPwoWRQ6njlxqtTxR78fZWQg99qrQxVygMEo8oockGC3hJ1Cckiht2M03xgTTCsBpJXhhXu4XktAYId40wTa8LcKe72zEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188463; c=relaxed/simple;
	bh=C01XfCEQ6hcAD6vEJ2da+5W6haYyOWUI8UlCWVg7P+E=;
	h=Date:To:From:Subject:Message-Id; b=WSRNTYLVKgsBVIDLEnZslOp7X2r/zCWlxFJcmX0M3gRaLYn/VbDdx8eWxmg9Tu9yuXP+qXWveqv+QSqzk2ojBVgXHyyXYUI+qPsR52EeSUk4YkPjGchzJAHOOyokrKJ5R22WIfeY7VDUgtCzIfttmYVWTdGwIMTyw+JvH/gTYN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k7zgXnT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k7zgXnT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38982C4CEEC;
	Mon, 17 Mar 2025 05:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188463;
	bh=C01XfCEQ6hcAD6vEJ2da+5W6haYyOWUI8UlCWVg7P+E=;
	h=Date:To:From:Subject:From;
	b=k7zgXnT4x6KqKqeVxMiGxwGoy0k+6fn5qibzsEwQmmpSqP6T/EsXQpKYx/jmtHav/
	 mNMDgWO/KfOoW40zfh1PDAVVCzVAlZcP9O3ZF9ExT6z5CQQt0gsJq2QWBZPn8HJoj2
	 0fhS81hlrUx5RoSbru4Qaxs0Ddt2n62v2S+JCUko=
Date: Sun, 16 Mar 2025 22:14:22 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch removed from -mm tree
Message-Id: <20250317051423.38982C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: avoid reclaiming irrelevant swap cache
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-reclaiming-irrelevant-swap-cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: avoid reclaiming irrelevant swap cache
Date: Fri, 14 Mar 2025 00:59:29 +0800

Patch series "mm, swap: remove swap slot cache", v3.

Slot cache was initially introduced by commit 67afa38e012e ("mm/swap: add
cache for swap slots allocation") to reduce the lock contention of
si->lock.

Previous series "mm, swap: rework of swap allocator locks" [1] removed
swap slot cache for freeing path as freeing path no longer touches
si->lock in most cased.  Allocation path also have slight to none
contention on si->lock since that series, but slot cache still helps to
reduce other overheads, like counters and the plist.

This series removes the slot cache from allocation path too, by using the
cluster as allocation fast path and also reduce other overheads.

Now slot cache is completely gone, the code is much simplified without
obvious feature or performance change, also clean up related workaround. 
Also this should avoid other potential issues, e.g.  the long pinning of
swap slots: swap slot cache pins swap slots with HAS_CACHE, causing
reclaim or allocation fail to use these slots on scanning.

The only behavior change is the swap device allocation rotation mechanism,
as explained in the patch "mm, swap: use percpu cluster as allocation fast
path".

Test results are looking good after deleting the swap slot cache:

- vm-scalability with: `usemem --init-time -O -y -x -R -31 1G`,
12G memory cgroup using simulated pmem as SWAP (32G pmem, 32 CPUs),
16 test runs for each case, measuring the total throughput:

                      Before (KB/s) (stdev)  After (KB/s) (stdev)
Random (4K):          424907.60 (24410.78)   414745.92  (34554.78)
Random (64K):         163308.82 (11635.72)   167314.50  (18434.99)
Sequential (4K, !-R): 6150056.79 (103205.90) 6321469.06 (115878.16)

- Build linux kernel with make -j96, using 4K folio with 1.5G memory
cgroup limit and 64K folio with 2G memory cgroup limit, on top of tmpfs,
12 test runs, measuring the system time:

                  Before (s) (stdev)  After (s) (stdev)
make -j96 (4K):   6445.69 (61.95)     6408.80 (69.46)
make -j96 (64K):  6841.71 (409.04)    6437.99 (435.55)

The performance is unchanged, slightly better in some cases.

[1] https://lore.kernel.org/linux-mm/20250113175732.48099-1-ryncsn@gmail.com/


This patch (of 7):

Swap allocator will do swap cache reclaim to recycle HAS_CACHE slots for
allocation.  It initiates the reclaim from the offset to be reclaimed and
looks up the corresponding folio.  The lookup process is lockless, so it's
possible the folio will be removed from the swap cache and given a
different swap entry before the reclaim locks the folio.  If it happens,
the reclaim will end up reclaiming an irrelevant folio, and return wrong
return value.

This shouldn't cause any problem with correctness or stability, but it is
indeed confusing and unexpected, and will increase fragmentation, decrease
performance.

Fix this by checking whether the folio is still pointing to the offset the
allocator want to reclaim before reclaiming it.

Link: https://lkml.kernel.org/r/20250313165935.63303-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250313165935.63303-2-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-avoid-reclaiming-irrelevant-swap-cache
+++ a/mm/swapfile.c
@@ -210,6 +210,7 @@ static int __try_to_reclaim_swap(struct
 	int ret, nr_pages;
 	bool need_reclaim;
 
+again:
 	folio = filemap_get_folio(address_space, swap_cache_index(entry));
 	if (IS_ERR(folio))
 		return 0;
@@ -227,8 +228,16 @@ static int __try_to_reclaim_swap(struct
 	if (!folio_trylock(folio))
 		goto out;
 
-	/* offset could point to the middle of a large folio */
+	/*
+	 * Offset could point to the middle of a large folio, or folio
+	 * may no longer point to the expected offset before it's locked.
+	 */
 	entry = folio->swap;
+	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+		folio_unlock(folio);
+		folio_put(folio);
+		goto again;
+	}
 	offset = swp_offset(entry);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
_

Patches currently in -mm which might be from kasong@tencent.com are


