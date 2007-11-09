From: akpm@linux-foundation.org
Subject: + rd-use-is_power_of_2-in-drivers-block-rdc.patch added to -mm tree
Date: Fri, 09 Nov 2007 12:51:32 -0800
Message-ID: <200711092051.lA9KpWhx031297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbXKIUvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 15:51:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     rd: use is_power_of_2() in drivers/block/rd.c.
has been added to the -mm tree.  Its filename is
     rd-use-is_power_of_2-in-drivers-block-rdc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rd: use is_power_of_2() in drivers/block/rd.c.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/rd.c~rd-use-is_power_of_2-in-drivers-block-rdc drivers/block/rd.c
--- a/drivers/block/rd.c~rd-use-is_power_of_2-in-drivers-block-rdc
+++ a/drivers/block/rd.c
@@ -56,6 +56,7 @@
 #include <linux/backing-dev.h>
 #include <linux/blkpg.h>
 #include <linux/writeback.h>
+#include <linux/log2.h>
 
 #include <asm/uaccess.h>
 
@@ -437,7 +438,7 @@ static int __init rd_init(void)
 	err = -ENOMEM;
 
 	if (rd_blocksize > PAGE_SIZE || rd_blocksize < 512 ||
-			(rd_blocksize & (rd_blocksize-1))) {
+			!is_power_of_2(rd_blocksize)) {
 		printk("RAMDISK: wrong blocksize %d, reverting to defaults\n",
 		       rd_blocksize);
 		rd_blocksize = BLOCK_SIZE;
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
hwmon-replace-power-of-two-test-in-drivers-hwmon-adt7470c.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-sparc64.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
