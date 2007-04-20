From: akpm@linux-foundation.org
Subject: + clean-up-mutex_trylock-noise.patch added to -mm tree
Date: Fri, 20 Apr 2007 16:03:33 -0700
Message-ID: <200704202303.l3KN3Xoh025926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767310AbXDTXEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 19:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, dwmw2@infradead.org, mchehab@infradead.org, mingo@elte.hu


The patch titled
     Clean up mutex_trylock noise
has been added to the -mm tree.  Its filename is
     clean-up-mutex_trylock-noise.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up mutex_trylock noise
From: Jean Delvare <khali@linux-fr.org>

Ingo Molnar's semaphore to mutex conversions left some noise on a few
trylock calls. Clean it up.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/zoran_driver.c |    2 +-
 drivers/mtd/mtd_blkdevs.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/zoran_driver.c~clean-up-mutex_trylock-noise drivers/media/video/zoran_driver.c
--- a/drivers/media/video/zoran_driver.c~clean-up-mutex_trylock-noise
+++ a/drivers/media/video/zoran_driver.c
@@ -2034,7 +2034,7 @@ zoran_do_ioctl (struct inode *inode,
 	 * but moving the free code outside the munmap() handler fixes
 	 * all this... If someone knows why, please explain me (Ronald)
 	 */
-	if (!!mutex_trylock(&zr->resource_lock)) {
+	if (mutex_trylock(&zr->resource_lock)) {
 		/* we obtained it! Let's try to free some things */
 		if (fh->jpg_buffers.ready_to_be_freed)
 			jpg_fbuffer_free(file);
diff -puN drivers/mtd/mtd_blkdevs.c~clean-up-mutex_trylock-noise drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~clean-up-mutex_trylock-noise
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -226,7 +226,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	int last_devnum = -1;
 	struct gendisk *gd;
 
-	if (!!mutex_trylock(&mtd_table_mutex)) {
+	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
 	}
@@ -304,7 +304,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 
 int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 {
-	if (!!mutex_trylock(&mtd_table_mutex)) {
+	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
 	}
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
x86-msr-add-support-for-safe-variants.patch
git-alsa.patch
git-dvb.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-hardware-monitoring-and-control-fix.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
git-ieee1394.patch
git-netdev-all.patch
git-net.patch
xtensa-strlcpy-is-smart-enough.patch
oss-strlcpy-is-smart-enough.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
legacy-pc-parports-support-parport-dev.patch
layered-parport-code-uses-parport-dev.patch
clean-up-mutex_trylock-noise.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
