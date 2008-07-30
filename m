From: akpm@linux-foundation.org
Subject: - madvise-update-function-comment-of-madvise_dontneed.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:06 -0700
Message-ID: <200807301915.m6UJF6l9010963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbYG3TP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     madvise: update function comment of madvise_dontneed
has been removed from the -mm tree.  Its filename was
     madvise-update-function-comment-of-madvise_dontneed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: madvise: update function comment of madvise_dontneed
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/madvise.c~madvise-update-function-comment-of-madvise_dontneed mm/madvise.c
--- a/mm/madvise.c~madvise-update-function-comment-of-madvise_dontneed
+++ a/mm/madvise.c
@@ -132,10 +132,10 @@ static long madvise_willneed(struct vm_a
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for refill_inactive to actually free
+ * zap_page_range call sets things up for shrink_active_list to actually free
  * these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
- * refill_inactive to pick up before reclaiming other pages.
+ * shrink_active_list to pick up before reclaiming other pages.
  *
  * NB: This interface discards data rather than pushes it out to swap,
  * as some implementations do.  This has performance implications for
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch

