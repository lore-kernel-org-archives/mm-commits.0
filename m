Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4F02C0287
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766268304; cv=none; b=QS2sJLNA6nv5iEelftViuzm9UVa6H31GMhIWwtxHmK4/nqbRvY4n3Y9b34J9+Y04b98lkcJOlY62npA5ouU145WdV1xqz2i5C1Y6tJcJhPA1L2Kb7CvokMvxPrbSNM295dccXdMN+7YgzbfjJIdzYLRUAMlXLA1xV2pIyjrirfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766268304; c=relaxed/simple;
	bh=YFmqGckcFZK/JtfFwJn7h9Ed/yA3wLpuTweRnukpi6c=;
	h=Date:To:From:Subject:Message-Id; b=KGiJ435ToEFl1uYq4IgfnN8h4Bo7ZvOQMYMfrMc1GskwsBgV12mpFU/TPyJMDqKWE33CduDEUWG/Ys4X9UfpbPRXZ1hVfF77EozdIaDJlcOfNCHVUNxprK+vl5TGQtIyTHPlvlifCojvqBCtW5XfROW4qbXTdF6p1pbd2kcASTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CqGb2GMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CqGb2GMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB44C4CEF5;
	Sat, 20 Dec 2025 22:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766268304;
	bh=YFmqGckcFZK/JtfFwJn7h9Ed/yA3wLpuTweRnukpi6c=;
	h=Date:To:From:Subject:From;
	b=CqGb2GMoVUO0VrR0Y5suEtMlMxoZQO59Jhk/gy2H8zU8oK0DhVcPHAPtHb98DpiRf
	 Tu4NGyY8PTam4NWmEX6frAxzQ+oC0WvoXYOdT2vacPRGFm0beJLqIfXTp3XXs2UUko
	 ZdXXOg9V7mKZSL0nLepcqSawh4MUXkMHvEqUrN9o=
Date: Sat, 20 Dec 2025 14:05:03 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,rafael@kernel.org,nphamcs@gmail.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch added to mm-new branch
Message-Id: <20251220220504.7CB44C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: swap entry of a bad slot should not be considered as swapped out
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
@@ -527,7 +527,7 @@ struct folio *swap_cache_alloc_folio(swp
 	if (folio)
 		return folio;
 
-	/* Skip allocation for unused swap slot for readahead path. */
+	/* Skip allocation for unused and bad swap slot for readahead. */
 	if (!swap_entry_swapped(si, entry))
 		return NULL;
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio.patch
mm-swap-split-swap-cache-preparation-loop-into-a-standalone-helper.patch
mm-swap-never-bypass-the-swap-cache-even-for-swp_synchronous_io.patch
mm-swap-always-try-to-free-swap-cache-for-swp_synchronous_io-devices.patch
mm-swap-simplify-the-code-and-reduce-indention.patch
mm-swap-free-the-swap-cache-after-folio-is-mapped.patch
mm-shmem-never-bypass-the-swap-cache-for-swp_synchronous_io.patch
mm-swap-swap-entry-of-a-bad-slot-should-not-be-considered-as-swapped-out.patch
mm-swap-consolidate-cluster-reclaim-and-usability-check.patch
mm-swap-split-locked-entry-duplicating-into-a-standalone-helper.patch
mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer.patch
mm-swap-remove-workaround-for-unsynchronized-swap-map-cache-state.patch
mm-swap-cleanup-swap-entry-management-workflow.patch
mm-swap-add-folio-to-swap-cache-directly-on-allocation.patch
mm-swap-check-swap-table-directly-for-checking-cache.patch
mm-swap-clean-up-and-improve-swap-entries-freeing.patch
mm-swap-drop-the-swap_has_cache-flag.patch
mm-swap-remove-no-longer-needed-_swap_info_get.patch

