From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch
 removed from -mm tree
Date: Fri, 24 Feb 2017 14:27:51 -0800
Message-ID: <58b0b367.+JKqR8NRNKnzmOeB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXW1w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move dirty pages out of the way until they're flushed fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch

This patch was dropped because it was folded into mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: move dirty pages out of the way until they're flushed fix

Mention the trade-off between waiting for writeback and potentially
causing hot cache refaults in the code where we make this decisions
and activate writeback pages.

Link: http://lkml.kernel.org/r/20170202191957.22872-8-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix
+++ a/mm/vmscan.c
@@ -1056,6 +1056,15 @@ static unsigned long shrink_page_list(st
 		 *    throttling so we could easily OOM just because too many
 		 *    pages are in writeback and there is nothing else to
 		 *    reclaim. Wait for the writeback to complete.
+		 *
+		 * In cases 1) and 2) we activate the pages to get them out of
+		 * the way while we continue scanning for clean pages on the
+		 * inactive list and refilling from the active list. The
+		 * observation here is that waiting for disk writes is more
+		 * expensive than potentially causing reloads down the line.
+		 * Since they're marked for immediate reclaim, they won't put
+		 * memory pressure on the cache working set any longer than it
+		 * takes to write them to disk.
 		 */
 		if (PageWriteback(page)) {
 			/* Case 1 above */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-vmscan-scan-dirty-pages-even-in-laptop-mode.patch
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch

