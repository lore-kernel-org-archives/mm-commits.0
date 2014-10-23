From: akpm@linux-foundation.org
Subject: + lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
 added to -mm tree
Date: Thu, 23 Oct 2014 12:57:08 -0700
Message-ID: <54495d94.CZEO+XWkkwv8gxn+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbaJWT5J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:57:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, kosaki.motohiro@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mgorman@suse.de, pintu.k@samsung.com, qiuxishi@huawei.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/show_mem.c: adds cma reserved infromation
has been added to the -mm tree.  Its filename is
     lib-show_mem-this-patch-adds-cma-reserved-infromation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-show_mem-this-patch-adds-cma-reserved-infromation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: lib/show_mem.c: adds cma reserved infromation

Add cma reserved information which is currently shown as a part of total
reserved only.  This patch is continuation of our previous cma patches
related to this.

https://lkml.org/lkml/2014/10/20/64
https://lkml.org/lkml/2014/10/22/383

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation lib/show_mem.c
--- a/lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation
+++ a/lib/show_mem.c
@@ -8,6 +8,9 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
+#ifdef CONFIG_CMA
+#include <linux/cma.h>
+#endif
 
 void show_mem(unsigned int filter)
 {
@@ -38,7 +41,12 @@ void show_mem(unsigned int filter)
 
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

mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch

