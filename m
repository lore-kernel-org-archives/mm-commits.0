From: akpm@linux-foundation.org
Subject: + mm-compaction-defer-only-on-compact_complete.patch added to -mm tree
Date: Wed, 15 Oct 2014 13:50:08 -0700
Message-ID: <543ede00.AqG0DV72nXG2idyW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaJOUuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 16:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: defer only on COMPACT_COMPLETE
has been added to the -mm tree.  Its filename is
     mm-compaction-defer-only-on-compact_complete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-defer-only-on-compact_complete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-defer-only-on-compact_complete.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-defer-only-on-compact_complete mm/compaction.c
--- a/mm/compaction.c~mm-compaction-defer-only-on-compact_complete
+++ a/mm/compaction.c
@@ -1343,7 +1343,7 @@ unsigned long try_to_compact_pages(struc
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
mm-compaction-avoid-premature-range-skip-in-isolate_migratepages_range.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch

