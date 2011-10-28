From: akpm@linux-foundation.org
Subject: + mm-vmstatc-cache-align-vm_stat.patch added to -mm tree
Date: Fri, 28 Oct 2011 15:55:02 -0700
Message-ID: <201110282255.p9SMt2c7029344@wpaz37.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab1J1Wzf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2011 18:55:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, cl@gentwo.org, mel@csn.ul.ie


The patch titled
     Subject: mm/vmstat.c: cache align vm_stat
has been added to the -mm tree.  Its filename is
     mm-vmstatc-cache-align-vm_stat.patch

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
From: Dimitri Sivanich <sivanich@sgi.com>
Subject: mm/vmstat.c: cache align vm_stat

Avoid false sharing of the vm_stat array.

This was found to adversely affect tmpfs I/O performance.

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
Subject: Subject: mm/vmstat.c: cache align vm_stat

Patches currently in -mm which might be from sivanich@sgi.com are

mm-vmstatc-cache-align-vm_stat.patch

