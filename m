Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9B380C04
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104144; cv=none; b=Vkom4VxC+yHRKYyClJFr4IlTngeQf+efAOp+5j85Kq9nY1scBpZjBv4r7b2cq+x2jzHKN5G7rv2xu6miAUzWsRo21fodob1u1ptan3Md7orF39/x4IH7iPglmxR3AZsGyAjAlE1gN7j+df6MHSNFmGR2lcUegG2Q7QO724eQ7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104144; c=relaxed/simple;
	bh=BFJt5gVGmVjPN3dl/ZUojRDOHc3Yb0xtzjHvDlpsk14=;
	h=Date:To:From:Subject:Message-Id; b=FgcHuJIRcEaj4osSzF327MrzNpc7APw8CkiFIIvrTYM7WOsd+NjyBEswPTII/IR1PQHlKUuAtE+MivlziLpg7go1s+lGFkaOdi2VKBuwWGdq360snXv6UvywbCPiCo6gyqTDFJM5Br95/OqphqtqJKkrF+i6DeLn7uXP2GVur10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jIIIP+9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jIIIP+9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C131AC3277B;
	Fri, 26 Apr 2024 04:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104143;
	bh=BFJt5gVGmVjPN3dl/ZUojRDOHc3Yb0xtzjHvDlpsk14=;
	h=Date:To:From:Subject:From;
	b=jIIIP+9FZTETZMncpw7v4GH1+ADd1ipt2lxakTedPaAO6jwRc4JxBIPn+oo9F8DbE
	 oAnRp915lULhOFypNiqffLap19QujZNsXMAdccm0xquCgHyOaRafwLnGjpu6dUvWdb
	 nqehYxpbGxV7c+L05u7SaroxtZAsU6KF1uymut7g=
Date: Thu, 25 Apr 2024 21:02:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,mhocko@suse.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-avoid-split-during-shrink_folio_list.patch removed from -mm tree
Message-Id: <20240426040223.C131AC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: avoid split during shrink_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-avoid-split-during-shrink_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-soft-dirty-should-fail-if-a-testcase-fails.patch
mm-fix-race-between-__split_huge_pmd_locked-and-gup-fast.patch

