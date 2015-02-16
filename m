From: akpm@linux-foundation.org
Subject: [merged]
 profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:57 -0800
Message-ID: <54e25039./fJ1Xj9cjHDv5StH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbBPURd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: profile: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: profile: use %*pb[l] to print bitmaps including cpumasks and nodemasks

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

 kernel/profile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/profile.c~profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/profile.c
--- a/kernel/profile.c~profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/profile.c
@@ -422,8 +422,7 @@ void profile_tick(int type)
 
 static int prof_cpu_mask_proc_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, prof_cpu_mask);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(prof_cpu_mask));
 	return 0;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

