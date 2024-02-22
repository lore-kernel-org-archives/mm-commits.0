Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A7E1754E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560194; cv=none; b=d8iWnMy2L9YrKgBk7R7MnptMaLNGGTa03lCrIIEKZk8rg9ata2T4mT/oEWbyIN41cpamY/v1qeKzniUaGXpeLLBcL8ihLbZwek7Nnb0Kz1/MTnG3/sU6ccJwn4EctrwK9cfrhGZdXQEXxTfrvF5DO8mSDqWW+leilhbahJPj/vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560194; c=relaxed/simple;
	bh=QNBzRb2ffL6LHVrp4N9qD1313fVMXXFBDU+zuPB2fz0=;
	h=Date:To:From:Subject:Message-Id; b=L++zTCqapGB8rmndyAq5ktlyeTduUt9Gxn39ScXf0h/w2A+wPySTHOoFLGaFUWtdXDAnTeMognFyPUbZaHd3W8Dv4gqUJjKIVPwC7yx7HftxtQbuYhDn0JPO8G4YH89Joer2MZQYARpDKbDHtnz/lJkkcgyOrIVog9wvFJnBwKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lf70+3mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lf70+3mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171FDC433C7;
	Thu, 22 Feb 2024 00:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560194;
	bh=QNBzRb2ffL6LHVrp4N9qD1313fVMXXFBDU+zuPB2fz0=;
	h=Date:To:From:Subject:From;
	b=Lf70+3mr8pIHoTz/VkTqpMPNHR5o+fCs7rme0EDae/uxlRhqZJa8LyoWzD3E9/SPH
	 tZ8hn8autIQklmoarTWCDfBAQCHHjiVUV8IYFsb93WP+WgBQVK/kpPKKgbCkPXvWv/
	 kPdNDYYUbltqBC5QwPBmhtdYPC5lIibe0+zRIN6I=
Date: Wed, 21 Feb 2024 16:03:13 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-add-more-comments-in-shrink_memcg_cb.patch removed from -mm tree
Message-Id: <20240222000314.171FDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: add more comments in shrink_memcg_cb()
has been removed from the -mm tree.  Its filename was
     mm-zswap-add-more-comments-in-shrink_memcg_cb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-zsmalloc-fix-migrate_write_lock-when-config_compaction.patch
mm-zsmalloc-remove-migrate_write_lock_nested.patch
mm-zsmalloc-remove-unused-zspage-isolated.patch
mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-remove-set_zspage_mapping.patch
mm-zsmalloc-remove_zspage-dont-need-fullness-parameter.patch
mm-zsmalloc-remove-get_zspage_mapping.patch
maintainers-add-chengming-zhou-as-a-zswap-reviewer.patch

