From: akpm@linux-foundation.org
Subject: + jsm-remove-further-unneeded-crud.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:59:36 -0700
Message-ID: <200708091959.l79Jxakw016792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755636AbXHIUAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, scottk@digi.com


The patch titled
     jsm: Remove further unneeded crud
has been added to the -mm tree.  Its filename is
     jsm-remove-further-unneeded-crud.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jsm: Remove further unneeded crud
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Remove some remaining vestiges of the old hacks jsm had to work around the old
tty buffering.  With the new tty buffering it simply doesn't matter any more.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Scott Kilau <scottk@digi.com> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |   42 ++-------------------------------
 1 files changed, 3 insertions(+), 39 deletions(-)

diff -puN drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -500,7 +500,6 @@ void jsm_input(struct jsm_channel *ch)
 {
 	struct jsm_board *bd;
 	struct tty_struct *tp;
-	struct tty_ldisc *ld;
 	u32 rmask;
 	u16 head;
 	u16 tail;
@@ -574,45 +573,13 @@ void jsm_input(struct jsm_channel *ch)
 
 	jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "start 2\n");
 
-	/*
-	 * If the rxbuf is empty and we are not throttled, put as much
-	 * as we can directly into the linux TTY buffer.
-	 *
-	 */
-	flip_len = TTY_FLIPBUF_SIZE;
-
-	len = min(data_len, flip_len);
-	len = min(len, (N_TTY_BUF_SIZE - 1) - tp->read_cnt);
-	ld = tty_ldisc_ref(tp);
-
-	/*
-	 * If we were unable to get a reference to the ld,
-	 * don't flush our buffer, and act like the ld doesn't
-	 * have any space to put the data right now.
-	 */
-	if (!ld) {
-		len = 0;
-	} else {
-		/*
-		 * If ld doesn't have a pointer to a receive_buf function,
-		 * flush the data, then act like the ld doesn't have any
-		 * space to put the data right now.
-		 */
-		if (!ld->receive_buf) {
-				ch->ch_r_head = ch->ch_r_tail;
-				len = 0;
-		}
-	}
-
-	if (len <= 0) {
+	if (data_len <= 0) {
 		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev, "jsm_input 1\n");
-		if (ld)
-			tty_ldisc_deref(ld);
 		return;
 	}
 
-	len = tty_buffer_request_room(tp, len);
+	len = tty_buffer_request_room(tp, data_len);
 	n = len;
 
 	/*
@@ -647,7 +614,7 @@ void jsm_input(struct jsm_channel *ch)
 				else if (*(ch->ch_equeue +tail +i) & UART_LSR_FE)
 					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_FRAME);
 				else
-				tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
+					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
 			}
 		} else {
 			tty_insert_flip_string(tp, ch->ch_rqueue + tail, s) ;
@@ -666,9 +633,6 @@ void jsm_input(struct jsm_channel *ch)
 	/* Tell the tty layer its okay to "eat" the data now */
 	tty_flip_buffer_push(tp);
 
-	if (ld)
-		tty_ldisc_deref(ld);
-
 	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "finish\n");
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch
belkin_sa-avoid-divide-by-zero-error.patch
blackfin-enable-arbitary-speed-serial-setting.patch
char-cyclades-remove-bottom-half-processing.patch
