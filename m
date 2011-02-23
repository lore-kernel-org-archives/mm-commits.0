From: akpm@linux-foundation.org
Subject: + mm-fix-dubious-code-in-__count_immobile_pages.patch added to -mm tree
Date: Tue, 22 Feb 2011 16:21:41 -0800
Message-ID: <201102230021.p1N0LfR6002844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab1BWAVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Feb 2011 19:21:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, stable@kernel.org


The patch titled
     mm: fix dubious code in __count_immobile_pages()
has been added to the -mm tree.  Its filename is
     mm-fix-dubious-code-in-__count_immobile_pages.patch

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
Subject: mm: fix dubious code in __count_immobile_pages()
From: Namhyung Kim <namhyung@gmail.com>

When pfn_valid_within() failed 'iter' was incremented twice.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-dubious-code-in-__count_immobile_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-dubious-code-in-__count_immobile_pages
+++ a/mm/page_alloc.c
@@ -5408,10 +5408,9 @@ __count_immobile_pages(struct zone *zone
 	for (found = 0, iter = 0; iter < pageblock_nr_pages; iter++) {
 		unsigned long check = pfn + iter;
 
-		if (!pfn_valid_within(check)) {
-			iter++;
+		if (!pfn_valid_within(check))
 			continue;
-		}
+
 		page = pfn_to_page(check);
 		if (!page_count(page)) {
 			if (PageBuddy(page))
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
mm-fix-dubious-code-in-__count_immobile_pages.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
select-remove-unused-max_select_seconds.patch

