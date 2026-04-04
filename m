Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C977260D;
	Sat,  4 Apr 2026 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775263588; cv=none; b=AxQGCMXGv63SGD9r/n5oNRcXOI6j0/VJpZh1vNVaHPe87RaCOcShBFlHz99kP57WkdC6CkjA50eyBBeCQwx8ysFlukkBDQGKrJwOLwP8RYFMFIr1WsW/cB5cPlr4nqw40+P6ibH0UECthhemUp51KHrvsJydmxIiLzm8Mo6ke18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775263588; c=relaxed/simple;
	bh=0lr4Uc0ZB3+GM0nP2kJSz4JktA5qM9temyX0uKIZjTk=;
	h=Date:To:From:Subject:Message-Id; b=Onq/DUIaKjHGsp8G0+kvSnpkbSHpEPIwjSSKsJSc6i0JCi4kfb+hbRjIllXoAPoZaqjMtBr2WmZB3t/+AIKbJBFG1JaCEwTAJ2BVPC+KDPbMixQofmZOTDETeDc2uxnSmhuvuR2ml5GIiAd4o32t3lv+iKkZonCiv/WNZQyBKGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WWoDSJj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WWoDSJj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D6AC4CEF7;
	Sat,  4 Apr 2026 00:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775263588;
	bh=0lr4Uc0ZB3+GM0nP2kJSz4JktA5qM9temyX0uKIZjTk=;
	h=Date:To:From:Subject:From;
	b=WWoDSJj62juNkhPKJbKUiEz24JUzd6ylrGhhQZgoH8s8BRHq6veNNAe9lzHCCVQN5
	 ZkesjW90HqvG4GHhP14NIeG3cOwcLLMBltLkaOsrd+EeZc1pRMO6zY9J3HJ4dk/5yF
	 IfR/PZL224dA/a3NdTZ1N+Xr/CMZSe+yrvogiUng=
Date: Fri, 03 Apr 2026 17:46:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,usama.arif@linux.dev,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,ljs@kernel.org,liam.howlett@oracle.com,kartikey406@gmail.com,joshua.hahnjy@gmail.com,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-deferred-split-queue-races-during-migration.patch removed from -mm tree
Message-Id: <20260404004628.03D6AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix deferred split queue races during migration
has been removed from the -mm tree.  Its filename was
     mm-fix-deferred-split-queue-races-during-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: fix deferred split queue races during migration
Date: Wed, 1 Apr 2026 21:10:32 +0800

migrate_folio_move() records the deferred split queue state from src and
replays it on dst.  Replaying it after remove_migration_ptes(src, dst, 0)
makes dst visible before it is requeued, so a concurrent rmap-removal path
can mark dst partially mapped and trip the WARN in deferred_split_folio().

Move the requeue before remove_migration_ptes() so dst is back on the
deferred split queue before it becomes visible again.

Because migration still holds dst locked at that point, teach
deferred_split_scan() to requeue a folio when folio_trylock() fails. 
Otherwise a fully mapped underused folio can be dequeued by the shrinker
and silently lost from split_queue.

[ziy@nvidia.com: move the comment]
  Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
Link: https://lkml.kernel.org/r/20260401131032.13011-1-lance.yang@linux.dev
Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++++++-----
 mm/migrate.c     |   18 +++++++++---------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-fix-deferred-split-queue-races-during-migration
+++ a/mm/huge_memory.c
@@ -4542,7 +4542,7 @@ retry:
 				goto next;
 		}
 		if (!folio_trylock(folio))
-			goto next;
+			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
 			if (underused)
@@ -4551,13 +4551,18 @@ retry:
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
+requeue:
 		/*
-		 * Only add back to the queue if folio is partially mapped.
-		 * If thp_underused returns false, or if split_folio fails
-		 * in the case it was underused, then consider it used and
-		 * don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
--- a/mm/migrate.c~mm-fix-deferred-split-queue-races-during-migration
+++ a/mm/migrate.c
@@ -1384,6 +1384,15 @@ static int migrate_folio_move(free_folio
 		goto out;
 
 	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
+	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
 	 * automatically build up the correct dst->mlock_count for it.
@@ -1399,15 +1408,6 @@ static int migrate_folio_move(free_folio
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-	/*
-	 * Requeue the destination folio on the deferred split queue if
-	 * the source was on the queue.  The source is unqueued in
-	 * __folio_migrate_mapping(), so we recorded the state from
-	 * before move_to_new_folio().
-	 */
-	if (src_deferred_split)
-		deferred_split_folio(dst, src_partially_mapped);
-
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
_

Patches currently in -mm which might be from lance.yang@linux.dev are


