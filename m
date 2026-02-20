Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C8314B08A
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547821; cv=none; b=R4Uhypglh+GwcuUZJpAJ8FphX0svxrnL6gN63SiXw/+EBjwYCzRfpCbLcZK4odgO7jobBg+hSLpAfrqwFPRSOSPvK1trcOb89WREvNEKfTk2N9amyn8uvxNC8d7KmkKRY0T+idXPEpBP4+VIjeegLBAsRkz3i1behHiglzzGsB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547821; c=relaxed/simple;
	bh=TuoossgFrpIcKU+e1LNJcD86e1X+ut6ZJ9h1ADHq8HI=;
	h=Date:To:From:Subject:Message-Id; b=JBHf4A8AKW3YcYlA9jDbpnvxzgrRiU4n9x+bhdHsBUEJ+jw9VLk+96pRY+Up5AqoDqt4Ijl/49L3wqChiBG2Zy3AqMgMWk84kT6jzP9GufmYYeWCVF7Eww0gLoAmnmDNi9nF6+iw0bFlyscxpSpW7MtZo8sgHC4xwMGuzi8QK7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TVVpiXxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TVVpiXxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092A4C4CEF7;
	Fri, 20 Feb 2026 00:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547821;
	bh=TuoossgFrpIcKU+e1LNJcD86e1X+ut6ZJ9h1ADHq8HI=;
	h=Date:To:From:Subject:From;
	b=TVVpiXxseLTx6cx1tGuIocUvYyryJAwLXlK//Me6oUtjPwNPZ1RZr9pUaFNyM64Yd
	 rXJnRgu54f37OGQY+tKW56Sc/6cYErd1ETXdYgvQOJkXQtqXOBmiU+peFPFekiSw3p
	 zH1sZNGyE4yxWpCds0paX+fAjcIuNOKKu0Vs5XrE=
Date: Thu, 19 Feb 2026 16:37:00 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-no-need-to-clear-the-shadow-explicitly.patch added to mm-new branch
Message-Id: <20260220003701.092A4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: no need to clear the shadow explicitly
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-no-need-to-clear-the-shadow-explicitly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-no-need-to-clear-the-shadow-explicitly.patch

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
Subject: mm, swap: no need to clear the shadow explicitly
Date: Wed, 18 Feb 2026 04:06:37 +0800

Since we no longer bypass the swap cache, every swap-in will clear the
swap shadow by inserting the folio into the swap table.  The only place we
may seem to need to free the swap shadow is when the swap slots are freed
directly without a folio (swap_put_entries_direct).  But with the swap
table, that is not needed either.  Freeing a slot in the swap table will
set the table entry to NULL, which erases the shadow just fine.

So just delete all explicit shadow clearing, it's no longer needed.  Also,
rearrange the freeing.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-12-f4e34be021a7@tencent.com
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

 mm/swap.h       |    1 -
 mm/swap_state.c |   21 ---------------------
 mm/swapfile.c   |    2 --
 3 files changed, 24 deletions(-)

--- a/mm/swapfile.c~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swapfile.c
@@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	__swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0
--- a/mm/swap.h~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swap.h
@@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
--- a/mm/swap_state.c~mm-swap-no-need-to-clear-the-shadow-explicitly
+++ a/mm/swap_state.c
@@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct s
 	}
 }
 
-/**
- * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid, all in one single cluster,
- * not occupied by any folio, and lock the cluster.
- */
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
-	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
-	unsigned long old;
-
-	ci_end = ci_off + nr_ents;
-	do {
-		old = __swap_table_xchg(ci, ci_off, null_to_swp_tb());
-		WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old));
-	} while (++ci_off < ci_end);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
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

