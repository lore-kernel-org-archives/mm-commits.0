From: akpm@linux-foundation.org
Subject: [merged]
 xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:17 -0800
Message-ID: <54e25011.QxWB9yMwzTwg31ZZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: xtensa: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/setup.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/xtensa/kernel/setup.c~xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/arch/xtensa/kernel/setup.c
@@ -574,12 +574,9 @@ void machine_power_off(void)
 static int
 c_show(struct seq_file *f, void *slot)
 {
-	char buf[NR_CPUS * 5];
-
-	cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 	/* high-level stuff */
 	seq_printf(f, "CPU count\t: %u\n"
-		      "CPU list\t: %s\n"
+		      "CPU list\t: %*pbl\n"
 		      "vendor_id\t: Tensilica\n"
 		      "model\t\t: Xtensa " XCHAL_HW_VERSION_NAME "\n"
 		      "core ID\t\t: " XCHAL_CORE_ID "\n"
@@ -588,7 +585,7 @@ c_show(struct seq_file *f, void *slot)
 		      "cpu MHz\t\t: %lu.%02lu\n"
 		      "bogomips\t: %lu.%02lu\n",
 		      num_online_cpus(),
-		      buf,
+		      cpumask_pr_args(cpu_online_mask),
 		      XCHAL_BUILD_UNIQUE_ID,
 		      XCHAL_HAVE_BE ?  "big" : "little",
 		      ccount_freq/1000000,
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

