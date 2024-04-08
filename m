Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF687482
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 20:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712608673; cv=none; b=IH5fznSt2u8EquAd4QN7BWj5ucAL3EpNYJ2Ig4GOebDwqd/xmav4Dj0RURz3UbEgm4tyZmWDaa+zldKT0elCd098B5AJ6Mr2Rt+ZbqTp6dhmaViJZgPhvlHj1KWwOik+RSw3LhdRQCgdHRjWZ8MpFM9fRorD0jL3x7aWC1sf8SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712608673; c=relaxed/simple;
	bh=eHWf55P5rWuxW4M0OpFjhln88/NxFvln5yiG9O55Tew=;
	h=Date:To:From:Subject:Message-Id; b=IbGQC5uB3JTc21HCKNX7hMD4VcAJDAavr0SR+A4QerO2j2BIgj4lIkLBe2dOUVgUC4adDhsjGjU7kuRUIWlTneH/CZH+1mBee+j6nb79ppK5i35l130cKcYbSwlXHSHQYqaRXkW92dGjBp9hzSKyrVJWZ8Zip6X8ETkOI5/EDs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i/eIf5Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i/eIf5Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4279C433F1;
	Mon,  8 Apr 2024 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712608672;
	bh=eHWf55P5rWuxW4M0OpFjhln88/NxFvln5yiG9O55Tew=;
	h=Date:To:From:Subject:From;
	b=i/eIf5ThAqa6cu3rN2QLPWquMk/8ArvE6kcmxs9XdiIOa9nBaxHsxLrDTpSUf0HXA
	 N8e26WPpBpoOqrS8yoDg2xDGkn4E6XhLDYUcs3qVg8UPgrAPPKIA3V8iQEySH1Iwmg
	 yGK5TSfgt3IhUHyKErPRTRuzt/woklIjSWchMnsQ=
Date: Mon, 08 Apr 2024 13:37:52 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-update-get_swap_pages-to-take-folio-order.patch added to mm-unstable branch
Message-Id: <20240408203752.C4279C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: update get_swap_pages() to take folio order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-update-get_swap_pages-to-take-folio-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-update-get_swap_pages-to-take-folio-order.patch

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
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
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

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch

