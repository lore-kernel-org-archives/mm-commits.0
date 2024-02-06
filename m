Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925FD51D
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707178520; cv=none; b=pXm1Donh9ADnwMiosaHw0XvA9oMOQbmUwFjRHr0YfCloKX2pGHNfMQndmjG6D/zdPCdyBuRSTsSTK3DuLda0uhHRc7WKf1apWvxqDSMBqtaCO9F/a/hccVfmax8iH1QCkROm50TnL3iBLGJ5IyDWpyq784E+BX8X3c4j8xNVDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707178520; c=relaxed/simple;
	bh=iHNX5Q4fWE69bLGBr72cn7MeNCR4yW0t9JfsUouRZBc=;
	h=Date:To:From:Subject:Message-Id; b=YRypFzKa4fyYPoz3GU/etFAFSXaBt2zo2Njj/TChWPT3Skm4RrAmA2lj8vqy/2DY7HbeIcFjcHUpAhdZ0VcD/Fi+r7/t+6TXgxpOAA/LF1blXItW2hpTPP/+UX+B8VT+Pd7wq4BpONPECvwzKC8ZJ2t+y1DWkHiewMnR9wEe+XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OxC04PZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OxC04PZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C330DC433F1;
	Tue,  6 Feb 2024 00:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707178519;
	bh=iHNX5Q4fWE69bLGBr72cn7MeNCR4yW0t9JfsUouRZBc=;
	h=Date:To:From:Subject:From;
	b=OxC04PZTHfUfOLkfClwY/98WrkROWkYbWSFEcoQ4WvoX+mdZrve32lpNnmpy1Etau
	 2eHos9JOB+sWHqLlhO2XgHxrdXnlCCX4JNMi8Y8FoRlAI3Jp/eimirotGwigoLzSYs
	 crsWxlIJHRE1hqHUnLNnkszbxS3USF3IGGa9M8cw=
Date: Mon, 05 Feb 2024 16:15:19 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-add-more-comments-in-shrink_memcg_cb.patch added to mm-unstable branch
Message-Id: <20240206001519.C330DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: add more comments in shrink_memcg_cb()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-add-more-comments-in-shrink_memcg_cb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-add-more-comments-in-shrink_memcg_cb.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: add more comments in shrink_memcg_cb()
Date: Sun, 04 Feb 2024 03:05:59 +0000

Patch series "mm/zswap: optimize zswap lru list", v2.

This series is motivated when observe the zswap lru list shrinking, noted
there are some unexpected cases in zswap_writeback_entry().

bpftrace -e 'kr:zswap_writeback_entry {@[(int32)retval]=count()}'

There are some -ENOMEM because when the swap entry is freed to per-cpu
swap pool, it doesn't invalidate/drop zswap entry.  Then the shrinker
encounter these trashy zswap entries, it can't be reclaimed and return
-ENOMEM.

So move the invalidation ahead to when swap entry freed to the per-cpu
swap pool, since there is no any benefit to leave trashy zswap entries on
the zswap tree and lru list.

Another case is -EEXIST, which is seen more in the case of
!zswap_exclusive_loads_enabled, in which case the swapin folio will leave
compressed copy on the tree and lru list.  And it can't be reclaimed until
the folio is removed from swapcache.

Changing to zswap_exclusive_loads_enabled mode will invalidate when folio
swapin, which has its own drawback if that folio is still clean in
swapcache and swapout again, we need to compress it again.  Please see the
commit for details on why we choose exclusive load as the default for
zswap.

Another optimization for -EEXIST is that we add LRU_STOP to support
terminating the shrinking process to avoid evicting warmer region.

Testing using kernel build in tmpfs, one 50GB swapfile and
zswap shrinker_enabled, with memory.max set to 2GB.

                mm-unstable   zswap-optimize
real               63.90s       63.25s
user             1064.05s     1063.40s
sys               292.32s      270.94s

The main optimization is in sys cpu, about 7% improvement.


This patch (of 6):

