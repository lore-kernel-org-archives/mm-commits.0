Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E3155744
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854818; cv=none; b=j4sq9oQL8WNi5egOZD53t9TNqhnMk9+oxXcT5sDrLJ5iY5xFNWouNy9x42Cgjk5CA+CuOxRHuYYOT5HJZ7nwzkBrMYcx3JDNMGH12iTIUb9SpHDLEkxoQyXL1zm6gGgeUlDMP7yJaoF1nxSG4+k3tmpM4dE68d7ZyGMizYZysKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854818; c=relaxed/simple;
	bh=bV4NY0zSkmR2uZaSZ6O5fhVoylEBbkKmNheFog56n+4=;
	h=Date:To:From:Subject:Message-Id; b=rXRU/w4fhLiy9IKIVbPbiHQ8EEjRnCTJZWsVUmFSW+c4Yi+F6vsOR2zC8LTewtcfrLcPrigLrqjksay1gdXMf9pHzR0c44idA8sPitFrIdm0+AmOuBkwk+MoSew/JfWQCZUlcKtz2fr/GMhiPPteibEP/0c6gCVcWoWd12UbQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wk1+EJPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wk1+EJPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3BC4CECF;
	Wed,  6 Nov 2024 01:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854817;
	bh=bV4NY0zSkmR2uZaSZ6O5fhVoylEBbkKmNheFog56n+4=;
	h=Date:To:From:Subject:From;
	b=Wk1+EJPX33Th7Z5CN74JdKT16vwRkiNH4OoECgiblmbnm5Wat8pzerkbFN/J3r0ZE
	 AdQAnpAln9xfaeCqu1U6xvFN3y2p/rW0TVVif4FmyzpxKJU2ktDYKUi+bxwqahrhW6
	 5Lqrf130DwJXu0GDLOgorjHunOSkUOIuZd/NS2DM=
Date: Tue, 05 Nov 2024 17:00:16 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-reset-page-lru-tier-bits-when-activating.patch removed from -mm tree
Message-Id: <20241106010017.C0F3BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: reset page lru tier bits when activating
has been removed from the -mm tree.  Its filename was
     mm-mglru-reset-page-lru-tier-bits-when-activating.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Xu <weixugc@google.com>
Subject: mm/mglru: reset page lru tier bits when activating
Date: Thu, 17 Oct 2024 18:15:28 +0000

When a folio is activated, lru_gen_add_folio() moves the folio to the
youngest generation.  But unlike folio_update_gen()/folio_inc_gen(),
lru_gen_add_folio() doesn't reset the folio lru tier bits (LRU_REFS_MASK |
LRU_REFS_FLAGS).  This inconsistency can affect how pages are aged via
folio_mark_accessed() (e.g.  fd accesses), though no user visible impact
related to this has been detected yet.

Note that lru_gen_add_folio() cannot clear PG_workingset if the activation
is due to workingset refault, otherwise PSI accounting will be skipped. 
So fix lru_gen_add_folio() to clear the lru tier bits other than
PG_workingset when activating a folio, and also clear all the lru tier
bits when a folio is activated via folio_activate() in
lru_gen_look_around().

Link: https://lkml.kernel.org/r/20241017181528.3358821-1-weixugc@google.com
Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Wei Xu <weixugc@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jan Alexander Steffens <heftig@archlinux.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   15 ++++++++++++++-
 include/linux/mmzone.h    |    2 ++
 mm/vmscan.c               |    8 ++++----
 3 files changed, 20 insertions(+), 5 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/include/linux/mm_inline.h
@@ -155,6 +155,11 @@ static inline int folio_lru_refs(struct
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + workingset;
 }
 
+static inline void folio_clear_lru_refs(struct folio *folio)
+{
+	set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+}
+
 static inline int folio_lru_gen(struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags);
@@ -222,6 +227,7 @@ static inline bool lru_gen_add_folio(str
 {
 	unsigned long seq;
 	unsigned long flags;
+	unsigned long mask;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -257,7 +263,14 @@ static inline bool lru_gen_add_folio(str
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
-	set_mask_bits(&folio->flags, LRU_GEN_MASK | BIT(PG_active), flags);
+	mask = LRU_GEN_MASK;
+	/*
+	 * Don't clear PG_workingset here because it can affect PSI accounting
+	 * if the activation is due to workingset refault.
+	 */
+	if (folio_test_active(folio))
+		mask |= LRU_REFS_MASK | BIT(PG_referenced) | BIT(PG_active);
+	set_mask_bits(&folio->flags, mask, flags);
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
--- a/include/linux/mmzone.h~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/include/linux/mmzone.h
@@ -403,6 +403,8 @@ enum {
 	NR_LRU_GEN_CAPS
 };
 
+#define LRU_REFS_FLAGS		(BIT(PG_referenced) | BIT(PG_workingset))
+
 #define MIN_LRU_BATCH		BITS_PER_LONG
 #define MAX_LRU_BATCH		(MIN_LRU_BATCH * 64)
 
--- a/mm/vmscan.c~mm-mglru-reset-page-lru-tier-bits-when-activating
+++ a/mm/vmscan.c
@@ -2603,8 +2603,6 @@ static bool should_clear_pmd_young(void)
  *                          shorthand helpers
  ******************************************************************************/
 
-#define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
-
 #define DEFINE_MAX_SEQ(lruvec)						\
 	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
 
@@ -4142,8 +4140,10 @@ bool lru_gen_look_around(struct page_vma
 		old_gen = folio_lru_gen(folio);
 		if (old_gen < 0)
 			folio_set_referenced(folio);
-		else if (old_gen != new_gen)
+		else if (old_gen != new_gen) {
+			folio_clear_lru_refs(folio);
 			folio_activate(folio);
+		}
 	}
 
 	arch_leave_lazy_mmu_mode();
@@ -4376,7 +4376,7 @@ static bool isolate_folio(struct lruvec
 
 	/* see the comment on MAX_NR_TIERS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+		folio_clear_lru_refs(folio);
 
 	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
_

Patches currently in -mm which might be from weixugc@google.com are


