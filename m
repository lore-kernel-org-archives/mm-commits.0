From: akpm@linux-foundation.org
Subject: + vmstat-update-comment-regarding-stat_threshold.patch added to -mm tree
Date: Wed, 30 Mar 2011 13:56:18 -0700
Message-ID: <201103302056.p2UKuIoC008762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932252Ab1C3U5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 16:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux.com


The patch titled
     vmstat: update comment regarding stat_threshold
has been added to the -mm tree.  Its filename is
     vmstat-update-comment-regarding-stat_threshold.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: update comment regarding stat_threshold
From: Christoph Lameter <cl@linux.com>

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/vmstat.c~vmstat-update-comment-regarding-stat_threshold mm/vmstat.c
--- a/mm/vmstat.c~vmstat-update-comment-regarding-stat_threshold
+++ a/mm/vmstat.c
@@ -321,9 +321,12 @@ static inline void mod_state(struct zone
 		/*
 		 * The fetching of the stat_threshold is racy. We may apply
 		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the following
-		 * will apply the threshold again and therefore bring the
-		 * counter under the threshold.
+		 * rescheduled while executing here. However, the next
+		 * counter update will apply the threshold again and
+		 * therefore bring the counter under the threshold again.
+		 *
+		 * Most of the time the thresholds are the same anyways
+		 * for all cpus in a zone.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
 
_

Patches currently in -mm which might be from cl@linux.com are

mm-optimize-pfn-calculation-in-online_page.patch
linux-next.patch
mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch
vmstat-update-comment-regarding-stat_threshold.patch

