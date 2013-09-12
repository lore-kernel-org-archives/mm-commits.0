From: akpm@linux-foundation.org
Subject: [merged] vmstat-create-fold_diff.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:31 -0700
Message-ID: <52321963.OCYUxmciAiUJAZRi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, js1304@gmail.com, adobriyan@gmail.com, cl@linux.com

Subject: [merged] vmstat-create-fold_diff.patch removed from -mm tree
To: cl@linux.com,adobriyan@gmail.com,js1304@gmail.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:31 -0700


The patch titled
     Subject: vmstat: create fold_diff
has been removed from the -mm tree.  Its filename was
     vmstat-create-fold_diff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
