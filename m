From: akpm@linux-foundation.org
Subject: [merged] fs-block_devc-page-cache-wrongly-left-invalidated-after-revalidate_disk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:39 -0800
Message-ID: <20130222203739.D87D65A41B6__23764.8898190402$1361565496$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57640 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3BVUhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:41 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so103501vcd.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herumi@nifty.com, jmoyer@redhat.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-page-cache-wrongly-left-invalidated-after-revalidate_disk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: MITSUNARI Shigeo <herumi@nifty.com>
Subject: fs/block_dev.c: page cache wrongly left invalidated after revalidate_disk()

We found that bdev->bd_invalidated was left set once revalidate_disk() is
called, which results in page cache flush every time that device is open.

Specifically, we found this problem in MD block device.  Once we resize a
MD device, mdadm --monitor periodically flush all page cache for that
device every 60 or 1000 seconds when it opens the device.

This bug lies since at least 3.2.0 till the latest kernel(3.6.2).
Patch is attached.

The following steps will reproduce the problem.

1. prepair a block device(ex. /dev/sdb).
2. create two partitions.

sudo parted /dev/sdb
mklabel gpt
mkpart primary 0% 50%
mkpart primary 50% 100% 

3. create a md device.

sudo mdadm -C /dev/md/hoge -l 1 -n 2 -e 1.2 --assume-clean --auto=md \
 --symlink=no /dev/sdb1 /dev/sdb2

4. create file system and mount it

sudo mkfs.ext3 /dev/md/hoge
sudo mkdir /mnt/test
sudo mount /dev/md/hoge /mnt/test

5. try to resize the device

sudo mdadm -G /dev/md/hoge --size=max

6. create a file to fill file cache.

sudo dd if=/dev/urandom of=/mnt/test/data bs=1M count=10
and verity the current status of file by free command.

7. mdadm monitor will open the md device every 1000 seconds
and you will find all file cache on the device are cleared.

The timing can be reduced by the following steps.

a) kill mdadm and restart it with --delay option
/sbin/mdadm --monitor --delay=30 --pid-file /var/run/mdadm/monitor.pid \
 --daemonise --scan --syslog

or open the md device directly.

sudo dd if=/dev/md/hoge of=/dev/null bs=4096 count=1

Signed-off-by: MITSUNARI Shigeo <herumi@nifty.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/block_dev.c~fs-block_devc-page-cache-wrongly-left-invalidated-after-revalidate_disk fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-page-cache-wrongly-left-invalidated-after-revalidate_disk
+++ a/fs/block_dev.c
@@ -994,6 +994,7 @@ int revalidate_disk(struct gendisk *disk
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
_

Patches currently in -mm which might be from herumi@nifty.com are

origin.patch

