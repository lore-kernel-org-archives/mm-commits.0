From: akpm@linux-foundation.org
Subject: [merged]
 lib-show_mem-this-patch-adds-cma-reserved-infromation.patch removed from
 -mm tree
Date: Fri, 19 Dec 2014 12:36:43 -0800
Message-ID: <54948c5b.AlN5pERevvp2ayd1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaLSUgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 15:36:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, pintu.k@samsung.com, qiuxishi@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/show_mem.c: add cma reserved information
has been removed from the -mm tree.  Its filename was
     lib-show_mem-this-patch-adds-cma-reserved-infromation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: lib/show_mem.c: add cma reserved information

Add cma reserved information which is currently shown as a part of total
reserved only.  This patch is continuation of our previous cma patches
related to this.

https://lkml.org/lkml/2014/10/20/64
https://lkml.org/lkml/2014/10/22/383

[akpm@linux-foundation.org: remove hopefully-unneeded ifdefs]
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation lib/show_mem.c
--- a/lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation
+++ a/lib/show_mem.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
+#include <linux/cma.h>
 
 void show_mem(unsigned int filter)
 {
@@ -38,7 +39,12 @@ void show_mem(unsigned int filter)
 
 	printk("%lu pages RAM\n", total);
 	printk("%lu pages HighMem/MovableOnly\n", highmem);
+#ifdef CONFIG_CMA
+	printk("%lu pages reserved\n", (reserved - totalcma_pages));
+	printk("%lu pages cma reserved\n", totalcma_pages);
+#else
 	printk("%lu pages reserved\n", reserved);
+#endif
 #ifdef CONFIG_QUICKLIST
 	printk("%lu pages in pagetable cache\n",
 		quicklist_total_size());
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

origin.patch

