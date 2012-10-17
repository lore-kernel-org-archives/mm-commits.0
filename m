From: akpm@linux-foundation.org
Subject: + aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:10:42 -0700
Message-ID: <20121017221043.28E6F1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40239 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2JQWKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:10:43 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so998975ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:10:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: support larger I/O requests via aoe_maxsectors module param
has been added to the -mm tree.  Its filename is
     aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

