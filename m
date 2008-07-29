From: akpm@linux-foundation.org
Subject: + madvise-update-function-comment-of-madvise_dontneed.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:31:16 -0700
Message-ID: <200807292231.m6TMVGJq025240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755139AbYG2WcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     madvise: update function comment of madvise_dontneed
has been added to the -mm tree.  Its filename is
     madvise-update-function-comment-of-madvise_dontneed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

madvise-update-function-comment-of-madvise_dontneed.patch
swap-update-function-comment-of-release_pages.patch
swapfile-vmscan-update-comments-related-to-vmscan-functions.patch
do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

