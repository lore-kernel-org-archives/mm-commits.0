From: akpm@linux-foundation.org
Subject: [merged] smaps-fix-wrong-rss-count.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:10 -0800
Message-ID: <201001112019.o0BKJAnk025549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab0AKUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     smaps: fix wrong rss count
has been removed from the -mm tree.  Its filename was
     smaps-fix-wrong-rss-count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smaps: fix wrong rss count
From: Minchan Kim <minchan.kim@gmail.com>

A long time ago we regarded zero page as file_rss and vm_normal_page
doesn't return NULL.

But now, we reinstated ZERO_PAGE and vm_normal_page's implementation can
return NULL in case of zero page.  Also we don't count it with file_rss
any more.

Then, RSS and PSS can't be matched.  For consistency, Let's ignore zero
page in smaps_pte_range.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-fix-wrong-rss-count fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-fix-wrong-rss-count
+++ a/fs/proc/task_mmu.c
@@ -361,12 +361,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 		if (!pte_present(ptent))
 			continue;
 
-		mss->resident += PAGE_SIZE;
