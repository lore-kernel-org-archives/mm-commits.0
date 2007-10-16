From: akpm@linux-foundation.org
Subject: - tty-bring-the-old-cris-driver-back-somewhere-into-the.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:43 -0700
Message-ID: <200710162036.l9GKahFn015210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38333 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760117AbXJPV3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     tty: bring the old cris driver back somewhere into the realm of new tty buffering
has been removed from the -mm tree.  Its filename was
     tty-bring-the-old-cris-driver-back-somewhere-into-the.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-libata-all.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
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
