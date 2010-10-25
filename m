From: akpm@linux-foundation.org
Subject: + mm-do_migrate_range-reduce-list_empty-check.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:40:11 -0700
Message-ID: <201010252140.o9PLeB7p017829@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784Ab0JYVkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: do_migrate_range: reduce list_empty() check
has been added to the -mm tree.  Its filename is
     mm-do_migrate_range-reduce-list_empty-check.patch

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
Subject: mm: do_migrate_range: reduce list_empty() check
From: Bob Liu <lliubbo@gmail.com>

Simple code for reducing list_empty(&source) check.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN mm/memory_hotplug.c~mm-do_migrate_range-reduce-list_empty-check mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-do_migrate_range-reduce-list_empty-check
+++ a/mm/memory_hotplug.c
@@ -705,24 +705,21 @@ do_migrate_range(unsigned long start_pfn
 			   check this again here. */
 			if (page_count(page)) {
 				not_managed++;
+				ret = -EBUSY;
 				break;
 			}
 		}
 	}
-	ret = -EBUSY;
-	if (not_managed) {
-		if (!list_empty(&source))
+	if (!list_empty(&source)) {
+		if (not_managed) {
+			putback_lru_pages(&source);
+			goto out;
+		}
+		/* this function returns # of failed pages */
+		ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
+		if (ret)
 			putback_lru_pages(&source);
-		goto out;
 	}
-	ret = 0;
-	if (list_empty(&source))
-		goto out;
-	/* this function returns # of failed pages */
-	ret = migrate_pages(&source, hotremove_migrate_alloc, 0, 1);
-	if (ret)
-		putback_lru_pages(&source);
