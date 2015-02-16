From: akpm@linux-foundation.org
Subject: [merged]
 arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:19 -0800
Message-ID: <54e25013.HBFllEdK+l1Nf8ZS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPUQz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: arm: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bus/arm-cci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/bus/arm-cci.c~arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/bus/arm-cci.c
--- a/drivers/bus/arm-cci.c~arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/bus/arm-cci.c
@@ -806,8 +806,8 @@ static int cci_pmu_event_init(struct per
 static ssize_t pmu_attr_cpumask_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &pmu->cpus);
