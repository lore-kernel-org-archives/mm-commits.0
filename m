Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465400;
	b=MKGbtpEPoei1P/ygrGwdU6Vb1jN+jBOCE8I+4paRxg2osDb05wppe00NFak/U47vJvQs
	 k5k6hTGsewTl8sZHxt2vwOeOKTfQKct5afJLgs4v5lvb5A+/TARcZjM0+QjlSkjx/n+mA
	 n85GsBOiHQ/1OKMAuqbjgbfI04rBUM+PgDf/RMCYxLf4AG7EwJ1IksJPQ0LtYJfKxlG2d
	 M7wigQUONCJXmSLxaLnJouZW50i9E6sUMGEq7YfBIUgEYSYUUjjjRbfr1QHS5JBN328x3
	 rZ/oXrGNtmOInddORAfo8w2vIvz1dwEUhULhiwmN2JH5lXEuYQhcaRfbvylgXFAtr1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465400;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=6chN9kK/fsPR0Mu3pXIWFeZXkojTs8fLq/nbHTAfieU=;
	b=OV1sMXqyULOk6xPmSauseSBrAzJ9Pk98iVrWA7IU/c3OZNLypx+/or7yv9SLzTrlkgu/
	 5GtQZODlu22sC84iop+ScdDLGO65P6XvCUTxQgxu3gbyIQFJoWq3/Cri9hl9B9b5nNg9m
	 yoamfByBzKPlQQ7x9D02f50VxNqVRE0OBIfUuxnFKqD2A0lPeglHfk9iBq2uKWjQJBZXm
	 MUAV/InXnJMwPmMVIAP/IXYQX2tPouy+4uBa/1wQDNyX60Rp8nd9A6ZMKA59TItBNrqAt
	 cDLkWdrmWHlEOMfLob8l/+5bhMtKq6XclZi9BPDUDwqSQ/d/Qe+y5RX0KWq2TepTcKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CJR+Im0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70361606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CJR+Im0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278BE1F000C4;
	Mon, 23 Nov 2026 20:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795465400;
	bh=6chN9kK/fsPR0Mu3pXIWFeZXkojTs8fLq/nbHTAfieU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=CJR+Im0HWPy49KJ6G1SBM2mMMgwT80j2wfQIisbYTOFG/nvZknQaHFbhvgH3WlSaB
	 DFe2meoe76ASzdY4CkD6SAvQjXyOmp+PRZ/f+bzMUsqP6mt09pnpPaaWGnjnGEG5RZ
	 MKDJIOqnayWx+GR5ybRes6q5cGStArREjwfK6Xso=
Date: Mon, 23 Nov 2026 12:23:19 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
Subject: + mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch added to mm-new branch
Message-Id: <20261123202320.278BE1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru, gup: mark folios referenced via a fast helper
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/mglru, gup: mark folios referenced via a fast helper
Date: Tue, 24 Nov 2026 02:53:02 +0800

Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
classical LRU as before. No counter update or promotion is needed,
nonzero MGLRU refs are left unchanged.

The classical path is taken for a folio that is off the gen lists while
MGLRU is off, not on lru_gen_enabled() alone: while MGLRU is being
turned off, a folio can still be on a gen list after the static key
flips, and setting PG_referenced there would bump its refs count.

That check uses lru_get_gen_flags(), so move the helper out of the
CONFIG_LRU_GEN block, it is now built with the option off, where
LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero. Keep the decoded value in
an int so the subtraction of the offset-by-one encoding cannot fold to
ULONG_MAX before it happens to avoid -Woverflow error with CONFIG_WERROR.

This helper only aims to be fast, it exists so the gup fast path can
stay a fast path. The new helper doesn't account for refs above
LRU_REFS_REFERENCED but that's fine for now as GUP never used that
or anything similar for CLRU either.

Convert the gup fast-path sites. No behavior change for classical LRU,
no regression for MGLRU either. Just prepare for the following changes
by providing a helper that follows the new convention.

