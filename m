Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C45D168BD
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 20:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729198624; cv=none; b=BA/rcc1iwqtW3BalhVQY1t4vSum9Dh3hfaeIQ0zRXfYez1VDtuxk9EXpej+/D+0ffd29dp9nAPm2XixcaUSY79rxk/igqbwyVimOdKjbuHCnKQWEtK4XKkxQcwcipdEgZxdGE2sTVo51k7gT8HRiSygPcykHVuAcZSm3WgEkJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729198624; c=relaxed/simple;
	bh=H1gpL9+r0bLtEB4J5ZARrNyRcQc1n6urR/Xff/VOjX0=;
	h=Date:To:From:Subject:Message-Id; b=dqjRXSL8PQ+j4fbKh1v3RnJuuCMDx8RCfpdJdv6zJ7VHqBMSvDzsGW7nPqeRmLl1JzxNZej1A6hWD7cRZms2UeaNV1BgpnsOZlwx2ByVckujIlwAPUm3+w2LCkzCIEWt+Pe6mKLjo6mFKIWh/JWQQARTEgxvlktkIUNzvsn0dyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gtmDLvF1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gtmDLvF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D0C4CECE;
	Thu, 17 Oct 2024 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729198623;
	bh=H1gpL9+r0bLtEB4J5ZARrNyRcQc1n6urR/Xff/VOjX0=;
	h=Date:To:From:Subject:From;
	b=gtmDLvF1RhODdzidPjh7Fhho0euAXxBabwjHuR+7atu9HVhTi9qeOhEJb58oQl9tU
	 9rRh0M/40LaiBUFOmo+fbz8v2GXdzQmgaCd81uVoQAIZhposnK0RVdyFKbk2ku0L2I
	 qneZ5BfW6Ui0ecwbGFTzh5n2iW3dAh5TIYNoyY2A=
Date: Thu, 17 Oct 2024 13:57:02 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,suleiman@google.com,heftig@archlinux.org,bgeffon@google.com,axelrasmussen@google.com,weixugc@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-reset-page-lru-tier-bits-when-activating.patch added to mm-unstable branch
Message-Id: <20241017205703.7A1D0C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: reset page lru tier bits when activating
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-reset-page-lru-tier-bits-when-activating.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-reset-page-lru-tier-bits-when-activating.patch

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
@@ -2602,8 +2602,6 @@ static bool should_clear_pmd_young(void)
  *                          shorthand helpers
  ******************************************************************************/
 
-#define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
-
 #define DEFINE_MAX_SEQ(lruvec)						\
 	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
 
@@ -4138,8 +4136,10 @@ void lru_gen_look_around(struct page_vma
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
@@ -4370,7 +4370,7 @@ static bool isolate_folio(struct lruvec
 
 	/* see the comment on MAX_NR_TIERS */
 	if (!folio_test_referenced(folio))
-		set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+		folio_clear_lru_refs(folio);
 
 	/* for shrink_folio_list() */
 	folio_clear_reclaim(folio);
_

Patches currently in -mm which might be from weixugc@google.com are

mm-mglru-reset-page-lru-tier-bits-when-activating.patch

