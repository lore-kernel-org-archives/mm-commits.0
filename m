From: akpm@linux-foundation.org
Subject: [merged] aic94xx-world-writable-sysfs-update_bios-file.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:51 -0700
Message-ID: <201105252031.p4PKVE0L015048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab1EYUcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     aic94xx: world-writable sysfs update_bios file
has been removed from the -mm tree.  Its filename was
     aic94xx-world-writable-sysfs-update_bios-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aic94xx: world-writable sysfs update_bios file
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to load firmware.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-world-writable-sysfs-update_bios-file drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~aic94xx-world-writable-sysfs-update_bios-file
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -486,7 +486,7 @@ static ssize_t asd_show_update_bios(stru
 			flash_error_table[i].reason);
 }
 
-static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUGO,
+static DEVICE_ATTR(update_bios, S_IRUGO|S_IWUSR,
 	asd_show_update_bios, asd_store_update_bios);
 
 static int asd_create_dev_attrs(struct asd_ha_struct *asd_ha)
_

Patches currently in -mm which might be from segoon@openwall.com are

origin.patch
linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

