Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C648641C
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866056; cv=none; b=Ztu1RdE/6D668vDKxhsB5xL0NpIR19KU70eJcxo3XNZNZIg0oDmtkTNAtMz6amaUZE0HYM32DPnIjfwp0yVBFXMlcnXMY7uGBdizMiLLli3CjioH3Srwe0tL6hnqQ4zP6LpBPINDwTwO9GTFftDu3EwCuMyi4DTH/pfUTAAP8Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866056; c=relaxed/simple;
	bh=8YcbKvk0wM3aOREhS1DC/qb9Me/qbVpczsrL2qafMms=;
	h=Date:To:From:Subject:Message-Id; b=HHECdHopb6ErkenNuS5oSd//9KpUThB34uIa+/XcCaZWZE7571g73qP0Gq4FipBmfNLk0u6s++AdYsLmhYoAvHlzCV0kbUULKY5x7UxvBvZSNaCNW3+Fpa07Ob7j7+hlyZW/+3h/Pb/TtQip0TddZoZkQ1hpjr17fTjNWYMO5gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJvfPB5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJvfPB5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA5F1F00898;
	Tue, 13 Oct 2026 04:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866053;
	bh=BLI88p2CcH7bW3kjsfaX33ju4wj0qsWoAD+9E31Xz5Y=;
	h=Date:To:From:Subject;
	b=dJvfPB5J/cl0C47q8whZjzNpYl0Y47BS9sfpVCc/4jJiZVG5xz8uegpHhX+JKLcyW
	 7YLyRJzjWizToDDYFnSl1wCpWDf3STejKc6z0kjLSQv8ox83Wq1KXsKVJO/xvY9Ozz
	 fZN9zr9enY6Km2EyS4xAV4pKtJ5G75r5/M83imfQ=
Date: Mon, 12 Oct 2026 21:34:12 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch removed from -mm tree
Message-Id: <20261013043413.3AA5F1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: put rotation-missed folios at the LRU tail
has been removed from the -mm tree.  Its filename was
     mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
@@ -5114,7 +5126,7 @@ retry:
 			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list);
+	move_folios_to_lru(&list, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
_

Patches currently in -mm which might be from chenridong@xiaomi.com are


