From: akpm@linux-foundation.org
Subject: + char-cyclades-fix-blockmove.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:41 -0700
Message-ID: <200705040645.l446jfk6030892@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965744AbXEDGpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, fix blockmove
has been added to the -mm tree.  Its filename is
     char-cyclades-fix-blockmove.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, fix blockmove
From: Jiri Slaby <jirislaby@gmail.com>

tty has no longer flip buffers accessible externally. Fix it by moving the
code to the tty_*flip* helpers.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-fix-blockmove drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-fix-blockmove
+++ a/drivers/char/cyclades.c
@@ -1560,7 +1560,7 @@ cyz_handle_rx(struct cyclades_port *info
 	int char_count;
 	int len;
 #ifdef BLOCKMOVE
-	int small_count;
+	unsigned char *buf;
 #else
 	char data;
 #endif
@@ -1596,25 +1596,23 @@ cyz_handle_rx(struct cyclades_port *info
 		/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
 		   for performance, but because of buffer boundaries, there
 		   may be several steps to the operation */
-			while (0 < (small_count = min_t(unsigned int,
-					rx_bufsize - new_rx_get,
-					min_t(unsigned int, TTY_FLIPBUF_SIZE -
-						tty->flip.count, char_count)))){
-				memcpy_fromio(tty->flip.char_buf_ptr,
-					(char *)(cinfo->base_addr + rx_bufaddr +
-						new_rx_get),
-					small_count);
+			while (1) {
+				len = tty_prepare_flip_string(tty, &buf,
+						char_count);
+				if (!len)
+					break;
 
-				tty->flip.char_buf_ptr += small_count;
-				memset(tty->flip.flag_buf_ptr, TTY_NORMAL,
-					small_count);
-				tty->flip.flag_buf_ptr += small_count;
-				new_rx_get = (new_rx_get + small_count) &
+				len = min_t(unsigned int, min(len, char_count),
+						rx_bufsize - new_rx_get);
+
+				memcpy_fromio(buf, cinfo->base_addr +
+						rx_bufaddr + new_rx_get, len);
+
+				new_rx_get = (new_rx_get + len) &
 						(rx_bufsize - 1);
-				char_count -= small_count;
-				info->icount.rx += small_count;
-				info->idle_stats.recv_bytes += small_count;
-				tty->flip.count += small_count;
+				char_count -= len;
+				info->icount.rx += len;
+				info->idle_stats.recv_bytes += len;
 			}
 #else
 			len = tty_buffer_request_room(tty, char_count);
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
