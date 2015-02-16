From: akpm@linux-foundation.org
Subject: [merged]
 mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:07 -0800
Message-ID: <54e25007.RVg3cICLRzL/T/Bu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mips: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/netlogic/common/smp.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN arch/mips/netlogic/common/smp.c~mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/mips/netlogic/common/smp.c
--- a/arch/mips/netlogic/common/smp.c~mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/mips/netlogic/common/smp.c
@@ -162,7 +162,6 @@ void __init nlm_smp_setup(void)
 	unsigned int boot_cpu;
 	int num_cpus, i, ncore, node;
 	volatile u32 *cpu_ready = nlm_get_boot_data(BOOT_CPU_READY);
-	char buf[64];
 
 	boot_cpu = hard_smp_processor_id();
 	cpumask_clear(&phys_cpu_present_mask);
@@ -189,10 +188,10 @@ void __init nlm_smp_setup(void)
 		}
 	}
 
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), &phys_cpu_present_mask);
-	pr_info("Physical CPU mask: %s\n", buf);
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), cpu_possible_mask);
-	pr_info("Possible CPU mask: %s\n", buf);
+	pr_info("Physical CPU mask: %*pb\n",
+		cpumask_pr_args(&phys_cpu_present_mask));
+	pr_info("Possible CPU mask: %*pb\n",
+		cpumask_pr_args(cpu_possible_mask));
 
 	/* check with the cores we have woken up */
 	for (ncore = 0, i = 0; i < NLM_NR_NODES; i++)
@@ -209,7 +208,6 @@ static int nlm_parse_cpumask(cpumask_t *
 {
 	uint32_t core0_thr_mask, core_thr_mask;
 	int threadmode, i, j;
-	char buf[64];
 
 	core0_thr_mask = 0;
 	for (i = 0; i < NLM_THREADS_PER_CORE; i++)
@@ -244,8 +242,7 @@ static int nlm_parse_cpumask(cpumask_t *
 	return threadmode;
 
 unsupp:
-	cpumask_scnprintf(buf, ARRAY_SIZE(buf), wakeup_mask);
-	panic("Unsupported CPU mask %s", buf);
+	panic("Unsupported CPU mask %*pb", cpumask_pr_args(wakeup_mask));
 	return 0;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

