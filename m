From: akpm@linux-foundation.org
Subject: [merged]
 x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:13 -0800
Message-ID: <54e2500d.hVJAHkv6MPkRm3zT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: x86: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Unnecessary buffer size calculation and condition on the lenght
  removed from intel_cacheinfo.c::show_shared_cpu_map_func().

* uv_nmi_nr_cpus_pr() got overly smart and implemented "..."
  abbreviation if the output stretched over the predefined 1024 byte
  buffer.  Replaced with plain printk.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |   24 ++++++++++-------------
 arch/x86/mm/numa.c                    |    6 +----
 arch/x86/platform/uv/uv_nmi.c         |   25 ++++++------------------
 3 files changed, 20 insertions(+), 35 deletions(-)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -952,20 +952,18 @@ static ssize_t show_size(struct _cpuid4_
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 					int type, char *buf)
 {
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int ret;
 
-	if (len > 1) {
-		const struct cpumask *mask;
-
-		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type ?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
+	if (type)
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+				cpumask_pr_args(mask));
+	else
+		ret = scnprintf(buf, PAGE_SIZE - 1, "%*pb",
+				cpumask_pr_args(mask));
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
 }
 
 static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
diff -puN arch/x86/mm/numa.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/mm/numa.c
@@ -794,7 +794,6 @@ int early_cpu_to_node(int cpu)
 void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 {
 	struct cpumask *mask;
-	char buf[64];
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
@@ -812,10 +811,9 @@ void debug_cpumask_set_cpu(int cpu, int
 	else
 		cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %*pbl\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
-		cpu, node, buf);
+		cpu, node, cpumask_pr_args(mask));
 	return;
 }
 
diff -puN arch/x86/platform/uv/uv_nmi.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/x86/platform/uv/uv_nmi.c
--- a/arch/x86/platform/uv/uv_nmi.c~x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/x86/platform/uv/uv_nmi.c
@@ -273,20 +273,6 @@ static inline void uv_clear_nmi(int cpu)
 	}
 }
 
-/* Print non-responding cpus */
-static void uv_nmi_nr_cpus_pr(char *fmt)
-{
-	static char cpu_list[1024];
-	int len = sizeof(cpu_list);
-	int c = cpumask_weight(uv_nmi_cpu_mask);
-	int n = cpulist_scnprintf(cpu_list, len, uv_nmi_cpu_mask);
-
-	if (n >= len-1)
-		strcpy(&cpu_list[len - 6], "...\n");
-
-	printk(fmt, c, cpu_list);
-}
-
 /* Ping non-responding cpus attemping to force them into the NMI handler */
 static void uv_nmi_nr_cpus_ping(void)
 {
@@ -371,16 +357,19 @@ static void uv_nmi_wait(int master)
 			break;
 
 		/* if not all made it in, send IPI NMI to them */
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		pr_alert("UV: Sending NMI IPI to %d non-responding CPUs: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
+
 		uv_nmi_nr_cpus_ping();
 
 		/* if all cpus are in, then done */
 		if (!uv_nmi_wait_cpus(0))
 			break;
 
-		uv_nmi_nr_cpus_pr(KERN_ALERT
-			"UV: %d CPUs not in NMI loop: %s\n");
+		pr_alert("UV: %d CPUs not in NMI loop: %*pbl\n",
+			 cpumask_weight(uv_nmi_cpu_mask),
+			 cpumask_pr_args(uv_nmi_cpu_mask));
 	} while (0);
 
 	pr_alert("UV: %d of %d CPUs in NMI\n",
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

