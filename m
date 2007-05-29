From: akpm@linux-foundation.org
Subject: + tty_io-use-kzalloc.patch added to -mm tree
Date: Tue, 29 May 2007 13:44:34 -0700
Message-ID: <200705292044.l4TKiYf0011101@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307AbXE2Uo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, alan@redhat.com


The patch titled
     tty_io: Use kzalloc
has been added to the -mm tree.  Its filename is
     tty_io-use-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty_io: Use kzalloc
From: Jean Delvare <khali@linux-fr.org>

Also remove needless casts.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/char/tty_io.c~tty_io-use-kzalloc drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_io-use-kzalloc
+++ a/drivers/char/tty_io.c
@@ -2026,11 +2026,9 @@ static int init_dev(struct tty_driver *d
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
@@ -2059,11 +2057,9 @@ static int init_dev(struct tty_driver *d
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
@@ -3748,9 +3744,8 @@ struct tty_driver *alloc_tty_driver(int 
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

hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
tty_io-use-kzalloc.patch
