From: akpm@linux-foundation.org
Subject: [patch 05/94] mm, compaction: kcompactd should not ignore
 pageblock skip
Date: Fri, 17 Nov 2017 15:26:27 -0800
Message-ID: <20171117232627.KndiCbCR-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423240AbdKQX02 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:26:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

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
