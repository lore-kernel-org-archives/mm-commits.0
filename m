From: akpm@linux-foundation.org
Subject: - genhd-register-the-block_ext_major-blockdev.patch removed from -mm tree
Date: Tue, 18 Nov 2008 17:01:57 -0800
Message-ID: <200811190101.mAJ11wwK008120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbYKSBCx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 20:02:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, jens.axboe@oracle.com, rjw@sisk.pl, tj@kernel.org, yanmin.zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     genhd: register the BLOCK_EXT_MAJOR blockdev
has been removed from the -mm tree.  Its filename was
     genhd-register-the-block_ext_major-blockdev.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genhd: register the BLOCK_EXT_MAJOR blockdev
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

We run into system boot failure with kernel 2.6.28-rc.  We found it on a
couple of machines, including T61 notebook, nehalem machine, and another
HPC NX6325 notebook.  All the machines use FedoraCore 8 or FedoraCore 9. 
With kernel prior to 2.6.28-rc, system boot doesn't fail.

I debug it and locate the root cause.  See
http://bugzilla.kernel.org/show_bug.cgi?id=11899
https://bugzilla.redhat.com/show_bug.cgi?id=471517

As a matter of fact, there are 2 bugs.

1) root=/dev/sda1, system boot randomly fails.  Mostly, boot for 5
   times and fails once.  nash has a bug.  Some of its functions misuse
   return value 0.  Sometimes, 0 means timeout and no uevent available. 
   Sometimes, 0 means nash gets an uevent, but the uevent isn't
   block-related (for exmaple, usb).  If by coincidence, kernel tells nash
   that uevents are available, but kernel also set timeout, nash might
   stops collecting other uevents in queue if current uevent isn't
   block-related.

   I work out a patch for nash to fix it. 
   http://bugzilla.kernel.org/attachment.cgi?id=18858

2) root=LABEL=/, system always can't boot.  initrd init reports
   switchroot fails.  Here is an executation branch of nash when booting:

    (1) nash read /sys/block/sda/dev; Assume major is 8 (on my desktop)

    (2) nash query /proc/devices with the major number; It found line  "8 sd";

    (3) nash use 'sd' to search its own probe table to find device
        (DISK) type for the device and add it to its own list;

    (4) Later on, it probes all devices in its list to get
        filesystem labels; scsi register "8 sd" always.

When major is 259, nash fails to find the device(DISK) type.  I enables
CONFIG_DEBUG_BLOCK_EXT_DEVT=y when compiling kernel, so 259 is picked up
for device /dev/sda1, which causes nash to fail to find device (DISK)
type.  To fixing issue 2), I create a patch for nash and another patch for
kernel.

http://bugzilla.kernel.org/attachment.cgi?id=18859
http://bugzilla.kernel.org/attachment.cgi?id=18837

This patch registers blkext, a new block device in proc/devices.

With 2 patches on nash and 1 patch on kernel, I boot my machines for
dozens of times without failure.

Signed-off-by Zhang Yanmin <yanmin.zhang@linux.intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/genhd.c~genhd-register-the-block_ext_major-blockdev block/genhd.c
--- a/block/genhd.c~genhd-register-the-block_ext_major-blockdev
+++ a/block/genhd.c
@@ -1028,6 +1028,7 @@ static int __init proc_genhd_init(void)
 {
 	proc_create("diskstats", 0, NULL, &proc_diskstats_operations);
 	proc_create("partitions", 0, NULL, &proc_partitions_operations);
+	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
 	return 0;
 }
 module_init(proc_genhd_init);
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

genhd-register-the-block_ext_major-blockdev.patch

