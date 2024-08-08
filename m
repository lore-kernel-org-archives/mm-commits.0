Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB4D15F311
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 23:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723158263; cv=none; b=QBSzCUkKiOzBh0lqK7v6A7+QGvaf6Gxh8kiMc/tH9KagLxIlkwupdzeJOa2fie+ZkzzMBbcoFY+Z6LPJy9fX1WW4ADTmdv8GsxgB2H0t5UPbtG6GZ0HQnhyniyymGj3SyM6+yXSLTht6RdZrRvBiEzh2IMN3uvh6EkIN2pRowIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723158263; c=relaxed/simple;
	bh=nOjxoImN6RtSWoEi1VsH1k2hhwi1L0+R4eYiEOVkXAY=;
	h=Date:To:From:Subject:Message-Id; b=u/YBG6KZ4J3gTJgq1ItaAtvuL3Anq3XY2tbqFeksyPpMw7txzYYJrlJYelsjelO1Sv24nsQcZANvBgbNMm0NQPcQt6CaVG9jI8zvVZRQhqMXl4Iyjhc9Cfq7okqxKq3LtkNQyz0vov5xAayX6A7cRb8dwQvszqrTRFbxmBFY6Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GJacBhcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GJacBhcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBFBC32782;
	Thu,  8 Aug 2024 23:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723158262;
	bh=nOjxoImN6RtSWoEi1VsH1k2hhwi1L0+R4eYiEOVkXAY=;
	h=Date:To:From:Subject:From;
	b=GJacBhcxY+i4AQeuq99buO+EikIUsHM6X8lHnKQ4Hg00dQBjkOQtIvf3blUgPlQ1K
	 DneV8Y6oUz1gWSqj+ruXsGSBCB1MnMegAdZQi3TFhK7YleYjj/5iP2e1atYFD/Zlrb
	 OCTUE4BJ5I0VgTWfEiOXjuMxGVdDh+09GctyPgxE=
Date: Thu, 08 Aug 2024 16:04:21 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch added to mm-unstable branch
Message-Id: <20240808230422.4DBFBC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: attempt to batch free swap entries for zap_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: attempt to batch free swap entries for zap_pte_range()
Date: Thu, 8 Aug 2024 09:58:59 +1200

Zhiguo reported that swap release could be a serious bottleneck during
process exits[1].  With mTHP, we have the opportunity to batch free swaps.

Thanks to the work of Chris and Kairui[2], I was able to achieve this
optimization with minimal code changes by building on their efforts.

If swap_count is 1, which is likely true as most anon memory are private,
we can free all contiguous swap slots all together.

Ran the below test program for measuring the bandwidth of munmap
using zRAM and 64KiB mTHP:

 #include <sys/mman.h>
 #include <sys/time.h>
 #include <stdlib.h>

 unsigned long long tv_to_ms(struct timeval tv)
 {
        return tv.tv_sec * 1000 + tv.tv_usec / 1000;
 }

 main()
 {
        struct timeval tv_b, tv_e;
        int i;
 #define SIZE 1024*1024*1024
        void *p = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (!p) {
                perror("fail to get memory");
                exit(-1);
        }

        madvise(p, SIZE, MADV_HUGEPAGE);
        memset(p, 0x11, SIZE); /* write to get mem */

        madvise(p, SIZE, MADV_PAGEOUT);

        gettimeofday(&tv_b, NULL);
        munmap(p, SIZE);
        gettimeofday(&tv_e, NULL);

        printf("munmap in bandwidth: %ld bytes/ms\n",
                        SIZE/(tv_to_ms(tv_e) - tv_to_ms(tv_b)));
 }

The result is as below (munmap bandwidth):
                mm-unstable  mm-unstable-with-patch
   round1       21053761      63161283
   round2       21053761      63161283
   round3       21053761      63161283
   round4       20648881      67108864
   round5       20648881      67108864

munmap bandwidth becomes 3X faster.

