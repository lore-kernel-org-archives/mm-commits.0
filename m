From: akpm@linux-foundation.org
Subject: - jsm-remove-further-unneeded-crud.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:55 -0700
Message-ID: <200710180655.l9I6ttLb030654@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759132AbXJRHi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, michal.k.k.piotrowski@gmail.com, scottk@digi.com, mm-commits@vger.kernel.org


The patch titled
     jsm: Remove further unneeded crud
has been removed from the -mm tree.  Its filename was
     jsm-remove-further-unneeded-crud.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: jsm: Remove further unneeded crud
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Remove some remaining vestiges of the old hacks jsm had to work around the old
tty buffering.  With the new tty buffering it simply doesn't matter any more.

[michal.k.k.piotrowski@gmail.com: fix warning]
Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Scott Kilau <scottk@digi.com> 
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |   43 ++-------------------------------
 1 file changed, 3 insertions(+), 40 deletions(-)

diff -puN drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-remove-further-unneeded-crud
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -500,13 +500,11 @@ void jsm_input(struct jsm_channel *ch)
 {
 	struct jsm_board *bd;
 	struct tty_struct *tp;
-	struct tty_ldisc *ld;
 	u32 rmask;
 	u16 head;
 	u16 tail;
 	int data_len;
 	unsigned long lock_flags;
-	int flip_len = 0;
 	int len = 0;
 	int n = 0;
 	int s = 0;
@@ -574,45 +572,13 @@ void jsm_input(struct jsm_channel *ch)
 
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
@@ -647,7 +613,7 @@ void jsm_input(struct jsm_channel *ch)
 				else if (*(ch->ch_equeue +tail +i) & UART_LSR_FE)
 					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_FRAME);
 				else
-				tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
+					tty_insert_flip_char(tp, *(ch->ch_rqueue +tail +i), TTY_NORMAL);
 			}
 		} else {
 			tty_insert_flip_string(tp, ch->ch_rqueue + tail, s) ;
@@ -666,9 +632,6 @@ void jsm_input(struct jsm_channel *ch)
 	/* Tell the tty layer its okay to "eat" the data now */
 	tty_flip_buffer_push(tp);
 
-	if (ld)
-		tty_ldisc_deref(ld);
-
 	jsm_printk(IOCTL, INFO, &ch->ch_bd->pci_dev, "finish\n");
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
libata-sff-correct-use-of-check_status.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
