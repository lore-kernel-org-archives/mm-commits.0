From: akpm@linux-foundation.org
Subject: + swap-update-function-comment-of-release_pages.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:31:18 -0700
Message-ID: <200807292231.m6TMVI7J025243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbYG2WcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     swap: update function comment of release_pages
has been added to the -mm tree.  Its filename is
     swap-update-function-comment-of-release_pages.patch

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
Subject: swap: update function comment of release_pages
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/swap.c~swap-update-function-comment-of-release_pages mm/swap.c
--- a/mm/swap.c~swap-update-function-comment-of-release_pages
+++ a/mm/swap.c
@@ -278,9 +278,10 @@ int lru_add_drain_all(void)
  * Avoid taking zone->lru_lock if possible, but if it is taken, retain it
  * for the remainder of the operation.
  *
- * The locking in this function is against shrink_cache(): we recheck the
- * page count inside the lock to see whether shrink_cache grabbed the page
- * via the LRU.  If it did, give up: shrink_cache will free it.
+ * The locking in this function is against shrink_inactive_list(): we recheck
+ * the page count inside the lock to see whether shrink_inactive_list()
+ * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
+ * will free it.
  */
 void release_pages(struct page **pages, int nr, int cold)
 {
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

madvise-update-function-comment-of-madvise_dontneed.patch
swap-update-function-comment-of-release_pages.patch
swapfile-vmscan-update-comments-related-to-vmscan-functions.patch
do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

