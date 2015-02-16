From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:09 -0800
Message-ID: <54e25009.HXIaQa1NAeQEdwnL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPU1n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:27:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: powerpc: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Spurious if (len > 1) test dropped from shared_cpu_map_show().

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/cacheinfo.c     |   15 ++++++---------
 arch/powerpc/sysdev/xics/ics-opal.c |    6 ++----
 arch/powerpc/sysdev/xics/ics-rtas.c |    7 ++-----
 3 files changed, 10 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/kernel/cacheinfo.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/powerpc/kernel/cacheinfo.c
--- a/arch/powerpc/kernel/cacheinfo.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/powerpc/kernel/cacheinfo.c
@@ -607,19 +607,16 @@ static ssize_t shared_cpu_map_show(struc
 {
 	struct cache_index_dir *index;
 	struct cache *cache;
-	int len;
-	int n = 0;
+	int ret;
 
 	index = kobj_to_cache_index_dir(k);
 	cache = index->cache;
-	len = PAGE_SIZE - 2;
 
-	if (len > 1) {
-		n = cpumask_scnprintf(buf, len, &cache->shared_cpu_map);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	ret = scnprintf(buf, PAGE_SIZE - 1, "%*pb\n",
+			cpumask_pr_args(&cache->shared_cpu_map));
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
 }
 
 static struct kobj_attribute cache_shared_cpu_map_attr =
diff -puN arch/powerpc/sysdev/xics/ics-opal.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/powerpc/sysdev/xics/ics-opal.c
--- a/arch/powerpc/sysdev/xics/ics-opal.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/powerpc/sysdev/xics/ics-opal.c
@@ -131,10 +131,8 @@ static int ics_opal_set_affinity(struct
 
 	wanted_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (wanted_server < 0) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		pr_warning("%s: No online cpus in the mask %s for irq %d\n",
-			   __func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask %*pb for irq %d\n",
+			   __func__, cpumask_pr_args(cpumask), d->irq);
 		return -1;
 	}
 	server = ics_opal_mangle_server(wanted_server);
diff -puN arch/powerpc/sysdev/xics/ics-rtas.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/powerpc/sysdev/xics/ics-rtas.c
--- a/arch/powerpc/sysdev/xics/ics-rtas.c~powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -140,11 +140,8 @@ static int ics_rtas_set_affinity(struct
 
 	irq_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (irq_server == -1) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		printk(KERN_WARNING
-			"%s: No online cpus in the mask %s for irq %d\n",
-			__func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask %*pb for irq %d\n",
+			   __func__, cpumask_pr_args(cpumask), d->irq);
 		return -1;
 	}
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

