Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28C35294E
	for <mm-commits@vger.kernel.org>; Sat,  5 Sep 2026 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788647111; cv=none; b=Uuf9D4NA4dhdJXCbjbPNUqidoEyf9BX+jhQiDh3qNPtP72LNtV7ALrY4GNIwBqksDlrfJMUl8X+/CgV2iS8CVoDiTtWr1F7S9Bt7bwnLKVO9yoHiMQU3DJMD1yB9SSEj2kT5g02jjr7Oq2HgBtQnrL7jDMrcjMZSxzMVOzHOSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788647111; c=relaxed/simple;
	bh=pJb9wNIJB/jX+1AlVN0C9HC31lcmiYhl6hx0p44t3h4=;
	h=Date:To:From:Subject:Message-Id; b=aij46VbCMlCGd2di4AhyMCjtSi/8JOvB1O284N20auktlSuoGD/pAlaTpP3eGMqifh3EFq68/CVJcfKVBscIGbnVphVKiLieMF7Y8UH4DK1M2lgQ5RIKjk7D9n5bDWOA65SPCmXibJaGJH6hyYlhnQqwnLY0FvZof2BKm2yaHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x7+IgWLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x7+IgWLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1251F00A3A;
	Sat,  5 Sep 2026 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788647109;
	bh=z8rKkZbX/PiN2K1LNOKHPwoD/wbvYFIPt9c47sP4zvw=;
	h=Date:To:From:Subject;
	b=x7+IgWLuaRQ0KztBpYCELeZq+BpLKtiIYUWtnv7r2mr+NkecpzN9ExjJ4JLpMkFVI
	 c/OPL5/7+pJ3TWeiWUgFdnDQmGq80LrmwlvcTbU0hxkrz8FoN3QdZESURryGrAGvLo
	 Vj5ika7+Ulsyug0NCFPMLCi6G32vyh50dj7Nu/Rk=
Date: Sat, 05 Sep 2026 15:25:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,shakeel.butt@linux.dev,ryncsn@gmail.com,roman.gushchin@linux.dev,ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch added to mm-new branch
Message-Id: <20260905222509.7D1251F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: introduce helpers for manipulating gen and refs flags
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch

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
Subject: mm/mglru: introduce helpers for manipulating gen and refs flags
Date: Sun, 06 Sep 2026 00:51:07 +0800

Instead of doing bit ops on folio->flags.f, introduce helpers for
adjusting a folio's refs and generation info, making the code easier to
debug and understand.

No functional change is intended: some combined atomic operations are
split into two, which only creates harmless transient states.  There is no
measurable performance impact, and some paths even look slightly better in
the generated assembly.

Link: https://lore.kernel.org/20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   84 ++++++++++++++++++++++++++++++++----
 include/linux/mmzone.h    |    1 
 mm/folio.c                |   19 ++++----
 mm/vmscan.c               |   60 ++++++++++++++-----------
 4 files changed, 122 insertions(+), 42 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags
+++ a/include/linux/mm_inline.h
@@ -142,10 +142,66 @@ static inline int lru_tier_from_refs(int
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(const struct folio *folio)
+/**
+ * lru_set_gen_flags - Set the LRU generation number to specified folio flags.
+ * @flags: pointer to the folio flags
+ * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
+ */
+static inline void lru_set_gen_flags(unsigned long *flags, int gen)
+{
+	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
+	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
+	/* Store gen offset by 1, zero means the folio is off-list. */
+	*flags &= ~LRU_GEN_MASK;
+	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
+}
+
+/**
+ * lru_get_gen_flags - Return the LRU generation number from folio flags.
+ * @flags: folio flags
+ *
+ * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
+ * -1 if the flags indicate the folio is off the list (e.g., isolated).
+ */
+static inline int lru_get_gen_flags(unsigned long flags)
+{
+	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+
+	/* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison */
+	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
+	return gen;
+}
+
+/**
+ * lru_set_refs_flags - Set the LRU referenced count to folio flags.
+ * @flags: pointer to the folio flags
+ * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
+ *
+ * For MGLRU, PG_referenced holds the first ref, and the extra bits hold the
+ * remaining refs. For classical LRU the extra bits are not used, so it can
+ * also be seen as the refs count never exceeds 1. In both cases, refs == 1
+ * means PG_referenced is set and the extra bits are zero, and refs == 0 means
+ * PG_referenced and the extra bits are all unset.
+ */
+static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
+
+	*flags &= ~LRU_REFS_FLAGS;
+	if (!refs)
+		return;
+	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
+}
 
