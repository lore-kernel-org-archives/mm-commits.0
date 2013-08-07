From: akpm@linux-foundation.org
Subject: + vmstat-create-fold_diff.patch added to -mm tree
Date: Wed, 07 Aug 2013 13:43:08 -0700
Message-ID: <5202b15c.EPEtttLXLTifHRzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab3HGUnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 16:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, adobriyan@gmail.com, cl@linux.com

Subject: + vmstat-create-fold_diff.patch added to -mm tree
To: cl@linux.com,adobriyan@gmail.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 13:43:08 -0700


The patch titled
     Subject: vmstat: create fold_diff
has been added to the -mm tree.  Its filename is
     vmstat-create-fold_diff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-create-fold_diff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-create-fold_diff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: vmstat: create fold_diff

Both functions that update global counters use the same mechanism.

Create a function that contains the common code.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/vmstat.c~vmstat-create-fold_diff mm/vmstat.c
--- a/mm/vmstat.c~vmstat-create-fold_diff
+++ a/mm/vmstat.c
@@ -414,6 +414,15 @@ void dec_zone_page_state(struct page *pa
 EXPORT_SYMBOL(dec_zone_page_state);
 #endif
 
+static inline void fold_diff(int *diff)
+{
+	int i;
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (diff[i])
+			atomic_long_add(diff[i], &vm_stat[i]);
+}
+
 /*
  * Update the zone counters for the current cpu.
  *
@@ -483,10 +492,7 @@ static void refresh_cpu_vm_stats(int cpu
 			drain_zone_pages(zone, &p->pcp);
 #endif
 	}
-
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (global_diff[i])
-			atomic_long_add(global_diff[i], &vm_stat[i]);
+	fold_diff(global_diff);
 }
 
 /*
@@ -516,9 +522,7 @@ void cpu_vm_stats_fold(int cpu)
 			}
 	}
 
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (global_diff[i])
-			atomic_long_add(global_diff[i], &vm_stat[i]);
+	fold_diff(global_diff);
 }
 
 /*
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
vmstat-create-fold_diff.patch
vmstat-use-this_cpu-to-avoid-irqon-off-sequence-in-refresh_cpu_vm_stats.patch
linux-next.patch

