Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76717BCE
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728772397; cv=none; b=iBCLNYIUpL9CIW2hoUkkxxzw82CY82QZhbUj/q1mtMv/ghU9Dx39F6bTECzvp+7bA1ysS3kcowAtoqBs9SFylKcX5l9Oc7fkYpDOr/eFsyuo6hSH7cPl6Im3HP8q5VbTtxOUuNYAsWHxvrrmhYGZOrlivxfqlLi80OJIoUXGtHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728772397; c=relaxed/simple;
	bh=OMvZYJd6QDLXHA+y7nf4yCk/AZahCiLwnqxGE8xdVKY=;
	h=Date:To:From:Subject:Message-Id; b=t3pD13/kJ8D7twAA53lrFHRRbpy+ddIyCbF3PiudyjSltX9aXmBzk0P1YdDN8xumn9tJkAdeYPuVZxi+9MuDcyuAlS/ZEpP6CBma9Dwu6W3ulFcmrvkomib4E1DzfdB+lh/JMxddGNCJ1q8SQ3SBVL5fKLULPBEDAlVW5Tx7cT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QwmzyUlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QwmzyUlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02D3C4CEC6;
	Sat, 12 Oct 2024 22:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728772396;
	bh=OMvZYJd6QDLXHA+y7nf4yCk/AZahCiLwnqxGE8xdVKY=;
	h=Date:To:From:Subject:From;
	b=QwmzyUlO8739NeHkUyRFzeUUaXUJY3gPz1gfDc7OVMe/VmTDhmVt5AKdwoHutqrf3
	 7ro49jNZxn2ZjiP3mA3g4GKV26Qyidx/gvhuHrPxf0EDclbu/TbSVi5TOtw8hIH8aF
	 bJ1E8rXw/deuZYlavh1EnqvhVkIBIeV4bFYpGuZE=
Date: Sat, 12 Oct 2024 15:33:15 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,minchan@kernel.org,kaleshsingh@google.com,jaewon31.kim@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-add-a-vmscan-event-for-reclaim_pages.patch added to mm-unstable branch
Message-Id: <20241012223315.E02D3C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmscan: add a vmscan event for reclaim_pages
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-add-a-vmscan-event-for-reclaim_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscan-add-a-vmscan-event-for-reclaim_pages.patch

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
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: vmscan: add a vmscan event for reclaim_pages
Date: Fri, 11 Oct 2024 21:49:28 +0900

reclaim_folio_list() uses a dummy reclaim_stat and is not being used.  To
know the memory stat, add a new trace event.  This is useful how how many
pages are not reclaimed or why.

This is an example.
mm_vmscan_reclaim_pages: nid=0 nr_scanned=112 nr_reclaimed=112 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=0 nr_unmap_fail=0

Currenlty reclaim_folio_list is only called by reclaim_pages, and
reclaim_pages is used by damon and madvise.  In the latest Android,
reclaim_pages is also used by shmem to reclaim all pages in a
address_space.

Link: https://lkml.kernel.org/r/20241011124928.1224813-1-jaewon31.kim@samsung.com
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   45 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |   16 +++++++----
 2 files changed, 56 insertions(+), 5 deletions(-)

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
@@ -2126,9 +2126,10 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
+				      unsigned int nr_scanned,
 				      struct pglist_data *pgdat)
 {
-	struct reclaim_stat dummy_stat;
+	struct reclaim_stat stat;
 	unsigned int nr_reclaimed;
 	struct folio *folio;
 	struct scan_control sc = {
@@ -2139,12 +2140,13 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, true);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &stat, true);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, nr_scanned, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
@@ -2152,6 +2154,7 @@ static unsigned int reclaim_folio_list(s
 unsigned long reclaim_pages(struct list_head *folio_list)
 {
 	int nid;
+	unsigned int nr_scanned = 0;
 	unsigned int nr_reclaimed = 0;
 	LIST_HEAD(node_folio_list);
 	unsigned int noreclaim_flag;
@@ -2168,15 +2171,18 @@ unsigned long reclaim_pages(struct list_
 		if (nid == folio_nid(folio)) {
 			folio_clear_active(folio);
 			list_move(&folio->lru, &node_folio_list);
+			nr_scanned += folio_nr_pages(folio);
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
+						   NODE_DATA(nid));
+		nr_scanned = 0;
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
-
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, nr_scanned,
+					   NODE_DATA(nid));
 	memalloc_noreclaim_restore(noreclaim_flag);
 
 	return nr_reclaimed;
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

vmscan-add-a-vmscan-event-for-reclaim_pages.patch

