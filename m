From: akpm@linux-foundation.org
Subject: - char-cyclades-cy_init-error-handling.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:11 -0700
Message-ID: <200705090257.l492vBmq010150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032751AbXEIC5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, cy_init error handling
has been removed from the -mm tree.  Its filename was
     char-cyclades-cy_init-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, cy_init error handling
From: Jiri Slaby <jirislaby@gmail.com>

- do not panic if tty_register_driver fails
- handle fail paths properly

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-cy_init-error-handling drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-cy_init-error-handling
+++ a/drivers/char/cyclades.c
@@ -5460,10 +5460,11 @@ static const struct tty_operations cy_op
 static int __init cy_init(void)
 {
 	unsigned int i, nboards;
+	int retval = -ENOMEM;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
-		return -ENOMEM;
+		goto err;
 	show_version();
 
 	/* Initialize the tty_driver structure */
@@ -5481,8 +5482,11 @@ static int __init cy_init(void)
 	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(cy_serial_driver, &cy_ops);
 
-	if (tty_register_driver(cy_serial_driver))
-		panic("Couldn't register Cyclades serial driver\n");
+	retval = tty_register_driver(cy_serial_driver);
+	if (retval) {
+		printk(KERN_ERR "Couldn't register Cyclades serial driver\n");
+		goto err_frtty;
+	}
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* base_addr=0 indicates board not found */
@@ -5508,7 +5512,18 @@ static int __init cy_init(void)
 	/* look for pci boards */
 	nboards += cy_detect_pci();
 
-	return nboards ? 0 : -ENODEV;
+	if (nboards == 0) {
+		retval = -ENODEV;
+		goto err_unr;
+	}
+
+	return 0;
+err_unr:
+	tty_unregister_driver(cy_serial_driver);
+err_frtty:
+	put_tty_driver(cy_serial_driver);
+err:
+	return retval;
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
