From: akpm@linux-foundation.org
Subject: + writeback-fix-nr_to_write-counter.patch added to -mm tree
Date: Tue, 03 Feb 2009 14:38:20 -0800
Message-ID: <200902032238.n13McKFu020458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbZBCWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 17:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, npiggin@suse.de, shaggy@linux.vnet.ibm.com


The patch titled
     writeback: fix nr_to_write counter
has been added to the -mm tree.  Its filename is
     writeback-fix-nr_to_write-counter.patch

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
Subject: writeback: fix nr_to_write counter
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Commit 05fe478dd04e02fa230c305ab9b5616669821dd3 ("mm: write_cache_pages
integrity fix") introduced some @wbc->nr_to_write breakage.  Here is the
change from the commit:

>--- a/mm/page-writeback.c
>+++ b/mm/page-writeback.c
>@@ -963,8 +963,10 @@ retry:
>                               }
>                       }
>
>                       if (--nr_to_write <= 0)
>                               done = 1;
>                       if (wbc->sync_mode == WB_SYNC_NONE) {
>                               if (--wbc->nr_to_write <= 0)
>                                       done = 1;
>                       }
>                       if (wbc->nonblocking && bdi_write_congested(bdi)) {
>                               wbc->encountered_congestion = 1;
>                               done = 1
>                       }

It made the following changes:

1. Decrement wbc->nr_to_write instead of nr_to_write

2. Decrement wbc->nr_to_write _only_ if wbc->sync_mode == WB_SYNC_NONE

3. If synced nr_to_write pages, stop only if if wbc->sync_mode ==
   WB_SYNC_NONE, otherwise keep going.

However, according to the commit message, the intention was to only make
change 3.  Change 1 is a bug.  Change 2 does not seem to be necessary, and
it breaks UBIFS expectations, so if needed, it should be done separately
later.  And change 2 does not seem to be documented in the commit message.

This patch does the following:

1. Undo changes 1 and 2

2.  Add a comment explaining change 3 (it very useful to have comments
   in _code_, not only in the commit).

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN mm/page-writeback.c~writeback-fix-nr_to_write-counter mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-fix-nr_to_write-counter
+++ a/mm/page-writeback.c
@@ -1051,13 +1051,22 @@ continue_unlock:
 				}
  			}
 
-			if (wbc->sync_mode == WB_SYNC_NONE) {
-				wbc->nr_to_write--;
-				if (wbc->nr_to_write <= 0) {
-					done = 1;
-					break;
-				}
+			if (nr_to_write > 0)
+				nr_to_write--;
+			else if (wbc->sync_mode == WB_SYNC_NONE) {
+				/*
+				 * We stop writing back only if we are not
+				 * doing integrity sync. In case of integrity
+				 * sync we have to keep going because someone
+				 * may be concurrently dirtying pages, and we
+				 * might have synced a lot of newly appeared
+				 * dirty pages, but have not synced all of the
+				 * old dirty pages.
+				 */
+				done = 1;
+				break;
 			}
+
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
_

Patches currently in -mm which might be from Artem.Bityutskiy@nokia.com are

origin.patch
linux-next.patch
writeback-fix-nr_to_write-counter.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch

