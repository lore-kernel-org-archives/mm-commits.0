From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch removed from
 -mm tree
Date: Mon, 20 Nov 2017 13:22:46 -0800
Message-ID: <20171120212246.tTdl1MJ26%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752816AbdKTVWr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:22:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, vbabka@suse.cz


The patch titled
     Subject: mm, compaction: kcompactd should not ignore pageblock skip
has been removed from the -mm tree.  Its filename was
     mm-compaction-kcompactd-should-not-ignore-pageblock-skip.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: kcompactd should not ignore pageblock skip

Kcompactd is needlessly ignoring pageblock skip information.  It is doing
MIGRATE_SYNC_LIGHT compaction, which is no more powerful than MIGRATE_SYNC
compaction.

If compaction recently failed to isolate memory from a set of pageblocks,
there is nothing to indicate that kcompactd will be able to do so, or that
it is beneficial from attempting to isolate memory.

Use the pageblock skip hint to avoid rescanning pageblocks needlessly
until that information is reset.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1708151638550.106658@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-kcompactd-should-not-ignore-pageblock-skip mm/compaction.c
--- a/mm/compaction.c~mm-compaction-kcompactd-should-not-ignore-pageblock-skip
+++ a/mm/compaction.c
@@ -1928,9 +1928,8 @@ static void kcompactd_do_work(pg_data_t
 		.total_free_scanned = 0,
 		.classzone_idx = pgdat->kcompactd_classzone_idx,
 		.mode = MIGRATE_SYNC_LIGHT,
-		.ignore_skip_hint = true,
+		.ignore_skip_hint = false,
 		.gfp_mask = GFP_KERNEL,
