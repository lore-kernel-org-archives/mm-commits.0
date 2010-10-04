From: akpm@linux-foundation.org
Subject: + memcg-fix-thresholds-with-use_hierarchy-==-1.patch added to -mm tree
Date: Mon, 04 Oct 2010 16:32:14 -0700
Message-ID: <201010042332.o94NWEP5022258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242Ab0JDXcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 19:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix thresholds with use_hierarchy == 1
has been added to the -mm tree.  Its filename is
     memcg-fix-thresholds-with-use_hierarchy-==-1.patch

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
Subject: memcg: fix thresholds with use_hierarchy == 1
From: Kirill A. Shutemov <kirill@shutemov.name>

We need to check parent's thresholds if parent has use_hierarchy == 1 to
be sure that parent's threshold events will be triggered even if parent
itself is not active (no MEM_CGROUP_EVENTS).

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-thresholds-with-use_hierarchy-==-1 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-thresholds-with-use_hierarchy-==-1
+++ a/mm/memcontrol.c
@@ -3587,9 +3587,13 @@ unlock:
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_threshold(memcg, false);
-	if (do_swap_account)
-		__mem_cgroup_threshold(memcg, true);
+	while (memcg) {
+		__mem_cgroup_threshold(memcg, false);
+		if (do_swap_account)
+			__mem_cgroup_threshold(memcg, true);
+
+		memcg =  parent_mem_cgroup(memcg);
+	}
 }
 
 static int compare_thresholds(const void *a, const void *b)
_

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-fix-thresholds-with-use_hierarchy-==-1.patch
linux-next.patch

