From: akpm@linux-foundation.org
Subject: [merged]
 time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:27 -0800
Message-ID: <54e2501b.87A1uDFXvlX5Ykuo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPURD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: time: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: time: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN kernel/time/tick-sched.c~time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/time/tick-sched.c
@@ -326,13 +326,6 @@ static int tick_nohz_cpu_down_callback(s
 	return NOTIFY_OK;
 }
 
-/*
- * Worst case string length in chunks of CPU range seems 2 steps
- * separations: 0,2,4,6,...
- * This is NR_CPUS + sizeof('\0')
- */
-static char __initdata nohz_full_buf[NR_CPUS + 1];
