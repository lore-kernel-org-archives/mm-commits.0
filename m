From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix.patch removed from -mm tree
Date: Thu, 20 Jan 2011 14:40:15 -0800
Message-ID: <201101202240.p0KMeFHe006761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753583Ab1ATWkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 17:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix.patch

This patch was dropped because it was folded into mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
From: Johannes Weiner <hannes@cmpxchg.org>

There is also the one in compact_finished(), here is an update:

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix-fix
+++ a/mm/compaction.c
@@ -406,6 +406,10 @@ static int compact_finished(struct zone 
 	if (!zone_watermark_ok(zone, cc->order, watermark, 0, 0))
 		return COMPACT_CONTINUE;
 
+	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
 	if (cc->order == -1)
 		return COMPACT_CONTINUE;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

thp-keep-highpte-mapped-until-it-is-no-longer-needed.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction.patch
memcg-modify-accounting-function-for-supporting-thp-better.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp-fix.patch
memcg-fix-lru-accounting-with-thp.patch
memcg-fix-rmdir-force_empty-with-thp.patch
memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch

