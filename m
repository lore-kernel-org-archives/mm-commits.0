Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A43B14B08A
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547818; cv=none; b=FDLIYjXFw6ZhE0E4EP7DncOrlQJcd6rvYbWjgiSSM5wVo7KpWez0ikBgVG+R//9P4igyN+HiqQ9QNMahkYqiWJ29RvbSXWYVkoXq5RHd/7EVjcuWcoIH9O3hKLGURPfLzP/sbaY9uvWJPjz9gjNGzgFOSQ6RZSjseDRdnqq8h78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547818; c=relaxed/simple;
	bh=7sgpMVFCBDb5J5Zhq9Xg4/mAeBeTLNRA+XJHbyE7zrc=;
	h=Date:To:From:Subject:Message-Id; b=Fhs5lLgm5taSzodICUkFF5bSNxxO0CvLVvPoXDkrSehpwfDyACQ+HjSD9/zorOjKXhu4M1xhBXDWxQLa70ZfIwD/2bR3XqPWZC4ZQa90znkUAMgjMp7sxVzWKqnqaTdTckBTUg7ZxKlEa4AUgYq8AdQh+bUALNNuSiqYCfwYZuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JYzUTQpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JYzUTQpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C40C4CEF7;
	Fri, 20 Feb 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547818;
	bh=7sgpMVFCBDb5J5Zhq9Xg4/mAeBeTLNRA+XJHbyE7zrc=;
	h=Date:To:From:Subject:From;
	b=JYzUTQpGKu3/gKv8z/wcxq9H0BZWA4H+HjpY2XXgb/tf9D5IgsL+J3MJLgFcfeaD+
	 gZW0IfwrK0LqwoTJdZ3L5mrqRDeixtBBjhd6f/hF1F+hxL1iqvoKKMt8HLVM7ZF/ip
	 j68cx02w97CTETznNZcYvngj3B5z7v5RXsYT8o7g=
Date: Thu, 19 Feb 2026 16:36:57 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-checking-if-a-folio-is-swapped.patch added to mm-new branch
Message-Id: <20260220003658.61C40C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify checking if a folio is swapped
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-simplify-checking-if-a-folio-is-swapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-checking-if-a-folio-is-swapped.patch

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
Subject: mm, swap: simplify checking if a folio is swapped
Date: Wed, 18 Feb 2026 04:06:36 +0800

Clean up and simplify how we check if a folio is swapped.  The helper
already requires the folio to be in swap cache and locked.  That's enough
to pin the swap cluster from being freed, so there is no need to lock
anything else to avoid UAF.

And besides, we have cleaned up and defined the swap operation to be
mostly folio based, and now the only place a folio will have any of its
swap slots' count increased from 0 to 1 is folio_dup_swap, which also
requires the folio lock.  So as we are holding the folio lock here, a
folio can't change its swap status from not swapped (all swap slots have a
count of 0) to swapped (any slot has a swap count larger than 0).

So there won't be any false negatives of this helper if we simply depend
on the folio lock to stabilize the cluster.

We are only using this helper to determine if we can and should release
the swap cache.  So false positives are completely harmless, and also
already exist before.  Depending on the timing, previously, it's also
possible that a racing thread releases the swap count right after
releasing the ci lock and before this helper returns.  In any case, the
worst that could happen is we leave a clean swap cache.  It will still be
reclaimed when under pressure just fine.

So, in conclusion, we can simplify and make the check much simpler and
lockless.  Also, rename it to folio_maybe_swapped to reflect the design.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-11-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h     |    5 +-
 mm/swapfile.c |   82 ++++++++++++++++++++++++++----------------------
 2 files changed, 48 insertions(+), 39 deletions(-)

--- a/mm/swapfile.c~mm-swap-simplify-checking-if-a-folio-is-swapped
+++ a/mm/swapfile.c
@@ -1743,7 +1743,11 @@ again:
  * @subpage: if not NULL, only increase the swap count of this subpage.
  *
  * Typically called when the folio is unmapped and have its swap entry to
- * take its palce.
+ * take its place: Swap entries allocated to a folio has count == 0 and pinned
+ * by swap cache. The swap cache pin doesn't increase the swap count. This
+ * helper sets the initial count == 1 and increases the count as the folio is
+ * unmapped and swap entries referencing the slots are generated to replace
+ * the folio.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache.
  * NOTE: The caller also has to ensure there is no raced call to
