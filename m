Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739852;
	b=3DVdZ3uuggd3TWN2LguHFt2afE/4GrncOKFqABts7W9i6YvlEw0hkoGH3SnFNoqaGoTc
	 MIZ4CrkK/mTMUl2NfuL0Iv2DhyCR/konE/W9xQlMhUdEsdRCctvHoAefyqEx/A5CWeZ3k
	 O6J8B1UkolEIdqx3XslXfXcJSooayXXKf+vjCpx9y6n6eWD3A03JpToJULOAJSuZb+cPY
	 UVwOwFTr5r5T/qMZQgKWBuV2sq3xXx6bNOU+/UVtxHyuG5DJkdC9B2NsR9Ok19wPwpcwG
	 yNQynxmXiOj9+U+gxWAnHyJD29j/K6Z2xVwWklwLqm+f/PkOeJuUXtSH6SG4PmS8J9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739852;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=9DBbFu1rjRItaJfg0wCC3yeruOcT26lk3t8ydp8DCwM=;
	b=nFHaX2HIGhy7Q9G2ispv59UKD05muW9CH+AB0FY0wnjKMd9s5TDRTcfbwlmqtqCKGBgh
	 p9RS5ERT+RPn/6rYyYjot7obx74WonjS0f+3ItsONF/RA4s4t7xdS4Z7aaHUEtuKNNUxt
	 uM5Lkss1UmrEFfM8r17ez9n7d/YeOZEI+LwGBxAz0eJ+Q1CU6wfwwvEuYTIMp0FhP6+kq
	 yLLwxv5mGnZTHGbHICgBSqUd3p3GG4m0HfIxGlQqUQ9sBpFKZPAMSJIN7L6888HjRaPef
	 rs6L0C7wABNOy4cGyfUf4ZhLljL2sXZsTcEbOPfiISZehFddIWU8jNoa5zaf3HPVdqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tnOUlXCJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE68D606A31B
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tnOUlXCJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5F1F000C1;
	Tue,  3 Nov 2026 21:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793739851;
	bh=9DBbFu1rjRItaJfg0wCC3yeruOcT26lk3t8ydp8DCwM=;
	h=Date:To:From:Subject;
	b=tnOUlXCJChXenmRXc7MDP206j7wtkdx3l/1QQj8v6A5SIcaOi83+VzNxuJwQFc6/P
	 xvRVdmjqqmI16smRJVMyK5RFNAtINOQ7k5WxaQZCMdy91VLReRW8FOwsqBtBBBei/L
	 7GjmQ3mBIdrT3KXZcHdhB3aNJti4Fk4bfLJ6wy1M=
Date: Tue, 03 Nov 2026 13:04:10 -0800
To: mm-commits@vger.kernel.org,wujianyue000@gmail.com,
	shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,
	kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch added to mm-new branch
Message-Id: <20261103210411.3CD5F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm, swap: only allow swapped-out slots into the swap cache
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: only allow swapped-out slots into the swap cache
Date: Wed, 04 Nov 2026 00:25:45 +0800

Patch series "mm, swap: keep hibernation swap slots out of the swap cache",
v4.

The original series is sent by YoungJun, now with a few nits fixed,
rebased and re-send, dropping already merged one.  Especially recently
there is LLM code inspecting suggesting patch 1/3 of this resent is needed
as it avoids reading into bad slots.

Cluster readahead walks a raw page_cluster sized window of offsets around
the faulting entry.  A hibernation slot looks like an ordinary swapped out
slot, so __swap_cache_add_check() lets it in.  Readahead reads the offset
off the device into a folio and puts that folio in the swap table where
the hibernation entry was.  This has been possible for a long time.  It
only wasted a folio and a read.

