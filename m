From: akpm@linux-foundation.org
Subject: [merged] mm-vmstatc-cache-align-vm_stat.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:30 -0700
Message-ID: <201111012112.pA1LCUkV001389@hpaq12.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, cl@gentwo.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat.c: cache align vm_stat
has been removed from the -mm tree.  Its filename was
     mm-vmstatc-cache-align-vm_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dimitri Sivanich <sivanich@sgi.com>
Subject: mm/vmstat.c: cache align vm_stat

Avoid false sharing of the vm_stat array.

This was found to adversely affect tmpfs I/O performance.

Tests run on a 640 cpu UV system.

With 120 threads doing parallel writes, each to different tmpfs mounts:
No patch:		~300 MB/sec
With vm_stat alignment:	~430 MB/sec

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Christoph Lameter <cl@gentwo.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmstatc-cache-align-vm_stat mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstatc-cache-align-vm_stat
+++ a/mm/vmstat.c
@@ -78,7 +78,7 @@ void vm_events_fold_cpu(int cpu)
  *
  * vm_stat contains the global counters
  */
-atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS];
+atomic_long_t vm_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_stat);
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from sivanich@sgi.com are

origin.patch