@@ -1942,49 +1946,44 @@ int swp_swapcount(swp_entry_t entry)
 	return count < 0 ? 0 : count;
 }
 
-static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
-					 swp_entry_t entry, int order)
+/*
+ * folio_maybe_swapped - Test if a folio covers any swap slot with count > 0.
+ *
+ * Check if a folio is swapped. Holding the folio lock ensures the folio won't
+ * go from not-swapped to swapped because the initial swap count increment can
+ * only be done by folio_dup_swap, which also locks the folio. But a concurrent
+ * decrease of swap count is possible through swap_put_entries_direct, so this
+ * may return a false positive.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+static bool folio_maybe_swapped(struct folio *folio)
 {
+	swp_entry_t entry = folio->swap;
 	struct swap_cluster_info *ci;
-	unsigned int nr_pages = 1 << order;
-	unsigned long roffset = swp_offset(entry);
-	unsigned long offset = round_down(roffset, nr_pages);
-	unsigned int ci_off;
-	int i;
+	unsigned int ci_off, ci_end;
 	bool ret = false;
 
-	ci = swap_cluster_lock(si, offset);
-	if (nr_pages == 1) {
-		ci_off = roffset % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off)))
-			ret = true;
-		goto unlock_out;
-	}
-	for (i = 0; i < nr_pages; i++) {
-		ci_off = (offset + i) % SWAPFILE_CLUSTER;
-		if (swp_tb_get_count(__swap_table_get(ci, ci_off))) {
-			ret = true;
-			break;
-		}
-	}
-unlock_out:
-	swap_cluster_unlock(ci);
-	return ret;
-}
-
-static bool folio_swapped(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si;
-
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
-	si = __swap_entry_to_info(entry);
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
-		return swap_entry_swapped(si, entry);
+	ci = __swap_entry_to_cluster(entry);
+	ci_off = swp_cluster_offset(entry);
+	ci_end = ci_off + folio_nr_pages(folio);
+	/*
+	 * Extra locking not needed, folio lock ensures its swap entries
+	 * won't be released, the backing data won't be gone either.
+	 */
+	rcu_read_lock();
+	do {
+		if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
+			ret = true;
+			break;
+		}
+	} while (++ci_off < ci_end);
+	rcu_read_unlock();
 
-	return swap_page_trans_huge_swapped(si, entry, folio_order(folio));
+	return ret;
 }
 
 static bool folio_swapcache_freeable(struct folio *folio)
@@ -2030,7 +2029,7 @@ bool folio_free_swap(struct folio *folio
 {
 	if (!folio_swapcache_freeable(folio))
 		return false;
-	if (folio_swapped(folio))
+	if (folio_maybe_swapped(folio))
 		return false;
 
 	swap_cache_del_folio(folio);
@@ -3704,6 +3703,8 @@ void si_swapinfo(struct sysinfo *val)
  *
  * Context: Caller must ensure there is no race condition on the reference
  * owner. e.g., locking the PTL of a PTE containing the entry being increased.
+ * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
+ * be used.
  */
 int swap_dup_entry_direct(swp_entry_t entry)
 {
@@ -3715,6 +3716,13 @@ int swap_dup_entry_direct(swp_entry_t en
 		return -EINVAL;
 	}
 
+	/*
+	 * The caller must be increasing the swap count from a direct
+	 * reference of the swap slot (e.g. a swap entry in page table).
+	 * So the swap count must be >= 1.
+	 */
+	VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
+
 	return swap_dup_entries_cluster(si, swp_offset(entry), 1);
 }
 
--- a/mm/swap.h~mm-swap-simplify-checking-if-a-folio-is-swapped
+++ a/mm/swap.h
@@ -195,12 +195,13 @@ extern int swap_retry_table_alloc(swp_en
  *
  * folio_alloc_swap(): the entry point for a folio to be swapped
  * out. It allocates swap slots and pins the slots with swap cache.
- * The slots start with a swap count of zero.
+ * The slots start with a swap count of zero. The slots are pinned
+ * by swap cache reference which doesn't contribute to swap count.
  *
  * folio_dup_swap(): increases the swap count of a folio, usually
  * during it gets unmapped and a swap entry is installed to replace
  * it (e.g., swap entry in page table). A swap slot with swap
- * count == 0 should only be increasd by this helper.
+ * count == 0 can only be increased by this helper.
  *
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch

