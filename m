From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-defer-only-on-compact_complete.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:40 -0800
Message-ID: <5489e8e8.+jvUgrqOq9eq5K2p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbaLKS4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: defer only on COMPACT_COMPLETE
has been removed from the -mm tree.  Its filename was
     mm-compaction-defer-only-on-compact_complete.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: defer only on COMPACT_COMPLETE

Deferred compaction is employed to avoid compacting zone where sync direct
compaction has recently failed.  As such, it makes sense to only defer
when a full zone was scanned, which is when compact_zone returns with
COMPACT_COMPLETE.  It's less useful to defer when compact_zone returns
with apparent success (COMPACT_PARTIAL), followed by a watermark check
failure, which can happen due to parallel allocation activity.  It also
does not make much sense to defer compaction which was completely skipped
(COMPACT_SKIP) for being unsuitable in the first place.

This patch therefore makes deferred compaction trigger only when
COMPACT_COMPLETE is returned from compact_zone().  Results of
stress-highalloc becnmark show the difference is within measurement error,
so the issue is rather cosmetic.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-defer-only-on-compact_complete mm/compaction.c
--- a/mm/compaction.c~mm-compaction-defer-only-on-compact_complete
+++ a/mm/compaction.c
@@ -1362,7 +1362,7 @@ unsigned long try_to_compact_pages(struc
 			goto break_loop;
 		}
 
-		if (mode != MIGRATE_ASYNC) {
+		if (mode != MIGRATE_ASYNC && status == COMPACT_COMPLETE) {
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch

