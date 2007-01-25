From: akpm@osdl.org
Subject: + char-mxser_new-do-not-null-driver_data.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:43:06 -0800
Message-ID: <200701250543.l0P5h6Rg007090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965351AbXAYFnL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, osv@javad.com


The patch titled
     Char: mxser_new, do not null driver_data
has been added to the -mm tree.  Its filename is
     char-mxser_new-do-not-null-driver_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, do not null driver_data
From: Jiri Slaby <jirislaby@gmail.com>

driver_data are initialzed to NULL from tty layer, no need to do it in the
driver.  In this case it cases oops, since driver_data may be NULL for a short
while for another closing process.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-do-not-null-driver_data drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-do-not-null-driver_data
+++ a/drivers/char/mxser_new.c
@@ -927,9 +927,6 @@ static int mxser_open(struct tty_struct 
 	struct mxser_port *info;
 	int retval, line;
 
-	/* initialize driver_data in case something fails */
-	tty->driver_data = NULL;
-
 	line = tty->index;
 	if (line == MXSER_PORTS)
 		return 0;
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
