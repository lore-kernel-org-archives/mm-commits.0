From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:34:59 -0700
Message-ID: <573f9f23.dnsU5neDuNwKeqrL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcETXfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix
has been removed from the -mm tree.  Its filename was
     mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch

This patch was dropped because it was folded into mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix

fix it for Mel's mm-page_alloc-remove-field-from-alloc_context.patch

Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix mm/compaction.c
--- a/mm/compaction.c~mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix
+++ a/mm/compaction.c
@@ -1403,7 +1403,7 @@ bool compaction_zonelist_suitable(struct
 		available = zone_reclaimable_pages(zone) / order;
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 		compact_result = __compaction_suitable(zone, order, alloc_flags,
-				ac->classzone_idx, available);
+				ac_classzone_idx(ac), available);
 		if (compact_result != COMPACT_SKIPPED &&
 				compact_result != COMPACT_NOT_SUITABLE_ZONE)
 			return true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch
mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

