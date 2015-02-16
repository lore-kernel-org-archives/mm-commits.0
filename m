From: akpm@linux-foundation.org
Subject: [merged]
 bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:05 -0800
Message-ID: <54e25005.h1WOwKJZ0DMB4BYs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbBPUQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: bitmap: use %*pb[l] to print bitmaps including cpumasks and nodemasks

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

 lib/bitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks lib/bitmap.c
--- a/lib/bitmap.c~bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/lib/bitmap.c
@@ -541,8 +541,8 @@ int bitmap_print_to_pagebuf(bool list, c
 	int n = 0;
 
 	if (len > 1) {
-		n = list ? bitmap_scnlistprintf(buf, len, maskp, nmaskbits) :
-			   bitmap_scnprintf(buf, len, maskp, nmaskbits);
+		n = list ? scnprintf(buf, len, "%*pbl", nmaskbits, maskp) :
+			   scnprintf(buf, len, "%*pb", nmaskbits, maskp);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

