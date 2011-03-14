From: akpm@linux-foundation.org
Subject: + arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch added to -mm tree
Date: Mon, 14 Mar 2011 15:16:56 -0700
Message-ID: <201103142216.p2EMGulM014164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab1CNWSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 18:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, linus.walleij@stericsson.com, linux@arm.linux.org.uk, srinidhi.kasagar@stericsson.com


The patch titled
     arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
has been added to the -mm tree.  Its filename is
     arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

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
Subject: arch/arm/mach-ux500/mbox-db5500.c: world-writable sysfs fifo file
From: Vasiliy Kulikov <segoon@openwall.com>

Don't allow everybody to use a modem.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ux500/mbox-db5500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-ux500/mbox-db5500.c~arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file arch/arm/mach-ux500/mbox-db5500.c
--- a/arch/arm/mach-ux500/mbox-db5500.c~arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file
+++ a/arch/arm/mach-ux500/mbox-db5500.c
@@ -168,7 +168,7 @@ static ssize_t mbox_read_fifo(struct dev
 	return sprintf(buf, "0x%X\n", mbox_value);
 }
 
-static DEVICE_ATTR(fifo, S_IWUGO | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
+static DEVICE_ATTR(fifo, S_IWUSR | S_IRUGO, mbox_read_fifo, mbox_write_fifo);
 
 static int mbox_show(struct seq_file *s, void *data)
 {
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

