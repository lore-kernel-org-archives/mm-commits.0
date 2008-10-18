From: akpm@linux-foundation.org
Subject: - block-sanitize-invalid-partition-table-entries.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:06 -0700
Message-ID: <200810182319.m9INJ6FS029426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYJRXUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, herton@mandriva.com.br, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: sanitize invalid partition table entries
has been removed from the -mm tree.  Its filename was
     block-sanitize-invalid-partition-table-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: sanitize invalid partition table entries
From: Kay Sievers <kay.sievers@vrfy.org>

We currently follow blindly what the partition table lies about the
disk, and let the kernel create block devices which can not be accessed.
Trying to identify the device leads to kernel logs full of:
  sdb: rw=0, want=73392, limit=28800
  attempt to access beyond end of device

Here is an example of a broken partition table, where sda2 starts
behind the end of the disk, and sdb3 is larger than the entire disk:
  Disk /dev/sdb: 14 MB, 14745600 bytes
  1 heads, 29 sectors/track, 993 cylinders, total 28800 sectors
     Device Boot      Start         End      Blocks   Id  System
  /dev/sdb1              29        7800        3886   83  Linux
  /dev/sdb2           37801       45601        3900+  83  Linux
  /dev/sdb3           15602       73402       28900+  83  Linux
  /dev/sdb4           23403       28796        2697   83  Linux

The kernel creates these completely invalid devices, which can not be
accessed, or may lead to other unpredictable failures:
  grep . /sys/class/block/sdb*/{start,size}
  /sys/class/block/sdb/size:28800
  /sys/class/block/sdb1/start:29
  /sys/class/block/sdb1/size:7772
  /sys/class/block/sdb2/start:37801
  /sys/class/block/sdb2/size:7801
  /sys/class/block/sdb3/start:15602
  /sys/class/block/sdb3/size:57801
  /sys/class/block/sdb4/start:23403
  /sys/class/block/sdb4/size:5394

With this patch, we ignore partitions which start behind the end of the disk,
and limit partitions to the end of the disk if they pretend to be larger:
  grep . /sys/class/block/sdb*/{start,size}
  /sys/class/block/sdb/size:28800
  /sys/class/block/sdb1/start:29
  /sys/class/block/sdb1/size:7772
  /sys/class/block/sdb3/start:15602
  /sys/class/block/sdb3/size:13198
  /sys/class/block/sdb4/start:23403
  /sys/class/block/sdb4/size:5394

These warnings are printed to the kernel log:
  sdb: p2 ignored, start 37801 is behind the end of the disk
  sdb: p3 size 57801 limited to end of disk

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/partitions/check.c~block-sanitize-invalid-partition-table-entries fs/partitions/check.c
--- a/fs/partitions/check.c~block-sanitize-invalid-partition-table-entries
+++ a/fs/partitions/check.c
@@ -538,10 +538,23 @@ int rescan_partitions(struct gendisk *di
 		sector_t from = state->parts[p].from;
 		if (!size)
 			continue;
+		if (from >= get_capacity(disk)) {
+			printk(KERN_WARNING
+			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
+			       disk->disk_name, p, (unsigned long long) from);
+			continue;
+		}
 		if (from + size > get_capacity(disk)) {
+			/*
+			 * we can not ignore partitions of broken tables
+			 * created by for example camera firmware, but we
+			 * limit them to the end of the disk to avoid
+			 * creating invalid block devices
+			 */
 			printk(KERN_WARNING
-				"%s: p%d exceeds device capacity\n",
-				disk->disk_name, p);
+			       "%s: p%d size %llu limited to end of disk\n",
+			       disk->disk_name, p, (unsigned long long) size);
+			size = get_capacity(disk) - from;
 		}
 		res = add_partition(disk, p, from, size, state->parts[p].flags);
 		if (res) {
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch

