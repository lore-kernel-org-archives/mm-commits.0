Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79AE46E01C;
	Wed, 12 Aug 2026 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786568463; cv=none; b=gOAwztjKpzXdBKNjONzyJjKiWtDB9MoljWeAeJfSEu8oC3zU69bhwrBa7C1ZHoq3/f3hbLksuatdhleBw75qRbs3mY4enqssG0QB2neS5jMZmeGKJfftmJS7W1iWHUGraT7Z3SxrtD+khUa1/bRNGtY2vI1kW4zXuDishP52kH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786568463; c=relaxed/simple;
	bh=T7H9pP6jCWseNjfy3ztFkcDXxDEZu1mAC/17cddfb+I=;
	h=Date:To:From:Subject:Message-Id; b=ERpZOYiQp03Ns6TkKMiTOT1KzDtxKY/gFy7fz4PSsnf2cRAtyo76Bgslf/wpai1PEn0u1QjqIW+2+RAiDyP58Nrf7rI73M3TpRPLEf7xUbM+GT5hAjs614xtgSTT6JPeAgzhb8WJAU2CeUJIiyY3i/y5bjblNzm4vAc+541Oaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YSLaj8W4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YSLaj8W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2F81F000E9;
	Wed, 12 Aug 2026 21:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786568457;
	bh=WFmCWXXf89domoFoOfeqgrQAPwNz4FAQ+Q43Cs0TAXM=;
	h=Date:To:From:Subject;
	b=YSLaj8W4o54WVQU8g/uXJqTuAg8PctBumna9n3GN9lgSyb61L+h0sToIUhwLBzu1S
	 Jj3eNm8H97zWV1kYvl57op8PrMbKL4F9H+US4TMkaL6WCzGzZs3So9nHkM8f2ZEtR/
	 Fb8HrrGLXC4NAJWxto7bzeN4zrZpPsCu6ItTNC+8=
Date: Wed, 12 Aug 2026 14:00:56 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,suleiman@google.com,steven@liquorix.net,stable@vger.kernel.org,shakeel.butt@linux.dev,oleksandr@natalenko.name,mhocko@kernel.org,ljs@kernel.org,heftig@archlinux.org,hannes@cmpxchg.org,david@kernel.org,bgeffon@google.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch added to mm-new branch
Message-Id: <20260812210057.0B2F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: fix and remove redundant unevictable folio handling
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch

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
Subject: mm/mglru: fix and remove redundant unevictable folio handling
Date: Wed, 12 Aug 2026 20:22:39 +0800

sort_folio() has a shortcut for moving folios that are no longer evictable
but are still sitting on a generation list.  However, this shortcut is
buggy.  It does not follow the PG_lru usage convention, and it has a more
serious issue.

Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
folio->lru can be reused to hold folio->mlock_count (see the comment in
lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
and every other place that turns a folio unevictable initialises
mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
__mlock_new_folio() set it to !!folio_test_mlocked(folio).  sort_folio()
sets nothing, and the lru_gen_del_folio() right above it may have already
poisoned folio->lru via list_del(), so mlock_count ends up aliasing
LIST_POISON2, which reads as 0x122, i.e.  290.  The result is user
visible.  On munlock, __munlock_folio() decrements that bogus count, finds
it still non-zero and bails out before clearing PG_mlocked, so the folio
remains unevictable and the Mlocked accounting stays inflated until the
folio is freed.

The shortcut also touches the LRU flags in the wrong order.  It calls
lru_gen_del_folio() while PG_lru is still set, so a concurrent
folio_test_clear_lru() (e.g.  compaction, folio_isolate_lru()) can succeed
on a folio that has already been taken off the generation list, which may
lead to unexpected behavior.

So fix it by isolating them as common folios and letting the generic
shrink path cull them.  This matches the classical LRU behavior, and there
should be no visible effect on the generic eviction or isolation behavior.

There is no performance concern either, such a folio goes through this
once, and then it is off the generation lists for good.

Link: https://lore.kernel.org/20260812-mglru-mlock-fix-v2-1-a3fec5853c08@tencent.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Alexander Steffens (heftig) <heftig@archlinux.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

--- a/mm/vmscan.c~mm-mglru-fix-and-remove-redundant-unevictable-folio-handling
+++ a/mm/vmscan.c
@@ -4649,7 +4649,6 @@ void lru_gen_reparent_memcg(struct mem_c
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
 		       int tier_idx)
 {
-	bool success;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4661,15 +4660,9 @@ static bool sort_folio(struct lruvec *lr
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
 
-	/* unevictable */
-	if (!folio_evictable(folio)) {
-		success = lru_gen_del_folio(lruvec, folio, true);
-		VM_WARN_ON_ONCE_FOLIO(!success, folio);
-		folio_set_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
-		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
-		return true;
-	}
+	/* unevictable: let it through and the generic path will cull it */
+	if (!folio_evictable(folio))
+		return false;
 
 	/* promoted */
 	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
@@ -4922,11 +4915,9 @@ retry:
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
-		if (!folio_evictable(folio)) {
-			list_del(&folio->lru);
-			folio_putback_lru(folio);
+		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
+		if (!folio_evictable(folio))
 			continue;
-		}
 
 		/* retry folios that may have missed folio_rotate_reclaimable() */
 		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch

