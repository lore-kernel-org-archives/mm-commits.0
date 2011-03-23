From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:44 -0700
Message-ID: <201103232044.p2NKiKWA029062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933299Ab1CWUpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, a.zummo@towertech.it, andy.sharp@onstor.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-ds1511.c: world-writable sysfs nvram file
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybogy to write to NVRAM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andy Sharp <andy.sharp@onstor.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1511.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1511.c~drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file
+++ a/drivers/rtc/rtc-ds1511.c
@@ -468,7 +468,7 @@ ds1511_nvram_write(struct file *filp, st
 static struct bin_attribute ds1511_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = DS1511_RAM_MAX,
 	.read = ds1511_nvram_read,
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch

