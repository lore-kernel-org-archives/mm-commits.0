From: akpm@linux-foundation.org
Subject: + aic94xx-world-writable-sysfs-update_bios-file.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:17:08 -0700
Message-ID: <201103142217.p2EMH852014192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386Ab1CNWSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, James.Bottomley@HansenPartnership.com


The patch titled
     aic94xx: world-writable sysfs update_bios file
has been added to the -mm tree.  Its filename is
     aic94xx-world-writable-sysfs-update_bios-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-leds-leds-lp5521c-world-writable-sysfs-engine-files.patch
drivers-leds-leds-lp5523c-world-writable-engine-sysfs-files.patch
drivers-misc-ep93xx_pwmc-world-writable-sysfs-files.patch
drivers-rtc-rtc-ds1511c-world-writable-sysfs-nvram-file.patch
aic94xx-world-writable-sysfs-update_bios-file.patch
drivers-scsi-scsi_transport_iscsic-world-writable-sysfs-priv_sess-file.patch

