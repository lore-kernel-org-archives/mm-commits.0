From: akpm@linux-foundation.org
Subject: + smaps-fix-wrong-rss-count.patch added to -mm tree
Date: Mon, 04 Jan 2010 16:47:29 -0800
Message-ID: <201001050047.o050lTIL028732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754477Ab0AEAr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 19:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, mpm@selenic.com


The patch titled
     smaps: fix wrong rss count
has been added to the -mm tree.  Its filename is
     smaps-fix-wrong-rss-count.patch

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
