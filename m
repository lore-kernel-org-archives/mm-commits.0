From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-sleep_on.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:39 -0700
Message-ID: <200705040645.l446jd58030889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965749AbXEDGpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, remove sleep_on
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-sleep_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, remove sleep_on
From: Jiri Slaby <jirislaby@gmail.com>

convert to wait_* and completion

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   45 +++++++++++++------------------------
 include/linux/cyclades.h |    2 -
 2 files changed, 17 insertions(+), 30 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-sleep_on drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-sleep_on
+++ a/drivers/char/cyclades.c
@@ -947,7 +947,7 @@ do_softint(struct work_struct *work)
 	tty_wakeup(tty);
 #ifdef Z_WAKE
 	if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event))
-		wake_up_interruptible(&info->shutdown_wait);
+		complete(&info->shutdown_wait);
 #endif
 } /* do_softint */
 
@@ -2324,9 +2324,8 @@ block_til_ready(struct tty_struct *tty, 
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING) {
-			interruptible_sleep_on(&info->close_wait);
-		}
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2597,8 +2596,8 @@ static int cy_open(struct tty_struct *tt
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+		wait_event_interruptible(info->close_wait,
+				!(info->flags & ASYNC_CLOSING));
 		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
@@ -2805,7 +2804,7 @@ static void cy_close(struct tty_struct *
 					"ttyC%d was %x\n", info->line, retval);
 			}
 			CY_UNLOCK(info, flags);
-			interruptible_sleep_on(&info->shutdown_wait);
+			wait_for_completion_interruptible(&info->shutdown_wait);
 			CY_LOCK(info, flags);
 		}
 #endif
@@ -4091,32 +4090,20 @@ cy_ioctl(struct tty_struct *tty, struct 
 	case TIOCMIWAIT:
 		CY_LOCK(info, flags);
 		/* note the counters on entry */
-		cprev = info->icount;
+		cnow = info->icount;
 		CY_UNLOCK(info, flags);
-		while (1) {
-			interruptible_sleep_on(&info->delta_msr_wait);
-			/* see if a signal did it */
-			if (signal_pending(current)) {
-				return -ERESTARTSYS;
-			}
-
+		ret_val = wait_event_interruptible(info->delta_msr_wait, ({
+			cprev = cnow;
 			CY_LOCK(info, flags);
 			cnow = info->icount;	/* atomic copy */
 			CY_UNLOCK(info, flags);
 
-			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-				return -EIO;	/* no change => error */
-			}
-			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			    ((arg & TIOCM_CD) && (cnow.dcd != cprev.dcd)) ||
-			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-				return 0;
-			}
-			cprev = cnow;
-		}
-		/* NOTREACHED */
+			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
+		}));
+		break;
 
 		/*
 		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
@@ -4534,7 +4521,7 @@ static void __devinit cy_init_card(struc
 		INIT_WORK(&info->tqueue, do_softint);
 		init_waitqueue_head(&info->open_wait);
 		init_waitqueue_head(&info->close_wait);
-		init_waitqueue_head(&info->shutdown_wait);
+		init_completion(&info->shutdown_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
 
 		if (IS_CYC_Z(*cinfo)) {
diff -puN include/linux/cyclades.h~char-cyclades-remove-sleep_on include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-sleep_on
+++ a/include/linux/cyclades.h
@@ -588,7 +588,7 @@ struct cyclades_port {
 	struct work_struct	tqueue;
 	wait_queue_head_t       open_wait;
 	wait_queue_head_t       close_wait;
-	wait_queue_head_t       shutdown_wait;
+	struct completion       shutdown_wait;
 	wait_queue_head_t       delta_msr_wait;
 	int throttle;
 };
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
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
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
