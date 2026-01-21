Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB335E53C
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966021; cv=none; b=D8u4OG92nVV2XcK6WQ+gSiOPd1aF/AGNQBHax0YI5hV1Nm7la+CB6QiThZZMun95BZjZLZjVzz4V7BXJF/IuWBYnlEwZsr+h3/ohHQCLLqrhIuIqu+QZ0Q4O8jUXeI+pNJs2U++QMWsyegnxNv2j8J0zxjGqdJAYUpAgsPuLebM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966021; c=relaxed/simple;
	bh=SAM0uCd+Wz2WX1JMKYq1rp0Wx4rG4PBOqrH5RYS2e3M=;
	h=Date:To:From:Subject:Message-Id; b=V5xEzV+SlUepLVAxcZ4Dd5Fv/gRzMQYXhaj+iWTpEVWnOF1qmkA91dw8JCY0DkRWNASH1eGjvl+c3tvKgK0c5x+Idg5DahC+CM4KWZgx6mzTyNm7aBM3YiBewBnjueSs4mEdtuOMoaeHAAY6RdSeviTCG6JrqdidgHxDU05mdNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fFLP0pCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fFLP0pCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE5AC16AAE;
	Wed, 21 Jan 2026 03:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966021;
	bh=SAM0uCd+Wz2WX1JMKYq1rp0Wx4rG4PBOqrH5RYS2e3M=;
	h=Date:To:From:Subject:From;
	b=fFLP0pCs9FqcsABg6mF8bFjDy7hX+6atVRqdgeGAy9ZvArmUcHjnPIv69djyph2+y
	 5ybDx88lUEDyF5bf8TV+SwgYKUXvRoRybKBqfTsV7lXrutXcJfOXg8ZY43WtZ2fUd7
	 jdvPWmvfR6P9Lpi07onVJdi2yXyYtFzIczkXErcg=
Date: Tue, 20 Jan 2026 19:27:00 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscanc-shrink_folio_list-save-a-tabstop.patch removed from -mm tree
Message-Id: <20260121032701.4CE5AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan.c:shrink_folio_list(): save a tabstop 
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-shrink_folio_list-save-a-tabstop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

