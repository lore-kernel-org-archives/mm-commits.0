From: akpm@linux-foundation.org
Subject: - add-cond_resched-to-refresh_cpu_vm_stats.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:54:08 -0700
Message-ID: <200804282154.m3SLs8oH017972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934976AbYD1VyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmstats: add cond_resched() to refresh_cpu_vm_stats()
has been removed from the -mm tree.  Its filename was
     add-cond_resched-to-refresh_cpu_vm_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstats: add cond_resched() to refresh_cpu_vm_stats()
From: Dimitri Sivanich <sivanich@sgi.com>

We've found that it can take quite a bit of time (100's of usec) to get
through the zone loop in refresh_cpu_vm_stats().

Adding a cond_resched() to allow other threads to run in the non-preemptive
case.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmstat.c~add-cond_resched-to-refresh_cpu_vm_stats mm/vmstat.c
--- a/mm/vmstat.c~add-cond_resched-to-refresh_cpu_vm_stats
+++ a/mm/vmstat.c
@@ -322,6 +322,7 @@ void refresh_cpu_vm_stats(int cpu)
 				p->expire = 3;
 #endif
 			}
+		cond_resched();
 #ifdef CONFIG_NUMA
 		/*
 		 * Deal with draining the remote pageset of this
_

Patches currently in -mm which might be from sivanich@sgi.com are

origin.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch

