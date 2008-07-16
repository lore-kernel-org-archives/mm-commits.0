From: akpm@linux-foundation.org
Subject: - rcu-classic-update-qlen-when-cpu-offline.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:36 -0700
Message-ID: <200807162135.m6GLZaxv014105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757607AbYGPVnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu classic: update qlen when cpu offline
has been removed from the -mm tree.  Its filename was
     rcu-classic-update-qlen-when-cpu-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu classic: update qlen when cpu offline
From: Lai Jiangshan <laijs@cn.fujitsu.com>

When callbacks are moved from offline cpu to this cpu, the qlen field of
this rdp should be updated.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcuclassic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/rcuclassic.c~rcu-classic-update-qlen-when-cpu-offline kernel/rcuclassic.c
--- a/kernel/rcuclassic.c~rcu-classic-update-qlen-when-cpu-offline
+++ a/kernel/rcuclassic.c
@@ -373,6 +373,10 @@ static void __rcu_offline_cpu(struct rcu
 	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+
+	local_irq_disable();
+	this_rdp->qlen += rdp->qlen;
+	local_irq_enable();
 }
 
 static void rcu_offline_cpu(int cpu)
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch
cpuset-code-cleanup-for-started_after.patch
cpuset-two-minor-code-cleanups.patch