Add more comments in shrink_memcg_cb() to describe the deref dance which
is implemented to fix race problem between lru writeback and swapoff, and
the reason why we rotate the entry at the beginning.

Also fix the stale comments in zswap_writeback_entry(), and add more
comments to state that we only deref the tree after we get the swapcache
reference.

Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-0-99d4084260a0@bytedance.com
Link: https://lkml.kernel.org/r/20240201-b4-zswap-invalidate-entry-v2-1-99d4084260a0@bytedance.com
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Suggested-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

--- a/mm/zswap.c~mm-zswap-add-more-comments-in-shrink_memcg_cb
+++ a/mm/zswap.c
@@ -1207,10 +1207,12 @@ static int zswap_writeback_entry(struct
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-	 * concurrent swapping to and from the slot. Verify that the
-	 * swap entry hasn't been invalidated and recycled behind our
-	 * backs (our zswap_entry reference doesn't prevent that), to
-	 * avoid overwriting a new swap folio with old compressed data.
+	 * concurrent swapping to and from the slot, and concurrent
+	 * swapoff so we can safely dereference the zswap tree here.
+	 * Verify that the swap entry hasn't been invalidated and recycled
+	 * behind our backs, to avoid overwriting a new swap folio with
+	 * old compressed data. Only when this is successful can the entry
+	 * be dereferenced.
 	 */
 	tree = swap_zswap_tree(swpentry);
 	spin_lock(&tree->lock);
@@ -1263,22 +1265,29 @@ static enum lru_status shrink_memcg_cb(s
 	int writeback_result;
 
 	/*
-	 * Rotate the entry to the tail before unlocking the LRU,
-	 * so that in case of an invalidation race concurrent
-	 * reclaimers don't waste their time on it.
+	 * As soon as we drop the LRU lock, the entry can be freed by
+	 * a concurrent invalidation. This means the following:
 	 *
-	 * If writeback succeeds, or failure is due to the entry
-	 * being invalidated by the swap subsystem, the invalidation
-	 * will unlink and free it.
+	 * 1. We extract the swp_entry_t to the stack, allowing
+	 *    zswap_writeback_entry() to pin the swap entry and
+	 *    then validate the zwap entry against that swap entry's
+	 *    tree using pointer value comparison. Only when that
+	 *    is successful can the entry be dereferenced.
 	 *
-	 * Temporary failures, where the same entry should be tried
-	 * again immediately, almost never happen for this shrinker.
-	 * We don't do any trylocking; -ENOMEM comes closest,
-	 * but that's extremely rare and doesn't happen spuriously
-	 * either. Don't bother distinguishing this case.
+	 * 2. Usually, objects are taken off the LRU for reclaim. In
+	 *    this case this isn't possible, because if reclaim fails
+	 *    for whatever reason, we have no means of knowing if the
+	 *    entry is alive to put it back on the LRU.
 	 *
-	 * But since they do exist in theory, the entry cannot just
-	 * be unlinked, or we could leak it. Hence, rotate.
+	 *    So rotate it before dropping the lock. If the entry is
+	 *    written back or invalidated, the free path will unlink
+	 *    it. For failures, rotation is the right thing as well.
+	 *
+	 *    Temporary failures, where the same entry should be tried
+	 *    again immediately, almost never happen for this shrinker.
+	 *    We don't do any trylocking; -ENOMEM comes closest,
+	 *    but that's extremely rare and doesn't happen spuriously
+	 *    either. Don't bother distinguishing this case.
 	 */
 	list_move_tail(item, &l->list);
 
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch
mm-zswap-add-more-comments-in-shrink_memcg_cb.patch
mm-zswap-invalidate-zswap-entry-when-swap-entry-free.patch
mm-zswap-stop-lru-list-shrinking-when-encounter-warm-region.patch
mm-zswap-remove-duplicate_entry-debug-value.patch
mm-zswap-only-support-zswap_exclusive_loads_enabled.patch
mm-zswap-zswap-entry-doesnt-need-refcount-anymore.patch

