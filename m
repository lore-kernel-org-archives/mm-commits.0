From: akpm@linux-foundation.org
Subject: - tty_io-use-kzalloc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:42 -0700
Message-ID: <200707162054.l6GKsgkR001845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbXGPVZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_io: Use kzalloc
has been removed from the -mm tree.  Its filename was
     tty_io-use-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty_io: Use kzalloc
From: Jean Delvare <khali@linux-fr.org>

Also remove needless casts.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/char/tty_io.c~tty_io-use-kzalloc drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_io-use-kzalloc
+++ a/drivers/char/tty_io.c
@@ -2033,11 +2033,9 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*ltp_loc) {
-		ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
-						 GFP_KERNEL);
+		ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
 		if (!ltp)
 			goto free_mem_out;
-		memset(ltp, 0, sizeof(struct ktermios));
 	}
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY) {
@@ -2066,11 +2064,9 @@ static int init_dev(struct tty_driver *d
 		}
 
 		if (!*o_ltp_loc) {
-			o_ltp = (struct ktermios *)
-				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+			o_ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_ltp)
 				goto free_mem_out;
-			memset(o_ltp, 0, sizeof(struct ktermios));
 		}
 
 		/*
@@ -3755,9 +3751,8 @@ struct tty_driver *alloc_tty_driver(int 
 {
 	struct tty_driver *driver;
 
-	driver = kmalloc(sizeof(struct tty_driver), GFP_KERNEL);
+	driver = kzalloc(sizeof(struct tty_driver), GFP_KERNEL);
 	if (driver) {
-		memset(driver, 0, sizeof(struct tty_driver));
 		driver->magic = TTY_DRIVER_MAGIC;
 		driver->num = lines;
 		/* later we'll move allocation of tables here */
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-dvb.patch
git-hwmon.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
applesmc-add-temperature-sensors-set-for-macbook.patch
ams-switch-to-using-input-polldev.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
omap-add-ti-twl92330-menelaus-power-management-chip-driver.patch
