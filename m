From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch added to -mm tree
Date: Wed, 09 Sep 2009 13:22:01 -0700
Message-ID: <200909092022.n89KM1Kx010617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbZIIUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 16:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch

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
Subject: memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

refcount of the "victim" should be decremented before exiting the loop.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix
+++ a/mm/memcontrol.c
@@ -1133,8 +1133,10 @@ static int mem_cgroup_hierarchical_recla
 				 * anything, it might because there are
 				 * no reclaimable pages under this hierarchy
 				 */
-				if (!check_soft || !total)
+				if (!check_soft || !total) {
+					css_put(&victim->css);
 					break;
+				}
 				/*
 				 * We want to do more targetted reclaim.
 				 * excess >> 2 is not to excessive so as to
@@ -1142,8 +1144,10 @@ static int mem_cgroup_hierarchical_recla
 				 * coming back to reclaim from this cgroup
 				 */
 				if (total >= (excess >> 2) ||
-					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
+					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
+					css_put(&victim->css);
 					break;
+				}
 			}
 		}
 		if (!mem_cgroup_local_usage(&victim->stat)) {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-add_to_swap_cache-does-not-return-eexist-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch

