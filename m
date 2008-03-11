From: akpm@linux-foundation.org
Subject: - keep-rd-online-and-cpu_online_map-in-sync.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:26 -0700
Message-ID: <200803111842.m2BIgQuc021454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbYCKSnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:43:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghaskins@novell.com, ego@in.ibm.com, mingo@elte.hu, rjw@sisk.pl, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     keep rd->online and cpu_online_map in sync
has been removed from the -mm tree.  Its filename was
     keep-rd-online-and-cpu_online_map-in-sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keep rd->online and cpu_online_map in sync
From: Gregory Haskins <ghaskins@novell.com>

It is possible to allow the root-domain cache of online cpus to become out of
sync with the global cpu_online_map.  This is because we currently trigger
removal of cpus too early in the notifier chain.  Other DOWN_PREPARE handlers
may in fact run and reconfigure the root-domain topology, thereby stomping on
our own offline handling.

The end result is that rd->online may become out of sync with cpu_online_map,
which results in potential task misrouting.

So change the offline handling to be more tightly coupled with the global
offline process by triggering on CPU_DYING intead of CPU_DOWN_PREPARE.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sched.c~keep-rd-online-and-cpu_online_map-in-sync kernel/sched.c
--- a/kernel/sched.c~keep-rd-online-and-cpu_online_map-in-sync
+++ a/kernel/sched.c
@@ -5956,7 +5956,8 @@ migration_call(struct notifier_block *nf
 		spin_unlock_irq(&rq->lock);
 		break;
 
-	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
_

Patches currently in -mm which might be from ghaskins@novell.com are

origin.patch
git-kvm.patch

