From: akpm@linux-foundation.org
Subject: + memcg-fix-account-leak-at-failure-of-memsw-acconting.patch added to -mm tree
Date: Tue, 25 Jan 2011 12:40:10 -0800
Message-ID: <201101252040.p0PKeA2Q006678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab1AYUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp, stable@kernel.org


The patch titled
     memcg: fix account leak at failure of memsw acconting.
has been added to the -mm tree.  Its filename is
     memcg-fix-account-leak-at-failure-of-memsw-acconting.patch

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
Subject: memcg: fix account leak at failure of memsw acconting.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

4b53433468 ("memcg: clean up try_charge main loop") removes a cancel of
charge at case: memory charge-> success.  mem+swap charge-> failure.

This leaks usage of memory. Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: <stable@kernel.org>	[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-fix-account-leak-at-failure-of-memsw-acconting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-account-leak-at-failure-of-memsw-acconting
+++ a/mm/memcontrol.c
@@ -1832,6 +1832,7 @@ static int __mem_cgroup_do_charge(struct
 		if (likely(!ret))
 			return CHARGE_OK;
 
+		res_counter_uncharge(&mem->res, csize);
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
memcg-fix-account-leak-at-failure-of-memsw-acconting.patch
memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch
memcg-fix-race-at-move_parent-around-compound_order.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

