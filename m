Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E14A51A154
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790029340; cv=none; b=pRcJTznYPaXZrU0om6/OjmYgej4gfDI+jyskYeeGH3a2JxMYXGSvFQ3F7YDNtSuLsXYuvEPRHpRn2fdjTXui3m+gxPpmdBf2GJEN5NGkbQ4/3c84D435XlC2LTYf/aCybze4r3D07oM0SaQUB/1A9ni/kcbmfu0oJVbd5OL8HbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790029340; c=relaxed/simple;
	bh=WjHjLz+ZO1UMOwYDYEnbjMupRhnJ4iu9UIKI/GMf7CE=;
	h=Date:To:From:Subject:Message-Id; b=BUA9jOpaO5V7XmmXMlsQUUTnt2z4UoQYGc/PaZky9UCimfjjl/B16sLO+PZNu60uHqgxswFhO96SjGJFtlOgZ8mI5etqpezQY7RkVe8fo6qzyGB5QFsk+fXWgHW3B/aNqxgn+PZqRmMHLEpPSgLf9FR3J3pp8YNHRsMk4RUGmWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzzX+Q0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzzX+Q0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C699A1F000FF;
	Mon, 21 Sep 2026 22:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790029337;
	bh=d8ZSAemJBup+9HVODDbcmKpi9pwMyg4kv+zRloeZFWI=;
	h=Date:To:From:Subject;
	b=fzzX+Q0AcR5rpyU+8L1cUCFA98TSl767YC6XxktW/48FhxAvq4yu/AoCY9Cykzgjl
	 ue7JtuRfBdDh4w99kxIxs/FXR14MDXIcRa6FtaHzwbOXothXHKqpWjXJUOVwJDccIx
	 SmNecNIHuecitbM/yvu3qjGuTbbCg90BhWbkU9ts=
Date: Mon, 21 Sep 2026 15:22:17 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch added to mm-new branch
Message-Id: <20260921222217.C699A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: put rotation-missed folios at the LRU tail
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm: vmscan: put rotation-missed folios at the LRU tail
Date: Sun, 20 Sep 2026 21:25:19 +0800

The page reclaim isolates a batch of folios from the tail of an LRU list
and works on them one by one.  For a suitable swap-backed folio on an
async swap device, it queues the folio for writeback and, after finishing
the batch, puts the folio back to the head of the original LRU list.

Meanwhile the page writeback flushes the queued folios in its own,
independent batches.  For each folio it writes back it calls
folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
tail.  But folio_rotate_reclaimable() only takes effect once the folio has
been put back by reclaim.  If the async swap device is fast enough, the
writeback can complete a folio while reclaim is still working on the rest
of the batch that contains it.  In that case the folio stays near the head
and reclaim will not revisit it before wrapping around, causing a cold/hot
inversion: a clean, written-back folio that should be a prime reclaim
candidate is kept ahead of hotter folios.

commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
isolated") addressed this for MGLRU only.  The traditional active/inactive
LRU has the same problem, reported at [1].  A reproducer is available at
[2].

Rather than re-reclaiming those folios (which would drop the swap cache
that may still be useful for a future hit [4]), restore the rotation that
was missed: when move_folios_to_lru() puts a folio back, add it to the LRU
tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
mapped, not dirty and not under writeback).  A referenced folio is left at
the head so it still gets a second chance, and a folio with an unexpected
reference (e.g.  a GUP or speculative pin) is left at the head because it
cannot be reclaimed yet anyway.  A new do_rotate parameter gates this so
it only applies on the reclaim put-back path (shrink_inactive_list()), not
on shrink_active_list() where the list order is already deliberate.  This
approach was suggested by Barry Song [3].

Only the traditional LRU is handled here.  MGLRU already retries such
folios via its own clean-list retry pass in evict_folios(), so it is left
unchanged.  The same do_rotate scheme could later replace that retry pass
to unify both LRUs, which is left for a follow-up.

Test result with [2]:

  Without patch:
    cat memory.usage_in_bytes
    1073700864
    cat memory.memsw.usage_in_bytes
    1413124096

    free -h
                  total        used        free
    Mem:           1.6Gi       1.2Gi       299Mi
    Swap:          1.0Gi       678Mi       346Mi

  With patch:
    cat memory.usage_in_bytes
    1071140864
    cat memory.memsw.usage_in_bytes
    1413423104

    free -h
                  total        used        free
    Mem:           1.6Gi       1.2Gi       322Mi
    Swap:          1.0Gi       328Mi       695Mi

After applying the patch, the difference between
memory.memsw.usage_in_bytes and memory.usage_in_bytes is close to the swap
"used" value reported by 'free -h'.

Link: https://lore.kernel.org/20260920132519.3369946-1-ridong.chen@linux.dev
Link: https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/ [1]
Link: https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/ [2]
Link: https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/ [4]
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Link: https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/ [3]
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 mm/vmscan.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-put-rotation-missed-folios-at-the-lru-tail
+++ a/mm/vmscan.c
@@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pgl
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list)
+static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -2018,7 +2018,19 @@ static unsigned int move_folios_to_lru(s
 			continue;
 		}
 
-		lruvec_add_folio(lruvec, folio);
+		/*
+		 * Put clean, unreferenced and unpinned folios that may have
+		 * missed folio_rotate_reclaimable() at the tail to avoid
+		 * cold/hot inversion.
+		 */
+		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio) &&
+		    !folio_test_referenced(folio) &&
+		    folio_ref_count(folio) == folio_expected_ref_count(folio))
+			lruvec_add_folio_tail(lruvec, folio);
+		else
+			lruvec_add_folio(lruvec, folio);
+
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
 		if (folio_test_active(folio))
@@ -2135,7 +2147,7 @@ static unsigned long shrink_inactive_lis
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list);
+	move_folios_to_lru(&folio_list, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2246,8 +2258,8 @@ static void shrink_active_list(unsigned
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active);
-	nr_deactivate = move_folios_to_lru(&l_inactive);
+	nr_activate = move_folios_to_lru(&l_active, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -5115,7 +5127,7 @@ retry:
 			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list);
+	move_folios_to_lru(&list, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-drop-the-combined-limit-gate-in-__node_reclaim.patch
mm-mglru-preserve-inactive-placement-when-enabling-mglru.patch
mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch
memcg-acquire-peaks_lock-when-reading-memorypeak.patch
mm-memcg-fix-memorypeak-reset-clobbering-other-fds-watermark.patch
mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

