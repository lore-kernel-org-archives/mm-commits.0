From: akpm@linux-foundation.org
Subject: [merged]
 scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:41 -0800
Message-ID: <54e25029.9p987mYKRUgP1JB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPURR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: scsi: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* map_show()'s return value is too high by one and the function could
  modify beyond the end of the buffer when the formatted text is long
  enough.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c~scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/drivers/scsi/scsi_debug.c
@@ -4658,10 +4658,10 @@ static ssize_t map_show(struct device_dr
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
-	count = bitmap_scnlistprintf(buf, PAGE_SIZE, map_storep, map_size);
