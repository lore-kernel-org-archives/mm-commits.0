Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795D02DF134;
	Fri, 14 Aug 2026 01:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669725; cv=none; b=CVqs10sdqeJ3rcxE1R7Qbj7Uf0WFweGen1lcAfFlFzFdEPh0uC06MBKIkUxW1FfmgYq+YAtxeAEZIIVndXPmX+eF8y4tCyDCN+xGXV7XM/MEs2zcnY9kij2y1EzeyNWd/6xWeRDqSxRT4J99DcPhckg+cX9iIYWmEcDtnCAgO4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669725; c=relaxed/simple;
	bh=jd9j59UHC/85iQPmqjwVRksbsjaDhnHqSO/aHKQnwHM=;
	h=Date:To:From:Subject:Message-Id; b=jL7PAUQZ1Plo7PKxwykQqlnXa9ztNsNHYNyheo461eFnx4SMHWcIZFvfgHz/QNngOwB102plrGkjv7ECJy3qMmG4Du9ewdnaCNxGJEQVkKfrSRKCiECNkrumkYbq/R7yE4qDPdG36wz+xqpPpNxooS3kYiDnU3/WbJ8neQV+cFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O5s7QWEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O5s7QWEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1204A1F000E9;
	Fri, 14 Aug 2026 01:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669724;
	bh=GfhUJbRYRBe5Q88JhPCueXU9JJ8Swf8GrYjREkOfSFE=;
	h=Date:To:From:Subject;
	b=O5s7QWExXDYRm9bdEqD1BDyg6zVr25nBhZaNubefq42zgInGp81O9j8j8slRNTJS6
	 mX+XEY/u6BPkFZNQzt5AXHVVJf/vIiOMvNLDtPJPTJonHPv9+TO4T4yRvutYag/6Kc
	 70n0zObTIhZvGS2PNS16BGTIj/E3V037WPpQRAxA=
Date: Thu, 13 Aug 2026 18:08:43 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch removed from -mm tree
Message-Id: <20260814010844.1204A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: don't free a hibernation slot that is in the swap cache
has been removed from the -mm tree.  Its filename was
     mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: don't free a hibernation slot that is in the swap cache
Date: Tue, 11 Aug 2026 22:22:06 +0900

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone
else.

This bug can trigger silent memory corruption, process crashes, or data
instability across completely unrelated userspace applications - typically
occurring when uswsusp is preparing the hibernation image.

I found this while working on giving hibernation slots their own marker in
the swap table, which I had discussed with Kairui. 
(https://lore.kernel.org/linux-mm/abp7aDgYLrxF3Me8@KASONG-MC4/) As far as
I know there are no reports, so there is no Reported-by/Closes to add.

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when
the folio leaves the cache, either through the reclaim below or through
normal reclaim later.

Link: https://lore.kernel.org/20260811132209.2862708-2-youngjun.park@lge.com
Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-dont-free-a-hibernation-slot-that-is-in-the-swap-cache
+++ a/mm/swapfile.c
@@ -2196,7 +2196,14 @@ void swap_free_hibernation_slot(swp_entr
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
_

Patches currently in -mm which might be from youngjun.park@lge.com are


