From: akpm@linux-foundation.org
Subject: [merged] aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:48 -0800
Message-ID: <20121218200949.1BB0620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:39038 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2LRUJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:51 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so63557lah.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: support larger I/O requests via aoe_maxsectors module param
has been removed from the -mm tree.  Its filename was
     aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: support larger I/O requests via aoe_maxsectors module param

The GPFS filesystem is an example of an aoe user that requires the aoe
driver to support I/O request sizes larger than the default.  Most users
will not need large I/O request sizes, because they would need to be split
up into multiple AoE commands anyway.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/block/aoe/aoeblk.c~aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param
+++ a/drivers/block/aoe/aoeblk.c
@@ -16,11 +16,18 @@
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
 #include <linux/export.h>
+#include <linux/moduleparam.h>
 #include "aoe.h"
 
 static DEFINE_MUTEX(aoeblk_mutex);
 static struct kmem_cache *buf_pool_cache;
 
+/* GPFS needs a larger value than the default. */
+static int aoe_maxsectors;
+module_param(aoe_maxsectors, int, 0644);
+MODULE_PARM_DESC(aoe_maxsectors,
+	"When nonzero, set the maximum number of sectors per I/O request");
+
 static ssize_t aoedisk_show_state(struct device *dev,
 				  struct device_attribute *attr, char *page)
 {
@@ -248,6 +255,8 @@ aoeblk_gdalloc(void *vp)
 	d->blkq = gd->queue = q;
 	q->queuedata = d;
 	d->gd = gd;
+	if (aoe_maxsectors)
+		blk_queue_max_hw_sectors(q, aoe_maxsectors);
 	gd->major = AOE_MAJOR;
 	gd->first_minor = d->sysminor;
 	gd->fops = &aoe_bdops;
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

