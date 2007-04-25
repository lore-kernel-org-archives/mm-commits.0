From: akpm@linux-foundation.org
Subject: - char-mxser_new-fix-tiocmiwait.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:31 -0700
Message-ID: <200704252038.l3PKcVXe012226@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993118AbXDYUjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, kas@fi.muni.cz, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, fix TIOCMIWAIT
has been removed from the -mm tree.  Its filename was
     char-mxser_new-fix-tiocmiwait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, fix TIOCMIWAIT
From: Jiri Slaby <jirislaby@gmail.com>

There was schedule() missing in the TIOCMIWAIT ioctl.  Solve it by moving
the code to the wait_event_interruptible.

Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   38 ++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-fix-tiocmiwait drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-fix-tiocmiwait
+++ a/drivers/char/mxser_new.c
@@ -1758,43 +1758,23 @@ static int mxser_ioctl(struct tty_struct
 		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
 		 * Caller should use TIOCGICOUNT to see which one it was
 		 */
-	case TIOCMIWAIT: {
-		DECLARE_WAITQUEUE(wait, current);
-		int ret;
+	case TIOCMIWAIT:
 		spin_lock_irqsave(&info->slock, flags);
-		cprev = info->icount;	/* note the counters on entry */
+		cnow = info->icount;	/* note the counters on entry */
 		spin_unlock_irqrestore(&info->slock, flags);
 
-		add_wait_queue(&info->delta_msr_wait, &wait);
-		while (1) {
+		wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			spin_lock_irqsave(&info->slock, flags);
 			cnow = info->icount;	/* atomic copy */
 			spin_unlock_irqrestore(&info->slock, flags);
 
-			set_current_state(TASK_INTERRUPTIBLE);
-			if (((arg & TIOCM_RNG) &&
-					(cnow.rng != cprev.rng)) ||
-					((arg & TIOCM_DSR) &&
-					(cnow.dsr != cprev.dsr)) ||
-					((arg & TIOCM_CD) &&
-					(cnow.dcd != cprev.dcd)) ||
-					((arg & TIOCM_CTS) &&
-					(cnow.cts != cprev.cts))) {
-				ret = 0;
-				break;
-			}
-			/* see if a signal did it */
-			if (signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				break;
-			}
-			cprev = cnow;
-		}
-		current->state = TASK_RUNNING;
-		remove_wait_queue(&info->delta_msr_wait, &wait);
+			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
+		}));
 		break;
-	}
-	/* NOTREACHED */
 	/*
 	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
 	 * Return: write counters to the user passed counter struct
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
acpi-asus_acpi-support-f2je-model.patch
input-ff-add-ff_raw-effect.patch
input-phantom-add-a-new-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
shrink_slab-handle-bad-shrinkers.patch
