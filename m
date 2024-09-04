Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7676F2F9
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423459; cv=none; b=quZaok78ZfdmpUJ55j+VKfMHB4Xi/ZOG8ZRpesOSI1sBTxsny+PKJ5713hUrItD/KLU/anb499JGe4Yz/gnSu0jryecveu4EcsC2T2JopnhacRk4rwSZmB0UGB47eU+gBZRjAa8KgZzh3U8NES99IyR7zdWeDps2Wrz0+TgUO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423459; c=relaxed/simple;
	bh=Zb3Hl33qOQWeKxNb6PYsg3FYT3aTlYnnwKQAb3laH0Y=;
	h=Date:To:From:Subject:Message-Id; b=bRGH5vJgv/Gpmw4+OhVHGP9W7wcecfNkpaFo7QEvoW/jylTmob9/wLB6q+VI3Cg2gua69ahRH9/DdkLawDKCI7kmb/10Xtc7V6voR3FnIH3pEkZY6YdB7YYr3zguIfI1G2WOvlLFknfhs8BjBbQeK5mbX35Mjl7iVA2+rvuHUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdgwlCo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdgwlCo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D85AC4CEC2;
	Wed,  4 Sep 2024 04:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423459;
	bh=Zb3Hl33qOQWeKxNb6PYsg3FYT3aTlYnnwKQAb3laH0Y=;
	h=Date:To:From:Subject:From;
	b=zdgwlCo0pEuH0GGL1ehK/liG76gADqKA1fjThH77d2j7T4al2Vyg9kQkwksGN35Hi
	 t+RD224vw7PcPI3bp7//NlxtevMhssAfoYdJgXKu+XORa8xlGgrAoE6Mu4xKg+hDN7
	 dW5hqBAzmL15wNP0gbLwE8qVPnhv0bZ6QOA0ONNE=
Date: Tue, 03 Sep 2024 21:17:38 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,baohua@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch removed from -mm tree
Message-Id: <20240904041739.6D85AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: attempt to batch free swap entries for zap_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[v-songbaohua@oppo.com: check all swaps belong to same swap_cgroup in swap_pte_batch()]
  Link: https://lkml.kernel.org/r/20240815215308.55233-1-21cnbao@gmail.com
[hughd@google.com: add mem_cgroup_disabled() check]
  Link: https://lkml.kernel.org/r/33f34a88-0130-5444-9b84-93198eeb50e7@google.com
[21cnbao@gmail.com: add missing zswap_invalidate()]
  Link: https://lkml.kernel.org/r/20240821054921.43468-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240807215859.57491-3-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h    |    9 ++++-
 mm/swap_cgroup.c |    2 +
 mm/swapfile.c    |   78 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 76 insertions(+), 13 deletions(-)

--- a/mm/internal.h~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range
+++ a/mm/internal.h
@@ -15,6 +15,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
@@ -275,18 +276,22 @@ static inline int swap_pte_batch(pte_t *
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
+	swp_entry_t entry = pte_to_swp_entry(pte);
 	pte_t *ptep = start_ptep + 1;
+	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(pte_to_swp_entry(pte)));
+	VM_WARN_ON(non_swap_entry(entry));
 
+	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
 		pte = ptep_get(ptep);
 
 		if (!pte_same(pte, expected_pte))
 			break;
-
+		if (lookup_swap_cgroup_id(pte_to_swp_entry(pte)) != cgroup_id)
+			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
--- a/mm/swap_cgroup.c~mm-attempt-to-batch-free-swap-entries-for-zap_pte_range
+++ a/mm/swap_cgroup.c
@@ -161,6 +161,8 @@ unsigned short swap_cgroup_record(swp_en
  */
 unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
+	if (mem_cgroup_disabled())
+		return 0;
 	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
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
@@ -1469,6 +1488,53 @@ static unsigned char __swap_entry_free(s
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
+		for (i = 0; i < nr; i++)
+			zswap_invalidate(swp_entry(si->type, offset + i));
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
@@ -1792,11 +1858,9 @@ void free_swap_and_cache_nr(swp_entry_t
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
@@ -1811,15 +1875,7 @@ void free_swap_and_cache_nr(swp_entry_t
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

mm-count-the-number-of-anonymous-thps-per-size.patch
mm-count-the-number-of-partially-mapped-anonymous-thps-per-size.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner.patch
mm-warn-about-illegal-__gfp_nofail-usage-in-a-more-appropriate-location-and-manner-fix.patch

