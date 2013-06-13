From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-broken-mutex-usage-in-ioctl.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:40 -0700
Message-ID: <51ba1624.1pzLhFxEjPqL3X+A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab3FMS5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com

Subject: [merged] cciss-fix-broken-mutex-usage-in-ioctl.patch removed from -mm tree
To: scameron@beardog.cce.hp.com,axboe@kernel.dk,mike.miller@hp.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:40 -0700


The patch titled
     Subject: cciss: fix broken mutex usage in ioctl
has been removed from the -mm tree.  Its filename was
     cciss-fix-broken-mutex-usage-in-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: cciss: fix broken mutex usage in ioctl

If a new logical drive is added and the CCISS_REGNEWD ioctl is invoked (as
is normal with the Array Configuration Utility) the process will hang as
below.  It attempts to acquire the same mutex twice, once in do_ioctl()
and once in cciss_unlocked_open().  The BKL was recursive, the mutex
isn't.

Linux version 3.10.0-rc2 (scameron@localhost.localdomain) (gcc version 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC) ) #1 SMP Fri May 24 14:32:12 CDT 2013
[...]
acu             D 0000000000000001     0  3246   3191 0x00000080
 ffff8800da833a18 0000000000000086 ffff8800da833fd8 0000000000012d00
 ffff8800da832010 0000000000012d00 0000000000012d00 0000000000012d00
 ffff8800da833fd8 0000000000012d00 ffff8800da8294e0 ffff8800db50eb10
Call Trace:
 [<ffffffff8153a2d9>] schedule+0x29/0x70
 [<ffffffff8153a5de>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81538e0b>] __mutex_lock_slowpath+0x17b/0x220
 [<ffffffff81538c6b>] mutex_lock+0x2b/0x50
 [<ffffffffa0002bdf>] cciss_unlocked_open+0x2f/0x110 [cciss]
 [<ffffffff811a06f3>] __blkdev_get+0xd3/0x470
 [<ffffffff811a0aec>] blkdev_get+0x5c/0x1e0
 [<ffffffff8123cd42>] register_disk+0x182/0x1a0
 [<ffffffff8123cedc>] add_disk+0x17c/0x310
 [<ffffffffa0002dfa>] cciss_add_disk+0x13a/0x170 [cciss]
 [<ffffffffa000adfb>] cciss_update_drive_info+0x39b/0x480 [cciss]
 [<ffffffffa000b818>] rebuild_lun_table+0x258/0x370 [cciss]
 [<ffffffffa000bc7f>] cciss_ioctl+0x34f/0x470 [cciss]
 [<ffffffff81538c5e>] ? mutex_lock+0x1e/0x50
 [<ffffffffa000bde9>] do_ioctl+0x49/0x70 [cciss]
 [<ffffffff81239e48>] __blkdev_driver_ioctl+0x28/0x30
 [<ffffffff8123a4e0>] blkdev_ioctl+0x200/0x7b0
 [<ffffffff81186633>] ? mntput+0x23/0x40
 [<ffffffff8119ef0c>] block_ioctl+0x3c/0x40
 [<ffffffff8117a309>] do_vfs_ioctl+0x89/0x350
 [<ffffffff8116a12e>] ? ____fput+0xe/0x10
 [<ffffffff81063ae4>] ? task_work_run+0x94/0xf0
 [<ffffffff8117a671>] SyS_ioctl+0xa1/0xb0
 [<ffffffff81544102>] system_call_fastpath+0x16/0x1b

This mutex usage was added into the ioctl path when the big kernel lock
was removed.  As it turns out, these paths are all thread safe anyway (or
can easily be made so) and we don't want ioctl() to be single threaded in
any case.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Miller <mike.miller@hp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-broken-mutex-usage-in-ioctl drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-broken-mutex-usage-in-ioctl
+++ a/drivers/block/cciss.c
@@ -168,8 +168,6 @@ static irqreturn_t do_cciss_msix_intr(in
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode);
 static void cciss_release(struct gendisk *disk, fmode_t mode);
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned int cmd, unsigned long arg);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -235,7 +233,7 @@ static const struct block_device_operati
 	.owner = THIS_MODULE,
 	.open = cciss_unlocked_open,
 	.release = cciss_release,
-	.ioctl = do_ioctl,
+	.ioctl = cciss_ioctl,
 	.getgeo = cciss_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = cciss_compat_ioctl,
@@ -1143,16 +1141,6 @@ static void cciss_release(struct gendisk
 	mutex_unlock(&cciss_mutex);
 }
 
-static int do_ioctl(struct block_device *bdev, fmode_t mode,
-		    unsigned cmd, unsigned long arg)
-{
-	int ret;
-	mutex_lock(&cciss_mutex);
-	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	mutex_unlock(&cciss_mutex);
-	return ret;
-}
-
 #ifdef CONFIG_COMPAT
 
 static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
@@ -1179,7 +1167,7 @@ static int cciss_compat_ioctl(struct blo
 	case CCISS_REGNEWD:
 	case CCISS_RESCANDISK:
 	case CCISS_GETLUNINFO:
-		return do_ioctl(bdev, mode, cmd, arg);
+		return cciss_ioctl(bdev, mode, cmd, arg);
 
 	case CCISS_PASSTHRU32:
 		return cciss_ioctl32_passthru(bdev, mode, cmd, arg);
@@ -1219,7 +1207,7 @@ static int cciss_ioctl32_passthru(struct
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1261,7 +1249,7 @@ static int cciss_ioctl32_big_passthru(st
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
+	err = cciss_ioctl(bdev, mode, CCISS_BIG_PASSTHRU, (unsigned long)p);
 	if (err)
 		return err;
 	err |=
@@ -1311,11 +1299,14 @@ static int cciss_getpciinfo(ctlr_info_t
 static int cciss_getintinfo(ctlr_info_t *h, void __user *argp)
 {
 	cciss_coalint_struct intinfo;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	intinfo.delay = readl(&h->cfgtable->HostWrite.CoalIntDelay);
 	intinfo.count = readl(&h->cfgtable->HostWrite.CoalIntCount);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user
 	    (argp, &intinfo, sizeof(cciss_coalint_struct)))
 		return -EFAULT;
@@ -1356,12 +1347,15 @@ static int cciss_setintinfo(ctlr_info_t
 static int cciss_getnodename(ctlr_info_t *h, void __user *argp)
 {
 	NodeName_type NodeName;
+	unsigned long flags;
 	int i;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	for (i = 0; i < 16; i++)
 		NodeName[i] = readb(&h->cfgtable->ServerName[i]);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, NodeName, sizeof(NodeName_type)))
 		return -EFAULT;
 	return 0;
@@ -1398,10 +1392,13 @@ static int cciss_setnodename(ctlr_info_t
 static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 {
 	Heartbeat_type heartbeat;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	heartbeat = readl(&h->cfgtable->HeartBeat);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &heartbeat, sizeof(Heartbeat_type)))
 		return -EFAULT;
 	return 0;
@@ -1410,10 +1407,13 @@ static int cciss_getheartbeat(ctlr_info_
 static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
 {
 	BusTypes_type BusTypes;
+	unsigned long flags;
 
 	if (!argp)
 		return -EINVAL;
+	spin_lock_irqsave(&h->lock, flags);
 	BusTypes = readl(&h->cfgtable->BusTypes);
+	spin_unlock_irqrestore(&h->lock, flags);
 	if (copy_to_user(argp, &BusTypes, sizeof(BusTypes_type)))
 		return -EFAULT;
 	return 0;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch

