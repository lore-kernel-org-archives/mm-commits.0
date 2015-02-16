From: akpm@linux-foundation.org
Subject: [merged]
 padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:51 -0800
Message-ID: <54e25033.BY4ChP/1dUfZJp7W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPUR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, steffen.klassert@secunet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: padata: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: padata: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/padata.c~padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/padata.c
--- a/kernel/padata.c~padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/padata.c
@@ -917,15 +917,10 @@ static ssize_t show_cpumask(struct padat
 	else
 		cpumask = pinst->cpumask.pcpu;
 
-	len = bitmap_scnprintf(buf, PAGE_SIZE, cpumask_bits(cpumask),
-			       nr_cpu_ids);
-	if (PAGE_SIZE - len < 2)
-		len = -EINVAL;
-	else
-		len += sprintf(buf + len, "\n");
