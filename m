Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB7376468;
	Tue, 25 Aug 2026 01:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622944; cv=none; b=e1XHp/MNdeQHLqNafcZWYmazQoJTlpxJniAPlTG28oyCkF0x+2uBn95LQI+ksjy1Ob3Ew8yL/5Z0kIOQCfDFbD7izwHEJ0oJuVMqSplOpuFkqoHrcto8N9haF+PEF4/eSzOWjDJO2xeVYd0QGzx1Flos1e/R+cXsKz+ZkjsQsb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622944; c=relaxed/simple;
	bh=5DJozmw8IGgHrSGNtI2l5hgc/CQkM2dTevTpes7xAu0=;
	h=Date:To:From:Subject:Message-Id; b=OUstVI5OiXK8lmevW/F341zIfSINIn4GSjL00FBjlyrlLJEHkqf0IYbZ9Gpa+cnXrWeCzdE36auu9fSY3DBkkX9QtZ/IMn4EZSQZs14lQOSOVvTFOgVq6WPpE1D7VBaBHi19SYOYfdIypx8yPG7dgywGIbFhlFy5xUr6ocpggY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MjL2Fn4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MjL2Fn4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C231F000E9;
	Tue, 25 Aug 2026 01:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622943;
	bh=J3DPObgIkgPswYENdgjVVLYjHlz0FG92HHr1vdKy/rU=;
	h=Date:To:From:Subject;
	b=MjL2Fn4XoACTZbWXKzQ9d2DPE0M5gjV1pw6jM6r3djnc54Jl3uuMImaa++g/p+2J7
	 XDbGPRR1ZW970RsJ08VTerXIU33kXZtHEjZ5Ms02C2atRNuK90ILvicf+FUro3qwBK
	 xJeonrcp1u52oBhcZWe15GiBEspFbks3dSi90N4g=
Date: Mon, 24 Aug 2026 18:55:42 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,suleiman@google.com,steven@liquorix.net,stable@vger.kernel.org,shakeel.butt@linux.dev,oleksandr@natalenko.name,mhocko@kernel.org,ljs@kernel.org,heftig@archlinux.org,hannes@cmpxchg.org,david@kernel.org,bgeffon@google.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch removed from -mm tree
Message-Id: <20260825015543.45C231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix and remove redundant unevictable folio handling
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-and-remove-redundant-unevictable-folio-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
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


