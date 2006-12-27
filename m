From: akpm@osdl.org
Subject: + char-mxser_new-remove-useless-spinlock.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:42:22 -0800
Message-ID: <200612270742.kBR7gMfX004643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbWL0HmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:42:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, remove useless spinlock
has been added to the -mm tree.  Its filename is
     char-mxser_new-remove-useless-spinlock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, remove useless spinlock
From: Jiri Slaby <jirislaby@gmail.com>

gm_lock is useless, since ISA is configured at init time and there it's
serialized.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-remove-useless-spinlock drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-remove-useless-spinlock
+++ a/drivers/char/mxser_new.c
@@ -313,7 +313,6 @@ static int mxvar_diagflag;
 static unsigned char mxser_msr[MXSER_PORTS + 1];
 static struct mxser_mon_ext mon_data_ext;
 static int mxser_set_baud_method[MXSER_PORTS + 1];
-static spinlock_t gm_lock;
 
 #ifdef CONFIG_PCI
 static int __devinit CheckIsMoxaMust(int io)
@@ -1377,7 +1376,6 @@ static int __init mxser_program_mode(int
 {
 	int id, i, j, n;
 
-	spin_lock(&gm_lock);
 	outb(0, port);
 	outb(0, port);
 	outb(0, port);
@@ -1385,7 +1383,6 @@ static int __init mxser_program_mode(int
 	(void)inb(port);
 	outb(0, port);
 	(void)inb(port);
-	spin_unlock(&gm_lock);
 
 	id = inb(port + 1) & 0x1F;
 	if ((id != C168_ASIC_ID) &&
@@ -2684,7 +2681,6 @@ static int __init mxser_module_init(void
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
 	if (!mxvar_sdriver)
 		return -ENOMEM;
-	spin_lock_init(&gm_lock);
 
 	printk(KERN_INFO "MOXA Smartio/Industio family driver version %s\n",
 		MXSER_VERSION);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
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
char-mxser-fix-oops-when-removing-opened.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
shrink_slab-handle-bad-shrinkers.patch