Link: https://patch.msgid.link/20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
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
Cc: Zi Yan <ziy@nvidia.com>
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
Cc: wang lian <lianux.mm@gmail.com>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: Tianyi Chen <hi@tychen.cc>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Harry Yoo <harry@kernel.org>

 include/linux/mm_inline.h |   62 ++++++++++++++++++++++++++----------
 mm/gup.c                  |    6 +--
 2 files changed, 49 insertions(+), 19 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-gup-mark-folios-referenced-via-a-fast-helper
+++ a/include/linux/mm_inline.h
@@ -105,6 +105,22 @@ static __always_inline enum lru_list fol
 	return lru;
 }
 
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
+{
+	int gen = (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
+
+	/* The gen is stored offset by one, so zero means off-list */
+	VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
+	return gen - 1;
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static inline bool lru_gen_switching(void)
@@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(uns
 	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
 }
 
-/**
- * lru_get_gen_flags - Return the LRU generation number from folio flags.
- * @flags: folio flags
- *
- * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
- * -1 if the flags indicate the folio is off the list (e.g., isolated).
- */
-static inline int lru_get_gen_flags(unsigned long flags)
-{
-	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
-
-	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
-	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
-	return gen;
-}
-
 static inline int folio_lru_gen(const struct folio *folio)
 {
 	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
@@ -483,6 +483,36 @@ static inline bool lru_gen_del_folio(str
 }
 #endif /* CONFIG_LRU_GEN */
 
+/**
+ * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
+ * @folio: the folio
+ *
+ * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
+ * untouched. For a folio off the gen lists with MGLRU off, a plain
+ * PG_referenced set.
+ */
+static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	unsigned int refs;
+
+	do {
+		refs = lru_get_refs_flags(old_flags);
+		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
+			/* For CLRU, just do folio_set_referenced() */
+			if (refs & LRU_REFS_REFERENCED)
+				break;
+			refs |= LRU_REFS_REFERENCED;
+		} else {
+			if (refs)
+				break;
+			refs = LRU_REFS_REFERENCED;
+		}
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
--- a/mm/gup.c~mm-mglru-gup-mark-folios-referenced-via-a-fast-helper
+++ a/mm/gup.c
@@ -2921,7 +2921,7 @@ static unsigned long gup_fast_pte_range(
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_inc_lru_refs_fast(folio);
 		pages[nr_pages] = page;
 		nr_pages++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2990,7 +2990,7 @@ static unsigned long gup_fast_pmd_leaf(p
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
@@ -3032,7 +3032,7 @@ static unsigned long gup_fast_pud_leaf(p
 
 	for (i = 0; i < nr_pages; i++)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_inc_lru_refs_fast(folio);
 	return nr_pages;
 }
 
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
mm-memcontrol-allow-update-of-lru-statistic-without-holding-lru-lock.patch
mm-memcontrol-avoid-potential-counter-leak-when-reparenting-local-stats.patch
mm-mglru-make-generation-page-counters-atomic.patch
mm-memcg-add-folio-based-lruvec-live-helper.patch
mm-mglru-frequency-guided-workingset-promotion-mglru-fg.patch
mm-mglru-make-folio-lru-referenced-times-count-a-generic-api.patch
mm-mglru-move-add-del-lru-size-accounting-out-of-lru_gen_update_size.patch
mm-mglru-gup-mark-folios-referenced-via-a-fast-helper.patch
mm-mglru-smaps-convert-to-lru-refs-based-operations-for-mglru.patch
mm-damon-convert-to-lru-refs-based-operations-for-mglru.patch
mm-khugepaged-convert-to-lru-refs-based-operations-for-mglru.patch
mm-madvise-adapt-for-lru-refs-based-operations-for-mglru.patch
mm-huge_memory-mark-folio-as-accessed-more-accurately-on-split.patch
mm-mglru-make-pg_workingset-helpers-work-based-on-folio-lru-refs.patch
mm-mglru-folio-lru-refs-based-active-inactive-number-accounting.patch
mm-mglru-make-folio_inc_lru_refs-lruvec-lockless.patch

