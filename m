From: akpm@linux-foundation.org
Subject: + zram-describe-device-attrs-in-documentation.patch added to -mm
 tree
Date: Mon, 16 Mar 2015 16:17:19 -0700
Message-ID: <5507647f.MxdSTeITZBMCSzDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbbCPXRU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 19:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: describe device attrs in documentation
has been added to the -mm tree.  Its filename is
     zram-describe-device-attrs-in-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-describe-device-attrs-in-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-describe-device-attrs-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 Documentation/blockdev/zram.txt |   49 +++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-describe-device-attrs-in-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-describe-device-attrs-in-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -117,20 +117,41 @@ execute
 	echo X > /sys/class/zram-control/zram_remove
 
 8) Stats:
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
+compact           WO    trigger memory compaction
+
+
+File /sys/block/zram<id>/stat
+
+Represents block layer statistics. Read Documentation/block/stat.txt for
+details.
 
 9) Deactivate:
 	swapoff /dev/zram0
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

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
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

