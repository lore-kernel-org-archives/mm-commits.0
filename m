From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again.patch removed from -mm tree
Date: Fri, 29 May 2009 11:43:22 -0700
Message-ID: <200905291843.n4TIhMNP011558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbZE2SoB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 May 2009 14:44:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, kamezawa.hiroyu@jp.fujitsu.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     memcg: fix build warning and avoid checking for mem != null again and again
has been removed from the -mm tree.  Its filename was
     memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix build warning and avoid checking for mem != null again and again
From: Nikanth Karthikesan <knikanth@suse.de>

Fix build warning, "mem_cgroup_is_obsolete defined but not used" when
CONFIG_DEBUG_VM is not set.  Also avoid checking for !mem again and again.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again
+++ a/mm/memcontrol.c
@@ -314,14 +314,6 @@ static struct mem_cgroup *try_get_mem_cg
 	return mem;
 }
 
-static bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
-{
-	if (!mem)
-		return true;
-	return css_is_removed(&mem->css);
-}
-
