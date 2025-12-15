Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADED228D8DA
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 19:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826033; cv=none; b=rdmlQs28dORSQMJ4WMOekZsoNu7tQ36A35mhaUGjw2pt5x3YmJl1xO4DoktiGRJNZMT+fqrPcUhehqDNNHSQrIIBVpdUOc3glPHruHzswHMvV2YOPbtud7RkTSdPwk3zCQJumShCLXm0bpObtm0TaAwpDLHjJf4/cTG6r3v0dCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826033; c=relaxed/simple;
	bh=6mOu7uDocjMnXbuLFFRsGm5UFm9v3IZYLxtpKZ8/JCU=;
	h=Date:To:From:Subject:Message-Id; b=bCDJ1NSh1SPj2TpqXfmVcyDwl4/iYFJ69mibyzIr/frln0Se6Xyo4SYmjXXLyQICCO32mI9cauhlniKxrxDbOKZGKwD4G+88sikCvBLh0gdDkf1P7d7oi6eNGL8Q1+Hi3Xxnt9Ww2+EY0soMJYLOwn0CH31rzaN+fqnydfEZbG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oyFwuk6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oyFwuk6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D800C4CEF5;
	Mon, 15 Dec 2025 19:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765826033;
	bh=6mOu7uDocjMnXbuLFFRsGm5UFm9v3IZYLxtpKZ8/JCU=;
	h=Date:To:From:Subject:From;
	b=oyFwuk6zYNXMm1hgEOjSgTueo/tADtr67wZrs/s5tZsmLJTwvkdH+gQ0NxraBMqPJ
	 rzQjL2awQv9FlQ2DsWsHWa7dvxqVojGwLFxr2L+o76VDDfp7yvkL5XqQfVdJ1ci1d4
	 q7vwaLammzv37DOuGCoo37ftPijdr81hrk+ZKw5Y=
Date: Mon, 15 Dec 2025 11:13:52 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscanc-shrink_folio_list-save-a-tabstop.patch added to mm-new branch
Message-Id: <20251215191353.3D800C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan.c:shrink_folio_list(): save a tabstop 
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscanc-shrink_folio_list-save-a-tabstop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscanc-shrink_folio_list-save-a-tabstop.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan.c:shrink_folio_list(): save a tabstop 
Date: Mon Dec 15 11:05:56 AM PST 2025

We have some needlessly deep indentation in this huge function due to

	if (expr1) {
		if (expr2) {
			...
		}
	}

Convert this to

	if (expr1 && expr2) {
		...
	}

Also, reflow that big block comment to fit in 80 cols.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   96 +++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-shrink_folio_list-save-a-tabstop
+++ a/mm/vmscan.c
@@ -1276,58 +1276,58 @@ retry:
 		 * Try to allocate it some swap space here.
 		 * Lazyfree folio could be freed directly
 		 */
-		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
-			if (!folio_test_swapcache(folio)) {
-				if (!(sc->gfp_mask & __GFP_IO))
-					goto keep_locked;
-				if (folio_maybe_dma_pinned(folio))
-					goto keep_locked;
-				if (folio_test_large(folio)) {
-					/* cannot split folio, skip it */
-					if (folio_expected_ref_count(folio) !=
-					    folio_ref_count(folio) - 1)
-						goto activate_locked;
-					/*
-					 * Split partially mapped folios right away.
-					 * We can free the unmapped pages without IO.
-					 */
-					if (data_race(!list_empty(&folio->_deferred_list) &&
-					    folio_test_partially_mapped(folio)) &&
-					    split_folio_to_list(folio, folio_list))
-						goto activate_locked;
-				}
-				if (folio_alloc_swap(folio)) {
-					int __maybe_unused order = folio_order(folio);
+		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+				!folio_test_swapcache(folio)) {
+			if (!(sc->gfp_mask & __GFP_IO))
+				goto keep_locked;
+			if (folio_maybe_dma_pinned(folio))
+				goto keep_locked;
+			if (folio_test_large(folio)) {
+				/* cannot split folio, skip it */
+				if (folio_expected_ref_count(folio) !=
+				    folio_ref_count(folio) - 1)
+					goto activate_locked;
+				/*
+				 * Split partially mapped folios right away.
+				 * We can free the unmapped pages without IO.
+				 */
+				if (data_race(!list_empty(&folio->_deferred_list) &&
+				    folio_test_partially_mapped(folio)) &&
+				    split_folio_to_list(folio, folio_list))
+					goto activate_locked;
+			}
+			if (folio_alloc_swap(folio)) {
+				int __maybe_unused order = folio_order(folio);
 
-					if (!folio_test_large(folio))
-						goto activate_locked_split;
-					/* Fallback to swap normal pages */
-					if (split_folio_to_list(folio, folio_list))
-						goto activate_locked;
+				if (!folio_test_large(folio))
+					goto activate_locked_split;
+				/* Fallback to swap normal pages */
+				if (split_folio_to_list(folio, folio_list))
+					goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-					if (nr_pages >= HPAGE_PMD_NR) {
-						count_memcg_folio_events(folio,
-							THP_SWPOUT_FALLBACK, 1);
-						count_vm_event(THP_SWPOUT_FALLBACK);
-					}
-#endif
-					count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-					if (folio_alloc_swap(folio))
-						goto activate_locked_split;
+				if (nr_pages >= HPAGE_PMD_NR) {
+					count_memcg_folio_events(folio,
+						THP_SWPOUT_FALLBACK, 1);
+					count_vm_event(THP_SWPOUT_FALLBACK);
 				}
-				/*
-				 * Normally the folio will be dirtied in unmap because its
-				 * pte should be dirty. A special case is MADV_FREE page. The
-				 * page's pte could have dirty bit cleared but the folio's
-				 * SwapBacked flag is still set because clearing the dirty bit
-				 * and SwapBacked flag has no lock protected. For such folio,
-				 * unmap will not set dirty bit for it, so folio reclaim will
-				 * not write the folio out. This can cause data corruption when
-				 * the folio is swapped in later. Always setting the dirty flag
-				 * for the folio solves the problem.
-				 */
-				folio_mark_dirty(folio);
+#endif
+				count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+				if (folio_alloc_swap(folio))
+					goto activate_locked_split;
 			}
+			/*
+			 * Normally the folio will be dirtied in unmap because
+			 * its pte should be dirty. A special case is MADV_FREE
+			 * page. The page's pte could have dirty bit cleared but
+			 * the folio's SwapBacked flag is still set because
+			 * clearing the dirty bit and SwapBacked flag has no
+			 * lock protected. For such folio, unmap will not set
+			 * dirty bit for it, so folio reclaim will not write the
+			 * folio out. This can cause data corruption when the
+			 * folio is swapped in later. Always setting the dirty
+			 * flag for the folio solves the problem.
+			 */
+			folio_mark_dirty(folio);
 		}
 
 		/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch
kasan-unpoison-vms-addresses-with-a-common-tag-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
kernel-watchdogc-fix-unused-var-warning.patch

