From: akpm@linux-foundation.org
Subject: + memcg-remove-impossible-conditional-when-committing.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:26:33 -0800
Message-ID: <201102032326.p13NQXfo031024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab1BCX1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:27:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove impossible conditional when committing
has been added to the -mm tree.  Its filename is
     memcg-remove-impossible-conditional-when-committing.patch

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
Subject: memcg: remove impossible conditional when committing
From: Johannes Weiner <hannes@cmpxchg.org>

No callsite ever passes a NULL pointer for a struct mem_cgroup * to the
committing function.  There is no need to check for it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-impossible-conditional-when-committing mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-impossible-conditional-when-committing
+++ a/mm/memcontrol.c
@@ -2092,10 +2092,6 @@ static void __mem_cgroup_commit_charge(s
 {
 	int nr_pages = page_size >> PAGE_SHIFT;
 
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
