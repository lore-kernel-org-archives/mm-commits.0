From: akpm@linux-foundation.org
Subject: + hil-small-fix.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:28:07 -0800
Message-ID: <200702052128.l15LS7sv031618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933466AbXBEV2O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, dtor@mail.ru


The patch titled
     HIL: small fix
has been added to the -mm tree.  Its filename is
     hil-small-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HIL: small fix
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>

This patch adds checking for errors in hil_keyb_init.  Also some extra
spaces are removed.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/hilkbd.c |  106 +++++++++++++++++-------------
 1 files changed, 62 insertions(+), 44 deletions(-)

diff -puN drivers/input/keyboard/hilkbd.c~hil-small-fix drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~hil-small-fix
+++ a/drivers/input/keyboard/hilkbd.c
@@ -6,10 +6,10 @@
  *  Copyright (C) 1999-2006 Helge Deller <deller@gmx.de>
  *
  *  Very basic HP Human Interface Loop (HIL) driver.
- *  This driver handles the keyboard on HP300 (m68k) and on some 
+ *  This driver handles the keyboard on HP300 (m68k) and on some
  *  HP700 (parisc) series machines.
  *
- * 
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License version 2.  See the file COPYING in the main directory of this
  * archive for more details.
@@ -64,9 +64,9 @@ MODULE_LICENSE("GPL v2");
 #endif
 
 
- 
+
 /* HIL helper functions */
- 
+
 #define hil_busy()              (hil_readb(HILBASE + HIL_CMD) & HIL_BUSY)
 #define hil_data_available()    (hil_readb(HILBASE + HIL_CMD) & HIL_DATA_RDY)
 #define hil_status()            (hil_readb(HILBASE + HIL_CMD))
@@ -75,7 +75,7 @@ MODULE_LICENSE("GPL v2");
 #define hil_write_data(x)       do { hil_writeb((x), HILBASE + HIL_DATA); } while (0)
 
 /* HIL constants */
- 
+
 #define	HIL_BUSY		0x02
 #define	HIL_DATA_RDY		0x01
 
@@ -89,7 +89,7 @@ MODULE_LICENSE("GPL v2");
 #define	HIL_READKBDSADR	 	0xF9
 #define	HIL_WRITEKBDSADR 	0xE9
 
-static unsigned int hphilkeyb_keycode[HIL_KEYCODES_SET1_TBLSIZE] = 
+static unsigned int hphilkeyb_keycode[HIL_KEYCODES_SET1_TBLSIZE] =
 	{ HIL_KEYCODES_SET1 };
 
 /* HIL structure */
