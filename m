From: akpm@linux-foundation.org
Subject: + page-allocator-fix-update-nr_free_pages-only-as-necessary.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:02:35 -0800
Message-ID: <201001082302.o08N2Z5n019475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab0AHXEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, mel@csn.ul.ie, minchan.kim@gmail.com, shijie8@gmail.com, stable@kernel.org


The patch titled
     page allocator: update NR_FREE_PAGES only when necessary
has been added to the -mm tree.  Its filename is
     page-allocator-fix-update-nr_free_pages-only-as-necessary.patch

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
Subject: page allocator: update NR_FREE_PAGES only when necessary
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit f2260e6b (page allocator: update NR_FREE_PAGES only as necessary)
made one minor regression.  if __rmqueue() was failed, NR_FREE_PAGES stat
go wrong.  this patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Huang Shijie <shijie8@gmail.com>
Reviewed-by : Minchan Kim <minchan.kim@gmail.com>
Cc: Huang Shijie <shijie8@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-fix-update-nr_free_pages-only-as-necessary mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-fix-update-nr_free_pages-only-as-necessary
+++ a/mm/page_alloc.c
@@ -1219,10 +1219,10 @@ again:
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
-		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

proc-revert-procfs-provide-stack-information-for-threads.patch
smaps-fix-wrong-rss-count.patch
linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

