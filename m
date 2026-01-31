Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBC738A9C2
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898407; cv=none; b=HosVPbiopybeRelec5jlwqaBy9uE1BFDaFRXSek5KJPkFORmJdy43V7yzW+CDrjeDhqNBBwor95s4pNdBiISJfqkajBADoXb6+9xnCKF/E2lGdHZBfy5Q/R6a0Goz8c0022Z7DXhBeiwEym+1yUTJgRoOR5rsmjSPDbDbYMNhws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898407; c=relaxed/simple;
	bh=o69yT762JAQWtbVXRwz0sHoHvZErj6HbJDJKeqPHYN4=;
	h=Date:To:From:Subject:Message-Id; b=aUrLfa0B+9cue5mUB0N6BymdhQDv9WqBcVbeRi96md/HpHt+P3X9Uq8FOaQeo35ogtySkljSQz/u5KtT3FsAeBiJ/ju7ZaREMpcfrfEjda19yVDNnHq4PtVcwbvjujA+G1N8zc8sbGggU9H/SFsMrgE8S/MilTWeuiU8HoqueOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oFfjG9In; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oFfjG9In"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23665C4CEF1;
	Sat, 31 Jan 2026 22:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898407;
	bh=o69yT762JAQWtbVXRwz0sHoHvZErj6HbJDJKeqPHYN4=;
	h=Date:To:From:Subject:From;
	b=oFfjG9InaRNmJrn963yCHur5Jnip1h0aaBBxTVS0iF4wxpF0RJ9wB9g/7j9l8JGgT
	 c4ICjHFAYU1guRXKDjTNe26ta5E6Bfm/4tm3lx+DvRo4zgAdKMu1OU6s8XylCaGnVD
	 q/dB53JFS2m/pzefvo2uCYAkktkPz/L3HwPOVmI8=
Date: Sat, 31 Jan 2026 14:26:46 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,rafael@kernel.org,nphamcs@gmail.com,kartikey406@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch removed from -mm tree
Message-Id: <20260131222647.23665C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: swap entry of a bad slot should not be considered as swapped out
has been removed from the -mm tree.  Its filename was
     mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: swap entry of a bad slot should not be considered as swapped out
Date: Sat, 20 Dec 2025 03:43:38 +0800

When checking if a swap entry is swapped out, we simply check if the
bitwise result of the count value is larger than 0.  But SWAP_MAP_BAD will
also be considered as a swao count value larger than 0.

SWAP_MAP_BAD being considered as a count value larger than 0 is useful for
the swap allocator: they will be seen as a used slot, so the allocator
will skip them.  But for the swapped out check, this isn't correct.

There is currently no observable issue.  The swapped out check is only
useful for readahead and folio swapped-out status check.  For readahead,
the swap cache layer will abort upon checking and updating the swap map. 
For the folio swapped out status check, the swap allocator will never
allocate an entry of bad slots to folio, so that part is fine too.  The
worst that could happen now is redundant allocation/freeing of folios and
waste CPU time.

This also makes it easier to get rid of swap map checking and update
during folio insertion in the swap cache layer.

Link: https://lkml.kernel.org/r/20251220-swap-table-p2-v5-9-8862a265a033@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 mm/swapfile.c   |   17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/mm/swapfile.c~mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out
+++ a/mm/swapfile.c
@@ -1766,10 +1766,10 @@ int __swap_count(swp_entry_t entry)
 	return swap_count(si->swap_map[offset]);
 }
 
-/*
- * How many references to @entry are currently swapped out?
- * This does not give an exact answer when swap count is continued,
- * but does include the high COUNT_CONTINUED flag to allow for that.
+/**
+ * swap_entry_swapped - Check if the swap entry is swapped.
+ * @si: the swap device.
+ * @entry: the swap entry.
  */
 bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 {
@@ -1780,7 +1780,8 @@ bool swap_entry_swapped(struct swap_info
 	ci = swap_cluster_lock(si, offset);
 	count = swap_count(si->swap_map[offset]);
 	swap_cluster_unlock(ci);
-	return !!count;
+
+	return count && count != SWAP_MAP_BAD;
 }
 
 /*
@@ -3677,10 +3678,10 @@ static int __swap_duplicate(swp_entry_t
 		count = si->swap_map[offset + i];
 
 		/*
-		 * swapin_readahead() doesn't check if a swap entry is valid, so the
-		 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+		 * For swapin out, allocator never allocates bad slots. for
+		 * swapin, readahead is guarded by swap_entry_swapped.
 		 */
-		if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+		if (WARN_ON(swap_count(count) == SWAP_MAP_BAD)) {
 			err = -ENOENT;
 			goto unlock_out;
 		}
--- a/mm/swap_state.c~mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out
+++ a/mm/swap_state.c
@@ -526,7 +526,7 @@ struct folio *swap_cache_alloc_folio(swp
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
+	/* Skip allocation for unused and bad swap slot for readahead. */
 	if (!swap_entry_swapped(si, entry))
 		return NULL;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-swap-fix-race-of-truncate-and-swap-entry-split.patch

