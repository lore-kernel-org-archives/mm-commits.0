From: akpm@linux-foundation.org
Subject: + mm-batch-free-pcp-list-if-possible.patch added to -mm tree
Date: Wed, 09 Feb 2011 12:38:19 -0800
Message-ID: <201102092038.p19KcJ7R021080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229Ab1BIUir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 15:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     mm: batch-free pcp list if possible
has been added to the -mm tree.  Its filename is
     mm-batch-free-pcp-list-if-possible.patch

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
Subject: mm: batch-free pcp list if possible
From: Namhyung Kim <namhyung@gmail.com>

free_pcppages_bulk() frees pages from pcp lists in a round-robin fashion
by keeping batch_free counter.  But it doesn't need to spin if there is
only one non-empty list.  This can be checked by batch_free ==
MIGRATE_PCPTYPES.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-batch-free-pcp-list-if-possible mm/page_alloc.c
--- a/mm/page_alloc.c~mm-batch-free-pcp-list-if-possible
+++ a/mm/page_alloc.c
@@ -614,6 +614,10 @@ static void free_pcppages_bulk(struct zo
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
+		/* This is an only non-empty list. Free them all. */
+		if (batch_free == MIGRATE_PCPTYPES)
+			batch_free = to_free;
+
 		do {
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
mm-batch-free-pcp-list-if-possible.patch
select-remove-unused-max_select_seconds.patch

