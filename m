From: akpm@linux-foundation.org
Subject: + memcg-avoid-percpu-cached-charge-draining-at-softlimit.patch added to -mm tree
Date: Tue, 14 Jun 2011 19:07:34 -0700
Message-ID: <201106150207.p5F27RZA001450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1FOCHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 22:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: avoid percpu cached charge draining at softlimit
has been added to the -mm tree.  Its filename is
     memcg-avoid-percpu-cached-charge-draining-at-softlimit.patch

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
Subject: memcg: avoid percpu cached charge draining at softlimit
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Based on Michal Hokko's comment.

We are not draining per cpu cached charges during soft limit reclaim
because background reclaim doesn't care about charges.  It tries to free
some memory and charges will not give any.

Cached charges might influence only selection of the biggest soft limit
offender but as the call is done only after the selection has been already
done it makes no change.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-avoid-percpu-cached-charge-draining-at-softlimit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-percpu-cached-charge-draining-at-softlimit
+++ a/mm/memcontrol.c
@@ -1670,7 +1670,13 @@ static int mem_cgroup_hierarchical_recla
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
+			/*
+			 * We are not draining per cpu cached charges during
+			 * soft limit reclaim  because global reclaim doesn't
+			 * care about charges. It tries to free some memory and
+			 * charges will not give any.
+			 */
+			if (!check_soft && loop >= 1)
 				drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-v6.patch
memcg-avoid-percpu-cached-charge-draining-at-softlimit.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

