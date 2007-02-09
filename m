From: akpm@linux-foundation.org
Subject: + input-scan_keyb-remove-it.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:03:37 -0800
Message-ID: <200702092303.l19N3bgA028740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbXBIXDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:03:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, dmitry.torokhov@gmail.com


The patch titled
     Input: scan_keyb, remove it
has been added to the -mm tree.  Its filename is
     input-scan_keyb-remove-it.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Input: scan_keyb, remove it
From: Jiri Slaby <jirislaby@gmail.com>

It's currently unused (unreferenced) beside the fact it's broken.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/scan_keyb.c |  149 -------------------------------------
 drivers/char/scan_keyb.h |   15 ---
 2 files changed, 164 deletions(-)

diff -puN drivers/char/scan_keyb.c~input-scan_keyb-remove-it /dev/null
--- a/drivers/char/scan_keyb.c
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- *	$Id: scan_keyb.c,v 1.2 2000/07/04 06:24:42 yaegashi Exp $ 
- *	Copyright (C) 2000 YAEGASHI Takeshi
- *	Generic scan keyboard driver
- */
-
-#include <linux/spinlock.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/tty.h>
-#include <linux/mm.h>
-#include <linux/signal.h>
-#include <linux/init.h>
-#include <linux/kbd_ll.h>
-#include <linux/delay.h>
-#include <linux/random.h>
-#include <linux/poll.h>
-#include <linux/miscdevice.h>
-#include <linux/slab.h>
-#include <linux/kbd_kern.h>
-#include <linux/timer.h>
-
-#define SCANHZ	(HZ/20)
-
-struct scan_keyboard {
-	struct scan_keyboard *next;
-	int (*scan)(unsigned char *buffer);
-	const unsigned char *table;
-	unsigned char *s0, *s1;
-	int length;
-};
-
-static int scan_jiffies=0;
-static struct scan_keyboard *keyboards=NULL;
-struct timer_list scan_timer;
-
-static void check_kbd(const unsigned char *table,
-		      unsigned char *new, unsigned char *old, int length)
-{
-	int need_tasklet_schedule=0;
-	unsigned int xor, bit;
-	
-	while(length-->0) {
-		if((xor=*new^*old)==0) {
-			table+=8;
-		}
-		else {
-			for(bit=0x01; bit<0x100; bit<<=1) {
-				if(xor&bit) {
-					handle_scancode(*table, !(*new&bit));
-					need_tasklet_schedule=1;
-#if 0
-					printk("0x%x %s\n", *table, (*new&bit)?"released":"pressed");
-#endif
-				}
-				table++;
-			}
-		}
-		new++; old++;
-	}
-
-	if(need_tasklet_schedule)
-		tasklet_schedule(&keyboard_tasklet);
-}
-
-
-static void scan_kbd(unsigned long dummy)
-{
-	struct scan_keyboard *kbd;
-
-	scan_jiffies++;
-
-	for(kbd=keyboards; kbd!=NULL; kbd=kbd->next) {
-		if(scan_jiffies&1) {
-			if(!kbd->scan(kbd->s0))
-				check_kbd(kbd->table,
-					  kbd->s0, kbd->s1, kbd->length);
-			else
-				memcpy(kbd->s0, kbd->s1, kbd->length);
-		}
-		else {
-			if(!kbd->scan(kbd->s1))
-				check_kbd(kbd->table,
-					  kbd->s1, kbd->s0, kbd->length);
-			else
-				memcpy(kbd->s1, kbd->s0, kbd->length);
-		}
-		
-	}
-
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
-}
-
-
-int register_scan_keyboard(int (*scan)(unsigned char *buffer),
-			   const unsigned char *table,
-			   int length)
-{
-	struct scan_keyboard *kbd;
-
-	kbd = kmalloc(sizeof(struct scan_keyboard), GFP_KERNEL);
-	if (kbd == NULL)
-		goto error_out;
-
-	kbd->scan=scan;
-	kbd->table=table;
-	kbd->length=length;
-
-	kbd->s0 = kmalloc(length, GFP_KERNEL);
-	if (kbd->s0 == NULL)
-		goto error_free_kbd;
-
-	kbd->s1 = kmalloc(length, GFP_KERNEL);
-	if (kbd->s1 == NULL)
-		goto error_free_s0;
-
-	memset(kbd->s0, -1, kbd->length);
-	memset(kbd->s1, -1, kbd->length);
-	
-	kbd->next=keyboards;
-	keyboards=kbd;
-
-	return 0;
-
- error_free_s0:
-	kfree(kbd->s0);
-
- error_free_kbd:
-	kfree(kbd);
-
- error_out:
-	return -ENOMEM;
-}
-			      
-			      
-void __init scan_kbd_init(void)
-{
-	init_timer(&scan_timer);
-	scan_timer.expires = jiffies + SCANHZ;
-	scan_timer.data = 0;
-	scan_timer.function = scan_kbd;
-	add_timer(&scan_timer);
-
-	printk(KERN_INFO "Generic scan keyboard driver initialized\n");
-}
diff -puN drivers/char/scan_keyb.h~input-scan_keyb-remove-it /dev/null
--- a/drivers/char/scan_keyb.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef	__DRIVER_CHAR_SCAN_KEYB_H
-#define	__DRIVER_CHAR_SCAN_KEYB_H
-/*
- *	$Id: scan_keyb.h,v 1.1 2000/06/10 21:45:30 yaegashi Exp $
- *	Copyright (C) 2000 YAEGASHI Takeshi
- *	Generic scan keyboard driver
- */
-
-int register_scan_keyboard(int (*scan)(unsigned char *buffer),
-			   const unsigned char *table,
-			   int length);
-
-void __init scan_kbd_init(void);
-
-#endif
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
input-scan_keyb-remove-it.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-mxser_new-upgrade-to-1915-fix.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
mxser-remove-useless-fields.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
