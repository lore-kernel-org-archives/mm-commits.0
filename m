From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 20 May 2016 16:35:30 -0700
Message-ID: <573f9f42.yx5pLGlwhyoNJO02%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbcETXfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes

WARNING: line over 80 characters
#49: FILE: mm/page_alloc.c:3327:
+	 * inside the allocator rather than hit the oom killer prematurely. Let's

ERROR: space required before the open parenthesis '('
#55: FILE: mm/page_alloc.c:3333:
+		if(zone_watermark_ok(zone, 0, min_wmark_pages(zone),

total: 1 errors, 1 warnings, 24 lines checked

./patches/mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more-for-config_compaction-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3325,13 +3325,13 @@ should_compact_retry(struct alloc_contex
 
 	/*
 	 * There are setups with compaction disabled which would prefer to loop
-	 * inside the allocator rather than hit the oom killer prematurely. Let's
-	 * give them a good hope and keep retrying while the order-0 watermarks
-	 * are OK.
+	 * inside the allocator rather than hit the oom killer prematurely.
+	 * Let's give them a good hope and keep retrying while the order-0
+	 * watermarks are OK.
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
 					ac->nodemask) {
-		if(zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+		if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
 					ac_classzone_idx(ac), alloc_flags))
 			return true;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-oom-protect-costly-allocations-some-more-for-config_compaction.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2-fix.patch
mm-compact-fix-zoneindex-in-compact-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
lib-gcd-use-binary-gcd-algorithm-instead-of-euclidean-fix.patch

