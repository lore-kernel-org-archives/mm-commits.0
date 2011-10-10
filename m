From: akpm@google.com
Subject: + mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch added to -mm tree
Date: Mon, 10 Oct 2011 15:53:15 -0700
Message-ID: <201110102253.p9AMrFv3023933@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:17330 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab1JJWxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2011 18:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@gentwo.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     Subject: mm: do not drain pagevecs for mlockall(MCL_FUTURE)
has been added to the -mm tree.  Its filename is
     mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch

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
From: Christoph Lameter <cl@gentwo.org>
Subject: mm: do not drain pagevecs for mlockall(MCL_FUTURE)

MCL_FUTURE does not move pages between lru list and draining the LRU per
cpu pagevecs is a nasty activity.  Avoid doing it unecessarily.

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/mlock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-do-not-drain-pagevecs-for-mlockallmcl_future mm/mlock.c
--- a/mm/mlock.c~mm-do-not-drain-pagevecs-for-mlockallmcl_future
+++ a/mm/mlock.c
@@ -549,7 +549,8 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		goto out;
 
-	lru_add_drain_all();	/* flush pagevec */
+	if (flags & MCL_CURRENT)
+		lru_add_drain_all();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 
_
Subject: Subject: mm: do not drain pagevecs for mlockall(MCL_FUTURE)

Patches currently in -mm which might be from cl@gentwo.org are

origin.patch
linux-next.patch
mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch

