Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0525CD26D
	for <mm-commits@vger.kernel.org>; Thu,  5 Dec 2024 04:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733373866; cv=none; b=Sk+vJSONlet39ljNJsyIj2GWZrfK/nuQeXwOUZwktPBJ0hjVqYlukMAh+IFNOoAasSAzXJqkSuk+38k9CQ8Sxo9ZmxHva0AIAwIQNNnJnzYmw1wHn2jdHUDzOQQs0uPduvfudVyQYxxEudtTbNIGlfgEoHHKp6B0Z1zgHya5Ypg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733373866; c=relaxed/simple;
	bh=FMq6BZfcOOhBIKwtCnz83/FChTVDc2pss1UWe20G5So=;
	h=Date:To:From:Subject:Message-Id; b=umNI1KfPDaQL6n09q+A4y2990VlRR9LdPD249iCoqciuOELCM+R5tHF9V36SYeRO5qqDtGUV9bhTIHkTtf7bDJeAAHg1TA60weC4qIfAxmcTvLOGGOnz6OXMByiPxZSmnbhbkl5/JMmrN7yC9PxW/SlwhWpyN0P1zF5SGkN/p9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pUt7JtuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pUt7JtuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C09C4CED6;
	Thu,  5 Dec 2024 04:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733373865;
	bh=FMq6BZfcOOhBIKwtCnz83/FChTVDc2pss1UWe20G5So=;
	h=Date:To:From:Subject:From;
	b=pUt7JtuWv5wqqRGPA/AjcAdd8fp3Q9Ol8325sR1ds+Il86HFmZdKW+6kh+rsuTzy1
	 Tlga9zEc4vnCKyfb8v83CsHxAFeDHNVlTIDdMMRqryC1vvalz30IlPjcms9HiOTMNW
	 TgMFa+FKD8V/MxDqioRMilYPiTEjYdSCCwtCWDF0=
Date: Wed, 04 Dec 2024 20:44:25 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,kasong@tencent.com,kaleshsingh@google.com,bharata@amd.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-optimize-deactivation.patch added to mm-unstable branch
Message-Id: <20241205044425.C4C09C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: optimize deactivation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-optimize-deactivation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-optimize-deactivation.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm/mglru: optimize deactivation
Date: Sun, 1 Dec 2024 20:28:19 -0700

Do not shuffle a folio in the deactivation paths if it is already in the
oldest generation.  This reduces the LRU lock contention.

Before this patch, the contention is reproducible by FIO, e.g.,

  fio -filename=/dev/nvme1n1p2 -direct=0 -thread -size=1024G \
      -rwmixwrite=30  --norandommap --randrepeat=0 -ioengine=sync \
      -bs=4k -numjobs=400 -runtime=25000 --time_based \
      -group_reporting -name=mglru

  98.96%--_raw_spin_lock_irqsave
          folio_lruvec_lock_irqsave
          |
           --98.78%--folio_batch_move_lru
               |
                --98.63%--deactivate_file_folio
                          mapping_try_invalidate
                          invalidate_mapping_pages
                          invalidate_bdev
                          blkdev_common_ioctl
                          blkdev_ioctl

After this patch, deactivate_file_folio() bails out early without taking
the LRU lock.

A side effect is that a folio can be left at the head of the oldest
generation, rather than the tail.  If reclaim happens at the same time, it
cannot reclaim this folio immediately.  Since there is no known
correlation between truncation and reclaim, this side effect is considered
insignificant.

Link: https://lkml.kernel.org/r/20241202032823.2741019-3-yuzhao@google.com
Reported-by: Bharata B Rao <bharata@amd.com>
Closes: https://lore.kernel.org/CAOUHufawNerxqLm7L9Yywp3HJFiYVrYO26ePUb1jH-qxNGWzyA@mail.gmail.com/
Signed-off-by: Yu Zhao <yuzhao@google.com>
Tested-by: Kalesh Singh <kaleshsingh@google.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-mglru-optimize-deactivation
+++ a/mm/swap.c
@@ -379,7 +379,8 @@ static void __lru_cache_activate_folio(s
 }
 
 #ifdef CONFIG_LRU_GEN
-static void folio_inc_refs(struct folio *folio)
+
+static void lru_gen_inc_refs(struct folio *folio)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags);
 
@@ -406,10 +407,30 @@ static void folio_inc_refs(struct folio
 		new_flags |= old_flags & ~LRU_REFS_MASK;
 	} while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
 }
-#else
-static void folio_inc_refs(struct folio *folio)
+
+static bool lru_gen_clear_refs(struct folio *folio)
+{
+	int gen = folio_lru_gen(folio);
+	int type = folio_is_file_lru(folio);
+	struct lru_gen_folio *lrugen = &folio_lruvec(folio)->lrugen;
+
+	set_mask_bits(&folio->flags, LRU_REFS_MASK | LRU_REFS_FLAGS, 0);
+
+	/* whether can do without shuffling under the LRU lock */
+	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+}
+
+#else /* !CONFIG_LRU_GEN */
+
+static void lru_gen_inc_refs(struct folio *folio)
+{
+}
+
+static bool lru_gen_clear_refs(struct folio *folio)
 {
+	return false;
 }
+
 #endif /* CONFIG_LRU_GEN */
 
 /**
@@ -428,7 +449,7 @@ static void folio_inc_refs(struct folio
 void folio_mark_accessed(struct folio *folio)
 {
 	if (lru_gen_enabled()) {
-		folio_inc_refs(folio);
+		lru_gen_inc_refs(folio);
 		return;
 	}
 
@@ -524,7 +545,7 @@ void folio_add_lru_vma(struct folio *fol
  */
 static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 {
-	bool active = folio_test_active(folio);
+	bool active = folio_test_active(folio) || lru_gen_enabled();
 	long nr_pages = folio_nr_pages(folio);
 
 	if (folio_test_unevictable(folio))
@@ -589,7 +610,10 @@ static void lru_lazyfree(struct lruvec *
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	folio_clear_referenced(folio);
+	if (lru_gen_enabled())
+		lru_gen_clear_refs(folio);
+	else
+		folio_clear_referenced(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
@@ -657,6 +681,9 @@ void deactivate_file_folio(struct folio
 	if (folio_test_unevictable(folio))
 		return;
 
+	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
+		return;
+
 	folio_batch_add_and_move(folio, lru_deactivate_file, true);
 }
 
@@ -670,7 +697,10 @@ void deactivate_file_folio(struct folio
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_unevictable(folio) || !(folio_test_active(folio) || lru_gen_enabled()))
+	if (folio_test_unevictable(folio))
+		return;
+
+	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
 	folio_batch_add_and_move(folio, lru_deactivate, true);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-clean-up-workingset.patch
mm-mglru-optimize-deactivation.patch
mm-mglru-rework-aging-feedback.patch
mm-mglru-rework-type-selection.patch
mm-mglru-rework-refault-detection.patch
mm-mglru-rework-workingset-protection.patch

