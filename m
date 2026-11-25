Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795638967;
	b=PEKz/5gvGotaH7pg9hLSgykSLwMLKyLgP9KqPSPiVagBqDvvsY6uZwgofoJAdpdd5pWS
	 GgRoGY3+ZrA5sMKG0N19toWWXp1+CcP6jWd/TPG1pc9nufTfJjCE/rCDUnrZt573xd9eo
	 d4gwLmLZAIscpaHlOz0peSlt1geaTzj8qFYXt2K7TRLi/zma/hrejxCgX18uAjU2bi0eL
	 pFOFDg4jL1k+5i8+D1xO+4om3cKLA894rL9ycRUJIfEqEUhRcU/o4GNCSiBjbKEq5PHJ1
	 kv4gNicw97pm164k80y3uBBE6rvlCKeZy+xM4wAOsEQkTz6IDJrAfbicUx5sX9AZ+rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795638967;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nhpoWvWAiwcJdhE+WNxcT+urv+jxWYHtoOgI+7xfNLs=;
	b=38xamASrdwFwRKmaVn+fCU7Zv3aFHCplXyXWcNLcl6GHjzpcvQ/oS+BEBv3F+g2zLI0H
	 mooqi2s4IjUsSOLc7S/GB9cO5SFBeIxbBF+HTi+ClVgAgqc8ComWtmLG0jyn3B2i9//9Y
	 7LI8BOcdgwc277tQVEzXQaL/ux46fvFJonB1RGcjQ9dl7k/I3uXvvOcbU+FQsM4rfiPUH
	 jooDKTEN5KAtH6is+PGoehggOoROglsZ85lN97eHVzsd3TvGUCuli+2dEGVhhslQFkjPP
	 IUFhN8xbT/hXZAfUoBL0tET3ieYm9c1iaMNL2/FiITC9C4j5QbsT4Uf0FRkY+d3ccHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vD28mhJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53A8606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 20:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vD28mhJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780D41F000C6;
	Wed, 25 Nov 2026 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795638967;
	bh=nhpoWvWAiwcJdhE+WNxcT+urv+jxWYHtoOgI+7xfNLs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=vD28mhJBPFhox7sAAenMFtAeF+u5m27vWOavPXvrmg33Il5PPK9CTKt1wWGYaL/wF
	 A4idShGF7aMaLnGMlog3UshnJdfwF4pdVSpPKpitD94Ot0ayBSmqk49XgnNjDd3CwI
	 XRooctIJDrNANz5srOmx8peTtz+BPP6eAbZMgqvY=
Date: Wed, 25 Nov 2026 12:36:06 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
Subject: [to-be-updated] mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch removed from -mm tree
Message-Id: <20261125203607.780D41F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru, smaps: convert to LRU refs based operations for MGLRU
has been removed from the -mm tree.  Its filename was
     mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru, smaps: convert to LRU refs based operations for MGLRU
Date: Tue, 24 Nov 2026 02:53:03 +0800

PG_referenced is only the lowest bit of the folio LRU refs count
(LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
clear it, and now it toggles as the count grows. But with the LRU
referenced count as a stable API now, we can use two helpers to provide
in-kernel users a stable and sane reading of the referenced status of
an LRU managed folio.

Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
count when MGLRU is enabled and PG_referenced otherwise, and switch the
smaps paths over to them. The lru_gen_enabled() test stays inside the
helpers, so its static key is not splattered over the few call sites.

Convert smaps as the first user of them. MGLRU now reports every folio
with a nonzero count, so the reading no longer flickers and clearing no
longer results in an ambiguous status.

The classical LRU case is unchanged.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: SJ Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Xiang Liu <liuxiang.277@bytedance.com>
Cc: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 fs/proc/task_mmu.c        |    6 +++---
 include/linux/mm_inline.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

--- a/fs/proc/task_mmu.c~mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru
+++ a/fs/proc/task_mmu.c
@@ -890,7 +890,7 @@ static void smaps_account(struct mem_siz
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
-	if (young || folio_test_young(folio) || folio_test_referenced(folio))
+	if (young || folio_test_young(folio) || folio_check_lru_refs(folio))
 		mss->referenced += size;
 
 	/*
@@ -1690,7 +1690,7 @@ static int clear_refs_pte_range(pmd_t *p
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1719,7 +1719,7 @@ out:
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		folio_test_clear_young(folio);
-		folio_clear_referenced(folio);
+		folio_clear_lru_refs(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
--- a/include/linux/mm_inline.h~mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru
+++ a/include/linux/mm_inline.h
@@ -513,6 +513,37 @@ static __always_inline void folio_inc_lr
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+/**
+ * folio_check_lru_refs - Test if an LRU managed folio has been referenced.
+ * @folio: The folio to test.
+ *
+ * Returns true if the MGLRU refs count is nonzero, or PG_referenced is set,
+ * which is also correct for the non-MGLRU case. Kept as a separate helper,
+ * to avoid splattering the lru_gen_enabled() static key.
+ */
+static inline bool folio_check_lru_refs(const struct folio *folio)
+{
+	if (lru_gen_enabled())
+		return folio_lru_refs(folio) > 0;
+	return folio_test_referenced(folio);
+}
+
+/**
+ * folio_clear_lru_refs - Clear the referenced state of an LRU managed folio.
+ * @folio: The folio to clear.
+ *
+ * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
+ * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
+ * just like folio_check_lru_refs().
+ */
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	if (lru_gen_enabled())
+		folio_set_lru_refs(folio, 0);
+	else
+		folio_clear_referenced(folio);
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-report-evictable-sizes-per-type.patch
mm-mglru-extract-lruvec_populated_min_seq-helper.patch
mm-mglru-reclaim-from-the-oldest-populated-gen.patch
mm-mglru-lift-the-forced-protection-of-reclaimer.patch
mm-mglru-skip-zones-above-reclaim_idx-instead-of-rotating-them.patch
mm-mglru-return-for-unavailable-anon-reclaim-earlier.patch
mm-mglru-balance-anon-and-file-scan-budget-by-refault-rate.patch
mm-mglru-lift-youngest-gen-protection-for-higher-priority.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

