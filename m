Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FA7188938
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854802; cv=none; b=Bcueip8EUabxe0l2/BAwrpmXJuZtwITyE6gW6YO+9tHNlwMQvnX6PGq3Yu+a9LiKktplHEamo+VvOS/MI+LsKsuotmHtZRRKdy0rGU+g/PXOrc3qtfF41vUYXNXxQB833Jt8PxPE9fDYQaUm1Mhj0J9190VKrbpHgiL/feALJVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854802; c=relaxed/simple;
	bh=5gxhnr93741a53EdDU7o+HQ44nXV11cARRGGiyBMjGI=;
	h=Date:To:From:Subject:Message-Id; b=mtoedwb7ffn8hDkeL62+ERlvPLESQjt/c4noN/dyt0utirRXsvy3ZPSyjkQb2ITieSQ/TlLBSp5EEa0M9ROA+h9TwbOdQDGTor1nDo4elHwZ569ZRk0QHbOb2h5mkKG34JcNeWqRZ6BdfM/UMYWxWjo1KFmLHmcbv6O18LWAmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JGDJC7HL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JGDJC7HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5507EC4CECF;
	Wed,  6 Nov 2024 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854802;
	bh=5gxhnr93741a53EdDU7o+HQ44nXV11cARRGGiyBMjGI=;
	h=Date:To:From:Subject:From;
	b=JGDJC7HL5jNYyK+dZgA9S7XOL0Kl2DxUupU0KxrhZUw7O1YgPtNrLxhprkKDj8ODe
	 YDPQ1/MN+qwLw8go3fJd5W2QNI6UfpsUe14zbiPOvxef2DnVQm1v3L4SN/MtB4W7eF
	 vXLnTAQ5F4zZAbNK5HsNTO+xCCG38fdTKKg9D+ik=
Date: Tue, 05 Nov 2024 17:00:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,minchan@kernel.org,kaleshsingh@google.com,jaewon31.kim@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-add-a-vmscan-event-for-reclaim_pages.patch removed from -mm tree
Message-Id: <20241106010002.5507EC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmscan: add a vmscan event for reclaim_pages
has been removed from the -mm tree.  Its filename was
     vmscan-add-a-vmscan-event-for-reclaim_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan: add a vmscan event for reclaim_pages
Date: Fri, 11 Oct 2024 21:49:28 +0900

reclaim_folio_list uses a dummy reclaim_stat and is not being used.  To
know the memory stat, add a new trace event.  This is useful how how many
pages are not reclaimed or why.

This is an example:

mm_vmscan_reclaim_pages: nid=0 nr_scanned=112 nr_reclaimed=112 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0

Currently reclaim_folio_list is only called by reclaim_pages, and
reclaim_pages is used by damon and madvise.  In the latest Android,
reclaim_pages is also used by shmem to reclaim all pages in a
address_space.

[jaewon31.kim@samsung.com: use sc.nr_scanned rather than new counting]
  Link: https://lkml.kernel.org/r/20241016143227.961162-1-jaewon31.kim@samsung.com
Link: https://lkml.kernel.org/r/20241011124928.1224813-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   45 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |    5 ++-
 2 files changed, 48 insertions(+), 2 deletions(-)

--- a/include/trace/events/vmscan.h~vmscan-add-a-vmscan-event-for-reclaim_pages
+++ a/include/trace/events/vmscan.h
@@ -346,6 +346,51 @@ TRACE_EVENT(mm_vmscan_write_folio,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(mm_vmscan_reclaim_pages,
+
+	TP_PROTO(int nid,
+		unsigned long nr_scanned, unsigned long nr_reclaimed,
+		struct reclaim_stat *stat),
+
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_reclaimed)
+		__field(unsigned long, nr_dirty)
+		__field(unsigned long, nr_writeback)
+		__field(unsigned long, nr_congested)
+		__field(unsigned long, nr_immediate)
+		__field(unsigned int, nr_activate0)
+		__field(unsigned int, nr_activate1)
+		__field(unsigned long, nr_ref_keep)
+		__field(unsigned long, nr_unmap_fail)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_dirty = stat->nr_dirty;
+		__entry->nr_writeback = stat->nr_writeback;
+		__entry->nr_congested = stat->nr_congested;
+		__entry->nr_immediate = stat->nr_immediate;
+		__entry->nr_activate0 = stat->nr_activate[0];
+		__entry->nr_activate1 = stat->nr_activate[1];
+		__entry->nr_ref_keep = stat->nr_ref_keep;
+		__entry->nr_unmap_fail = stat->nr_unmap_fail;
+	),
+
+	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate_anon=%d nr_activate_file=%d nr_ref_keep=%ld nr_unmap_fail=%ld",
+		__entry->nid,
+		__entry->nr_scanned, __entry->nr_reclaimed,
+		__entry->nr_dirty, __entry->nr_writeback,
+		__entry->nr_congested, __entry->nr_immediate,
+		__entry->nr_activate0, __entry->nr_activate1,
+		__entry->nr_ref_keep, __entry->nr_unmap_fail)
+);
+
 TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
 	TP_PROTO(int nid,
--- a/mm/vmscan.c~vmscan-add-a-vmscan-event-for-reclaim_pages
+++ a/mm/vmscan.c
@@ -2129,7 +2129,7 @@ static void shrink_active_list(unsigned
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
 				      struct pglist_data *pgdat)
 {
-	struct reclaim_stat dummy_stat;
+	struct reclaim_stat stat;
 	unsigned int nr_reclaimed;
 	struct folio *folio;
 	struct scan_control sc = {
@@ -2140,12 +2140,13 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, true);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are


