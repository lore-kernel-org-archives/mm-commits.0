Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4BC7482
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712608678; cv=none; b=ONqgCI+iwITSy3jGXeTWcdKnMR1FgCan9l3eBX6x53zyhdqez6rwJHtTiisV9vIHT1rCLxj4gswvdCKx9ALKdpkT5QBL/MLvOU6nIRQ4ZHtky2u3FTWAYjfeU33XmWdMkqsQAz/DtS1zQbEFj8fJH7taVlCRZvqzJKf7rAHhA+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712608678; c=relaxed/simple;
	bh=BTxeyfOIWCFXhFbIOGhQ3QJigylPL8wIs3jfS6zt7rU=;
	h=Date:To:From:Subject:Message-Id; b=DMitsJJECFXexNY+oUDmcrRq0akuefBvfZoiSuzKDyXeYD4fXFFAWQDBUcOzDPFhZ9nmplMLHyTwSKnjMhQoJcRqrJYtVsvRvW1q1tb8yC12n/X6NXMwdNN3Vr/QWlP8M7lc9yYb2Yb9/R/+iwzR/hu0QzbBiAcf7Oppsl2KpQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x08HHaUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x08HHaUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45AEC433F1;
	Mon,  8 Apr 2024 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712608678;
	bh=BTxeyfOIWCFXhFbIOGhQ3QJigylPL8wIs3jfS6zt7rU=;
	h=Date:To:From:Subject:From;
	b=x08HHaUT8sd3S4ORXB8gpbRgNR7H8lPA0KfL+8Lz/4gNSbVRj9VMWCHwf8YfCiZcS
	 ipL8n+swbwrEBRp12cj1lbDOsEwdsHFOULt47G9vrsBJhw5nfgy0xlQa0e+cQF16b1
	 j+58gNaswp2hePdKa6+qrTZu7D4Q2p9/6mFmvOmw=
Date: Mon, 08 Apr 2024 13:37:57 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-split-during-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20240408203757.E45AEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: avoid split during shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-avoid-split-during-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-split-during-shrink_folio_list.patch

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
Subject: mm: vmscan: avoid split during shrink_folio_list()
Date: Mon, 8 Apr 2024 19:39:45 +0100

Now that swap supports storing all mTHP sizes, avoid splitting large
folios before swap-out.  This benefits performance of the swap-out path by
eliding split_folio_to_list(), which is expensive, and also sets us up for
swapping in large folios in a future series.

If the folio is partially mapped, we continue to split it since we want to
avoid the extra IO overhead and storage of writing out pages
uneccessarily.

THP_SWPOUT and THP_SWPOUT_FALLBACK counters should continue to count
events only for PMD-mappable folios to avoid user confusion.  THP_SWPOUT
already has the appropriate guard.  Add a guard for THP_SWPOUT_FALLBACK. 
It may be appropriate to add per-size counters in future.

Link: https://lkml.kernel.org/r/20240408183946.2991168-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Gao Xiang <xiang@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-split-during-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1206,25 +1206,25 @@ retry:
 					if (!can_split_folio(folio, NULL))
 						goto activate_locked;
 					/*
-					 * Split folios without a PMD map right
-					 * away. Chances are some or all of the
-					 * tail pages can be freed without IO.
+					 * Split partially mapped folios right away.
+					 * We can free the unmapped pages without IO.
 					 */
-					if (!folio_entire_mapcount(folio) &&
-					    split_folio_to_list(folio,
-								folio_list))
+					if (data_race(!list_empty(&folio->_deferred_list)) &&
+					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
 				if (!add_to_swap(folio)) {
 					if (!folio_test_large(folio))
 						goto activate_locked_split;
 					/* Fallback to swap normal pages */
-					if (split_folio_to_list(folio,
-								folio_list))
+					if (split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
-					count_vm_event(THP_SWPOUT_FALLBACK);
+					if (nr_pages >= HPAGE_PMD_NR) {
+						count_memcg_folio_events(folio,
+							THP_SWPOUT_FALLBACK, 1);
+						count_vm_event(THP_SWPOUT_FALLBACK);
+					}
 #endif
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-swap-remove-cluster_flag_huge-from-swap_cluster_info-flags.patch
mm-swap-free_swap_and_cache_nr-as-batched-free_swap_and_cache.patch
mm-swap-simplify-struct-percpu_cluster.patch
mm-swap-update-get_swap_pages-to-take-folio-order.patch
mm-swap-allow-storage-of-all-mthp-orders.patch
mm-vmscan-avoid-split-during-shrink_folio_list.patch
mm-madvise-avoid-split-during-madv_pageout-and-madv_cold.patch

