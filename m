From: akpm@linux-foundation.org
Subject: [merged] zram-describe-device-attrs-in-documentation.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:50 -0700
Message-ID: <552fe91e.HEYuQJ4OCBO/1v3V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbbDPQsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: describe device attrs in documentation
has been removed from the -mm tree.  Its filename was
     zram-describe-device-attrs-in-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: describe device attrs in documentation

Briefly describe exported device stat attrs in zram documentation.  We
will eventually get rid of per-stat sysfs nodes and, thus, clean up
Documentation/ABI/testing/sysfs-block-zram file, which is the only source
of information about device sysfs nodes.

Add `num_migrated' description, since there is no independent
`num_migrated' sysfs node (and no corresponding sysfs-block-zram entry),
it will be exported via zram<id>/mm_stat file.

At this point we can provide minimal description, because sysfs-block-zram
still contains detailed information.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   48 +++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-describe-device-attrs-in-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-describe-device-attrs-in-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -98,20 +98,40 @@ size of the disk when not in use so a hu
 	mount /dev/zram1 /tmp
 
 7) Stats:
-	Per-device statistics are exported as various nodes under
-	/sys/block/zram<id>/
-		disksize
-		num_reads
-		num_writes
-		failed_reads
-		failed_writes
-		invalid_io
-		notify_free
-		zero_pages
-		orig_data_size
-		compr_data_size
-		mem_used_total
-		mem_used_max
+Per-device statistics are exported as various nodes under /sys/block/zram<id>/
+
+A brief description of exported device attritbutes. For more details please
+read Documentation/ABI/testing/sysfs-block-zram.
+
+Name            access            description
+----            ------            -----------
+disksize          RW    show and set the device's disk size
+initstate         RO    shows the initialization state of the device
+reset             WO    trigger device reset
+num_reads         RO    the number of reads
+failed_reads      RO    the number of failed reads
+num_write         RO    the number of writes
+failed_writes     RO    the number of failed writes
+invalid_io        RO    the number of non-page-size-aligned I/O requests
+max_comp_streams  RW    the number of possible concurrent compress operations
+comp_algorithm    RW    show and change the compression algorithm
+notify_free       RO    the number of notifications to free pages (either
+                        slot free notifications or REQ_DISCARD requests)
+zero_pages        RO    the number of zero filled pages written to this disk
+orig_data_size    RO    uncompressed size of data stored in this disk
+compr_data_size   RO    compressed size of data stored in this disk
+mem_used_total    RO    the amount of memory allocated for this disk
+mem_used_max      RW    the maximum amount memory zram have consumed to
+                        store compressed data
+mem_limit         RW    the maximum amount of memory ZRAM can use to store
+                        the compressed data
+num_migrated      RO    the number of objects migrated migrated by compaction
+
+
+File /sys/block/zram<id>/stat
+
+Represents block layer statistics. Read Documentation/block/stat.txt for
+details.
 
 8) Deactivate:
 	swapoff /dev/zram0
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