+/**
+ * lru_get_refs_flags - Return LRU referenced / access count from folio flags.
+ * @flags: folio flags
+ *
+ * Reads the LRU referenced count set by lru_set_refs_flags().
+ */
+static inline int lru_get_refs_flags(unsigned long flags)
+{
 	if (!(flags & BIT(PG_referenced)))
 		return 0;
 	/*
@@ -155,11 +211,24 @@ static inline int folio_lru_refs(const s
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(const struct folio *folio)
+static inline int folio_lru_refs(const struct folio *folio)
 {
-	unsigned long flags = READ_ONCE(folio->flags.f);
+	return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
 
-	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
+{
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+
+	do {
+		new_flags = old_flags;
+		lru_set_refs_flags(&new_flags, refs);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
+}
+
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
 }
 
 static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
@@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(str
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
+	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
@@ -295,7 +364,7 @@ static inline bool lru_gen_del_folio(str
 
 	/* for folio_migrate_flags() */
 	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
-	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
+	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
@@ -339,7 +408,6 @@ static inline bool lru_gen_del_folio(str
 
 static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
-
 }
 #endif /* CONFIG_LRU_GEN */
 
--- a/include/linux/mmzone.h~mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags
+++ a/include/linux/mmzone.h
@@ -500,6 +500,7 @@ enum lruvec_flags {
 
 #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
 #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
+#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
 
 /*
  * For folios accessed multiple times through file descriptors,
--- a/mm/folio.c~mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags
+++ a/mm/folio.c
@@ -354,26 +354,28 @@ static void __lru_cache_activate_folio(s
 
 static void lru_gen_inc_refs(struct folio *folio)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int refs;
 
 	if (folio_test_unevictable(folio))
 		return;
 
 	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+	if (!folio_lru_refs(folio)) {
+		folio_set_lru_refs(folio, 1);
 		return;
 	}
 
 	do {
-		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
+		new_flags = old_flags;
+		refs = lru_get_refs_flags(old_flags);
+		if (refs == LRU_REFS_MAX) {
 			if (!folio_test_workingset(folio))
 				folio_set_workingset(folio);
 			return;
 		}
-
-		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_refs_flags(&new_flags, refs + 1);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
 static bool lru_gen_clear_refs(struct folio *folio)
@@ -385,7 +387,8 @@ static bool lru_gen_clear_refs(struct fo
 	if (gen < 0)
 		return true;
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
+	folio_set_lru_refs(folio, 0);
+	folio_clear_workingset(folio);
 
 	rcu_read_lock();
 	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
--- a/mm/vmscan.c~mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags
+++ a/mm/vmscan.c
@@ -863,19 +863,22 @@ static bool lru_gen_set_refs(struct foli
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		/* Activate file-backed executable folios after first usage. */
 		if (is_exec_file_folio(folio, vma_flags)) {
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			folio_set_workingset(folio);
+			folio_set_lru_refs(folio, 0);
 			return true;
 		}
 
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return false;
 	}
 
 	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1)
-		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
-	else
+	if (folio_lru_refs(folio) > 1) {
+		folio_set_workingset(folio);
+		folio_set_lru_refs(folio, 0);
+	} else {
 		folio_mark_accessed(folio);
+	}
 	return true;
 }
 #else
@@ -3291,11 +3294,10 @@ static bool positive_ctrl_err(struct ctr
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
-
-	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
+	int old_gen;
 
 	/*
 	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
@@ -3304,31 +3306,34 @@ static int folio_update_gen(struct folio
 	 */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
 	    !is_exec_file_folio(folio, vma_flags)) {
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		folio_set_lru_refs(folio, 1);
 		return -1;
 	}
 
 	do {
+		old_gen = lru_get_gen_flags(old_flags);
+		new_flags = old_flags;
+
 		/* lru_gen_del_folio() has isolated this page? */
-		if (!(old_flags & LRU_GEN_MASK))
-			return -1;
+		if (old_gen < 0)
+			break;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+		new_flags |= BIT(PG_workingset);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+	return old_gen;
 }
 
 static int __folio_inc_gen(struct folio *folio, int old_gen, bool *increased)
 {
-	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
+	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int new_gen;
 
-	VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
-
 	do {
-		new_gen = ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
+		new_gen = lru_get_gen_flags(old_flags);
+
 		/* folio_update_gen() has promoted this page? */
 		if (new_gen >= 0 && new_gen != old_gen) {
 			if (increased)
@@ -3336,11 +3341,12 @@ static int __folio_inc_gen(struct folio
 			return new_gen;
 		}
 
+		new_flags = old_flags;
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 
-		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
-		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
+		lru_set_gen_flags(&new_flags, new_gen);
+		lru_set_refs_flags(&new_flags, 0);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	if (increased)
 		*increased = true;
@@ -4785,7 +4791,7 @@ static bool isolate_folio(struct lruvec
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
+		folio_set_lru_refs(folio, 0);
 
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
@@ -5017,8 +5023,10 @@ retry:
 		}
 
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
+			folio_set_lru_refs(folio, 0);
+			folio_set_active(folio);
+		}
 	}
 
 	move_folios_to_lru(&list);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch

