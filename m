From: akpm@osdl.org
Subject: + char-mxser_new-lock-count-and-flags.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:43:08 -0800
Message-ID: <200701250543.l0P5h8FZ007093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXAYFnL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, osv@javad.com


The patch titled
     Char: mxser_new, lock count and flags
has been added to the -mm tree.  Its filename is
     char-mxser_new-lock-count-and-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, lock count and flags
From: Jiri Slaby <jirislaby@gmail.com>

Both open count and INITIALIZED flag should be changed under lock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-lock-count-and-flags drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-lock-count-and-flags
+++ a/drivers/char/mxser_new.c
@@ -853,9 +853,9 @@ static int mxser_startup(struct mxser_po
 	 * and set the speed of the serial port
 	 */
 	mxser_change_speed(info, NULL);
+	info->flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&info->slock, flags);
 
-	info->flags |= ASYNC_INITIALIZED;
 	return 0;
 }
 
@@ -925,6 +925,7 @@ static void mxser_shutdown(struct mxser_
 static int mxser_open(struct tty_struct *tty, struct file *filp)
 {
 	struct mxser_port *info;
+	unsigned long flags;
 	int retval, line;
 
 	line = tty->index;
@@ -941,7 +942,9 @@ static int mxser_open(struct tty_struct 
 	/*
 	 * Start up serial port
 	 */
+	spin_lock_irqsave(&info->slock, flags);
 	info->count++;
+	spin_unlock_irqrestore(&info->slock, flags);
 	retval = mxser_startup(info);
 	if (retval)
 		return retval;
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
shrink_slab-handle-bad-shrinkers.patch
