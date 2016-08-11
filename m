From: akpm@linux-foundation.org
Subject: +
 mm-compaction-more-reliably-increase-direct-compaction-priority.patch added to -mm tree
Date: Thu, 11 Aug 2016 14:29:51 -0700
Message-ID: <57acee4f.Oc/8exYor+e5d53x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbcHKV3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: more reliably increase direct compaction priority
has been added to the -mm tree.  Its filename is
     mm-compaction-more-reliably-increase-direct-compaction-priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-more-reliably-increase-direct-compaction-priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-more-reliably-increase-direct-compaction-priority.patch

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
Subject: mm, compaction: more reliably increase direct compaction priority

During reclaim/compaction loop, compaction priority can be increased by
the should_compact_retry() function, but the current code is not optimal. 
Priority is only increased when compaction_failed() is true, which means
that compaction has scanned the whole zone.  This may not happen even
after multiple attempts with a lower priority due to parallel activity, so
we might needlessly struggle on the lower priorities and possibly run out
of compaction retry attempts in the process.

After this patch we are guaranteed at least one attempt at the highest
compaction priority even if we exhaust all retries at the lower
priorities.

Link: http://lkml.kernel.org/r/20160810091226.6709-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-more-reliably-increase-direct-compaction-priority
+++ a/mm/page_alloc.c
@@ -3153,13 +3153,8 @@ should_compact_retry(struct alloc_contex
 	 * so it doesn't really make much sense to retry except when the
 	 * failure could be caused by insufficient priority
 	 */
-	if (compaction_failed(compact_result)) {
-		if (*compact_priority > MIN_COMPACT_PRIORITY) {
-			(*compact_priority)--;
-			return true;
-		}
-		return false;
-	}
+	if (compaction_failed(compact_result))
+		goto check_priority;
 
 	/*
 	 * make sure the compaction wasn't deferred or didn't bail out early
@@ -3183,6 +3178,15 @@ should_compact_retry(struct alloc_contex
 	if (compaction_retries <= max_retries)
 		return true;
 
+	/*
+	 * Make sure there is at least one attempt at the highest priority
+	 * if we exhausted all retries at the lower priorities
+	 */
+check_priority:
+	if (*compact_priority > MIN_COMPACT_PRIORITY) {
+		(*compact_priority)--;
+		return true;
+	}
 	return false;
 }
 #else
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

