From: akpm@linux-foundation.org
Subject: [merged] zram-remove-num_migrated-device-attr.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:53:44 -0700
Message-ID: <552fe918.BpFFP+34Cf85Midn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove `num_migrated' device attr
has been removed from the -mm tree.  Its filename was
     zram-remove-num_migrated-device-attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove `num_migrated' device attr

This patch introduces rework to zram stats.  We have per-stat sysfs nodes,
and it makes things a bit hard to use in user space: it doesn't give an
immediate stats 'snapshot', it requires user space to use more syscalls -
open, read, close for every stat file, with appropriate error checks on
every step, etc.

First, zram now accounts block layer statistics, available in
/sys/block/zram<id>/stat and /proc/diskstats files.  So some new stats are
available (see Documentation/block/stat.txt), besides, zram's activities
now can be monitored by sysstat's iostat or similar tools.

Example:
cat /sys/block/zram0/stat
248     0    1984    0   251029     0  2008232   5120   0   5116   5116



Second, group currently exported on per-stat basis nodes into two
categories (files):

-- zram<id>/io_stat
accumulates device's IO stats, that are not accounted by block layer,
and contains:
        failed_reads
        failed_writes
        invalid_io
        notify_free

Example:
cat /sys/block/zram0/io_stat
0        0        0   652572


-- zram<id>/mm_stat
accumulates zram mm stats and contains:
        orig_data_size
        compr_data_size
        mem_used_total
        mem_limit
        mem_used_max
        zero_pages
        num_migrated


Example:
cat /sys/block/zram0/mm_stat
434634752 270288572 279158784        0 579895296    15060        0


per-stat sysfs nodes are now considered to be deprecated and we plan to
remove them (and clean up some of the existing stat code) in two years (as
of now, there is no warning printed to syslog about deprecated stats being
used).  User space is advised to use the above mentioned 3 files.



This patch (of 7):

Remove sysfs `num_migrated' attribute.  We are moving away from per-stat
device attrs towards 3 stat files that will accumulate io and mm stats in
a format similar to block layer statistics in /sys/block/<dev>/stat.  That
will be easier to use in user space, and reduce the number of syscalls
needed to read zram device statistics.

`num_migrated' will return back in zram<id>/mm_stat file.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    7 -------
 drivers/block/zram/zram_drv.c              |    2 --
 2 files changed, 9 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-remove-num_migrated-device-attr Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-remove-num_migrated-device-attr
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -149,10 +149,3 @@ Description:
 		The compact file is write-only and trigger compaction for
 		allocator zrm uses. The allocator moves some objects so that
 		it could free fragment space.
-
-What:		/sys/block/zram<id>/num_migrated
-Date:		August 2015
-Contact:	Minchan Kim <minchan@kernel.org>
-Description:
-		The compact file is read-only and shows how many object
-		migrated by compaction.
diff -puN drivers/block/zram/zram_drv.c~zram-remove-num_migrated-device-attr drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-num_migrated-device-attr
+++ a/drivers/block/zram/zram_drv.c
@@ -1057,7 +1057,6 @@ ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
 ZRAM_ATTR_RO(compr_data_size);
-ZRAM_ATTR_RO(num_migrated);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -1067,7 +1066,6 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
-	&dev_attr_num_migrated.attr,
 	&dev_attr_compact.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

