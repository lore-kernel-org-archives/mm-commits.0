From: akpm@linux-foundation.org
Subject: - nbd-remove-limit-on-max-number-of-nbd-devices.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:23 -0800
Message-ID: <200802082020.m18KK4mZ011134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756759AbYBHUaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:30:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     NBD: remove limit on max number of nbd devices
has been removed from the -mm tree.  Its filename was
     nbd-remove-limit-on-max-number-of-nbd-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NBD: remove limit on max number of nbd devices
From: Paul Clements <paul.clements@steeleye.com>

Remove the arbitrary 128 device limit for NBD.  nbds_max can now be set to
any number.  In certain scenarios where devices are used sparsely we have
run into the 128 device limit.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   10 ++++------
 include/linux/nbd.h |    1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/block/nbd.c~nbd-remove-limit-on-max-number-of-nbd-devices drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-remove-limit-on-max-number-of-nbd-devices
+++ a/drivers/block/nbd.c
@@ -54,7 +54,7 @@ static unsigned int debugflags;
 #endif /* NDEBUG */
 
 static unsigned int nbds_max = 16;
-static struct nbd_device nbd_dev[MAX_NBD];
+static struct nbd_device *nbd_dev;
 
 /*
  * Use just one lock (or at most 1 per NIC). Two arguments for this:
@@ -649,11 +649,9 @@ static int __init nbd_init(void)
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
-	if (nbds_max > MAX_NBD) {
-		printk(KERN_CRIT "nbd: cannot allocate more than %u nbds; %u requested.\n", MAX_NBD,
-				nbds_max);
-		return -EINVAL;
-	}
+	nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
+	if (!nbd_dev)
+		return -ENOMEM;
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1);
diff -puN include/linux/nbd.h~nbd-remove-limit-on-max-number-of-nbd-devices include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-remove-limit-on-max-number-of-nbd-devices
+++ a/include/linux/nbd.h
@@ -35,7 +35,6 @@ enum {
 };
 
 #define nbd_cmd(req) ((req)->cmd[0])
-#define MAX_NBD 128
 
 /* userspace doesn't need the nbd_device structure */
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch
