From: akpm@linux-foundation.org
Subject: + esp-clean-up-to-modern-coding-style.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:21:22 -0700
Message-ID: <200804291921.m3TJLMGh005395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbYD2TWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com


The patch titled
     esp: clean up to modern coding style
has been added to the -mm tree.  Its filename is
     esp-clean-up-to-modern-coding-style.patch

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
Subject: esp: clean up to modern coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/esp.c |  591 ++++++++++++++++++++-----------------------
 1 file changed, 283 insertions(+), 308 deletions(-)

diff -puN drivers/char/esp.c~esp-clean-up-to-modern-coding-style drivers/char/esp.c
--- a/drivers/char/esp.c~esp-clean-up-to-modern-coding-style
+++ a/drivers/char/esp.c
@@ -8,7 +8,7 @@
  *  Extensively rewritten by Theodore Ts'o, 8/16/92 -- 9/14/92.  Now
  *  much more extensible to support other serial cards based on the
  *  16450/16550A UART's.  Added support for the AST FourPort and the
- *  Accent Async board.  
+ *  Accent Async board.
  *
  *  set_serial_info fixed to set the flags, custom divisor, and uart
  * 	type fields.  Fix suggested by Michael K. Johnson 12/12/92.
@@ -61,11 +61,11 @@
 #include <linux/bitops.h>
 
 #include <asm/system.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <asm/dma.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/hayesesp.h>
 
@@ -127,8 +127,10 @@ static struct tty_driver *esp_driver;
 #undef SERIAL_DEBUG_FLOW
 
 #if defined(MODULE) && defined(SERIAL_DEBUG_MCOUNT)
-#define DBG_CNT(s) printk("(%s): [%x] refc=%d, serc=%d, ttyc=%d -> %s\n", \
- tty->name, (info->flags), serial_driver.refcount,info->count,tty->count,s)
+#define DBG_CNT(s) printk(KERN_DEBUG "(%s): [%x] refc=%d, serc=%d, ttyc=%d -> %s\n", \
+				tty->name, info->flags, \
+				serial_driver.refcount, \
+				info->count, tty->count, s)
 #else
 #define DBG_CNT(s)
 #endif
