From: akpm@linux-foundation.org
Subject: [merged] mm-fix-page-reclaim-comment-error.patch removed from -mm tree
Date: Fri, 29 Jun 2012 13:18:14 -0700
Message-ID: <20120629201814.82248A0244@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42611 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2USQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:18:16 -0400
Received: by eaao13 with SMTP id o13so212046eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:18:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, liwp.linux@gmail.com, minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix page reclaim comment error
has been removed from the -mm tree.  Its filename was
     mm-fix-page-reclaim-comment-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: fix page reclaim comment error

Since there are five lists in LRU cache, the array nr in get_scan_count
should be:

nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
nr[2] = file inactive pages to scan; nr[3] = file active pages to scan

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-page-reclaim-comment-error mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-page-reclaim-comment-error
+++ a/mm/vmscan.c
@@ -1577,7 +1577,8 @@ static int vmscan_swappiness(struct scan
  * by looking at the fraction of the pages scanned we did rotate back
  * onto the active list instead of evict.
  *
- * nr[0] = anon pages to scan; nr[1] = file pages to scan
+ * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
+ * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch

