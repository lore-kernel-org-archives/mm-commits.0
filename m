From: akpm@linux-foundation.org
Subject: + synclink_gt-fix-missed-serial-input-signal-changes.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:45:04 -0800
Message-ID: <200801312145.m0VLj4KK012858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbYAaVpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:45:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com


The patch titled
     synclink_gt fix missed serial input signal changes
has been added to the -mm tree.  Its filename is
     synclink_gt-fix-missed-serial-input-signal-changes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt fix missed serial input signal changes
From: Paul Fulghum <paulkf@microgate.com>

Fix missed serial input signal changes caused by rereading the serial
status register during interrupt processing.  Now processing is performed
on original status register value.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   68 +++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-fix-missed-serial-input-signal-changes drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-fix-missed-serial-input-signal-changes
+++ a/drivers/char/synclink_gt.c
@@ -2039,37 +2039,41 @@ static void bh_transmit(struct slgt_info
 		tty_wakeup(tty);
 }
 
-static void dsr_change(struct slgt_info *info)
+static void dsr_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT3) {
+		info->signals |= SerialSignal_DSR;
+		info->input_signal_events.dsr_up++;
+	} else {
+		info->signals &= ~SerialSignal_DSR;
+		info->input_signal_events.dsr_down++;
+	}
 	DBGISR(("dsr_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->dsr_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_DSR);
 		return;
 	}
 	info->icount.dsr++;
-	if (info->signals & SerialSignal_DSR)
-		info->input_signal_events.dsr_up++;
-	else
-		info->input_signal_events.dsr_down++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
 }
 
-static void cts_change(struct slgt_info *info)
+static void cts_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT2) {
+		info->signals |= SerialSignal_CTS;
+		info->input_signal_events.cts_up++;
+	} else {
+		info->signals &= ~SerialSignal_CTS;
+		info->input_signal_events.cts_down++;
+	}
 	DBGISR(("cts_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->cts_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_CTS);
 		return;
 	}
 	info->icount.cts++;
-	if (info->signals & SerialSignal_CTS)
-		info->input_signal_events.cts_up++;
-	else
-		info->input_signal_events.cts_down++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
@@ -2090,20 +2094,21 @@ static void cts_change(struct slgt_info 
 	}
 }
 
-static void dcd_change(struct slgt_info *info)
+static void dcd_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT1) {
+		info->signals |= SerialSignal_DCD;
+		info->input_signal_events.dcd_up++;
+	} else {
+		info->signals &= ~SerialSignal_DCD;
+		info->input_signal_events.dcd_down++;
+	}
 	DBGISR(("dcd_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->dcd_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_DCD);
 		return;
 	}
 	info->icount.dcd++;
-	if (info->signals & SerialSignal_DCD) {
-		info->input_signal_events.dcd_up++;
-	} else {
-		info->input_signal_events.dcd_down++;
-	}
 #if SYNCLINK_GENERIC_HDLC
 	if (info->netcount) {
 		if (info->signals & SerialSignal_DCD)
@@ -2126,20 +2131,21 @@ static void dcd_change(struct slgt_info 
 	}
 }
 
-static void ri_change(struct slgt_info *info)
+static void ri_change(struct slgt_info *info, unsigned short status)
 {
-	get_signals(info);
+	if (status & BIT0) {
+		info->signals |= SerialSignal_RI;
+		info->input_signal_events.ri_up++;
+	} else {
+		info->signals &= ~SerialSignal_RI;
+		info->input_signal_events.ri_down++;
+	}
 	DBGISR(("ri_change %s signals=%04X\n", info->device_name, info->signals));
 	if ((info->ri_chkcount)++ == IO_PIN_SHUTDOWN_LIMIT) {
 		slgt_irq_off(info, IRQ_RI);
 		return;
 	}
-	info->icount.dcd++;
-	if (info->signals & SerialSignal_RI) {
-		info->input_signal_events.ri_up++;
-	} else {
-		info->input_signal_events.ri_down++;
-	}
+	info->icount.rng++;
 	wake_up_interruptible(&info->status_event_wait_q);
 	wake_up_interruptible(&info->event_wait_q);
 	info->pending_bh |= BH_STATUS;
@@ -2190,13 +2196,13 @@ static void isr_serial(struct slgt_info 
 	}
 
 	if (status & IRQ_DSR)
-		dsr_change(info);
+		dsr_change(info, status);
 	if (status & IRQ_CTS)
-		cts_change(info);
+		cts_change(info, status);
 	if (status & IRQ_DCD)
-		dcd_change(info);
+		dcd_change(info, status);
 	if (status & IRQ_RI)
-		ri_change(info);
+		ri_change(info, status);
 }
 
 static void isr_rdma(struct slgt_info *info)
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink-standardize-format-of-linux-header-file-includes-with.patch
synclink_gt-fix-missed-serial-input-signal-changes.patch
