From: akpm@linux-foundation.org
Subject: [merged]
 zram-add-config-and-doc-file-for-writeback-feature.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:37:49 -0700
Message-ID: <20170907183749.ud05JZNzY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbdIGShu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juno.choi@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: zram: add config and doc file for writeback feature
has been removed from the -mm tree.  Its filename was
     zram-add-config-and-doc-file-for-writeback-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add config and doc file for writeback feature

This patch adds document and kconfig for using of writeback feature.

Link: http://lkml.kernel.org/r/1498459987-24562-10-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    8 ++++++++
 Documentation/blockdev/zram.txt            |   11 +++++++++++
 drivers/block/zram/Kconfig                 |   12 ++++++++++++
 3 files changed, 31 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-add-config-and-doc-file-for-writeback-feature Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-add-config-and-doc-file-for-writeback-feature
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -90,3 +90,11 @@ Description:
 		device's debugging info useful for kernel developers. Its
 		format is not documented intentionally and may change
 		anytime without any notice.
+
+What:		/sys/block/zram<id>/backing_dev
+Date:		June 2017
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		The backing_dev file is read-write and set up backing
+		device for zram to write incompressible pages.
+		For using, user should enable CONFIG_ZRAM_WRITEBACK.
diff -puN Documentation/blockdev/zram.txt~zram-add-config-and-doc-file-for-writeback-feature Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-config-and-doc-file-for-writeback-feature
+++ a/Documentation/blockdev/zram.txt
@@ -168,6 +168,7 @@ max_comp_streams  RW    the number of po
 comp_algorithm    RW    show and change the compression algorithm
 compact           WO    trigger memory compaction
 debug_stat        RO    this file is used for zram debugging purposes
+backing_dev	  RW	set up backend storage for zram to write out
 
 
 User space is advised to use the following files to read the device statistics.
@@ -231,5 +232,15 @@ line of text and contains the following
 	resets the disksize to zero. You must set the disksize again
 	before reusing the device.
 
+* Optional Feature
+
+= writeback
+
+With incompressible pages, there is no memory saving with zram.
+Instead, with CONFIG_ZRAM_WRITEBACK, zram can write incompressible page
+to backing storage rather than keeping it in memory.
+User should set up backing device via /sys/block/zramX/backing_dev
+before disksize setting.
+
 Nitin Gupta
 ngupta@vflare.org
diff -puN drivers/block/zram/Kconfig~zram-add-config-and-doc-file-for-writeback-feature drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-add-config-and-doc-file-for-writeback-feature
+++ a/drivers/block/zram/Kconfig
@@ -13,3 +13,15 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
+
+config ZRAM_WRITEBACK
+       bool "Write back incompressible page to backing device"
+       depends on ZRAM
+       default n
+       help
+	 With incompressible page, there is no memory saving to keep it
+	 in memory. Instead, write it out to backing device.
+	 For this feature, admin should set up backing device via
+	 /sys/block/zramX/backing_dev.
+
+	 See zram.txt for more infomration.
_

Patches currently in -mm which might be from minchan@kernel.org are


