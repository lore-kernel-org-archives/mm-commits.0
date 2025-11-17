Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38DA222584
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343153; cv=none; b=HnIEot4C5MNz4JHy7Lk8Bqd0T6OqkImaepIJDUHBgGulN+M7PrajW3f+IxgleuS2iooaYXSyty/UfAmN+1MDQT8qnmHfNHeEOz9xnvcGZMDzx+M34Ymahl79843iD90IMyKhnr5Oo5md0JKoCDOFOGCgsxHPPCpIa273gCJYQ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343153; c=relaxed/simple;
	bh=/XuD3hP1eZJkvLZdkw8LCJNZpetGo6x2Ssk1OH5CFf0=;
	h=Date:To:From:Subject:Message-Id; b=WTFXKmEU0xhP6rEKCgEQJUaem3Q3mabcUNoFcMYlDM9T+1oQRFJZM130nuPx0ogPUdNZWEp8FcTztTsTFftTDWPhniD9i1Gm8RMumdQVW75VPTlQ/zYLlIhSqDZL3Y7D+lhas962dOqpPMgvj1P0rOpqE5Gkv1uLaAltHE8Q/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TpepTCK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TpepTCK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB06C113D0;
	Mon, 17 Nov 2025 01:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343152;
	bh=/XuD3hP1eZJkvLZdkw8LCJNZpetGo6x2Ssk1OH5CFf0=;
	h=Date:To:From:Subject:From;
	b=TpepTCK24xq2dphh3rQysUpkxk/BqdO7mZsu+GnCKawiiVggpvRTHtyFs/UnJioBr
	 +gixmv3S0NuJOj9n9oiXnqc8o9fl6CSJDkf3bN3jGkHRK7b3qBCK4lHyZpCwcDKbS3
	 eRXWQokN9lp+hmXdy6QdYVAzeDh8DW1V8HmbF4hI=
Date: Sun, 16 Nov 2025 17:32:32 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch removed from -mm tree
Message-Id: <20251117013232.CAB06C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: simplify the logic for activating dirty file folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: simplify the logic for activating dirty file folios
Date: Fri, 17 Oct 2025 15:53:07 +0800

After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
attempt to write back filesystem folios through reclaim.

However, in the shrink_folio_list() function, there still remains some
logic related to writeback control of dirty file folios.  The original
logic was that, for direct reclaim, or when folio_test_reclaim() is false,
or the PGDAT_DIRTY flag is not set, the dirty file folios would be
directly activated to avoid being scanned again; otherwise, it will try to
writeback the dirty file folios.  However, since we can no longer perform
writeback on dirty folios, the dirty file folios will still be activated.

Additionally, under the original logic, if we continue to try writeback
dirty file folios, we will also check the references flag,
sc->may_writepage, and may_enter_fs(), which may result in dirty file
folios being left in the inactive list.  This is unreasonable.  Even if
these dirty folios are scanned again, we still cannot clean them.

Therefore, the checks on these dirty file folios appear to be redundant
and can be removed.  Dirty file folios should be directly moved to the
active list to avoid being scanned again.  Since we set the PG_reclaim
flag for the dirty folios, once the writeback is completed, they will be
moved back to the tail of the inactive list to be retried for quick
reclaim.

Link: https://lkml.kernel.org/r/ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ----
 mm/vmscan.c            |   25 +++----------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios
+++ a/include/linux/mmzone.h
@@ -1060,10 +1060,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
-	PGDAT_DIRTY,			/* reclaim scanning has recently found
-					 * many dirty file pages at the tail
-					 * of the LRU.
-					 */
 	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
 					 * many pages under writeback
 					 */
--- a/mm/vmscan.c~mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios
+++ a/mm/vmscan.c
@@ -1409,21 +1409,7 @@ retry:
 
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
-			/*
-			 * Only kswapd can writeback filesystem folios
-			 * to avoid risk of stack overflow. But avoid
-			 * injecting inefficient single-folio I/O into
-			 * flusher writeback as much as possible: only
-			 * write folios when we've encountered many
-			 * dirty folios, and when we've already scanned
-			 * the rest of the LRU for clean folios and see
-			 * the same dirty folios again (with the reclaim
-			 * flag set).
-			 */
-			if (folio_is_file_lru(folio) &&
-			    (!current_is_kswapd() ||
-			     !folio_test_reclaim(folio) ||
-			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
+			if (folio_is_file_lru(folio)) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principle to folio_deactivate()
@@ -1432,7 +1418,8 @@ retry:
 				 */
 				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
 						nr_pages);
-				folio_set_reclaim(folio);
+				if (!folio_test_reclaim(folio))
+					folio_set_reclaim(folio);
 
 				goto activate_locked;
 			}
@@ -6127,11 +6114,6 @@ again:
 		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
 			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
-		/* Allow kswapd to start writing pages during reclaim.*/
-		if (sc->nr.unqueued_dirty &&
-			sc->nr.unqueued_dirty == sc->nr.file_taken)
-			set_bit(PGDAT_DIRTY, &pgdat->flags);
-
 		/*
 		 * If kswapd scans pages marked for immediate
 		 * reclaim and under writeback (nr_immediate), it
@@ -6872,7 +6854,6 @@ static void clear_pgdat_congested(pg_dat
 
 	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
 	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
-	clear_bit(PGDAT_DIRTY, &pgdat->flags);
 	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

