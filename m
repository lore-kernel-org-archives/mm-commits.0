From: akpm@linux-foundation.org
Subject: + char-cyclades-remove-unused-timestamps.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:45 -0700
Message-ID: <200705040645.l446jjjM030898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965744AbXEDGps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, remove unused timestamps
has been added to the -mm tree.  Its filename is
     char-cyclades-remove-unused-timestamps.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, remove unused timestamps
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   12 ------------
 include/linux/cyclades.h |    2 --
 2 files changed, 14 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-unused-timestamps drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-unused-timestamps
+++ a/drivers/char/cyclades.c
@@ -1049,7 +1049,6 @@ static void cyy_intr_chip(struct cyclade
 		channel = (u_short) (save_xir & CyIRChannel);
 		i = channel + chip * 4 + cinfo->first_line;
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1225,7 +1224,6 @@ static void cyy_intr_chip(struct cyclade
 			goto txend;
 		}
 		info = &cy_port[i];
-		info->last_active = jiffies;
 		if (info->tty == 0) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
@@ -1339,7 +1337,6 @@ txend:
 		save_xir = (u_char) readb(base_addr + (CyMIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
 		info = &cy_port[channel + chip * 4 + cinfo->first_line];
-		info->last_active = jiffies;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1570,9 +1567,6 @@ cyz_handle_rx(struct cyclades_port *info
 		char_count = rx_put - rx_get + rx_bufsize;
 
 	if (char_count) {
-		info->last_active = jiffies;
-		info->jiffies[1] = jiffies;
-
 #ifdef CY_ENABLE_MONITORING
 		info->mon.int_count++;
 		info->mon.char_count += char_count;
@@ -1678,8 +1672,6 @@ cyz_handle_tx(struct cyclades_port *info
 			info->x_char = 0;
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #ifdef BLOCKMOVE
 		while (0 < (small_count = min_t(unsigned int,
@@ -1699,8 +1691,6 @@ cyz_handle_tx(struct cyclades_port *info
 			info->xmit_cnt -= small_count;
 			info->xmit_tail = (info->xmit_tail + small_count) &
 					(SERIAL_XMIT_SIZE - 1);
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #else
 		while (info->xmit_cnt && char_count) {
@@ -1713,8 +1703,6 @@ cyz_handle_tx(struct cyclades_port *info
 			tx_put = (tx_put + 1) & (tx_bufsize - 1);
 			char_count--;
 			info->icount.tx++;
-			info->last_active = jiffies;
-			info->jiffies[2] = jiffies;
 		}
 #endif
 ztxdone:
diff -puN include/linux/cyclades.h~char-cyclades-remove-unused-timestamps include/linux/cyclades.h
--- a/include/linux/cyclades.h~char-cyclades-remove-unused-timestamps
+++ a/include/linux/cyclades.h
@@ -569,7 +569,6 @@ struct cyclades_port {
 	int			close_delay;
 	unsigned short		closing_wait;
 	unsigned long		event;
-	unsigned long		last_active;
 	int			count;	/* # of fd on device */
 	int                     breakon;
 	int                     breakoff;
@@ -580,7 +579,6 @@ struct cyclades_port {
 	int			xmit_cnt;
         int                     default_threshold;
         int                     default_timeout;
-	unsigned long		jiffies[3];
 	unsigned long		rflush_count;
 	struct cyclades_monitor	mon;
 	struct cyclades_idle_stats	idle_stats;
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
