From: akpm@linux-foundation.org
Subject: [merged] mmvmscan-only-evict-file-pages-when-we-have-plenty.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:17 -0800
Message-ID: <20121212195817.A4F4182004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:46865 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:18 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so117851ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,vmscan: only evict file pages when we have plenty
has been removed from the -mm tree.  Its filename was
     mmvmscan-only-evict-file-pages-when-we-have-plenty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm,vmscan: only evict file pages when we have plenty

If we have more inactive file pages than active file pages, we skip
scanning the active file pages altogether, with the idea that we do not
want to evict the working set when there is plenty of streaming IO in the
cache.

However, the code forgot to also skip scanning anonymous pages in that
situation.  That leads to the curious situation of keeping the active file
pages protected from being paged out when there are lots of inactive file
pages, while still scanning and evicting anonymous pages.

This patch fixes that situation, by only evicting file pages when we have
plenty of them and most are inactive.

[akpm@linux-foundation.org: adjust comment layout]
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~mmvmscan-only-evict-file-pages-when-we-have-plenty mm/vmscan.c
--- a/mm/vmscan.c~mmvmscan-only-evict-file-pages-when-we-have-plenty
+++ a/mm/vmscan.c
@@ -1679,13 +1679,24 @@ static void get_scan_count(struct lruvec
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
-		/* If we have very few page cache pages,
-		   force-scan anon pages. */
 		if (unlikely(file + free <= high_wmark_pages(zone))) {
+			/*
+			 * If we have very few page cache pages, force-scan
+			 * anon pages.
+			 */
 			fraction[0] = 1;
 			fraction[1] = 0;
 			denominator = 1;
 			goto out;
+		} else if (!inactive_file_is_low_global(zone)) {
+			/*
+			 * There is enough inactive page cache, do not
+			 * reclaim anything from the working set right now.
+			 */
+			fraction[0] = 0;
+			fraction[1] = 1;
+			denominator = 1;
+			goto out;
 		}
 	}
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-compaction-fix-compiler-warning.patch
mm-protect-against-concurrent-vma-expansion.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

