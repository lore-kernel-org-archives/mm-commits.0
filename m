Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582157FBBE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104141; cv=none; b=cbW+q5YN3Eq3oOD1Z+S3s6mThYpmz3Rl8PdcoCnr4TpqkL2dZEIBDMKwDpP1qhm9XOyUgdhCIMOAgnB1ZFadDQSuzfNK+ICH6hGkY/8lGlBqDXW8FXLUkX63yfSHmu9Fiqy0u8LGRIBTtp88DReDLogVhw0w20VxqUSZc4bIkcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104141; c=relaxed/simple;
	bh=OL0x8k5fn08NQX+xNcxg6gaWub0k2+sWLjOHSfSSnZ0=;
	h=Date:To:From:Subject:Message-Id; b=P1hV+PNQ3aLW2dGIqL9q0cS+4xDRR53CebxW0u8JplqQ9crnGs+HVLPKbLgg2Hp0RTe03NAqQ45HuvuqlLbMeWOZuCyF75Vlva+M79lNyI/C9aLFUa6t5LQEOXQabt275Lxf6ORnqYmaZHRhHF02dLzmhpEnLOtAufvQysJGI3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G3pCioVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G3pCioVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F813C113CD;
	Fri, 26 Apr 2024 04:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104141;
	bh=OL0x8k5fn08NQX+xNcxg6gaWub0k2+sWLjOHSfSSnZ0=;
	h=Date:To:From:Subject:From;
	b=G3pCioVPYuughZN9wDlAzeHRgJKRX2ySpdYS+J2g2g6d5OT8F46GQkbY+wkp7SUig
	 pgGI2h6EiO8Fajv+RvWjGz3Mwky9rm3wqeisufgvzmRGuSepD0Mm+7YAL+7R8FnQ4R
	 CnDiI2xlERigVUbmAOxAX6c7RWQ053vo8tDN0v5M=
Date: Thu, 25 Apr 2024 21:02:20 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-update-get_swap_pages-to-take-folio-order.patch removed from -mm tree
Message-Id: <20240426040221.2F813C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: update get_swap_pages() to take folio order
has been removed from the -mm tree.  Its filename was
     mm-swap-update-get_swap_pages-to-take-folio-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: swap: update get_swap_pages() to take folio order
Date: Mon, 8 Apr 2024 19:39:43 +0100

We are about to allow swap storage of any mTHP size.  To prepare for that,
let's change get_swap_pages() to take a folio order parameter instead of
nr_pages.  This makes the interface self-documenting; a power-of-2 number
of pages must be provided.  We will also need the order internally so this
simplifies accessing it.

Link: https://lkml.kernel.org/r/20240408183946.2991168-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap_slots.c      |    6 +++---
 mm/swapfile.c        |   13 +++++++------
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/swap.h~mm-swap-update-get_swap_pages-to-take-folio-order
+++ a/include/linux/swap.h
@@ -468,7 +468,7 @@ swp_entry_t folio_alloc_swap(struct foli
 bool folio_free_swap(struct folio *folio);
 void put_swap_folio(struct folio *folio, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
-extern int get_swap_pages(int n, swp_entry_t swp_entries[], int entry_size);
+extern int get_swap_pages(int n, swp_entry_t swp_entries[], int order);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
--- a/mm/swapfile.c~mm-swap-update-get_swap_pages-to-take-folio-order
+++ a/mm/swapfile.c
@@ -278,15 +278,15 @@ static void discard_swap_cluster(struct
 #ifdef CONFIG_THP_SWAP
 #define SWAPFILE_CLUSTER	HPAGE_PMD_NR
 
-#define swap_entry_size(size)	(size)
+#define swap_entry_order(order)	(order)
 #else
 #define SWAPFILE_CLUSTER	256
 
 /*
- * Define swap_entry_size() as constant to let compiler to optimize
+ * Define swap_entry_order() as constant to let compiler to optimize
  * out some code if !CONFIG_THP_SWAP
  */
-#define swap_entry_size(size)	1
+#define swap_entry_order(order)	0
 #endif
 #define LATENCY_LIMIT		256
 
@@ -1042,9 +1042,10 @@ static void swap_free_cluster(struct swa
 	swap_range_free(si, offset, SWAPFILE_CLUSTER);
 }
 
-int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
+int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_order)
 {
-	unsigned long size = swap_entry_size(entry_size);
+	int order = swap_entry_order(entry_order);
+	unsigned long size = 1 << order;
 	struct swap_info_struct *si, *next;
 	long avail_pgs;
 	int n_ret = 0;
@@ -1349,7 +1350,7 @@ void put_swap_folio(struct folio *folio,
 	unsigned char *map;
 	unsigned int i, free_entries = 0;
 	unsigned char val;
-	int size = swap_entry_size(folio_nr_pages(folio));
+	int size = 1 << swap_entry_order(folio_order(folio));
 
 	si = _swap_info_get(entry);
 	if (!si)
--- a/mm/swap_slots.c~mm-swap-update-get_swap_pages-to-take-folio-order
+++ a/mm/swap_slots.c
@@ -264,7 +264,7 @@ static int refill_swap_slots_cache(struc
 	cache->cur = 0;
 	if (swap_slot_cache_active)
 		cache->nr = get_swap_pages(SWAP_SLOTS_CACHE_SIZE,
-					   cache->slots, 1);
+					   cache->slots, 0);
 
 	return cache->nr;
 }
@@ -311,7 +311,7 @@ swp_entry_t folio_alloc_swap(struct foli
 
 	if (folio_test_large(folio)) {
 		if (IS_ENABLED(CONFIG_THP_SWAP))
-			get_swap_pages(1, &entry, folio_nr_pages(folio));
+			get_swap_pages(1, &entry, folio_order(folio));
 		goto out;
 	}
 
@@ -343,7 +343,7 @@ repeat:
 			goto out;
 	}
 
-	get_swap_pages(1, &entry, 1);
+	get_swap_pages(1, &entry, 0);
 out:
 	if (mem_cgroup_try_charge_swap(folio, entry)) {
 		put_swap_folio(folio, entry);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

