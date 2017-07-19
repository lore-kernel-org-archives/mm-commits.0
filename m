From: akpm@linux-foundation.org
Subject: + zram-add-config-and-doc-file-for-writeback-feature.patch added
 to -mm tree
Date: Wed, 19 Jul 2017 16:08:25 -0700
Message-ID: <596fe669.usH10cwRf6+A3LhO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933492AbdGSXI0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add config and doc file for writeback feature
has been added to the -mm tree.  Its filename is
     zram-add-config-and-doc-file-for-writeback-feature.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-config-and-doc-file-for-writeback-feature.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-config-and-doc-file-for-writeback-feature.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

