From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch added
 to -mm tree
Date: Fri, 19 Aug 2016 12:50:50 -0700
Message-ID: <57b7631a.DcGZXfhpjDe6iwbl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41603 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbcHSTuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2016 15:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-add-the-ultimate-direct-compaction-priority-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch

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
Subject: mm-compaction-add-the-ultimate-direct-compaction-priority-fix

Use the MIN_COMPACT_PRIORITY alias instead of COMPACT_PRIO_SYNC_FULL to
disable heuristics "because this would be easier to follow and it would be
easier for future changes", per Michal.

Link: http://lkml.kernel.org/r/d443b884-87e7-1c93-8684-3a3a35759fb1@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-add-the-ultimate-direct-compaction-priority-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-the-ultimate-direct-compaction-priority-fix
+++ a/mm/compaction.c
@@ -1644,8 +1644,8 @@ static enum compact_result compact_zone_
 		.alloc_flags = alloc_flags,
 		.classzone_idx = classzone_idx,
 		.direct_compaction = true,
-		.whole_zone = (prio == COMPACT_PRIO_SYNC_FULL),
-		.ignore_skip_hint = (prio == COMPACT_PRIO_SYNC_FULL)
+		.whole_zone = (prio == MIN_COMPACT_PRIORITY),
+		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY)
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1691,7 +1691,7 @@ enum compact_result try_to_compact_pages
 								ac->nodemask) {
 		enum compact_result status;
 
-		if (prio > COMPACT_PRIO_SYNC_FULL
+		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-create-compact_gap-wrapper-fix.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

