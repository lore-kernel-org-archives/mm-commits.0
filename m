From: akpm@linux-foundation.org
Subject: + char-cyclades-make-the-isr-code-readable.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:40:09 -0700
Message-ID: <200707302340.l6UNe964004448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54509 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761588AbXG3XkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, make the isr code readable
has been added to the -mm tree.  Its filename is
     char-cyclades-make-the-isr-code-readable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, make the isr code readable
From: Jiri Slaby <jirislaby@gmail.com>

Due to large indent the code was wrapped and unreadable.  Create 3 function
instead of one and reorder the code, so it is readable now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |  623 +++++++++++++++++---------------------
 1 files changed, 295 insertions(+), 328 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-make-the-isr-code-readable drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-make-the-isr-code-readable
+++ a/drivers/char/cyclades.c
@@ -980,378 +980,342 @@ static unsigned detect_isa_irq(void __io
 }
 #endif				/* CONFIG_ISA */
 
-static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
-			void __iomem * base_addr, int status, int index)
+static void cyy_chip_rx(struct cyclades_card *cinfo, int chip,
+		void __iomem *base_addr)
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
 	int char_count;
-	int j, len, mdm_change, mdm_status, outch;
+	int j, len, index = cinfo->bus_index;
 	int save_xir, channel, save_car;
 	char data;
 
