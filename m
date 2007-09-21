From: akpm@linux-foundation.org
Subject: + tty-bring-the-old-cris-driver-back-somewhere-into-the.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:49:20 -0700
Message-ID: <200709210649.l8L6nKtu023278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbXIUGtm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:49:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, starvik@axis.com


The patch titled
     tty: bring the old cris driver back somewhere into the realm of new tty buffering
has been added to the -mm tree.  Its filename is
     tty-bring-the-old-cris-driver-back-somewhere-into-the.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tty: bring the old cris driver back somewhere into the realm of new tty buffering
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/crisv10.c |   67 ++++++-------------------------------
 1 file changed, 12 insertions(+), 55 deletions(-)

diff -puN drivers/serial/crisv10.c~tty-bring-the-old-cris-driver-back-somewhere-into-the drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~tty-bring-the-old-cris-driver-back-somewhere-into-the
+++ a/drivers/serial/crisv10.c
@@ -514,6 +514,8 @@ struct tty_driver *serial_driver;
  * TTY_THRESHOLD_THROTTLE/UNTHROTTLE=128
  * BUF_SIZE can't be > 128
  */
+#define CRIS_BUF_SIZE	512
+
 /* Currently 16 descriptors x 128 bytes = 2048 bytes */
 #define SERIAL_DESCR_BUF_SIZE 256
 
@@ -2497,55 +2499,18 @@ static void flush_to_flip_buffer(struct 
 		return;
 	}
 
-	length = tty->flip.count;
-	/* Don't flip more than the ldisc has room for.
-	 * The return value from ldisc.receive_room(tty) - might not be up to
-	 * date, the previous flip of up to TTY_FLIPBUF_SIZE might be on the
-	 * processed and not accounted for yet.
-	 * Since we use DMA, 1 SERIAL_DESCR_BUF_SIZE could be on the way.
-	 * Lets buffer data here and let flow control take care of it.
-	 * Since we normally flip large chunks, the ldisc don't react
-	 * with throttle until too late if we flip to much.
-	 */
-	max_flip_size = tty->ldisc.receive_room(tty);
-	if (max_flip_size < 0)
-		max_flip_size = 0;
-	if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-			      length + info->recv_cnt +  /* We have this queued */
-			      2*SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-			      TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles room %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#if 0
-		else if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-					   length + info->recv_cnt +  /* We have this queued */
-					   SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-					   TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles again! %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#endif
-	}
-
-	if (max_flip_size > TTY_FLIPBUF_SIZE)
-		max_flip_size = TTY_FLIPBUF_SIZE;
-
-	while ((buffer = info->first_recv_buffer) && length < max_flip_size) {
+	while ((buffer = info->first_recv_buffer) != NULL) {
 		unsigned int count = buffer->length;
 
-		if (length + count > max_flip_size)
-			count = max_flip_size - length;
+		count = tty_buffer_request_room(tty, count);
+		if (count == 0) /* Throttle ?? */
+			break;
 
-		memcpy(tty->flip.char_buf_ptr + length, buffer->buffer, count);
-		memset(tty->flip.flag_buf_ptr + length, TTY_NORMAL, count);
-		tty->flip.flag_buf_ptr[length] = buffer->error;
+		if (count > 1)
+			tty_insert_flip_strings(tty, buffer->buffer, count - 1);
+		tty_insert_flip_char(tty, buffer->buffer[count-1], buffer->error);
 
-		length += count;
 		info->recv_cnt -= count;
-		DFLIP(DEBUG_LOG(info->line,"flip: %i\n", length));
 
 		if (count == buffer->length) {
 			info->first_recv_buffer = buffer->next;
@@ -2560,14 +2525,6 @@ static void flush_to_flip_buffer(struct 
 	if (!info->first_recv_buffer)
 		info->last_recv_buffer = NULL;
 
-	tty->flip.count = length;
-	DFLIP(if (tty->ldisc.chars_in_buffer(tty) > 3500) {
-		DEBUG_LOG(info->line, "ldisc %lu\n",
-			  tty->ldisc.chars_in_buffer(tty));
-		DEBUG_LOG(info->line, "flip.count %lu\n",
-			  tty->flip.count);
-	      }
-	      );
 	restore_flags(flags);
 
 	DFLIP(
@@ -2722,17 +2679,17 @@ struct e100_serial * handle_ser_rx_inter
 		printk("!NO TTY!\n");
 		return info;
 	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE - TTY_THRESHOLD_THROTTLE) {
+	if (tty->flip.count >= CRIS_BUF_SIZE - TTY_THRESHOLD_THROTTLE) {
 		/* check TTY_THROTTLED first so it indicates our state */
 		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
 			DFLOW(DEBUG_LOG(info->line, "rs_throttle flip.count: %i\n", tty->flip.count));
 			rs_throttle(tty);
 		}
 	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
+	if (tty->flip.count >= CRIS_BUF_SIZE) {
 		DEBUG_LOG(info->line, "force FLIP! %i\n", tty->flip.count);
 		tty->flip.work.func((void *) tty);
-		if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
+		if (tty->flip.count >= CRIS_BUF_SIZE) {
 			DEBUG_LOG(info->line, "FLIP FULL! %i\n", tty->flip.count);
 			return info;		/* if TTY_DONT_FLIP is set */
 		}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

dtc-fix-typo.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
pata_acpi-use-ata_sff_port_start.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-add-a-drivers-ide-style-dma-disable.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
drivers-ata-pata_ixp4xx_cfc-ioremap-return-code-check.patch
libata-update-experimental-tags-to-reflect-reality-better.patch
libata-sff-fix-documentation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
