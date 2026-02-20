Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F21C84A0
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547799; cv=none; b=PObQlJfbfNzwYaAZ43g/fJt0SWXTjBqqw2hQgYXkz6/tCb+FUl1qZLTYlTo0KvRNUHquKzJ+TJIvzAIPNtE/8sOVzqigTQzsib7FfO8LjYdA9dGLU/g847WRzscdEX+O6OHpx0pfrXJxSZhzqXY0IdS0b1uJqh1yw/jhVKh+rjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547799; c=relaxed/simple;
	bh=RJU568GPjRPjN0hDByom4mk2ak5AW1vM2aSjDMWD8AQ=;
	h=Date:To:From:Subject:Message-Id; b=Xrk64jT/M20H/OiS5los4n5ltJPR+msiaOovkGalL42EXntoe1nqBNbOqT1AsmLo3S7Je/ORvnLY8s5JEkcSSgZ1sMW2CAoxKyXQRUa8NEcBMKuPv0TbE8GIcMM5lCiT7YCF/S2idm1sdjbhuAwo+fGfQmO0o3sPJxfm3JMTwgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D30bwld1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D30bwld1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7EDC4CEF7;
	Fri, 20 Feb 2026 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547799;
	bh=RJU568GPjRPjN0hDByom4mk2ak5AW1vM2aSjDMWD8AQ=;
	h=Date:To:From:Subject:From;
	b=D30bwld1m6JIUFB84qT8Okni2z6Ccm3clDoTJlD1RBYZcTlFLxTxygYJ6WamEv+JS
	 Idzz214esS++fIrtjb/2klhCNzclDojqH3LKOSZWPJWifWzFGH/BS5uQ8pf1MNANEI
	 1z2DATrSqDDCps81L7xvg+SSvEgAee6er4hcQCcQ=
Date: Thu, 19 Feb 2026 16:36:38 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch added to mm-new branch
Message-Id: <20260220003638.ED7EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/workingset: leave highest bits empty for anon shadow
has been added to the -mm mm-new branch.  Its filename is
     mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch

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
Subject: mm/workingset: leave highest bits empty for anon shadow
Date: Wed, 18 Feb 2026 04:06:30 +0800

Swap table entry will need 4 bits reserved for swap count in the shadow,
so the anon shadow should have its leading 4 bits remain 0.

This should be OK for the foreseeable future.  Take 52 bits of physical
address space as an example: for 4K pages, there would be at most 40 bits
for addressable pages.  Currently, we have 36 bits available (64 - 1 - 16
- 10 - 1, where XA_VALUE takes 1 bit for marker, MEM_CGROUP_ID_SHIFT takes
16 bits, NODES_SHIFT takes <=10 bits, WORKINGSET flags takes 1 bit).

So in the worst case, we previously need to pack the 40 bits of address in
36 bits fields using a 64K bucket (bucket_order = 4).  After this, the
bucket will be increased to 1M.  Which should be fine, as on such large
machines, the working set size will be way larger than the bucket size.

And for MGLRU's gen number tracking, it should be even more than enough,
MGLRU's gen number (max_seq) increment is much slower compared to the
eviction counter (nonresident_age).

And after all, either the refault distance or the gen distance is only a
hint that can tolerate inaccuracy just fine.

And the 4 bits can be shrunk to 3, or extended to a higher value if needed
later.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com
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

 mm/swap_table.h |    4 +++
 mm/workingset.c |   49 ++++++++++++++++++++++++++++------------------
 2 files changed, 34 insertions(+), 19 deletions(-)

--- a/mm/swap_table.h~mm-workingset-leave-highest-bits-empty-for-anon-shadow
+++ a/mm/swap_table.h
@@ -12,6 +12,7 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
@@ -22,6 +23,9 @@ struct swap_table {
  * (shadow), or NULL.
  */
 
+/* Macro for shadow offset calculation */
+#define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
+
 /*
  * Helpers for casting one type of info into a swap table entry.
  */
--- a/mm/workingset.c~mm-workingset-leave-highest-bits-empty-for-anon-shadow
+++ a/mm/workingset.c
@@ -16,6 +16,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "swap_table.h"
 #include "internal.h"
 
 /*
@@ -184,7 +185,9 @@
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
 			 WORKINGSET_SHIFT + NODES_SHIFT + \
 			 MEM_CGROUP_ID_SHIFT)
+#define EVICTION_SHIFT_ANON	(EVICTION_SHIFT + SWAP_COUNT_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+#define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
 
 /*
  * Eviction timestamps need to be able to cover the full range of
@@ -194,12 +197,12 @@
  * that case, we have to sacrifice granularity for distance, and group
  * evictions into coarser buckets by shaving off lower timestamp bits.
  */
-static unsigned int bucket_order __read_mostly;
+static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
-			 bool workingset)
+			 bool workingset, bool file)
 {
-	eviction &= EVICTION_MASK;
+	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -244,7 +247,8 @@ static void *lru_gen_eviction(struct fol
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
+		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
@@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct fol
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
 }
 
 /*
@@ -262,7 +266,7 @@ static void *lru_gen_eviction(struct fol
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	int memcg_id;
 	unsigned long max_seq;
@@ -275,7 +279,7 @@ static bool lru_gen_test_recent(void *sh
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
-	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
 	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
@@ -293,7 +297,7 @@ static void lru_gen_refault(struct folio
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +335,7 @@ static void *lru_gen_eviction(struct fol
 }
 
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	return false;
 }
@@ -381,6 +385,7 @@ void workingset_age_nonresident(struct l
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	int file = folio_is_file_lru(folio);
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	int memcgid;
@@ -397,10 +402,10 @@ void *workingset_eviction(struct folio *
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
-	eviction >>= bucket_order;
+	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-				folio_test_workingset(folio));
+			   folio_test_workingset(folio), file);
 }
 
 /**
@@ -431,14 +436,15 @@ bool workingset_test_recent(void *shadow
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
+					     workingset, file);
 		rcu_read_unlock();
 		return recent;
 	}
 
 	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-	eviction <<= bucket_order;
+	eviction <<= bucket_order[file];
 
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -495,7 +501,8 @@ bool workingset_test_recent(void *shadow
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
 	 */
-	refault_distance = (refault - eviction) & EVICTION_MASK;
+	refault_distance = ((refault - eviction) &
+			    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -780,8 +787,8 @@ static struct lock_class_key shadow_node
 
 static int __init workingset_init(void)
 {
+	unsigned int timestamp_bits, timestamp_bits_anon;
 	struct shrinker *workingset_shadow_shrinker;
-	unsigned int timestamp_bits;
 	unsigned int max_order;
 	int ret = -ENOMEM;
 
@@ -794,11 +801,15 @@ static int __init workingset_init(void)
 	 * double the initial memory by using totalram_pages as-is.
 	 */
 	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
+	timestamp_bits_anon = BITS_PER_LONG - EVICTION_SHIFT_ANON;
 	max_order = fls_long(totalram_pages() - 1);
-	if (max_order > timestamp_bits)
-		bucket_order = max_order - timestamp_bits;
-	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
-	       timestamp_bits, max_order, bucket_order);
+	if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
+		bucket_order[WORKINGSET_FILE] = max_order - timestamp_bits;
+	if (max_order > timestamp_bits_anon)
+		bucket_order[WORKINGSET_ANON] = max_order - timestamp_bits_anon;
+	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
+		timestamp_bits, timestamp_bits_anon, max_order,
+		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						    SHRINKER_MEMCG_AWARE,
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