[1] https://lore.kernel.org/linux-mm/20240731133318.527-1-justinjiang@vivo.com/
[2] https://lore.kernel.org/linux-mm/20240730-swap-allocator-v5-0-cb9c148b9297@kernel.org/

Link: https://lkml.kernel.org/r/20240807215859.57491-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   76 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 65 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range
+++ a/mm/swapfile.c
@@ -156,6 +156,25 @@ static bool swap_is_has_cache(struct swa
 	return true;
 }
 
+static bool swap_is_last_map(struct swap_info_struct *si,
+		unsigned long offset, int nr_pages, bool *has_cache)
+{
+	unsigned char *map = si->swap_map + offset;
+	unsigned char *map_end = map + nr_pages;
+	unsigned char count = *map;
+
+	if (swap_count(count) != 1)
+		return false;
+
+	while (++map < map_end) {
+		if (*map != count)
+			return false;
+	}
+
+	*has_cache = !!(count & SWAP_HAS_CACHE);
+	return true;
+}
+
 /*
  * returns number of pages in the folio that backs the swap entry. If positive,
  * the folio was reclaimed. If negative, the folio was not reclaimed. If 0, no
@@ -1469,6 +1488,51 @@ static unsigned char __swap_entry_free(s
 	return usage;
 }
 
+static bool __swap_entries_free(struct swap_info_struct *si,
+		swp_entry_t entry, int nr)
+{
+	unsigned long offset = swp_offset(entry);
+	unsigned int type = swp_type(entry);
+	struct swap_cluster_info *ci;
+	bool has_cache = false;
+	unsigned char count;
+	int i;
+
+	if (nr <= 1 || swap_count(data_race(si->swap_map[offset])) != 1)
+		goto fallback;
+	/* cross into another cluster */
+	if (nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER)
+		goto fallback;
+
+	ci = lock_cluster_or_swap_info(si, offset);
+	if (!swap_is_last_map(si, offset, nr, &has_cache)) {
+		unlock_cluster_or_swap_info(si, ci);
+		goto fallback;
+	}
+	for (i = 0; i < nr; i++)
+		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
+	unlock_cluster_or_swap_info(si, ci);
+
+	if (!has_cache) {
+		spin_lock(&si->lock);
+		swap_entry_range_free(si, entry, nr);
+		spin_unlock(&si->lock);
+	}
+	return has_cache;
+
+fallback:
+	for (i = 0; i < nr; i++) {
+		if (data_race(si->swap_map[offset + i])) {
+			count = __swap_entry_free(si, swp_entry(type, offset + i));
+			if (count == SWAP_HAS_CACHE)
+				has_cache = true;
+		} else {
+			WARN_ON_ONCE(1);
+		}
+	}
+	return has_cache;
+}
+
 /*
  * Drop the last HAS_CACHE flag of swap entries, caller have to
  * ensure all entries belong to the same cgroup.
@@ -1792,11 +1856,9 @@ void free_swap_and_cache_nr(swp_entry_t
 {
 	const unsigned long start_offset = swp_offset(entry);
 	const unsigned long end_offset = start_offset + nr;
-	unsigned int type = swp_type(entry);
 	struct swap_info_struct *si;
 	bool any_only_cache = false;
 	unsigned long offset;
-	unsigned char count;
 
 	if (non_swap_entry(entry))
 		return;
@@ -1811,15 +1873,7 @@ void free_swap_and_cache_nr(swp_entry_t
 	/*
 	 * First free all entries in the range.
 	 */
-	for (offset = start_offset; offset < end_offset; offset++) {
-		if (data_race(si->swap_map[offset])) {
-			count = __swap_entry_free(si, swp_entry(type, offset));
-			if (count == SWAP_HAS_CACHE)
-				any_only_cache = true;
-		} else {
-			WARN_ON_ONCE(1);
-		}
-	}
+	any_only_cache = __swap_entries_free(si, entry, nr);
 
 	/*
 	 * Short-circuit the below loop if none of the entries had their
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

