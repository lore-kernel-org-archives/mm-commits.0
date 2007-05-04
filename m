From: akpm@linux-foundation.org
Subject: + char-cyclades-timers-cleanup.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:43 -0700
Message-ID: <200705040645.l446jhh0030895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965746AbXEDGpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, timers cleanup
has been added to the -mm tree.  Its filename is
     char-cyclades-timers-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, timers cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-timers-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-timers-cleanup
+++ a/drivers/char/cyclades.c
@@ -932,15 +932,9 @@ do_softint(struct work_struct *work)
 	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event))
 		wake_up_interruptible(&info->open_wait);
 #ifdef CONFIG_CYZ_INTR
-	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event)) {
-		if (cyz_rx_full_timer[info->line].function == NULL) {
-			cyz_rx_full_timer[info->line].expires = jiffies + 1;
-			cyz_rx_full_timer[info->line].function = cyz_rx_restart;
-			cyz_rx_full_timer[info->line].data =
-						(unsigned long)info;
-			add_timer(&cyz_rx_full_timer[info->line]);
-		}
-	}
+	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event) &&
+			!timer_pending(&cyz_rx_full_timer[info->line]))
+		mod_timer(&cyz_rx_full_timer[info->line], jiffies + 1);
 #endif
 	if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event))
 		wake_up_interruptible(&info->delta_msr_wait);
@@ -1887,7 +1881,6 @@ static void cyz_rx_restart(unsigned long
 		printk(KERN_ERR "cyc:cyz_rx_restart retval on ttyC%d was %x\n",
 			info->line, retval);
 	}
-	cyz_rx_full_timer[info->line].function = NULL;
 	CY_UNLOCK(info, flags);
 }
 
@@ -4529,8 +4522,8 @@ static void __devinit cy_init_card(struc
 			else
 				info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
 #ifdef CONFIG_CYZ_INTR
-			init_timer(&cyz_rx_full_timer[port]);
-			cyz_rx_full_timer[port].function = NULL;
+			setup_timer(&cyz_rx_full_timer[port],
+				cyz_rx_restart, (unsigned long)info);
 #endif
 		} else {
 			info->type = PORT_CIRRUS;
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
