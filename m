From: akpm@linux-foundation.org
Subject: - fix-serial-buffer-memory-leak.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:27 -0700
Message-ID: <200708140503.l7E53RO6032057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934146AbXHNFLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, laurentp@cse-semaphore.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     fix serial buffer memory leak
has been removed from the -mm tree.  Its filename was
     fix-serial-buffer-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix serial buffer memory leak
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Patch c5c34d4862e18ef07c1276d233507f540fb5a532 (tty: flush flip buffer on 
ldisc input queue flush) introduces a race condition which can lead to memory 
leaks.

The problem can be triggered when tcflush() is called when data are being 
pushed to the line discipline driver by flush_to_ldisc().

flush_to_ldisc() releases tty->buf.lock when calling the line discipline 
receive_buf function. At that poing tty_buffer_flush() kicks in and sets both 
tty->buf.head and tty->buf.tail to NULL. When flush_to_ldisc() finishes, it 
restores tty->buf.head but doesn't touch tty->buf.tail. This corrups the 
buffer queue, and the next call to tty_buffer_request_room() will allocate a 
new buffer and overwrite tty->buf.head. The previous buffer is then lost 
forever without being released.

(Thanks to Laurent for the above text, for finding, disgnosing and reporting
the bug)

- Use tty->flags bits for the flush status.

- Wait for the flag to clear again before returning

- Fix the doc error noted

- Fix flush of empty queue leaving stale flushpending

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Paul Fulghum <paulkf@microgate.com>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   55 +++++++++++++++++++++++++++++++++++-----
 include/linux/tty.h   |    2 +
 2 files changed, 51 insertions(+), 6 deletions(-)

diff -puN drivers/char/tty_io.c~fix-serial-buffer-memory-leak drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~fix-serial-buffer-memory-leak
+++ a/drivers/char/tty_io.c
@@ -369,25 +369,54 @@ static void tty_buffer_free(struct tty_s
 }
 
 /**
- *	tty_buffer_flush		-	flush full tty buffers
+ *	__tty_buffer_flush		-	flush full tty buffers
  *	@tty: tty to flush
  *
- *	flush all the buffers containing receive data
+ *	flush all the buffers containing receive data. Caller must
+ *	hold the buffer lock and must have ensured no parallel flush to
+ *	ldisc is running.
  *
- *	Locking: none
+ *	Locking: Caller must hold tty->buf.lock
  */
 
-static void tty_buffer_flush(struct tty_struct *tty)
+static void __tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_buffer *thead;
-	unsigned long flags;
 
-	spin_lock_irqsave(&tty->buf.lock, flags);
 	while((thead = tty->buf.head) != NULL) {
 		tty->buf.head = thead->next;
 		tty_buffer_free(tty, thead);
 	}
 	tty->buf.tail = NULL;
+}
+
+/**
+ *	tty_buffer_flush		-	flush full tty buffers
+ *	@tty: tty to flush
+ *
+ *	flush all the buffers containing receive data. If the buffer is
+ *	being processed by flush_to_ldisc then we defer the processing
+ *	to that function
+ *
+ *	Locking: none
+ */
+
+static void tty_buffer_flush(struct tty_struct *tty)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tty->buf.lock, flags);
+
+	/* If the data is being pushed to the tty layer then we can't
+	   process it here. Instead set a flag and the flush_to_ldisc
+	   path will process the flush request before it exits */
+	if (test_bit(TTY_FLUSHING, &tty->flags)) {
+		set_bit(TTY_FLUSHPENDING, &tty->flags);
+		spin_unlock_irqrestore(&tty->buf.lock, flags);
+		wait_event(tty->read_wait,
+				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
+		return;
+	} else
+		__tty_buffer_flush(tty);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 }
 
@@ -3594,6 +3623,7 @@ static void flush_to_ldisc(struct work_s
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
+	set_bit(TTY_FLUSHING, &tty->flags);	/* So we know a flush is running */
 	head = tty->buf.head;
 	if (head != NULL) {
 		tty->buf.head = NULL;
@@ -3607,6 +3637,11 @@ static void flush_to_ldisc(struct work_s
 				tty_buffer_free(tty, tbuf);
 				continue;
 			}
+			/* Ldisc or user is trying to flush the buffers
+			   we are feeding to the ldisc, stop feeding the
+			   line discipline as we want to empty the queue */
+			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
+				break;
 			if (!tty->receive_room) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
@@ -3620,8 +3655,16 @@ static void flush_to_ldisc(struct work_s
 			disc->receive_buf(tty, char_buf, flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
+		/* Restore the queue head */
 		tty->buf.head = head;
 	}
+	/* We may have a deferred request to flush the input buffer,
+	   if so pull the chain under the lock and empty the queue */
+	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
+		__tty_buffer_flush(tty);
+		clear_bit(TTY_FLUSHPENDING, &tty->flags);
+	}
+	clear_bit(TTY_FLUSHING, &tty->flags);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
 	tty_ldisc_deref(disc);
diff -puN include/linux/tty.h~fix-serial-buffer-memory-leak include/linux/tty.h
--- a/include/linux/tty.h~fix-serial-buffer-memory-leak
+++ a/include/linux/tty.h
@@ -274,6 +274,8 @@ struct tty_struct {
 #define TTY_PTY_LOCK 		16	/* pty private */
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
+#define TTY_FLUSHING		19	/* Flushing to ldisc in progress */
+#define TTY_FLUSHPENDING	20	/* Queued buffer flush pending */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
git-avr32.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
alpm-store-interrupt-value.patch
alpm-increase-number-of-allowable-device-flags.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
belkin_sa-avoid-divide-by-zero-error.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
