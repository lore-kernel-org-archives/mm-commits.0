From: akpm@linux-foundation.org
Subject: + mm-do_migrate_range-exit-loop-if-not_managed-is-true.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:40:09 -0700
Message-ID: <201010252140.o9PLe9PU017826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755409Ab0JYVkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: do_migrate_range: exit loop if not_managed is true
has been added to the -mm tree.  Its filename is
     mm-do_migrate_range-exit-loop-if-not_managed-is-true.patch

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
Subject: mm: do_migrate_range: exit loop if not_managed is true
From: Bob Liu <lliubbo@gmail.com>

If not_managed is true all pages will be putback to lru, so break the loop
earlier to skip other pages isolate.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-do_migrate_range-exit-loop-if-not_managed-is-true mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-do_migrate_range-exit-loop-if-not_managed-is-true
+++ a/mm/memory_hotplug.c
@@ -696,15 +696,17 @@ do_migrate_range(unsigned long start_pfn
 					    page_is_file_cache(page));
 
 		} else {
-			/* Becasue we don't have big zone->lock. we should
-			   check this again here. */
-			if (page_count(page))
-				not_managed++;
 #ifdef CONFIG_DEBUG_VM
 			printk(KERN_ALERT "removing pfn %lx from LRU failed\n",
 			       pfn);
 			dump_page(page);
 #endif
+			/* Becasue we don't have big zone->lock. we should
+			   check this again here. */
+			if (page_count(page)) {
+				not_managed++;
+				break;
+			}
 		}
 	}
 	ret = -EBUSY;
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
linux-next.patch
mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init.patch
mm-do_migrate_range-exit-loop-if-not_managed-is-true.patch
mm-do_migrate_range-reduce-list_empty-check.patch

