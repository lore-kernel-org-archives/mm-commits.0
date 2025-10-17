Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BDB23816A
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 22:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760739263; cv=none; b=cdFdj1V60DTMUDF0+kixVb30MkUir5V5FZ31+UPvI3px8ODrnbjcu+DIw8ZMOnMsjTUqDcN3R6T9ru2owe9f5hW96eZwNZTgI8bDgVUw+46FcJzZADkEotwojcEwQhkGh1q5wCohqxefmgYxhMAl9osM1b2lGEnrme59+WJ1Dck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760739263; c=relaxed/simple;
	bh=Sk2YyN0J7xVLtAVuUSlXkHvMyfwdDsrfFXzo8VOopPI=;
	h=Date:To:From:Subject:Message-Id; b=S+o+YoPWcjOwZYQPsn0NuN66oTEAZoR3dj3cRHV1joL9NMKEzGlbSdZJH2vhg+AqhyIqbyrgGM9H90qzfZCrY8YiYkfLtVmQMAGMSvijw6NuLxkcO8GALP5jIOckM6swrCHVXGWAfzhWEOwD/Qobk/LhYp7wSEz3fVCsQuNgdQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aEEqJUPa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aEEqJUPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBA9C4CEE7;
	Fri, 17 Oct 2025 22:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760739260;
	bh=Sk2YyN0J7xVLtAVuUSlXkHvMyfwdDsrfFXzo8VOopPI=;
	h=Date:To:From:Subject:From;
	b=aEEqJUPaBlMGNTpMYoiTERi4uLcNhSHhNtWRiWyEEyCfCencAECkYQx6U+pWw1Mdv
	 TMGUo8Ase8/bqmFY8w8wmAubk+TJfB8dvIwgfgubhrhJqM4E+/FuAQvUA6oR3gZBCh
	 bjcqdWzh+t/vL7PVSt3+O/xo2Cy2uWRoMrMUtyAc=
Date: Fri, 17 Oct 2025 15:14:20 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch added to mm-new branch
Message-Id: <20251017221420.ADBA9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: simplify the logic for activating dirty file folios
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
@@ -1387,21 +1387,7 @@ retry:
 
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
@@ -1410,7 +1396,8 @@ retry:
 				 */
 				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
 						nr_pages);
-				folio_set_reclaim(folio);
+				if (!folio_test_reclaim(folio))
+					folio_set_reclaim(folio);
 
 				goto activate_locked;
 			}
@@ -6105,11 +6092,6 @@ again:
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
@@ -6850,7 +6832,6 @@ static void clear_pgdat_congested(pg_dat
 
 	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
 	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
-	clear_bit(PGDAT_DIRTY, &pgdat->flags);
 	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch
mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch
mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