@@ -189,7 +191,7 @@ static inline void serial_out(struct esp
  */
 static void rs_stop(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_stop"))
@@ -206,12 +208,12 @@ static void rs_stop(struct tty_struct *t
 
 static void rs_start(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
-	
+
 	if (serial_paranoia_check(info, tty->name, "rs_start"))
 		return;
-	
+
 	spin_lock_irqsave(&info->lock, flags);
 	if (info->xmit_cnt && info->xmit_buf && !(info->IER & UART_IER_THRI)) {
 		info->IER |= UART_IER_THRI;
@@ -233,7 +235,7 @@ static void rs_start(struct tty_struct *
  * rs_interrupt() should try to keep the interrupt handler as fast as
  * possible.  After you are done making modifications, it is not a bad
  * idea to do:
- * 
+ *
  * gcc -S -DKERNEL -Wall -Wstrict-prototypes -O6 -fomit-frame-pointer serial.c
  *
  * and look at the resulting assemble code in serial.s.
@@ -290,7 +292,7 @@ static inline void receive_chars_pio(str
 	}
 
 	status_mask = (info->read_status_mask >> 2) & 0x07;
-		
+
 	for (i = 0; i < num_bytes - 1; i += 2) {
 		*((unsigned short *)(pio_buf->data + i)) =
 			inw(info->port + UART_ESI_RX);
@@ -325,8 +327,7 @@ static inline void receive_chars_pio(str
 				flag = TTY_BREAK;
 				if (info->flags & ASYNC_SAK)
 					do_SAK(tty);
-			}
-			else if (err_buf->data[i] & 0x02)
+			} else if (err_buf->data[i] & 0x02)
 				flag = TTY_FRAME;
 			else if (err_buf->data[i] & 0x01)
 				flag = TTY_PARITY;
@@ -341,23 +342,29 @@ static inline void receive_chars_pio(str
 	release_pio_buffer(err_buf);
 }
 
-static inline void receive_chars_dma(struct esp_struct *info, int num_bytes)
+static void program_isa_dma(int dma, int dir, unsigned long addr, int len)
 {
 	unsigned long flags;
+
+	flags = claim_dma_lock();
+	disable_dma(dma);
+	clear_dma_ff(dma);
+	set_dma_mode(dma, dir);
+	set_dma_addr(dma, addr);
+	set_dma_count(dma, len);
+	enable_dma(dma);
+	release_dma_lock(flags);
+}
+
+static void receive_chars_dma(struct esp_struct *info, int num_bytes)
+{
 	info->stat_flags &= ~ESP_STAT_RX_TIMEOUT;
 	dma_bytes = num_bytes;
 	info->stat_flags |= ESP_STAT_DMA_RX;
-	
-	flags=claim_dma_lock();
-        disable_dma(dma);
-        clear_dma_ff(dma);
-        set_dma_mode(dma, DMA_MODE_READ);
-        set_dma_addr(dma, isa_virt_to_bus(dma_buffer));
-        set_dma_count(dma, dma_bytes);
-        enable_dma(dma);
-        release_dma_lock(flags);
-        
-        serial_out(info, UART_ESI_CMD1, ESI_START_DMA_RX);
+
+	program_isa_dma(dma, DMA_MODE_READ, isa_virt_to_bus(dma_buffer),
+								dma_bytes);
+	serial_out(info, UART_ESI_CMD1, ESI_START_DMA_RX);
 }
 
 static inline void receive_chars_dma_done(struct esp_struct *info,
@@ -366,22 +373,22 @@ static inline void receive_chars_dma_don
 	struct tty_struct *tty = info->tty;
 	int num_bytes;
 	unsigned long flags;
-	
-	flags=claim_dma_lock();
+
+	flags = claim_dma_lock();
 	disable_dma(dma);
 	clear_dma_ff(dma);
 
 	info->stat_flags &= ~ESP_STAT_DMA_RX;
 	num_bytes = dma_bytes - get_dma_residue(dma);
 	release_dma_lock(flags);
-	
+
 	info->icount.rx += num_bytes;
 
 	if (num_bytes > 0) {
 		tty_insert_flip_string(tty, dma_buffer, num_bytes - 1);
 
 		status &= (0x1c & info->read_status_mask);
-		
+
 		/* Is the status significant or do we throw the last byte ? */
 		if (!(status & info->ignore_status_mask)) {
 			int statflag = 0;
@@ -393,13 +400,13 @@ static inline void receive_chars_dma_don
 					do_SAK(tty);
 			} else if (status & 0x08) {
 				statflag = TTY_FRAME;
-				(info->icount.frame)++;
-			}
-			else if (status & 0x04) {
+				info->icount.frame++;
+			} else if (status & 0x04) {
 				statflag = TTY_PARITY;
-				(info->icount.parity)++;
+				info->icount.parity++;
 			}
-			tty_insert_flip_char(tty, dma_buffer[num_bytes - 1], statflag);
+			tty_insert_flip_char(tty, dma_buffer[num_bytes - 1],
+								statflag);
 		}
 		tty_schedule_flip(tty);
 	}
@@ -484,8 +491,6 @@ static inline void transmit_chars_pio(st
 /* Caller must hold info->lock */
 static inline void transmit_chars_dma(struct esp_struct *info, int num_bytes)
 {
-	unsigned long flags;
-	
 	dma_bytes = num_bytes;
 
 	if (info->xmit_tail + dma_bytes <= ESP_XMIT_SIZE) {
@@ -517,26 +522,18 @@ static inline void transmit_chars_dma(st
 	}
 
 	info->stat_flags |= ESP_STAT_DMA_TX;
-	
-	flags=claim_dma_lock();
-        disable_dma(dma);
-        clear_dma_ff(dma);
-        set_dma_mode(dma, DMA_MODE_WRITE);
-        set_dma_addr(dma, isa_virt_to_bus(dma_buffer));
-        set_dma_count(dma, dma_bytes);
-        enable_dma(dma);
-        release_dma_lock(flags);
-        
-        serial_out(info, UART_ESI_CMD1, ESI_START_DMA_TX);
+
+	program_isa_dma(dma, DMA_MODE_WRITE, isa_virt_to_bus(dma_buffer),
+								dma_bytes);
+	serial_out(info, UART_ESI_CMD1, ESI_START_DMA_TX);
 }
 
 static inline void transmit_chars_dma_done(struct esp_struct *info)
 {
 	int num_bytes;
 	unsigned long flags;
-	
 
-	flags=claim_dma_lock();
+	flags = claim_dma_lock();
 	disable_dma(dma);
 	clear_dma_ff(dma);
 
@@ -547,27 +544,21 @@ static inline void transmit_chars_dma_do
 	if (dma_bytes != num_bytes) {
 		dma_bytes -= num_bytes;
 		memmove(dma_buffer, dma_buffer + num_bytes, dma_bytes);
-		
-		flags=claim_dma_lock();
-        	disable_dma(dma);
-        	clear_dma_ff(dma);
-        	set_dma_mode(dma, DMA_MODE_WRITE);
-        	set_dma_addr(dma, isa_virt_to_bus(dma_buffer));
-        	set_dma_count(dma, dma_bytes);
-        	enable_dma(dma);
-        	release_dma_lock(flags);
-        	
-        	serial_out(info, UART_ESI_CMD1, ESI_START_DMA_TX);
+
+		program_isa_dma(dma, DMA_MODE_WRITE,
+				isa_virt_to_bus(dma_buffer), dma_bytes);
+
+		serial_out(info, UART_ESI_CMD1, ESI_START_DMA_TX);
 	} else {
 		dma_bytes = 0;
 		info->stat_flags &= ~ESP_STAT_DMA_TX;
 	}
 }
 
-static inline void check_modem_status(struct esp_struct *info)
+static void check_modem_status(struct esp_struct *info)
 {
 	int	status;
-	
+
 	serial_out(info, UART_ESI_CMD1, ESI_GET_UART_STAT);
 	status = serial_in(info, UART_ESI_STAT2);
 
@@ -588,7 +579,7 @@ static inline void check_modem_status(st
 #if (defined(SERIAL_DEBUG_OPEN) || defined(SERIAL_DEBUG_INTR))
 		printk("ttys%d CD now %s...", info->line,
 		       (status & UART_MSR_DCD) ? "on" : "off");
-#endif		
+#endif
 		if (status & UART_MSR_DCD)
 			wake_up_interruptible(&info->open_wait);
 		else {
@@ -605,7 +596,7 @@ static inline void check_modem_status(st
  */
 static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
 {
-	struct esp_struct * info;
+	struct esp_struct *info;
 	unsigned err_status;
 	unsigned int scratch;
 
@@ -617,7 +608,7 @@ static irqreturn_t rs_interrupt_single(i
 	scratch = serial_in(info, UART_ESI_SID);
 
 	spin_lock(&info->lock);
-	
+
 	if (!info->tty) {
 		spin_unlock(&info->lock);
 		return IRQ_NONE;
@@ -637,7 +628,7 @@ static irqreturn_t rs_interrupt_single(i
 		if (err_status & 0x80) /* Start break */
 			wake_up_interruptible(&info->break_wait);
 	}
-		
+
 	if ((scratch & 0x88) || /* DMA completed or timed out */
 	    (err_status & 0x1c) /* receive error */) {
 		if (info->stat_flags & ESP_STAT_DMA_RX)
@@ -667,7 +658,7 @@ static irqreturn_t rs_interrupt_single(i
 				receive_chars_dma(info, num_bytes);
 		}
 	}
-	
+
 	if (!(info->stat_flags & (ESP_STAT_DMA_RX | ESP_STAT_DMA_TX)) &&
 	    (scratch & 0x02) && (info->IER & UART_IER_THRI)) {
 		if ((info->xmit_cnt <= 0) || info->tty->stopped) {
@@ -722,11 +713,11 @@ static irqreturn_t rs_interrupt_single(i
  * ---------------------------------------------------------------
  */
 
-static inline void esp_basic_init(struct esp_struct * info)
+static void esp_basic_init(struct esp_struct *info)
 {
 	/* put ESPC in enhanced mode */
 	serial_out(info, UART_ESI_CMD1, ESI_SET_MODE);
-	
+
 	if (info->stat_flags & ESP_STAT_NEVER_DMA)
 		serial_out(info, UART_ESI_CMD2, 0x01);
 	else
@@ -783,13 +774,13 @@ static inline void esp_basic_init(struct
 	serial_out(info, UART_ESI_CMD2, 0xff);
 }
 
-static int startup(struct esp_struct * info)
+static int startup(struct esp_struct *info)
 {
 	unsigned long flags;
-	int	retval=0;
-        unsigned int num_chars;
+	int	retval = 0;
+	unsigned int num_chars;
 
-        spin_lock_irqsave(&info->lock, flags);
+	spin_lock_irqsave(&info->lock, flags);
 
 	if (info->flags & ASYNC_INITIALIZED)
 		goto out;
@@ -802,7 +793,8 @@ static int startup(struct esp_struct * i
 	}
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("starting up ttys%d (irq %d)...", info->line, info->irq);
+	printk(KERN_DEBUG "starting up ttys%d (irq %d)...",
+						info->line, info->irq);
 #endif
 
 	/* Flush the RX buffer.  Using the ESI flush command may cause */
@@ -863,7 +855,7 @@ static int startup(struct esp_struct * i
 			dma_buffer = NULL;
 			info->stat_flags |= ESP_STAT_USE_PIO;
 		}
-			
+
 	}
 
 	info->MCR = UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2;
@@ -872,7 +864,7 @@ static int startup(struct esp_struct * i
 	serial_out(info, UART_ESI_CMD1, ESI_WRITE_UART);
 	serial_out(info, UART_ESI_CMD2, UART_MCR);
 	serial_out(info, UART_ESI_CMD2, info->MCR);
-	
+
 	/*
 	 * Finally, enable interrupts
 	 */
@@ -881,7 +873,7 @@ static int startup(struct esp_struct * i
 			UART_IER_DMA_TC;
 	serial_out(info, UART_ESI_CMD1, ESI_SET_SRV_MASK);
 	serial_out(info, UART_ESI_CMD2, info->IER);
-	
+
 	if (info->tty)
 		clear_bit(TTY_IO_ERROR, &info->tty->flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
@@ -900,7 +892,7 @@ static int startup(struct esp_struct * i
 		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			info->tty->alt_speed = 460800;
 	}
-	
+
 	/*
 	 * set the speed of the serial port
 	 */
@@ -918,7 +910,7 @@ out_unlocked:
  * This routine will shutdown a serial port; interrupts are disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void shutdown(struct esp_struct * info)
+static void shutdown(struct esp_struct *info)
 {
 	unsigned long	flags, f;
 
@@ -929,7 +921,7 @@ static void shutdown(struct esp_struct *
 	printk("Shutting down serial port %d (irq %d)....", info->line,
 	       info->irq);
 #endif
-	
+
 	spin_lock_irqsave(&info->lock, flags);
 	/*
 	 * clear delta_msr_wait queue to avoid mem leaks: we may free the irq
@@ -941,14 +933,14 @@ static void shutdown(struct esp_struct *
 	/* stop a DMA transfer on the port being closed */
 	/* DMA lock is higher priority always */
 	if (info->stat_flags & (ESP_STAT_DMA_RX | ESP_STAT_DMA_TX)) {
-		f=claim_dma_lock();
+		f = claim_dma_lock();
 		disable_dma(dma);
 		clear_dma_ff(dma);
 		release_dma_lock(f);
-		
+
 		dma_bytes = 0;
 	}
-	
+
 	/*
 	 * Free the IRQ
 	 */
@@ -970,7 +962,7 @@ static void shutdown(struct esp_struct *
 			free_pages((unsigned long)dma_buffer,
 				   get_order(DMA_BUFFER_SZ));
 			dma_buffer = NULL;
-		}		
+		}
 	}
 
 	if (info->xmit_buf) {
@@ -992,7 +984,7 @@ static void shutdown(struct esp_struct *
 
 	if (info->tty)
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
-	
+
 	info->flags &= ~ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&info->lock, flags);
 }
@@ -1005,7 +997,7 @@ static void change_speed(struct esp_stru
 {
 	unsigned short port;
 	int	quot = 0;
-	unsigned cflag,cval;
+	unsigned cflag, cval;
 	int	baud, bits;
 	unsigned char flow1 = 0, flow2 = 0;
 	unsigned long flags;
@@ -1014,14 +1006,14 @@ static void change_speed(struct esp_stru
 		return;
 	cflag = info->tty->termios->c_cflag;
 	port = info->port;
-	
+
 	/* byte size and parity */
 	switch (cflag & CSIZE) {
-	      case CS5: cval = 0x00; bits = 7; break;
-	      case CS6: cval = 0x01; bits = 8; break;
-	      case CS7: cval = 0x02; bits = 9; break;
-	      case CS8: cval = 0x03; bits = 10; break;
-	      default:  cval = 0x00; bits = 7; break;
+	case CS5: cval = 0x00; bits = 7; break;
+	case CS6: cval = 0x01; bits = 8; break;
+	case CS7: cval = 0x02; bits = 9; break;
+	case CS8: cval = 0x03; bits = 10; break;
+	default:  cval = 0x00; bits = 7; break;
 	}
 	if (cflag & CSTOPB) {
 		cval |= 0x04;
@@ -1037,14 +1029,12 @@ static void change_speed(struct esp_stru
 	if (cflag & CMSPAR)
 		cval |= UART_LCR_SPAR;
 #endif
-
 	baud = tty_get_baud_rate(info->tty);
 	if (baud == 38400 &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
+		((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST))
 		quot = info->custom_divisor;
 	else {
-		if (baud == 134)
-			/* Special case since 134 is really 134.5 */
+		if (baud == 134) /* Special case since 134 is really 134.5 */
 			quot = (2*BASE_BAUD / 269);
 		else if (baud)
 			quot = BASE_BAUD / baud;
@@ -1052,7 +1042,12 @@ static void change_speed(struct esp_stru
 	/* If the quotient is ever zero, default to 9600 bps */
 	if (!quot)
 		quot = BASE_BAUD / 9600;
-	
+
+	if (baud) {
+		/* Actual rate */
+		baud = BASE_BAUD/quot;
+		tty_encode_baud_rate(info->tty, baud, baud);
+	}
 	info->timeout = ((1024 * HZ * bits * quot) / BASE_BAUD) + (HZ / 50);
 
 	/* CTS flow control flag and modem status interrupts */
@@ -1066,10 +1061,8 @@ static void change_speed(struct esp_stru
 		info->flags &= ~ASYNC_CTS_FLOW;
 	if (cflag & CLOCAL)
 		info->flags &= ~ASYNC_CHECK_CD;
-	else {
+	else
 		info->flags |= ASYNC_CHECK_CD;
-		/* info->IER |= UART_IER_MSI; */
-	}
 
 	/*
 	 * Set up parity check flag
@@ -1079,7 +1072,7 @@ static void change_speed(struct esp_stru
 		info->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
 	if (I_BRKINT(info->tty) || I_PARMRK(info->tty))
 		info->read_status_mask |= UART_LSR_BI;
-	
+
 	info->ignore_status_mask = 0;
 #if 0
 	/* This should be safe, but for some broken bits of hardware... */
@@ -1092,7 +1085,7 @@ static void change_speed(struct esp_stru
 		info->ignore_status_mask |= UART_LSR_BI;
 		info->read_status_mask |= UART_LSR_BI;
 		/*
-		 * If we're ignore parity and break indicators, ignore 
+		 * If we're ignore parity and break indicators, ignore
 		 * overruns too.  (For real raw support).
 		 */
 		if (I_IGNPAR(info->tty)) {
@@ -1130,19 +1123,19 @@ static void change_speed(struct esp_stru
 		serial_out(info, UART_ESI_CMD2, 0x10);
 		serial_out(info, UART_ESI_CMD2, 0x21);
 		switch (cflag & CSIZE) {
-			case CS5:
-				serial_out(info, UART_ESI_CMD2, 0x1f);
-				break;
-			case CS6:
-				serial_out(info, UART_ESI_CMD2, 0x3f);
-				break;
-			case CS7:
-			case CS8:
-				serial_out(info, UART_ESI_CMD2, 0x7f);
-				break;
-			default:
-				serial_out(info, UART_ESI_CMD2, 0xff);
-				break;
+		case CS5:
+			serial_out(info, UART_ESI_CMD2, 0x1f);
+			break;
+		case CS6:
+			serial_out(info, UART_ESI_CMD2, 0x3f);
+			break;
+		case CS7:
+		case CS8:
+			serial_out(info, UART_ESI_CMD2, 0x7f);
+			break;
+		default:
+			serial_out(info, UART_ESI_CMD2, 0xff);
+			break;
 		}
 	}
 
@@ -1158,7 +1151,7 @@ static void change_speed(struct esp_stru
 
 static void rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
@@ -1178,9 +1171,9 @@ static void rs_put_char(struct tty_struc
 
 static void rs_flush_chars(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
-				
+
 	if (serial_paranoia_check(info, tty->name, "rs_flush_chars"))
 		return;
 
@@ -1198,11 +1191,11 @@ out:
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static int rs_write(struct tty_struct * tty,
+static int rs_write(struct tty_struct *tty,
 		    const unsigned char *buf, int count)
 {
 	int	c, t, ret = 0;
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_write"))
@@ -1210,19 +1203,19 @@ static int rs_write(struct tty_struct * 
 
 	if (!info->xmit_buf)
 		return 0;
-	    
+
 	while (1) {
 		/* Thanks to R. Wolff for suggesting how to do this with */
 		/* interrupts enabled */
 
 		c = count;
 		t = ESP_XMIT_SIZE - info->xmit_cnt - 1;
-		
+
 		if (t < c)
 			c = t;
 
 		t = ESP_XMIT_SIZE - info->xmit_head;
-		
+
 		if (t < c)
 			c = t;
 
@@ -1252,10 +1245,10 @@ static int rs_write(struct tty_struct * 
 
 static int rs_write_room(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	int	ret;
 	unsigned long flags;
-				
+
 	if (serial_paranoia_check(info, tty->name, "rs_write_room"))
 		return 0;
 
@@ -1270,8 +1263,8 @@ static int rs_write_room(struct tty_stru
 
 static int rs_chars_in_buffer(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
-				
+	struct esp_struct *info = tty->driver_data;
+
 	if (serial_paranoia_check(info, tty->name, "rs_chars_in_buffer"))
 		return 0;
 	return info->xmit_cnt;
@@ -1279,9 +1272,9 @@ static int rs_chars_in_buffer(struct tty
 
 static void rs_flush_buffer(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
-				
+
 	if (serial_paranoia_check(info, tty->name, "rs_flush_buffer"))
 		return;
 	spin_lock_irqsave(&info->lock, flags);
@@ -1293,20 +1286,20 @@ static void rs_flush_buffer(struct tty_s
 /*
  * ------------------------------------------------------------
  * rs_throttle()
- * 
+ *
  * This routine is called by the upper-layer tty layer to signal that
  * incoming characters should be throttled.
  * ------------------------------------------------------------
  */
-static void rs_throttle(struct tty_struct * tty)
+static void rs_throttle(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 #ifdef SERIAL_DEBUG_THROTTLE
 	char	buf[64];
-	
+
 	printk("throttle %s: %d....\n", tty_name(tty, buf),
-	       tty->ldisc.chars_in_buffer(tty));
+						tty_chars_in_buffer(tty));
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "rs_throttle"))
@@ -1321,20 +1314,20 @@ static void rs_throttle(struct tty_struc
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rs_unthrottle(struct tty_struct * tty)
+static void rs_unthrottle(struct tty_struct *tty)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 #ifdef SERIAL_DEBUG_THROTTLE
 	char	buf[64];
-	
-	printk("unthrottle %s: %d....\n", tty_name(tty, buf),
-	       tty->ldisc.chars_in_buffer(tty));
+
+	printk(KERN_DEBUG "unthrottle %s: %d....\n", tty_name(tty, buf),
+	       tty_chars_in_buffer(tty));
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "rs_unthrottle"))
 		return;
-	
+
 	spin_lock_irqsave(&info->lock, flags);
 	info->IER |= UART_IER_RDI;
 	serial_out(info, UART_ESI_CMD1, ESI_SET_SRV_MASK);
@@ -1350,11 +1343,11 @@ static void rs_unthrottle(struct tty_str
  * ------------------------------------------------------------
  */
 
-static int get_serial_info(struct esp_struct * info,
+static int get_serial_info(struct esp_struct *info,
 			   struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
-  
+
 	lock_kernel();
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = PORT_16550A;
@@ -1369,16 +1362,16 @@ static int get_serial_info(struct esp_st
 	tmp.custom_divisor = info->custom_divisor;
 	tmp.hub6 = 0;
 	unlock_kernel();
-	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
+	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
 }
 
-static int get_esp_config(struct esp_struct * info,
+static int get_esp_config(struct esp_struct *info,
 			  struct hayes_esp_config __user *retinfo)
 {
 	struct hayes_esp_config tmp;
-  
+
 	if (!retinfo)
 		return -EFAULT;
 
@@ -1396,7 +1389,7 @@ static int get_esp_config(struct esp_str
 	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
 
-static int set_serial_info(struct esp_struct * info,
+static int set_serial_info(struct esp_struct *info,
 			   struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
@@ -1405,7 +1398,7 @@ static int set_serial_info(struct esp_st
 	int retval = 0;
 	struct esp_struct *current_async;
 
-	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 	old_info = *info;
 
@@ -1426,7 +1419,7 @@ static int set_serial_info(struct esp_st
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		if (change_irq || 
+		if (change_irq ||
 		    (new_serial.close_delay != info->close_delay) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->flags & ~ASYNC_USR_MASK)))
@@ -1511,8 +1504,8 @@ static int set_serial_info(struct esp_st
 	return retval;
 }
 
-static int set_esp_config(struct esp_struct * info,
-			  struct hayes_esp_config __user * new_info)
+static int set_esp_config(struct esp_struct *info,
+			  struct hayes_esp_config __user *new_info)
 {
 	struct hayes_esp_config new_config;
 	unsigned int change_dma;
@@ -1554,7 +1547,6 @@ static int set_esp_config(struct esp_str
 		if (new_config.dma_channel) {
 			/* PIO mode to DMA mode transition OR */
 			/* change current DMA channel */
-			
 			current_async = ports;
 
 			while (current_async) {
@@ -1563,16 +1555,15 @@ static int set_esp_config(struct esp_str
 						return -EBUSY;
 				} else if (current_async->count)
 					return -EBUSY;
-					
-				current_async =
-					current_async->next_port;
+
+				current_async = current_async->next_port;
 			}
 
 			shutdown(info);
 			dma = new_config.dma_channel;
 			info->stat_flags &= ~ESP_STAT_NEVER_DMA;
-			
-                        /* all ports must use the same DMA channel */
+
+			/* all ports must use the same DMA channel */
 
 			spin_lock_irqsave(&info->lock, flags);
 			current_async = ports;
@@ -1584,7 +1575,6 @@ static int set_esp_config(struct esp_str
 			spin_unlock_irqrestore(&info->lock, flags);
 		} else {
 			/* DMA mode to PIO mode only */
-			
 			if (info->count > 1)
 				return -EBUSY;
 
@@ -1655,9 +1645,9 @@ static int set_esp_config(struct esp_str
  * 	    release the bus after transmitting. This must be done when
  * 	    the transmit shift register is empty, not be done when the
  * 	    transmit holding register is empty.  This functionality
- * 	    allows an RS485 driver to be written in user space. 
+ * 	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct esp_struct * info, unsigned int __user *value)
+static int get_lsr_info(struct esp_struct *info, unsigned int __user *value)
 {
 	unsigned char status;
 	unsigned int result;
@@ -1668,13 +1658,13 @@ static int get_lsr_info(struct esp_struc
 	status = serial_in(info, UART_ESI_STAT1);
 	spin_unlock_irqrestore(&info->lock, flags);
 	result = ((status & UART_LSR_TEMT) ? TIOCSER_TEMT : 0);
-	return put_user(result,value);
+	return put_user(result, value);
 }
 
 
 static int esp_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned char control, status;
 	unsigned long flags;
 
@@ -1701,7 +1691,7 @@ static int esp_tiocmget(struct tty_struc
 static int esp_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
@@ -1734,9 +1724,9 @@ static int esp_tiocmset(struct tty_struc
  */
 static void esp_break(struct tty_struct *tty, int break_state)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
-	
+
 	if (serial_paranoia_check(info, tty->name, "esp_break"))
 		return;
 
@@ -1756,10 +1746,10 @@ static void esp_break(struct tty_struct 
 	}
 }
 
-static int rs_ioctl(struct tty_struct *tty, struct file * file,
+static int rs_ioctl(struct tty_struct *tty, struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
@@ -1777,102 +1767,93 @@ static int rs_ioctl(struct tty_struct *t
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
-	
-	switch (cmd) {
-		case TIOCGSERIAL:
-			return get_serial_info(info, argp);
-		case TIOCSSERIAL:
-			lock_kernel();
-			ret = set_serial_info(info, argp);
-			unlock_kernel();
-			return ret;
-		case TIOCSERCONFIG:
-			/* do not reconfigure after initial configuration */
-			return 0;
-
-		case TIOCSERGWILD:
-			return put_user(0L, (unsigned long __user *)argp);
 
-		case TIOCSERGETLSR: /* Get line status register */
-			    return get_lsr_info(info, argp);
-
-		case TIOCSERSWILD:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			return 0;
-
-		/*
-		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
-		 * - mask passed in arg for lines of interest
- 		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
-		 * Caller should use TIOCGICOUNT to see which one it was
-		 */
-		 case TIOCMIWAIT:
+	switch (cmd) {
+	case TIOCGSERIAL:
+		return get_serial_info(info, argp);
+	case TIOCSSERIAL:
+		lock_kernel();
+		ret = set_serial_info(info, argp);
+		unlock_kernel();
+		return ret;
+	case TIOCSERGWILD:
+		return put_user(0L, (unsigned long __user *)argp);
+	case TIOCSERGETLSR: /* Get line status register */
+		return get_lsr_info(info, argp);
+	case TIOCSERSWILD:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		return 0;
+	/*
+	 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
+	 * - mask passed in arg for lines of interest
+	 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
+	 * Caller should use TIOCGICOUNT to see which one it was
+	 */
+	case TIOCMIWAIT:
+		spin_lock_irqsave(&info->lock, flags);
+		cprev = info->icount;	/* note the counters on entry */
+		spin_unlock_irqrestore(&info->lock, flags);
+		while (1) {
+			/* FIXME: convert to new style wakeup */
+			interruptible_sleep_on(&info->delta_msr_wait);
+			/* see if a signal did it */
+			if (signal_pending(current))
+				return -ERESTARTSYS;
 			spin_lock_irqsave(&info->lock, flags);
-			cprev = info->icount;	/* note the counters on entry */
+			cnow = info->icount;	/* atomic copy */
 			spin_unlock_irqrestore(&info->lock, flags);
-			while (1) {
-				/* FIXME: convert to new style wakeup */
-				interruptible_sleep_on(&info->delta_msr_wait);
-				/* see if a signal did it */
-				if (signal_pending(current))
-					return -ERESTARTSYS;
-				spin_lock_irqsave(&info->lock, flags);
-				cnow = info->icount;	/* atomic copy */
-				spin_unlock_irqrestore(&info->lock, flags);
-				if (cnow.rng == cprev.rng &&
-				    cnow.dsr == cprev.dsr && 
-				    cnow.dcd == cprev.dcd &&
-				    cnow.cts == cprev.cts)
-					return -EIO; /* no change => error */
-				if (((arg & TIOCM_RNG) &&
-				     (cnow.rng != cprev.rng)) ||
-				     ((arg & TIOCM_DSR) &&
-				      (cnow.dsr != cprev.dsr)) ||
-				     ((arg & TIOCM_CD) &&
-				      (cnow.dcd != cprev.dcd)) ||
-				     ((arg & TIOCM_CTS) &&
-				      (cnow.cts != cprev.cts)) ) {
-					return 0;
-				}
-				cprev = cnow;
+			if (cnow.rng == cprev.rng &&
+			    cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd &&
+			    cnow.cts == cprev.cts)
+				return -EIO; /* no change => error */
+			if (((arg & TIOCM_RNG) &&
+			     (cnow.rng != cprev.rng)) ||
+			     ((arg & TIOCM_DSR) &&
+			      (cnow.dsr != cprev.dsr)) ||
+			     ((arg & TIOCM_CD) &&
+			      (cnow.dcd != cprev.dcd)) ||
+			     ((arg & TIOCM_CTS) &&
+			      (cnow.cts != cprev.cts))) {
+				return 0;
 			}
-			/* NOTREACHED */
-
-		/* 
-		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-		 * Return: write counters to the user passed counter struct
-		 * NB: both 1->0 and 0->1 transitions are counted except for
-		 *     RI where only 0->1 is counted.
-		 */
-		case TIOCGICOUNT:
-			spin_lock_irqsave(&info->lock, flags);
-			cnow = info->icount;
-			spin_unlock_irqrestore(&info->lock, flags);
-			p_cuser = argp;
-			if (put_user(cnow.cts, &p_cuser->cts) ||
-			    put_user(cnow.dsr, &p_cuser->dsr) ||
-			    put_user(cnow.rng, &p_cuser->rng) ||
-			    put_user(cnow.dcd, &p_cuser->dcd))
-				return -EFAULT;
-
-			return 0;
-		case TIOCGHAYESESP:
-			return get_esp_config(info, argp);
-		case TIOCSHAYESESP:
-			lock_kernel();
-			ret = set_esp_config(info, argp);
-			unlock_kernel();
-			return ret;
-		default:
-			return -ENOIOCTLCMD;
+			cprev = cnow;
 		}
+		/* NOTREACHED */
+	/*
+	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+	 * Return: write counters to the user passed counter struct
+	 * NB: both 1->0 and 0->1 transitions are counted except for
+	 *     RI where only 0->1 is counted.
+	 */
+	case TIOCGICOUNT:
+		spin_lock_irqsave(&info->lock, flags);
+		cnow = info->icount;
+		spin_unlock_irqrestore(&info->lock, flags);
+		p_cuser = argp;
+		if (put_user(cnow.cts, &p_cuser->cts) ||
+		    put_user(cnow.dsr, &p_cuser->dsr) ||
+		    put_user(cnow.rng, &p_cuser->rng) ||
+		    put_user(cnow.dcd, &p_cuser->dcd))
+			return -EFAULT;
+			return 0;
+	case TIOCGHAYESESP:
+		return get_esp_config(info, argp);
+	case TIOCSHAYESESP:
+		lock_kernel();
+		ret = set_esp_config(info, argp);
+		unlock_kernel();
+		return ret;
+	default:
+		return -ENOIOCTLCMD;
+	}
 	return 0;
 }
 
 static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	change_speed(info);
@@ -1909,32 +1890,33 @@ static void rs_set_termios(struct tty_st
 /*
  * ------------------------------------------------------------
  * rs_close()
- * 
+ *
  * This routine is called when the serial port gets closed.  First, we
  * wait for the last remaining data to be sent.  Then, we unlink its
  * async structure from the interrupt chain if necessary, and we free
  * that IRQ if nothing is left in the chain.
  * ------------------------------------------------------------
  */
-static void rs_close(struct tty_struct *tty, struct file * filp)
+static void rs_close(struct tty_struct *tty, struct file *filp)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long flags;
 
 	if (!info || serial_paranoia_check(info, tty->name, "rs_close"))
 		return;
-	
+
 	spin_lock_irqsave(&info->lock, flags);
-	
+
 	if (tty_hung_up_p(filp)) {
 		DBG_CNT("before DEC-hung");
 		goto out;
 	}
-	
+
 #ifdef SERIAL_DEBUG_OPEN
-	printk("rs_close ttys%d, count = %d\n", info->line, info->count);
+	printk(KERN_DEBUG "rs_close ttys%d, count = %d\n",
+						info->line, info->count);
 #endif
-	if ((tty->count == 1) && (info->count != 1)) {
+	if (tty->count == 1 && info->count != 1) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -1942,12 +1924,11 @@ static void rs_close(struct tty_struct *
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
-		printk("rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->count);
+		printk(KERN_DEBUG "rs_close: bad serial port count; tty->count is 1, info->count is %d\n", info->count);
 		info->count = 1;
 	}
 	if (--info->count < 0) {
-		printk("rs_close: bad serial port count for ttys%d: %d\n",
+		printk(KERN_ERR "rs_close: bad serial port count for ttys%d: %d\n",
 		       info->line, info->count);
 		info->count = 0;
 	}
@@ -1959,7 +1940,7 @@ static void rs_close(struct tty_struct *
 
 	spin_unlock_irqrestore(&info->lock, flags);
 	/*
-	 * Now we wait for the transmit buffer to clear; and we notify 
+	 * Now we wait for the transmit buffer to clear; and we notify
 	 * the line discipline to only process XON/XOFF characters.
 	 */
 	tty->closing = 1;
@@ -2001,9 +1982,8 @@ static void rs_close(struct tty_struct *
 	info->tty = NULL;
 
 	if (info->blocked_open) {
-		if (info->close_delay) {
+		if (info->close_delay)
 			msleep_interruptible(jiffies_to_msecs(info->close_delay));
-		}
 		wake_up_interruptible(&info->open_wait);
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
@@ -2016,7 +1996,7 @@ out:
 
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 {
-	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
+	struct esp_struct *info = tty->driver_data;
 	unsigned long orig_jiffies, char_time;
 	unsigned long flags;
 
@@ -2058,11 +2038,11 @@ static void rs_wait_until_sent(struct tt
  */
 static void esp_hangup(struct tty_struct *tty)
 {
-	struct esp_struct * info = (struct esp_struct *)tty->driver_data;
-	
+	struct esp_struct *info = tty->driver_data;
+
 	if (serial_paranoia_check(info, tty->name, "esp_hangup"))
 		return;
-	
+
 	rs_flush_buffer(tty);
 	shutdown(info);
 	info->count = 0;
@@ -2076,7 +2056,7 @@ static void esp_hangup(struct tty_struct
  * esp_open() and friends
  * ------------------------------------------------------------
  */
-static int block_til_ready(struct tty_struct *tty, struct file * filp,
+static int block_til_ready(struct tty_struct *tty, struct file *filp,
 			   struct esp_struct *info)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -2125,11 +2105,11 @@ static int block_til_ready(struct tty_st
 	retval = 0;
 	add_wait_queue(&info->open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready before block: ttys%d, count = %d\n",
+	printk(KERN_DEBUG "block_til_ready before block: ttys%d, count = %d\n",
 	       info->line, info->count);
 #endif
 	spin_lock_irqsave(&info->lock, flags);
-	if (!tty_hung_up_p(filp)) 
+	if (!tty_hung_up_p(filp))
 		info->count--;
 	info->blocked_open++;
 	while (1) {
@@ -2151,7 +2131,7 @@ static int block_til_ready(struct tty_st
 			if (info->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
-				retval = -ERESTARTSYS;	
+				retval = -ERESTARTSYS;
 #else
 			retval = -EAGAIN;
 #endif
@@ -2170,7 +2150,7 @@ static int block_til_ready(struct tty_st
 			break;
 		}
 #ifdef SERIAL_DEBUG_OPEN
-		printk("block_til_ready blocking: ttys%d, count = %d\n",
+		printk(KERN_DEBUG "block_til_ready blocking: ttys%d, count = %d\n",
 		       info->line, info->count);
 #endif
 		spin_unlock_irqrestore(&info->lock, flags);
@@ -2184,14 +2164,14 @@ static int block_til_ready(struct tty_st
 	info->blocked_open--;
 	spin_unlock_irqrestore(&info->lock, flags);
 #ifdef SERIAL_DEBUG_OPEN
-	printk("block_til_ready after blocking: ttys%d, count = %d\n",
+	printk(KERN_DEBUG "block_til_ready after blocking: ttys%d, count = %d\n",
 	       info->line, info->count);
 #endif
 	if (retval)
 		return retval;
 	info->flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
-}	
+}
 
 /*
  * This routine is called whenever a serial port is opened.  It
@@ -2199,7 +2179,7 @@ static int block_til_ready(struct tty_st
  * the IRQ chain.   It also performs the serial-specific
  * initialization for the tty structure.
  */
-static int esp_open(struct tty_struct *tty, struct file * filp)
+static int esp_open(struct tty_struct *tty, struct file *filp)
 {
 	struct esp_struct	*info;
 	int 			retval, line;
@@ -2222,7 +2202,7 @@ static int esp_open(struct tty_struct *t
 	}
 
 #ifdef SERIAL_DEBUG_OPEN
-	printk("esp_open %s, count = %d\n", tty->name, info->count);
+	printk(KERN_DEBUG "esp_open %s, count = %d\n", tty->name, info->count);
 #endif
 	spin_lock_irqsave(&info->lock, flags);
 	info->count++;
@@ -2230,7 +2210,7 @@ static int esp_open(struct tty_struct *t
 	info->tty = tty;
 
 	spin_unlock_irqrestore(&info->lock, flags);
-	
+
 	/*
 	 * Start up serial port
 	 */
@@ -2241,14 +2221,13 @@ static int esp_open(struct tty_struct *t
 	retval = block_til_ready(tty, filp, info);
 	if (retval) {
 #ifdef SERIAL_DEBUG_OPEN
-		printk("esp_open returning after block_til_ready with %d\n",
+		printk(KERN_DEBUG "esp_open returning after block_til_ready with %d\n",
 		       retval);
 #endif
 		return retval;
 	}
-
 #ifdef SERIAL_DEBUG_OPEN
-	printk("esp_open %s successful...", tty->name);
+	printk(KERN_DEBUG "esp_open %s successful...", tty->name);
 #endif
 	return 0;
 }
@@ -2266,10 +2245,10 @@ static int esp_open(struct tty_struct *t
  * number, and identifies which options were configured into this
  * driver.
  */
- 
-static inline void show_serial_version(void)
+
+static void show_serial_version(void)
 {
- 	printk(KERN_INFO "%s version %s (DMA %u)\n",
+	printk(KERN_INFO "%s version %s (DMA %u)\n",
 		serial_name, serial_version, dma);
 }
 
@@ -2277,7 +2256,7 @@ static inline void show_serial_version(v
  * This routine is called by espserial_init() to initialize a specific serial
  * port.
  */
-static inline int autoconfig(struct esp_struct * info)
+static int autoconfig(struct esp_struct *info)
 {
 	int port_detected = 0;
 	unsigned long flags;
@@ -2353,14 +2332,14 @@ static const struct tty_operations esp_o
 static int __init espserial_init(void)
 {
 	int i, offset;
-	struct esp_struct * info;
+	struct esp_struct *info;
 	struct esp_struct *last_primary = NULL;
-	int esp[] = {0x100,0x140,0x180,0x200,0x240,0x280,0x300,0x380};
+	int esp[] = { 0x100, 0x140, 0x180, 0x200, 0x240, 0x280, 0x300, 0x380 };
 
 	esp_driver = alloc_tty_driver(NR_PORTS);
 	if (!esp_driver)
 		return -ENOMEM;
-	
+
 	for (i = 0; i < NR_PRIMARY; i++) {
 		if (irq[i] != 0) {
 			if ((irq[i] < 2) || (irq[i] > 15) || (irq[i] == 6) ||
@@ -2382,20 +2361,20 @@ static int __init espserial_init(void)
 
 	if ((flow_off < 1) || (flow_off > 1023))
 		flow_off = 1016;
-	
+
 	if ((flow_on < 1) || (flow_on > 1023))
 		flow_on = 944;
 
 	if ((rx_timeout < 0) || (rx_timeout > 255))
 		rx_timeout = 128;
-	
+
 	if (flow_on >= flow_off)
 		flow_on = flow_off - 1;
 
 	show_serial_version();
 
 	/* Initialize the tty_driver structure */
-	
+
 	esp_driver->owner = THIS_MODULE;
 	esp_driver->name = "ttyP";
 	esp_driver->major = ESP_IN_MAJOR;
@@ -2405,10 +2384,11 @@ static int __init espserial_init(void)
 	esp_driver->init_termios = tty_std_termios;
 	esp_driver->init_termios.c_cflag =
 		B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	esp_driver->init_termios.c_ispeed = 9600;
+	esp_driver->init_termios.c_ospeed = 9600;
 	esp_driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(esp_driver, &esp_ops);
-	if (tty_register_driver(esp_driver))
-	{
+	if (tty_register_driver(esp_driver)) {
 		printk(KERN_ERR "Couldn't register esp serial driver");
 		put_tty_driver(esp_driver);
 		return 1;
@@ -2416,8 +2396,7 @@ static int __init espserial_init(void)
 
 	info = kzalloc(sizeof(struct esp_struct), GFP_KERNEL);
 
-	if (!info)
-	{
+	if (!info) {
 		printk(KERN_ERR "Couldn't allocate memory for esp serial device information\n");
 		tty_unregister_driver(esp_driver);
 		put_tty_driver(esp_driver);
@@ -2480,10 +2459,8 @@ static int __init espserial_init(void)
 			info->stat_flags |= ESP_STAT_NEVER_DMA;
 
 		info = kzalloc(sizeof(struct esp_struct), GFP_KERNEL);
-		if (!info)
-		{
-			printk(KERN_ERR "Couldn't allocate memory for esp serial device information\n"); 
-
+		if (!info) {
+			printk(KERN_ERR "Couldn't allocate memory for esp serial device information\n");
 			/* allow use of the already detected ports */
 			return 0;
 		}
@@ -2507,22 +2484,20 @@ static int __init espserial_init(void)
 	return 0;
 }
 
-static void __exit espserial_exit(void) 
+static void __exit espserial_exit(void)
 {
 	int e1;
 	struct esp_struct *temp_async;
 	struct esp_pio_buffer *pio_buf;
 
-	/* printk("Unloading %s: version %s\n", serial_name, serial_version); */
-	if ((e1 = tty_unregister_driver(esp_driver)))
-		printk("SERIAL: failed to unregister serial driver (%d)\n",
-		       e1);
+	e1 = tty_unregister_driver(esp_driver);
+	if (e1)
+		printk(KERN_ERR "esp: failed to unregister driver (%d)\n", e1);
 	put_tty_driver(esp_driver);
 
 	while (ports) {
-		if (ports->port) {
+		if (ports->port)
 			release_region(ports->port, REGION_SIZE);
-		}
 		temp_async = ports->next_port;
 		kfree(ports);
 		ports = temp_async;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
sxc-fix-printk-warnings-on-sparc32.patch
istallion-tiocg-ssoftcar-handling-removal.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
riscom8-coding-style.patch
toshiba-use-ioremap_cached.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
s390-tty-prepare-for-put_char-to-return-success-fail.patch
serial-m68k-put_char-returns.patch
usb-gadget-switch-to-put_char-returning-int.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isdn-switch-to-int-put_char-method.patch
pty-prepare-for-tty-ops-changes.patch
pc300-update-to-tty_set_operations.patch
serial-switch-the-serial-core-to-int-put_char-methods.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework.patch
tty-the-big-operations-rework-broke-wan-x25_asy-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
strip-fix-up-strip-for-the-new-order.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
x25_asy-code-cleanup.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
maintainers-sort-ordering.patch
char-serial-switch-drivers-to-ioremap_nocache.patch

