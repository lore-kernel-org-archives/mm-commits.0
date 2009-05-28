From: akpm@linux-foundation.org
Subject: + memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again.patch added to -mm tree
Date: Thu, 28 May 2009 02:09:09 -0700
Message-ID: <200905280909.n4S999mE020066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZE1JNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 05:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, kamezawa.hiroyu@jp.fujitsu.com, penberg@cs.helsinki.fi


The patch titled
     memcg: fix build warning and avoid checking for mem != null again and again
has been added to the -mm tree.  Its filename is
     memcg-fix-build-warning-and-avoid-checking-for-mem-=-null-again-and-again.patch

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