-	if (status & CySRReceive) {	/* reception interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
+	printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
 #endif
-		/* determine the channel & change to that context */
-		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) readb(base_addr + (CyRIR << index));
-		channel = (u_short) (save_xir & CyIRChannel);
-		info = &cinfo->ports[channel + chip * 4];
-		save_car = readb(base_addr + (CyCAR << index));
-		cy_writeb(base_addr + (CyCAR << index), save_xir);
-
-		/* if there is nowhere to put the data, discard it */
-		if (info->tty == NULL) {
-			j = (readb(base_addr + (CyRIVR << index)) &
-				CyIVRMask);
-			if (j == CyIVRRxEx) {	/* exception */
-				data = readb(base_addr + (CyRDSR << index));
-			} else {	/* normal character reception */
-				char_count = readb(base_addr +
-						(CyRDCR << index));
-				while (char_count--) {
-					data = readb(base_addr +
-						(CyRDSR << index));
-				}
-			}
-		} else {	/* there is an open port for this data */
-			tty = info->tty;
-			j = (readb(base_addr + (CyRIVR << index)) &
-					CyIVRMask);
-			if (j == CyIVRRxEx) {	/* exception */
+	/* determine the channel & change to that context */
+	spin_lock(&cinfo->card_lock);
+	save_xir = (u_char) readb(base_addr + (CyRIR << index));
+	channel = (u_short) (save_xir & CyIRChannel);
+	info = &cinfo->ports[channel + chip * 4];
+	save_car = readb(base_addr + (CyCAR << index));
+	cy_writeb(base_addr + (CyCAR << index), save_xir);
+
+	/* if there is nowhere to put the data, discard it */
+	if (info->tty == NULL) {
+		j = (readb(base_addr + (CyRIVR << index)) & CyIVRMask);
+		if (j == CyIVRRxEx) {	/* exception */
+			data = readb(base_addr + (CyRDSR << index));
+		} else {	/* normal character reception */
+			char_count = readb(base_addr + (CyRDCR << index));
+			while (char_count--)
 				data = readb(base_addr + (CyRDSR << index));
+		}
+		goto end;
+	}
+	/* there is an open port for this data */
+	tty = info->tty;
+	j = readb(base_addr + (CyRIVR << index)) & CyIVRMask;
+	if (j == CyIVRRxEx) {	/* exception */
+		data = readb(base_addr + (CyRDSR << index));
+
+		/* For statistics only */
+		if (data & CyBREAK)
+			info->icount.brk++;
+		else if (data & CyFRAME)
+			info->icount.frame++;
+		else if (data & CyPARITY)
+			info->icount.parity++;
+		else if (data & CyOVERRUN)
+			info->icount.overrun++;
 
-				/* For statistics only */
-				if (data & CyBREAK)
-					info->icount.brk++;
-				else if (data & CyFRAME)
-					info->icount.frame++;
-				else if (data & CyPARITY)
-					info->icount.parity++;
-				else if (data & CyOVERRUN)
-					info->icount.overrun++;
-
-				if (data & info->ignore_status_mask) {
+		if (data & info->ignore_status_mask) {
+			info->icount.rx++;
+			spin_unlock(&cinfo->card_lock);
+			return;
+		}
+		if (tty_buffer_request_room(tty, 1)) {
+			if (data & info->read_status_mask) {
+				if (data & CyBREAK) {
+					tty_insert_flip_char(tty,
+						readb(base_addr + (CyRDSR <<
+							index)), TTY_BREAK);
+					info->icount.rx++;
+					if (info->flags & ASYNC_SAK)
+						do_SAK(tty);
+				} else if (data & CyFRAME) {
+					tty_insert_flip_char( tty,
+						readb(base_addr + (CyRDSR <<
+							index)), TTY_FRAME);
+					info->icount.rx++;
+					info->idle_stats.frame_errs++;
+				} else if (data & CyPARITY) {
+					/* Pieces of seven... */
+					tty_insert_flip_char(tty,
+						readb(base_addr + (CyRDSR <<
+							index)), TTY_PARITY);
+					info->icount.rx++;
+					info->idle_stats.parity_errs++;
+				} else if (data & CyOVERRUN) {
+					tty_insert_flip_char(tty, 0,
+							TTY_OVERRUN);
+					info->icount.rx++;
+					/* If the flip buffer itself is
+					   overflowing, we still lose
+					   the next incoming character.
+					 */
+					tty_insert_flip_char(tty,
+						readb(base_addr + (CyRDSR <<
+							index)), TTY_FRAME);
 					info->icount.rx++;
-					spin_unlock(&cinfo->card_lock);
-					return;
-				}
-				if (tty_buffer_request_room(tty, 1)) {
-					if (data & info->read_status_mask) {
-						if (data & CyBREAK) {
-							tty_insert_flip_char(
-								tty,
-								readb(
-								base_addr +
-								(CyRDSR <<
-									index)),
-								TTY_BREAK);
-							info->icount.rx++;
-							if (info->flags &
-							    ASYNC_SAK) {
-								do_SAK(tty);
-							}
-						} else if (data & CyFRAME) {
-							tty_insert_flip_char(
-								tty,
-								readb(
-								base_addr +
-								(CyRDSR <<
-									index)),
-								TTY_FRAME);
-							info->icount.rx++;
-							info->idle_stats.
-								frame_errs++;
-						} else if (data & CyPARITY) {
-							/* Pieces of seven... */
-							tty_insert_flip_char(
-								tty,
-								readb(
-								base_addr +
-								(CyRDSR <<
-									index)),
-								TTY_PARITY);
-							info->icount.rx++;
-							info->idle_stats.
-								parity_errs++;
-						} else if (data & CyOVERRUN) {
-							tty_insert_flip_char(
-								tty, 0,
-								TTY_OVERRUN);
-							info->icount.rx++;
-						/* If the flip buffer itself is
-						   overflowing, we still lose
-						   the next incoming character.
-						 */
-							tty_insert_flip_char(
-								tty,
-								readb(
-								base_addr +
-								(CyRDSR <<
-									index)),
-								TTY_FRAME);
-							info->icount.rx++;
-							info->idle_stats.
-								overruns++;
-					/* These two conditions may imply */
-					/* a normal read should be done. */
-					/* }else if(data & CyTIMEOUT){ */
-					/* }else if(data & CySPECHAR){ */
-						} else {
-							tty_insert_flip_char(
-								tty, 0,
-								TTY_NORMAL);
-							info->icount.rx++;
-						}
-					} else {
-						tty_insert_flip_char(tty, 0,
-								TTY_NORMAL);
-						info->icount.rx++;
-					}
-				} else {
-					/* there was a software buffer
-					   overrun and nothing could be
-					   done about it!!! */
-					info->icount.buf_overrun++;
 					info->idle_stats.overruns++;
+				/* These two conditions may imply */
+				/* a normal read should be done. */
+				/* } else if(data & CyTIMEOUT) { */
+				/* } else if(data & CySPECHAR) { */
+				} else {
+					tty_insert_flip_char(tty, 0,
+							TTY_NORMAL);
+					info->icount.rx++;
 				}
-			} else {	/* normal character reception */
-				/* load # chars available from the chip */
-				char_count = readb(base_addr +
-						(CyRDCR << index));
+			} else {
+				tty_insert_flip_char(tty, 0, TTY_NORMAL);
+				info->icount.rx++;
+			}
+		} else {
+			/* there was a software buffer overrun and nothing
+			 * could be done about it!!! */
+			info->icount.buf_overrun++;
+			info->idle_stats.overruns++;
+		}
+	} else {	/* normal character reception */
+		/* load # chars available from the chip */
+		char_count = readb(base_addr + (CyRDCR << index));
 
 #ifdef CY_ENABLE_MONITORING
-				++info->mon.int_count;
-				info->mon.char_count += char_count;
-				if (char_count > info->mon.char_max)
-					info->mon.char_max = char_count;
-				info->mon.char_last = char_count;
-#endif
-				len = tty_buffer_request_room(tty, char_count);
-				while (len--) {
-					data = readb(base_addr +
-							(CyRDSR << index));
-					tty_insert_flip_char(tty, data,
-							TTY_NORMAL);
-					info->idle_stats.recv_bytes++;
-					info->icount.rx++;
+		++info->mon.int_count;
+		info->mon.char_count += char_count;
+		if (char_count > info->mon.char_max)
+			info->mon.char_max = char_count;
+		info->mon.char_last = char_count;
+#endif
+		len = tty_buffer_request_room(tty, char_count);
+		while (len--) {
+			data = readb(base_addr + (CyRDSR << index));
+			tty_insert_flip_char(tty, data, TTY_NORMAL);
+			info->idle_stats.recv_bytes++;
+			info->icount.rx++;
 #ifdef CY_16Y_HACK
-					udelay(10L);
+			udelay(10L);
 #endif
-				}
-				info->idle_stats.recv_idle = jiffies;
-			}
-			tty_schedule_flip(tty);
 		}
-		/* end of service */
-		cy_writeb(base_addr + (CyRIR << index), (save_xir & 0x3f));
-		cy_writeb(base_addr + (CyCAR << index), (save_car));
-		spin_unlock(&cinfo->card_lock);
+		info->idle_stats.recv_idle = jiffies;
 	}
+	tty_schedule_flip(tty);
+end:
+	/* end of service */
+	cy_writeb(base_addr + (CyRIR << index), save_xir & 0x3f);
+	cy_writeb(base_addr + (CyCAR << index), save_car);
+	spin_unlock(&cinfo->card_lock);
+}
+
+static void cyy_chip_tx(struct cyclades_card *cinfo, int chip,
+		void __iomem *base_addr)
+{
+	struct cyclades_port *info;
+	int char_count;
+	int outch;
+	int save_xir, channel, save_car, index = cinfo->bus_index;
 
-	if (status & CySRTransmit) {	/* transmission interrupt */
-		/* Since we only get here when the transmit buffer
-		   is empty, we know we can always stuff a dozen
-		   characters. */
+	/* Since we only get here when the transmit buffer
+	   is empty, we know we can always stuff a dozen
+	   characters. */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk(KERN_DEBUG "cyy_interrupt: xmit intr, chip %d\n", chip);
+	printk(KERN_DEBUG "cyy_interrupt: xmit intr, chip %d\n", chip);
 #endif
 
-		/* determine the channel & change to that context */
-		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) readb(base_addr + (CyTIR << index));
-		channel = (u_short) (save_xir & CyIRChannel);
-		save_car = readb(base_addr + (CyCAR << index));
-		cy_writeb(base_addr + (CyCAR << index), save_xir);
+	/* determine the channel & change to that context */
+	spin_lock(&cinfo->card_lock);
+	save_xir = (u_char) readb(base_addr + (CyTIR << index));
+	channel = (u_short) (save_xir & CyIRChannel);
+	save_car = readb(base_addr + (CyCAR << index));
+	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
-		/* validate the port# (as configured and open) */
-		if (channel + chip * 4 >= cinfo->nports) {
-			cy_writeb(base_addr + (CySRER << index),
-				  readb(base_addr + (CySRER << index)) &
-				  ~CyTxRdy);
-			goto txend;
-		}
-		info = &cinfo->ports[channel + chip * 4];
-		if (info->tty == NULL) {
-			cy_writeb(base_addr + (CySRER << index),
-				  readb(base_addr + (CySRER << index)) &
-				  ~CyTxRdy);
-			goto txend;
-		}
+	/* validate the port# (as configured and open) */
+	if (channel + chip * 4 >= cinfo->nports) {
+		cy_writeb(base_addr + (CySRER << index),
+			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+		goto end;
+	}
+	info = &cinfo->ports[channel + chip * 4];
+	if (info->tty == NULL) {
+		cy_writeb(base_addr + (CySRER << index),
+			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+		goto end;
+	}
 
-		/* load the on-chip space for outbound data */
-		char_count = info->xmit_fifo_size;
+	/* load the on-chip space for outbound data */
+	char_count = info->xmit_fifo_size;
 
-		if (info->x_char) {	/* send special char */
-			outch = info->x_char;
-			cy_writeb(base_addr + (CyTDR << index), outch);
-			char_count--;
-			info->icount.tx++;
-			info->x_char = 0;
-		}
+	if (info->x_char) {	/* send special char */
+		outch = info->x_char;
+		cy_writeb(base_addr + (CyTDR << index), outch);
+		char_count--;
+		info->icount.tx++;
+		info->x_char = 0;
+	}
 
-		if (info->breakon || info->breakoff) {
-			if (info->breakon) {
-				cy_writeb(base_addr + (CyTDR << index), 0);
-				cy_writeb(base_addr + (CyTDR << index), 0x81);
-				info->breakon = 0;
-				char_count -= 2;
-			}
-			if (info->breakoff) {
-				cy_writeb(base_addr + (CyTDR << index), 0);
-				cy_writeb(base_addr + (CyTDR << index), 0x83);
-				info->breakoff = 0;
-				char_count -= 2;
-			}
+	if (info->breakon || info->breakoff) {
+		if (info->breakon) {
+			cy_writeb(base_addr + (CyTDR << index), 0);
+			cy_writeb(base_addr + (CyTDR << index), 0x81);
+			info->breakon = 0;
+			char_count -= 2;
 		}
+		if (info->breakoff) {
+			cy_writeb(base_addr + (CyTDR << index), 0);
+			cy_writeb(base_addr + (CyTDR << index), 0x83);
+			info->breakoff = 0;
+			char_count -= 2;
+		}
+	}
 
-		while (char_count-- > 0) {
-			if (!info->xmit_cnt) {
-				if (readb(base_addr + (CySRER << index)) &
-						CyTxMpty) {
-					cy_writeb(base_addr + (CySRER << index),
-						readb(base_addr +
-							(CySRER << index)) &
+	while (char_count-- > 0) {
+		if (!info->xmit_cnt) {
+			if (readb(base_addr + (CySRER << index)) & CyTxMpty) {
+				cy_writeb(base_addr + (CySRER << index),
+					readb(base_addr + (CySRER << index)) &
 						~CyTxMpty);
-				} else {
-					cy_writeb(base_addr + (CySRER << index),
-						(readb(base_addr +
-						  	(CySRER << index)) &
+			} else {
+				cy_writeb(base_addr + (CySRER << index),
+					(readb(base_addr + (CySRER << index)) &
 						~CyTxRdy) | CyTxMpty);
-				}
-				goto txdone;
 			}
-			if (info->xmit_buf == NULL) {
-				cy_writeb(base_addr + (CySRER << index),
-					readb(base_addr + (CySRER << index)) &
+			goto done;
+		}
+		if (info->xmit_buf == NULL) {
+			cy_writeb(base_addr + (CySRER << index),
+				readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
-				goto txdone;
-			}
-			if (info->tty->stopped || info->tty->hw_stopped) {
-				cy_writeb(base_addr + (CySRER << index),
-					readb(base_addr + (CySRER << index)) &
+			goto done;
+		}
+		if (info->tty->stopped || info->tty->hw_stopped) {
+			cy_writeb(base_addr + (CySRER << index),
+				readb(base_addr + (CySRER << index)) &
 					~CyTxRdy);
-				goto txdone;
-			}
-			/* Because the Embedded Transmit Commands have
-			   been enabled, we must check to see if the
-			   escape character, NULL, is being sent.  If it
-			   is, we must ensure that there is room for it
-			   to be doubled in the output stream.  Therefore
-			   we no longer advance the pointer when the
-			   character is fetched, but rather wait until
-			   after the check for a NULL output character.
-			   This is necessary because there may not be
-			   room for the two chars needed to send a NULL.)
-			 */
-			outch = info->xmit_buf[info->xmit_tail];
-			if (outch) {
+			goto done;
+		}
+		/* Because the Embedded Transmit Commands have been enabled,
+		 * we must check to see if the escape character, NULL, is being
+		 * sent. If it is, we must ensure that there is room for it to
+		 * be doubled in the output stream.  Therefore we no longer
+		 * advance the pointer when the character is fetched, but
+		 * rather wait until after the check for a NULL output
+		 * character. This is necessary because there may not be room
+		 * for the two chars needed to send a NULL.)
+		 */
+		outch = info->xmit_buf[info->xmit_tail];
+		if (outch) {
+			info->xmit_cnt--;
+			info->xmit_tail = (info->xmit_tail + 1) &
+					(SERIAL_XMIT_SIZE - 1);
+			cy_writeb(base_addr + (CyTDR << index), outch);
+			info->icount.tx++;
+		} else {
+			if (char_count > 1) {
 				info->xmit_cnt--;
 				info->xmit_tail = (info->xmit_tail + 1) &
-						(SERIAL_XMIT_SIZE - 1);
+					(SERIAL_XMIT_SIZE - 1);
 				cy_writeb(base_addr + (CyTDR << index), outch);
+				cy_writeb(base_addr + (CyTDR << index), 0);
 				info->icount.tx++;
-			} else {
-				if (char_count > 1) {
-					info->xmit_cnt--;
-					info->xmit_tail = (info->xmit_tail + 1)&
-						(SERIAL_XMIT_SIZE - 1);
-					cy_writeb(base_addr + (CyTDR << index),
-						outch);
-					cy_writeb(base_addr + (CyTDR << index),
-						0);
-					info->icount.tx++;
-					char_count--;
-				}
+				char_count--;
 			}
 		}
+	}
 
-txdone:
-		tty_wakeup(info->tty);
-txend:
-		/* end of service */
-		cy_writeb(base_addr + (CyTIR << index), (save_xir & 0x3f));
-		cy_writeb(base_addr + (CyCAR << index), (save_car));
-		spin_unlock(&cinfo->card_lock);
-	}
-
-	if (status & CySRModem) {	/* modem interrupt */
-
-		/* determine the channel & change to that context */
-		spin_lock(&cinfo->card_lock);
-		save_xir = (u_char) readb(base_addr + (CyMIR << index));
-		channel = (u_short) (save_xir & CyIRChannel);
-		info = &cinfo->ports[channel + chip * 4];
-		save_car = readb(base_addr + (CyCAR << index));
-		cy_writeb(base_addr + (CyCAR << index), save_xir);
+done:
+	tty_wakeup(info->tty);
+end:
+	/* end of service */
+	cy_writeb(base_addr + (CyTIR << index), save_xir & 0x3f);
+	cy_writeb(base_addr + (CyCAR << index), save_car);
+	spin_unlock(&cinfo->card_lock);
+}
 
-		mdm_change = readb(base_addr + (CyMISR << index));
-		mdm_status = readb(base_addr + (CyMSVR1 << index));
+static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
+		void __iomem *base_addr)
+{
+	struct cyclades_port *info;
+	int mdm_change, mdm_status;
+	int save_xir, channel, save_car, index = cinfo->bus_index;
 
-		if (info->tty) {
-			if (mdm_change & CyANY_DELTA) {
-				/* For statistics only */
-				if (mdm_change & CyDCD)
-					info->icount.dcd++;
-				if (mdm_change & CyCTS)
-					info->icount.cts++;
-				if (mdm_change & CyDSR)
-					info->icount.dsr++;
-				if (mdm_change & CyRI)
-					info->icount.rng++;
-
-				wake_up_interruptible(&info->delta_msr_wait);
-			}
-
-			if ((mdm_change & CyDCD) &&
-					(info->flags & ASYNC_CHECK_CD)) {
-				if (!(mdm_status & CyDCD)) {
-					tty_hangup(info->tty);
-					info->flags &= ~ASYNC_NORMAL_ACTIVE;
-				}
-				wake_up_interruptible(&info->open_wait);
-			}
-			if ((mdm_change & CyCTS) &&
-					(info->flags & ASYNC_CTS_FLOW)) {
-				if (info->tty->hw_stopped) {
-					if (mdm_status & CyCTS) {
-						/* cy_start isn't used
-						   because... !!! */
-						info->tty->hw_stopped = 0;
-						cy_writeb(base_addr +
-							(CySRER << index),
-							readb(base_addr +
-								(CySRER <<
-									index))|
-							CyTxRdy);
-						tty_wakeup(info->tty);
-					}
-				} else {
-					if (!(mdm_status & CyCTS)) {
-						/* cy_stop isn't used
-						   because ... !!! */
-						info->tty->hw_stopped = 1;
-						cy_writeb(base_addr +
-							(CySRER << index),
-							readb(base_addr +
-								(CySRER <<
-								index)) &
-							~CyTxRdy);
-					}
-				}
+	/* determine the channel & change to that context */
+	spin_lock(&cinfo->card_lock);
+	save_xir = (u_char) readb(base_addr + (CyMIR << index));
+	channel = (u_short) (save_xir & CyIRChannel);
+	info = &cinfo->ports[channel + chip * 4];
+	save_car = readb(base_addr + (CyCAR << index));
+	cy_writeb(base_addr + (CyCAR << index), save_xir);
+
+	mdm_change = readb(base_addr + (CyMISR << index));
+	mdm_status = readb(base_addr + (CyMSVR1 << index));
+
+	if (!info->tty)
+		goto end;
+
+	if (mdm_change & CyANY_DELTA) {
+		/* For statistics only */
+		if (mdm_change & CyDCD)
+			info->icount.dcd++;
+		if (mdm_change & CyCTS)
+			info->icount.cts++;
+		if (mdm_change & CyDSR)
+			info->icount.dsr++;
+		if (mdm_change & CyRI)
+			info->icount.rng++;
+
+		wake_up_interruptible(&info->delta_msr_wait);
+	}
+
+	if ((mdm_change & CyDCD) && (info->flags & ASYNC_CHECK_CD)) {
+		if (!(mdm_status & CyDCD)) {
+			tty_hangup(info->tty);
+			info->flags &= ~ASYNC_NORMAL_ACTIVE;
+		}
+		wake_up_interruptible(&info->open_wait);
+	}
+	if ((mdm_change & CyCTS) && (info->flags & ASYNC_CTS_FLOW)) {
+		if (info->tty->hw_stopped) {
+			if (mdm_status & CyCTS) {
+				/* cy_start isn't used
+				   because... !!! */
+				info->tty->hw_stopped = 0;
+				cy_writeb(base_addr + (CySRER << index),
+					readb(base_addr + (CySRER << index)) |
+						CyTxRdy);
+				tty_wakeup(info->tty);
 			}
-/*			if (mdm_change & CyDSR) {
+		} else {
+			if (!(mdm_status & CyCTS)) {
+				/* cy_stop isn't used
+				   because ... !!! */
+				info->tty->hw_stopped = 1;
+				cy_writeb(base_addr + (CySRER << index),
+					readb(base_addr + (CySRER << index)) &
+						~CyTxRdy);
 			}
-			if (mdm_change & CyRI) {
-			}*/
 		}
-		/* end of service */
-		cy_writeb(base_addr + (CyMIR << index), (save_xir & 0x3f));
-		cy_writeb(base_addr + (CyCAR << index), save_car);
-		spin_unlock(&cinfo->card_lock);
 	}
+/*	if (mdm_change & CyDSR) {
+	}
+	if (mdm_change & CyRI) {
+	}*/
+end:
+	/* end of service */
+	cy_writeb(base_addr + (CyMIR << index), save_xir & 0x3f);
+	cy_writeb(base_addr + (CyCAR << index), save_car);
+	spin_unlock(&cinfo->card_lock);
 }
 
 /* The real interrupt service routine is called
@@ -1401,11 +1365,14 @@ static irqreturn_t cyy_interrupt(int irq
 			   chips to be checked in a round-robin fashion (after
 			   draining each of a bunch (1000) of characters).
 			 */
-				if (1000 < too_many++) {
+				if (1000 < too_many++)
 					break;
-				}
-				cyy_intr_chip(cinfo, chip, base_addr, status,
-						index);
+				if (status & CySRReceive) /* rx intr */
+					cyy_chip_rx(cinfo, chip, base_addr);
+				if (status & CySRTransmit) /* tx intr */
+					cyy_chip_tx(cinfo, chip, base_addr);
+				if (status & CySRModem) /* modem intr */
+					cyy_chip_modem(cinfo, chip, base_addr);
 			}
 		}
 	} while (had_work);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
