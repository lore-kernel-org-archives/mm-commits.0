From: akpm@linux-foundation.org
Subject: + writeback-fix-break-condition.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:21:47 -0800
Message-ID: <200902092321.n19NLlJJ003628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbZBIXWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fedux@lugmen.org.ar, Artem.Bityutskiy@nokia.com, npiggin@suse.de


The patch titled
     writeback: fix break condition
has been added to the -mm tree.  Its filename is
     writeback-fix-break-condition.patch

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
Subject: writeback: fix break condition
From: Federico Cuello <fedux@lugmen.org.ar>

Commit dcf6a79dda5cc2a2bec183e50d829030c0972aaa ("write-back: fix
nr_to_write counter") fixed nr_to_write counter, but didn't set the break
condition properly.

If nr_to_write == 0 after being decremented it will loop one more time
before setting done = 1 and breaking the loop.

Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN mm/page-writeback.c~writeback-fix-break-condition mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-fix-break-condition
+++ a/mm/page-writeback.c
@@ -1051,20 +1051,21 @@ continue_unlock:
 				}
  			}
 
-			if (nr_to_write > 0)
+			if (nr_to_write > 0) {
 				nr_to_write--;
-			else if (wbc->sync_mode == WB_SYNC_NONE) {
-				/*
-				 * We stop writing back only if we are not
-				 * doing integrity sync. In case of integrity
-				 * sync we have to keep going because someone
-				 * may be concurrently dirtying pages, and we
-				 * might have synced a lot of newly appeared
-				 * dirty pages, but have not synced all of the
-				 * old dirty pages.
-				 */
-				done = 1;
-				break;
+				if (nr_to_write == 0 && wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are not
+					 * doing integrity sync. In case of integrity
+					 * sync we have to keep going because someone
+					 * may be concurrently dirtying pages, and we
+					 * might have synced a lot of newly appeared
+					 * dirty pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
 			}
 
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
_

Patches currently in -mm which might be from fedux@lugmen.org.ar are

writeback-fix-break-condition.patch

