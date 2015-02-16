From: akpm@linux-foundation.org
Subject: [merged]
 workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:31 -0800
Message-ID: <54e2501f.D0loknVtb/bb3Eki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPURH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: workqueue: use %*pb[l] to format bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: workqueue: use %*pb[l] to format bitmaps including cpumasks and nodemasks

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

 kernel/workqueue.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/workqueue.c~workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/workqueue.c
@@ -3083,10 +3083,9 @@ static ssize_t wq_cpumask_show(struct de
 	int written;
 
 	mutex_lock(&wq->mutex);
-	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
+	written = scnprintf(buf, PAGE_SIZE, "%*pb\n",
+			    cpumask_pr_args(wq->unbound_attrs->cpumask));
 	mutex_unlock(&wq->mutex);
