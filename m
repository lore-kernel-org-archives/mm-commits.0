From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch
 added to -mm tree
Date: Thu, 02 Feb 2017 14:48:23 -0800
Message-ID: <5893b737.fMIAC3ob1iyTAY60%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdBBWsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:48:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move dirty pages out of the way until they're flushed fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmscan-kick-flushers-when-we-encounter-dirty-pages-on-the-lru-fix.patch
mm-vmscan-remove-old-flusher-wakeup-from-direct-reclaim-path.patch
mm-vmscan-only-write-dirty-pages-that-the-scanner-has-seen-twice.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed.patch
mm-vmscan-move-dirty-pages-out-of-the-way-until-theyre-flushed-fix.patch

