From: akpm@linux-foundation.org
Subject: - char-mxser_new-remove-useless-spinlock.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:25 -0800
Message-ID: <200702112251.l1BMpPA8015942@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60116 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758AbXBKWv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, remove useless spinlock
has been removed from the -mm tree.  Its filename was
     char-mxser_new-remove-useless-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, remove useless spinlock
From: Jiri Slaby <jirislaby@gmail.com>

gm_lock is useless, since ISA is configured at init time and there it's
serialized.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