@@ -97,11 +97,11 @@ static struct {
 	struct input_dev *dev;
 
 	unsigned int curdev;
-	
+
 	unsigned char s;
 	unsigned char c;
 	int valid;
-	
+
 	unsigned char data[16];
 	unsigned int ptr;
 	spinlock_t lock;
@@ -115,7 +115,7 @@ static void poll_finished(void)
 	int down;
 	int key;
 	unsigned char scode;
-	
+
 	switch (hil_dev.data[0]) {
 	case 0x40:
 		down = (hil_dev.data[1] & 1) == 0;
@@ -127,6 +127,7 @@ static void poll_finished(void)
 	hil_dev.curdev = 0;
 }
 
+
 static inline void handle_status(unsigned char s, unsigned char c)
 {
 	if (c & 0x8) {
@@ -143,6 +144,7 @@ static inline void handle_status(unsigne
 	}
 }
 
+
 static inline void handle_data(unsigned char s, unsigned char c)
 {
 	if (hil_dev.curdev) {
@@ -152,13 +154,11 @@ static inline void handle_data(unsigned 
 }
 
 
-/* 
- * Handle HIL interrupts.
- */
+/* handle HIL interrupts */
 static irqreturn_t hil_interrupt(int irq, void *handle)
 {
 	unsigned char s, c;
-	
+
 	s = hil_status();
 	c = hil_read_data();
 
@@ -179,10 +179,8 @@ static irqreturn_t hil_interrupt(int irq
 	return IRQ_HANDLED;
 }
 
-/*
- * Send a command to the HIL
- */
 
+/* send a command to the HIL */
 static void hil_do(unsigned char cmd, unsigned char *data, unsigned int len)
 {
 	unsigned long flags;
@@ -200,16 +198,14 @@ static void hil_do(unsigned char cmd, un
 }
 
 
-/*
- * Initialise HIL. 
- */
-
+/* initialise HIL */
 static int __init
 hil_keyb_init(void)
 {
 	unsigned char c;
 	unsigned int i, kbid;
 	wait_queue_head_t hil_wait;
+	int err;
 
 	if (hil_dev.dev) {
 		return -ENODEV; /* already initialized */
@@ -219,15 +215,25 @@ hil_keyb_init(void)
 	if (!hil_dev.dev)
 		return -ENOMEM;
 	hil_dev.dev->private = &hil_dev;
-	
+
 #if defined(CONFIG_HP300)
-	if (!hwreg_present((void *)(HILBASE + HIL_DATA)))
-		return -ENODEV;
-	
-	request_region(HILBASE+HIL_DATA, 2, "hil");
+	if (!hwreg_present((void *)(HILBASE + HIL_DATA))) {
+		printk(KERN_ERR "HIL: hardware register was not found\n");
+		err = -ENODEV;
+		goto err1;
+	}
+	if (!request_region(HILBASE + HIL_DATA, 2, "hil")) {
+		printk(KERN_ERR "HIL: IOPORT region already used\n");
+		err = -EIO;
+		goto err1;
+	}
 #endif
-	
-	request_irq(HIL_IRQ, hil_interrupt, 0, "hil", hil_dev.dev_id);
+
+	err = request_irq(HIL_IRQ, hil_interrupt, 0, "hil", hil_dev.dev_id);
+	if (err) {
+		printk(KERN_ERR "HIL: Can't get IRQ\n");
+		goto err2;
+	}
 
 	/* Turn on interrupts */
 	hil_do(HIL_INTON, NULL, 0);
@@ -239,32 +245,32 @@ hil_keyb_init(void)
 	init_waitqueue_head(&hil_wait);
 	wait_event_interruptible_timeout(hil_wait, hil_dev.valid, 3*HZ);
 	if (!hil_dev.valid) {
-		printk(KERN_WARNING "HIL: timed out, assuming no keyboard present.\n");
+		printk(KERN_WARNING "HIL: timed out, assuming no keyboard present\n");
 	}
 
-	c = hil_dev.c; 
+	c = hil_dev.c;
 	hil_dev.valid = 0;
 	if (c == 0) {
 		kbid = -1;
-		printk(KERN_WARNING "HIL: no keyboard present.\n");
+		printk(KERN_WARNING "HIL: no keyboard present\n");
 	} else {
 		kbid = ffz(~c);
-		/* printk(KERN_INFO "HIL: keyboard found at id %d\n", kbid); */
+		printk(KERN_INFO "HIL: keyboard found at id %d\n", kbid);
 	}
 
 	/* set it to raw mode */
 	c = 0;
 	hil_do(HIL_WRITEKBDSADR, &c, 1);
-	
+
 	for (i = 0; i < HIL_KEYCODES_SET1_TBLSIZE; i++)
 		if (hphilkeyb_keycode[i] != KEY_RESERVED)
 			set_bit(hphilkeyb_keycode[i], hil_dev.dev->keybit);
 
-	hil_dev.dev->evbit[0]    = BIT(EV_KEY) | BIT(EV_REP);
-	hil_dev.dev->ledbit[0]   = BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL);
-	hil_dev.dev->keycodemax  = HIL_KEYCODES_SET1_TBLSIZE;
-	hil_dev.dev->keycodesize = sizeof(hphilkeyb_keycode[0]);
-	hil_dev.dev->keycode     = hphilkeyb_keycode;
+	hil_dev.dev->evbit[0]	= BIT(EV_KEY) | BIT(EV_REP);
+	hil_dev.dev->ledbit[0]	= BIT(LED_NUML) | BIT(LED_CAPSL) | BIT(LED_SCROLLL);
+	hil_dev.dev->keycodemax	= HIL_KEYCODES_SET1_TBLSIZE;
+	hil_dev.dev->keycodesize= sizeof(hphilkeyb_keycode[0]);
+	hil_dev.dev->keycode	= hphilkeyb_keycode;
 	hil_dev.dev->name 	= "HIL keyboard";
 	hil_dev.dev->phys 	= "hpkbd/input0";
 
@@ -273,13 +279,29 @@ hil_keyb_init(void)
 	hil_dev.dev->id.product	= 0x0001;
 	hil_dev.dev->id.version	= 0x0010;
 
-	input_register_device(hil_dev.dev);
+	err = input_register_device(hil_dev.dev);
+	if (err) {
+		printk(KERN_ERR "HIL: Can't register device\n");
+		goto err3;
+	}
 	printk(KERN_INFO "input: %s, ID %d at 0x%08lx (irq %d) found and attached\n",
-		hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
+	       hil_dev.dev->name, kbid, HILBASE, HIL_IRQ);
 
 	return 0;
+
+err3:
+	hil_do(HIL_INTOFF, NULL, 0);
+	disable_irq(HIL_IRQ);
+	free_irq(HIL_IRQ, hil_dev.dev_id);
+err2:
+	release_region(HILBASE + HIL_DATA, 2);
+err1:
+	input_free_device(hil_dev.dev);
+	hil_dev.dev = NULL;
+	return err;
 }
 
+
 #if defined(CONFIG_PARISC)
 static int __init
 hil_init_chip(struct parisc_device *dev)
@@ -292,7 +314,7 @@ hil_init_chip(struct parisc_device *dev)
 	hil_base = dev->hpa.start;
 	hil_irq  = dev->irq;
 	hil_dev.dev_id = dev;
-	
+
 	printk(KERN_INFO "Found HIL bus at 0x%08lx, IRQ %d\n", hil_base, hil_irq);
 
 	return hil_keyb_init();
@@ -313,9 +335,6 @@ static struct parisc_driver hil_driver =
 #endif /* CONFIG_PARISC */
 
 
-
-
-
 static int __init hil_init(void)
 {
 #if defined(CONFIG_PARISC)
@@ -349,4 +368,3 @@ static void __exit hil_exit(void)
 
 module_init(hil_init);
 module_exit(hil_exit);
-
_

Patches currently in -mm which might be from gorcunov@gmail.com are

hil-small-fix.patch
qconf-fix-showing-help-info-on-failed-search.patch
qconf-back-button-behaviour-normalization.patch
