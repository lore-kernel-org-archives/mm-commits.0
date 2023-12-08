Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA67481D4;
	Fri,  8 Dec 2023 19:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LfYE3V1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF7DC433C8;
	Fri,  8 Dec 2023 19:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065239;
	bh=I1VnRCEKoW1i9i3+g1aKH6rlt4cc0b7gneFXx1rFgiA=;
	h=Date:To:From:Subject:From;
	b=LfYE3V1rWX4o9HLH6+YsWM8ZzN3aJ0ze8rJKamipgwCu2HXqkFA8LWWfxJT1s6MXC
	 xwN+unAKnL8AHgbzgaiNtmypRFLjgjSx4iDTklMo0h9qY+aw2dEKLnpBHi5Yrpkn4v
	 fJ7hAe9uZW97wA+OQXHN5ljBdhb+FNcHZlocYYII=
Date: Fri, 08 Dec 2023 11:53:59 -0800
To: mm-commits@vger.kernel.org,tjmercier@google.com,stable@vger.kernel.org,ryncsn@gmail.com,quic_charante@quicinc.com,kaleshsingh@google.com,jaroslav.pulchart@gooddata.com,hdanton@sina.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-underprotected-page-cache.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195359.AEF7DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix underprotected page cache
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mglru-fix-underprotected-page-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-underprotected-page-cache.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: fix underprotected page cache
Date: Thu, 7 Dec 2023 23:14:04 -0700

Unmapped folios accessed through file descriptors can be underprotected. 
Those folios are added to the oldest generation based on:

1. The fact that they are less costly to reclaim (no need to walk the
   rmap and flush the TLB) and have less impact on performance (don't
   cause major PFs and can be non-blocking if needed again).
2. The observation that they are likely to be single-use. E.g., for
   client use cases like Android, its apps parse configuration files
   and store the data in heap (anon); for server use cases like MySQL,
   it reads from InnoDB files and holds the cached data for tables in
   buffer pools (anon).

However, the oldest generation can be very short lived, and if so, it
doesn't provide the PID controller with enough time to respond to a surge
of refaults.  (Note that the PID controller uses weighted refaults and
those from evicted generations only take a half of the whole weight.) In
other words, for a short lived generation, the moving average smooths out
the spike quickly.

To fix the problem:
1. For folios that are already on LRU, if they can be beyond the
   tracking range of tiers, i.e., five accesses through file
   descriptors, move them to the second oldest generation to give them
   more time to age. (Note that tiers are used by the PID controller
   to statistically determine whether folios accessed multiple times
   through file descriptors are worth protecting.)
2. When adding unmapped folios to LRU, adjust the placement of them so
   that they are not too close to the tail. The effect of this is
   similar to the above.

On Android, launching 55 apps sequentially:
                           Before     After      Change
  workingset_refault_anon  25641024   25598972   0%
  workingset_refault_file  115016834  106178438  -8%

Link: https://lkml.kernel.org/r/20231208061407.2125867-1-yuzhao@google.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Charan Teja Kalla <quic_charante@quicinc.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   23 ++++++++++++++---------
 mm/vmscan.c               |    2 +-
 mm/workingset.c           |    6 +++---
 3 files changed, 18 insertions(+), 13 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-fix-underprotected-page-cache
+++ a/include/linux/mm_inline.h
@@ -232,22 +232,27 @@ static inline bool lru_gen_add_folio(str
 	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 	/*
-	 * There are three common cases for this page:
-	 * 1. If it's hot, e.g., freshly faulted in or previously hot and
-	 *    migrated, add it to the youngest generation.
-	 * 2. If it's cold but can't be evicted immediately, i.e., an anon page
-	 *    not in swapcache or a dirty page pending writeback, add it to the
-	 *    second oldest generation.
-	 * 3. Everything else (clean, cold) is added to the oldest generation.
+	 * There are four common cases for this page:
+	 * 1. If it's hot, i.e., freshly faulted in, add it to the youngest
+	 *    generation, and it's protected over the rest below.
+	 * 2. If it can't be evicted immediately, i.e., a dirty page pending
+	 *    writeback, add it to the second youngest generation.
+	 * 3. If it should be evicted first, e.g., cold and clean from
+	 *    folio_rotate_reclaimable(), add it to the oldest generation.
+	 * 4. Everything else falls between 2 & 3 above and is added to the
+	 *    second oldest generation if it's considered inactive, or the
+	 *    oldest generation otherwise. See lru_gen_is_active().
 	 */
 	if (folio_test_active(folio))
 		seq = lrugen->max_seq;
 	else if ((type == LRU_GEN_ANON && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		seq = lrugen->min_seq[type] + 1;
-	else
+		seq = lrugen->max_seq - 1;
+	else if (reclaiming || lrugen->min_seq[type] + MIN_NR_GENS >= lrugen->max_seq)
 		seq = lrugen->min_seq[type];
+	else
+		seq = lrugen->min_seq[type] + 1;
 
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
--- a/mm/vmscan.c~mm-mglru-fix-underprotected-page-cache
+++ a/mm/vmscan.c
@@ -4232,7 +4232,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* protected */
-	if (tier > tier_idx) {
+	if (tier > tier_idx || refs == BIT(LRU_REFS_WIDTH)) {
 		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
 		gen = folio_inc_gen(lruvec, folio, false);
--- a/mm/workingset.c~mm-mglru-fix-underprotected-page-cache
+++ a/mm/workingset.c
@@ -313,10 +313,10 @@ static void lru_gen_refault(struct folio
 	 * 1. For pages accessed through page tables, hotter pages pushed out
 	 *    hot pages which refaulted immediately.
 	 * 2. For pages accessed multiple times through file descriptors,
-	 *    numbers of accesses might have been out of the range.
+	 *    they would have been protected by sort_folio().
 	 */
-	if (lru_gen_in_fault() || refs == BIT(LRU_REFS_WIDTH)) {
-		folio_set_workingset(folio);
+	if (lru_gen_in_fault() || refs >= BIT(LRU_REFS_WIDTH) - 1) {
+		set_mask_bits(&folio->flags, 0, LRU_REFS_MASK | BIT(PG_workingset));
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	}
 unlock:
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-fix-underprotected-page-cache.patch
mm-mglru-try-to-stop-at-high-watermarks.patch
mm-mglru-respect-min_ttl_ms-with-memcgs.patch
mm-mglru-reclaim-offlined-memcgs-harder.patch

