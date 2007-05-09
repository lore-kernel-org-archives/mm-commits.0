From: akpm@linux-foundation.org
Subject: - clean-up-mutex_trylock-noise.patch removed from -mm tree
Date: Tue, 08 May 2007 19:51:05 -0700
Message-ID: <200705090251.l492p5Wo009422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032159AbXEICvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, dwmw2@infradead.org, mchehab@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Clean up mutex_trylock noise
has been removed from the -mm tree.  Its filename was
     clean-up-mutex_trylock-noise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -216,7 +216,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	int last_devnum = -1;
 	struct gendisk *gd;
 
-	if (!!mutex_trylock(&mtd_table_mutex)) {
+	if (mutex_trylock(&mtd_table_mutex)) {
 		mutex_unlock(&mtd_table_mutex);
 		BUG();
 	}
@@ -294,7 +294,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 
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
applesmc-use-the-address-as-platform-device-id.patch
applesmc-use-standard-sysfs-names-for-labels.patch
git-alsa.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
x86-msr-add-support-for-safe-variants.patch