That changed with commit 0d6af9bcf383 ("mm, swap: use the swap table to
track the swap count").  A slot with a folio in the swap cache should only
be freed when the folio leaves the cache.  swap_put_entries_cluster()
still does that, but the conversion left swap_free_hibernation_slot()
freeing the slot either way.  Nothing points at the folio after that, and
when reclaim drops it later, it writes to the table entry at the old
offset, which someone else may own by then.

That one is fixed in v3 1/4, which is upstream as commit 10d9012e83ef
("mm, swap: don't free a hibernation slot that is in the swap cache")
already.

What is left removes the cause.  Readahead should not touch these slots at
all, so patch 1 lets only swapped out slots into the swap cache, which
also puts back a bad slot check the swap cache rework dropped, patch 2
gives hibernation slots their own swap table entry type so that check
covers them too, and patch 3 drops the guard and the reclaim in
swap_free_hibernation_slot(), since no such folio can exist any more.

For any of this a task has to hold hibernation slots while the system is
still running.  The in kernel path does not, it allocates, writes and
frees the slots with everything frozen.  Userspace hibernation is
different.  The process writing the image is not frozen, and
SNAPSHOT_ALLOC_SWAP_PAGE does not check that anything is frozen.  The swap
device must also not be SWP_SYNCHRONOUS_IO, or swapin takes the direct
path and never reaches cluster readahead.

Tested with a debug patch generated by AI that counts hibernation slots
through the swap cache paths.  virtio-blk swap, page-cluster 3,
SNAPSHOT_ALLOC_SWAP_PAGE interleaved with MADV_PAGEOUT of a shmem region
so the hibernation slots land in the readahead windows.

                                unpatched   fix only   this series
  hibernation slots allocated       2732       2732         2732
  readahead landed on the slot      2731       2731         2731
  admitted to the swap cache        2731       2731            0
  reclaim found the folio              0       2731            -
  slot left unfreed                    0          0            0
  VM_WARN in the free path          2731          0            0

The VM_WARN is the existing assertion in __swap_cluster_free_entries(),
not something the debug patch adds.


This patch (of 3):

__swap_cache_add_check() turns away folio entries and slots with no count
and lets everything else in.  That is safe only when the caller owns the
slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
window of offsets around the faulting entry, so it can land on any slot.

A bad slot gets in.  The check reads the count with __swp_tb_get_count(),
which shifts the count bits out without looking at the type, and
SWP_TB_BAD has all of them set, so the slot reads as SWP_TB_COUNT_MAX.
Readahead then allocates a folio and reads the offset off the device for a
slot nothing will ever swap in, and the folio entry that replaces it drops
the bad marker.

Readahead used to be guarded by swap_entry_swapped(), which goes through
swp_tb_get_count() and gets -EINVAL for a bad slot.  That call went away
when the swap cache checks moved into __swap_cache_add_check(), and the
raw accessor there does not do the same type test.

Require a shadow entry instead.  A slot dropped from the swap cache always
gets one, empty if there is no workingset value.  The type test runs first,
so the count is only read off a countable entry, and the check as a whole
runs before the folio allocation in __swap_cache_alloc().

The large folio walk in the same function does the same raw reads.  A bad
slot cannot be in its range, but the range is not pinned, so a slot freed
and then taken by hibernation still trips the countable assertion there.
Give the walk the same shadow test, the folio check folds into it.

Reproduced with a badpages list written into the swap header by hand.
Readahead took over four bad slots before this patch and none after.  It
needs a crafted header, so a normal setup will not hit it.

Link: https://lore.kernel.org/20261104-swap-hibernation-slots-v4-0-0ba9393609e1@tencent.com
Link: https://lore.kernel.org/20261104-swap-hibernation-slots-v4-1-0ba9393609e1@tencent.com
Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation in swap cache directly")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/swap_state.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-only-allow-swapped-out-slots-into-the-swap-cache
+++ a/mm/swap_state.c
@@ -191,9 +191,14 @@ static int __swap_cache_add_check(struct
 	old_tb = __swap_table_get(ci, ci_off);
 	if (swp_tb_is_folio(old_tb))
 		return -EEXIST;
-	if (!__swp_tb_get_count(old_tb))
+	/*
+	 * Only a swapped-out slot may be brought into the swap cache.
+	 * Cluster readahead walks raw offset ranges, so it can land on
+	 * slots that are free, bad, or owned by hibernation.
+	 */
+	if (!swp_tb_is_shadow(old_tb) || !__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	if (shadowp && swp_tb_is_shadow(old_tb))
+	if (shadowp)
 		*shadowp = swp_tb_to_shadow(old_tb);
 	if (memcg_id)
 		*memcg_id = __swap_cgroup_get(ci, ci_off);
@@ -206,7 +211,7 @@ static int __swap_cache_add_check(struct
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb) ||
+		if (unlikely(!swp_tb_is_shadow(old_tb) ||
 			     !__swp_tb_get_count(old_tb) ||
 			     is_zero != __swap_table_test_zero(ci, ci_off) ||
 			     (memcg_id && *memcg_id != __swap_cgroup_get(ci, ci_off))))
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-only-allow-swapped-out-slots-into-the-swap-cache.patch
mm-swap-give-hibernation-swap-slots-their-own-swap-table-entry-type.patch
mm-swap-drop-the-swap-cache-guard-and-reclaim-in-swap_free_hibernation_slot.patch

