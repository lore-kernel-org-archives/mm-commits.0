From: akpm@linux-foundation.org
Subject: + mm-increase-reclaim_distance-to-30.patch added to -mm tree
Date: Mon, 11 Apr 2011 14:22:03 -0700
Message-ID: <201104112122.p3BLM3DW001867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab1DKVWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 17:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com, tony.luck@intel.com


The patch titled
     mm: increase RECLAIM_DISTANCE to 30
has been added to the -mm tree.  Its filename is
     mm-increase-reclaim_distance-to-30.patch

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
Subject: mm: increase RECLAIM_DISTANCE to 30
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Recently, Robert Mueller reported that zone_reclaim_mode doesn't work
properly on his new NUMA server (Dual Xeon E5520 + Intel S5520UR MB).  He
is using Cyrus IMAPd and it's built on a very traditional single-process
model.

  * a master process which reads config files and manages the other
    process
  * multiple imapd processes, one per connection
  * multiple pop3d processes, one per connection
  * multiple lmtpd processes, one per connection
  * periodical "cleanup" processes.

There are thousands of independent processes.  The problem is, recent
Intel motherboard turn on zone_reclaim_mode by default and traditional
prefork model software don't work well on it.  Unfortunatelly, such models
are still typical even in the 21st century.  We can't ignore them.

This patch raises the zone_reclaim_mode threshold to 30.  30 doesn't have
any specific meaning.  but 20 means that one-hop QPI/Hypertransport and
such relatively cheap 2-4 socket machine are often used for tradiotional
servers as above.  The intention is that these machines don't use
zone_reclaim_mode.

Note: ia64 and Power have arch specific RECLAIM_DISTANCE definitions. 
This patch doesn't change such high-end NUMA machine behavior.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/topology.h~mm-increase-reclaim_distance-to-30 include/linux/topology.h
--- a/include/linux/topology.h~mm-increase-reclaim_distance-to-30
+++ a/include/linux/topology.h
@@ -60,7 +60,7 @@ int arch_update_cpu_topology(void);
  * (in whatever arch specific measurement units returned by node_distance())
  * then switch on zone reclaim on boot.
  */
-#define RECLAIM_DISTANCE 20
+#define RECLAIM_DISTANCE 30
 #endif
 #ifndef PENALTY_FOR_NODE_WITH_CPUS
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

memcg-fix-mem_cgroup_rotate_reclaimable_page.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

