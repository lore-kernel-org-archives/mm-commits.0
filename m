From: akpm@linux-foundation.org
Subject: + synclink-drivers-bool-conversion.patch added to -mm tree
Date: Mon, 10 Mar 2008 14:42:47 -0700
Message-ID: <200803102142.m2ALgl3k007204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbYCJVn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 17:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, paulkf@microgate.com


The patch titled
     synclink drivers bool conversion
has been added to the -mm tree.  Its filename is
     synclink-drivers-bool-conversion.patch

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
Subject: synclink drivers bool conversion
From: Joe Perches <joe@perches.com>

Remove more TRUE/FALSE defines and uses
Remove == TRUE tests
Convert BOOLEAN to bool
Convert int to bool where appropriate

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/synclink_cs.c |  125 ++++++-------
 drivers/char/synclink.c           |  258 +++++++++++++---------------
 drivers/char/synclink_gt.c        |  102 +++++------
 drivers/char/synclinkmp.c         |  157 ++++++++---------
 include/linux/synclink.h          |    4 
 5 files changed, 319 insertions(+), 327 deletions(-)

diff -puN drivers/char/pcmcia/synclink_cs.c~synclink-drivers-bool-conversion drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~synclink-drivers-bool-conversion
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -189,20 +189,20 @@ typedef struct _mgslpc_info {
 
 	u32 pending_bh;
 
-	int bh_running;
-	int bh_requested;
+	bool bh_running;
+	bool bh_requested;
 
 	int dcd_chkcount; /* check counts to prevent */
 	int cts_chkcount; /* too many IRQs if a signal */
 	int dsr_chkcount; /* is floating */
 	int ri_chkcount;
 
-	int rx_enabled;
-	int rx_overflow;
+	bool rx_enabled;
+	bool rx_overflow;
 
-	int tx_enabled;
-	int tx_active;
-	int tx_aborting;
+	bool tx_enabled;
+	bool tx_active;
+	bool tx_aborting;
 	u32 idle_mode;
 
 	int if_mode; /* serial interface selection (RS-232, v.35 etc) */
@@ -216,12 +216,12 @@ typedef struct _mgslpc_info {
 
 	unsigned char serial_signals;	/* current serial signal states */
 
-	char irq_occurred;		/* for diagnostics use */
+	bool irq_occurred;		/* for diagnostics use */
 	char testing_irq;
 	unsigned int init_error;	/* startup error (DIAGS)	*/
 
 	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
-	BOOLEAN drop_rts_on_tx_done;
+	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
 
@@ -402,8 +402,8 @@ static void hdlcdev_exit(MGSLPC_INFO *in
 
 static void trace_block(MGSLPC_INFO *info,const char* data, int count, int xmit);
 
-static BOOLEAN register_test(MGSLPC_INFO *info);
-static BOOLEAN irq_test(MGSLPC_INFO *info);
+static bool register_test(MGSLPC_INFO *info);
+static bool irq_test(MGSLPC_INFO *info);
 static int adapter_test(MGSLPC_INFO *info);
 
 static int claim_resources(MGSLPC_INFO *info);
@@ -411,7 +411,7 @@ static void release_resources(MGSLPC_INF
 static void mgslpc_add_device(MGSLPC_INFO *info);
 static void mgslpc_remove_device(MGSLPC_INFO *info);
 
-static int  rx_get_frame(MGSLPC_INFO *info);
+static bool rx_get_frame(MGSLPC_INFO *info);
 static void rx_reset_buffers(MGSLPC_INFO *info);
 static int  rx_alloc_buffers(MGSLPC_INFO *info);
 static void rx_free_buffers(MGSLPC_INFO *info);
@@ -719,7 +719,7 @@ static int mgslpc_resume(struct pcmcia_d
 }
 
 
-static inline int mgslpc_paranoia_check(MGSLPC_INFO *info,
+static inline bool mgslpc_paranoia_check(MGSLPC_INFO *info,
 					char *name, const char *routine)
 {
 #ifdef MGSLPC_PARANOIA_CHECK
@@ -730,17 +730,17 @@ static inline int mgslpc_paranoia_check(
 
 	if (!info) {
 		printk(badinfo, name, routine);
-		return 1;
+		return true;
 	}
 	if (info->magic != MGSLPC_MAGIC) {
 		printk(badmagic, name, routine);
-		return 1;
+		return true;
 	}
 #else
 	if (!info)
-		return 1;
+		return true;
 #endif
-	return 0;
+	return false;
 }
 
 
@@ -752,16 +752,16 @@ static inline int mgslpc_paranoia_check(
 #define CMD_TXEOM       BIT1	// transmit end message
 #define CMD_TXRESET     BIT0	// transmit reset
 
-static BOOLEAN wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
+static bool wait_command_complete(MGSLPC_INFO *info, unsigned char channel)
 {
 	int i = 0;
 	/* wait for command completion */
 	while (read_reg(info, (unsigned char)(channel+STAR)) & BIT2) {
 		udelay(1);
 		if (i++ == 1000)
-			return FALSE;
+			return false;
 	}
-	return TRUE;
+	return true;
 }
 
 static void issue_command(MGSLPC_INFO *info, unsigned char channel, unsigned char cmd)
@@ -825,8 +825,8 @@ static int bh_action(MGSLPC_INFO *info)
 
 	if (!rc) {
 		/* Mark BH routine as complete */
-		info->bh_running   = 0;
-		info->bh_requested = 0;
+		info->bh_running = false;
+		info->bh_requested = false;
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
@@ -846,7 +846,7 @@ static void bh_handler(struct work_struc
 		printk( "%s(%d):bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
 
-	info->bh_running = 1;
+	info->bh_running = true;
 
 	while((action = bh_action(info)) != 0) {
 
@@ -913,7 +913,7 @@ static void rx_ready_hdlc(MGSLPC_INFO *i
 		/* no more free buffers */
 		issue_command(info, CHA, CMD_RXRESET);
 		info->pending_bh |= BH_RECEIVE;
-		info->rx_overflow = 1;
+		info->rx_overflow = true;
 		info->icount.buf_overrun++;
 		return;
 	}
@@ -1032,8 +1032,8 @@ static void tx_done(MGSLPC_INFO *info)
 	if (!info->tx_active)
 		return;
 
-	info->tx_active = 0;
-	info->tx_aborting = 0;
+	info->tx_active = false;
+	info->tx_aborting = false;
 
 	if (info->params.mode == MGSL_MODE_ASYNC)
 		return;
@@ -1047,7 +1047,7 @@ static void tx_done(MGSLPC_INFO *info)
 			info->serial_signals &= ~SerialSignal_RTS;
 			set_signals(info);
 		}
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 	}
 
 #if SYNCLINK_GENERIC_HDLC
@@ -1081,7 +1081,7 @@ static void tx_ready(MGSLPC_INFO *info)
 			return;
 		}
 		if (!info->tx_count)
-			info->tx_active = 0;
+			info->tx_active = false;
 	}
 
 	if (!info->tx_count)
@@ -1263,7 +1263,7 @@ static irqreturn_t mgslpc_isr(int irq, v
 		{
 			isr = read_reg16(info, CHA + ISR);
 			if (isr & IRQ_TIMER) {
-				info->irq_occurred = 1;
+				info->irq_occurred = true;
 				irq_disable(info, CHA, IRQ_TIMER);
 			}
 
@@ -1320,7 +1320,7 @@ static irqreturn_t mgslpc_isr(int irq, v
 			printk("%s(%d):%s queueing bh task.\n",
 				__FILE__,__LINE__,info->device_name);
 		schedule_work(&info->task);
-		info->bh_requested = 1;
+		info->bh_requested = true;
 	}
 
 	spin_unlock(&info->lock);
@@ -1992,7 +1992,7 @@ static int tx_abort(MGSLPC_INFO * info)
 		 * This results in underrun and abort transmission.
 		 */
 		info->tx_count = info->tx_put = info->tx_get = 0;
-		info->tx_aborting = TRUE;
+		info->tx_aborting = true;
 	}
 	spin_unlock_irqrestore(&info->lock,flags);
 	return 0;
@@ -2591,7 +2591,8 @@ static int block_til_ready(struct tty_st
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
-	int		do_clocal = 0, extra_count = 0;
+	bool		do_clocal = false;
+	bool		extra_count = false;
 	unsigned long	flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -2606,7 +2607,7 @@ static int block_til_ready(struct tty_st
 	}
 
 	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
+		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
@@ -2624,7 +2625,7 @@ static int block_til_ready(struct tty_st
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (!tty_hung_up_p(filp)) {
-		extra_count = 1;
+		extra_count = true;
 		info->count--;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
@@ -3495,8 +3496,8 @@ static void rx_stop(MGSLPC_INFO *info)
 	/* MODE:03 RAC Receiver Active, 0=inactive */
 	clear_reg_bits(info, CHA + MODE, BIT3);
 
-	info->rx_enabled = 0;
-	info->rx_overflow = 0;
+	info->rx_enabled = false;
+	info->rx_overflow = false;
 }
 
 static void rx_start(MGSLPC_INFO *info)
@@ -3506,13 +3507,13 @@ static void rx_start(MGSLPC_INFO *info)
 			 __FILE__,__LINE__, info->device_name );
 
 	rx_reset_buffers(info);
-	info->rx_enabled = 0;
-	info->rx_overflow = 0;
+	info->rx_enabled = false;
+	info->rx_overflow = false;
 
 	/* MODE:03 RAC Receiver Active, 1=active */
 	set_reg_bits(info, CHA + MODE, BIT3);
 
-	info->rx_enabled = 1;
+	info->rx_enabled = true;
 }
 
 static void tx_start(MGSLPC_INFO *info)
@@ -3525,24 +3526,24 @@ static void tx_start(MGSLPC_INFO *info)
 		/* If auto RTS enabled and RTS is inactive, then assert */
 		/* RTS and set a flag indicating that the driver should */
 		/* negate RTS when the transmission completes. */
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 
 		if (info->params.flags & HDLC_FLAG_AUTO_RTS) {
 			get_signals(info);
 			if (!(info->serial_signals & SerialSignal_RTS)) {
 				info->serial_signals |= SerialSignal_RTS;
 				set_signals(info);
-				info->drop_rts_on_tx_done = 1;
+				info->drop_rts_on_tx_done = true;
 			}
 		}
 
 		if (info->params.mode == MGSL_MODE_ASYNC) {
 			if (!info->tx_active) {
-				info->tx_active = 1;
+				info->tx_active = true;
 				tx_ready(info);
 			}
 		} else {
-			info->tx_active = 1;
+			info->tx_active = true;
 			tx_ready(info);
 			mod_timer(&info->tx_timer, jiffies +
 					msecs_to_jiffies(5000));
@@ -3550,7 +3551,7 @@ static void tx_start(MGSLPC_INFO *info)
 	}
 
 	if (!info->tx_enabled)
-		info->tx_enabled = 1;
+		info->tx_enabled = true;
 }
 
 static void tx_stop(MGSLPC_INFO *info)
@@ -3561,8 +3562,8 @@ static void tx_stop(MGSLPC_INFO *info)
 
 	del_timer(&info->tx_timer);
 
-	info->tx_enabled = 0;
-	info->tx_active  = 0;
+	info->tx_enabled = false;
+	info->tx_active = false;
 }
 
 /* Reset the adapter to a known state and prepare it for further use.
@@ -3862,19 +3863,19 @@ static void rx_reset_buffers(MGSLPC_INFO
 /* Attempt to return a received HDLC frame
  * Only frames received without errors are returned.
  *
- * Returns 1 if frame returned, otherwise 0
+ * Returns true if frame returned, otherwise false
  */
-static int rx_get_frame(MGSLPC_INFO *info)
+static bool rx_get_frame(MGSLPC_INFO *info)
 {
 	unsigned short status;
 	RXBUF *buf;
 	unsigned int framesize = 0;
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
-	int return_frame = 0;
+	bool return_frame = false;
 
 	if (info->rx_frame_count == 0)
-		return 0;
+		return false;
 
 	buf = (RXBUF*)(info->rx_buf + (info->rx_get * info->rx_buf_size));
 
@@ -3893,7 +3894,7 @@ static int rx_get_frame(MGSLPC_INFO *inf
 		else if (!(status & BIT5)) {
 			info->icount.rxcrc++;
 			if (info->params.crc_type & HDLC_CRC_RETURN_EX)
-				return_frame = 1;
+				return_frame = true;
 		}
 		framesize = 0;
 #if SYNCLINK_GENERIC_HDLC
@@ -3904,7 +3905,7 @@ static int rx_get_frame(MGSLPC_INFO *inf
 		}
 #endif
 	} else
-		return_frame = 1;
+		return_frame = true;
 
 	if (return_frame)
 		framesize = buf->count;
@@ -3947,16 +3948,16 @@ static int rx_get_frame(MGSLPC_INFO *inf
 		info->rx_get = 0;
 	spin_unlock_irqrestore(&info->lock,flags);
 
-	return 1;
+	return true;
 }
 
-static BOOLEAN register_test(MGSLPC_INFO *info)
+static bool register_test(MGSLPC_INFO *info)
 {
 	static unsigned char patterns[] =
 	    { 0x00, 0xff, 0xaa, 0x55, 0x69, 0x96, 0x0f };
 	static unsigned int count = ARRAY_SIZE(patterns);
 	unsigned int i;
-	BOOLEAN rc = TRUE;
+	bool rc = true;
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
@@ -3967,7 +3968,7 @@ static BOOLEAN register_test(MGSLPC_INFO
 		write_reg(info, XAD2, patterns[(i + 1) % count]);
 		if ((read_reg(info, XAD1) != patterns[i]) ||
 		    (read_reg(info, XAD2) != patterns[(i + 1) % count])) {
-			rc = FALSE;
+			rc = false;
 			break;
 		}
 	}
@@ -3976,7 +3977,7 @@ static BOOLEAN register_test(MGSLPC_INFO
 	return rc;
 }
 
-static BOOLEAN irq_test(MGSLPC_INFO *info)
+static bool irq_test(MGSLPC_INFO *info)
 {
 	unsigned long end_time;
 	unsigned long flags;
@@ -3984,10 +3985,10 @@ static BOOLEAN irq_test(MGSLPC_INFO *inf
 	spin_lock_irqsave(&info->lock,flags);
 	reset_device(info);
 
-	info->testing_irq = TRUE;
+	info->testing_irq = true;
 	hdlc_mode(info);
 
-	info->irq_occurred = FALSE;
+	info->irq_occurred = false;
 
 	/* init hdlc mode */
 
@@ -4002,13 +4003,13 @@ static BOOLEAN irq_test(MGSLPC_INFO *inf
 		msleep_interruptible(10);
 	}
 
-	info->testing_irq = FALSE;
+	info->testing_irq = false;
 
 	spin_lock_irqsave(&info->lock,flags);
 	reset_device(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
-	return info->irq_occurred ? TRUE : FALSE;
+	return info->irq_occurred;
 }
 
 static int adapter_test(MGSLPC_INFO *info)
@@ -4081,7 +4082,7 @@ static void tx_timeout(unsigned long con
 		info->icount.txtimeout++;
 	}
 	spin_lock_irqsave(&info->lock,flags);
-	info->tx_active = 0;
+	info->tx_active = false;
 	info->tx_count = info->tx_put = info->tx_get = 0;
 
 	spin_unlock_irqrestore(&info->lock,flags);
diff -puN drivers/char/synclink.c~synclink-drivers-bool-conversion drivers/char/synclink.c
--- a/drivers/char/synclink.c~synclink-drivers-bool-conversion
+++ a/drivers/char/synclink.c
@@ -218,9 +218,9 @@ struct mgsl_struct {
 
 	u32 pending_bh;
 
-	int bh_running;		/* Protection from multiple */
+	bool bh_running;		/* Protection from multiple */
 	int isr_overflow;
-	int bh_requested;
+	bool bh_requested;
 	
 	int dcd_chkcount;		/* check counts to prevent */
 	int cts_chkcount;		/* too many IRQs if a signal */
@@ -250,12 +250,12 @@ struct mgsl_struct {
 	int tx_holding_count;		/* number of tx holding buffers waiting */
 	struct tx_holding_buffer tx_holding_buffers[MAX_TX_HOLDING_BUFFERS];
 
-	int rx_enabled;
-	int rx_overflow;
-	int rx_rcc_underrun;
+	bool rx_enabled;
+	bool rx_overflow;
+	bool rx_rcc_underrun;
 
-	int tx_enabled;
-	int tx_active;
+	bool tx_enabled;
+	bool tx_active;
 	u32 idle_mode;
 
 	u16 cmr_value;
@@ -269,14 +269,14 @@ struct mgsl_struct {
 
 	unsigned int io_base;		/* base I/O address of adapter */
 	unsigned int io_addr_size;	/* size of the I/O address range */
-	int io_addr_requested;		/* nonzero if I/O address requested */
+	bool io_addr_requested;		/* true if I/O address requested */
 	
 	unsigned int irq_level;		/* interrupt level */
 	unsigned long irq_flags;
-	int irq_requested;		/* nonzero if IRQ requested */
+	bool irq_requested;		/* true if IRQ requested */
 	
 	unsigned int dma_level;		/* DMA channel */
-	int dma_requested;		/* nonzero if dma channel requested */
+	bool dma_requested;		/* true if dma channel requested */
 
 	u16 mbre_bit;
 	u16 loopback_bits;
@@ -286,27 +286,27 @@ struct mgsl_struct {
 
 	unsigned char serial_signals;	/* current serial signal states */
 
-	int irq_occurred;		/* for diagnostics use */
+	bool irq_occurred;		/* for diagnostics use */
 	unsigned int init_error;	/* Initialization startup error 		(DIAGS)	*/
 	int	fDiagnosticsmode;	/* Driver in Diagnostic mode?			(DIAGS)	*/
 
 	u32 last_mem_alloc;
 	unsigned char* memory_base;	/* shared memory address (PCI only) */
 	u32 phys_memory_base;
-	int shared_mem_requested;
+	bool shared_mem_requested;
 
 	unsigned char* lcr_base;	/* local config registers (PCI only) */
 	u32 phys_lcr_base;
 	u32 lcr_offset;
-	int lcr_mem_requested;
+	bool lcr_mem_requested;
 
 	u32 misc_ctrl_value;
 	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
 	char char_buf[MAX_ASYNC_BUFFER_SIZE];	
-	BOOLEAN drop_rts_on_tx_done;
+	bool drop_rts_on_tx_done;
 
-	BOOLEAN loopmode_insert_requested;
-	BOOLEAN	loopmode_send_done_requested;
+	bool loopmode_insert_requested;
+	bool loopmode_send_done_requested;
 	
 	struct	_input_signal_events	input_signal_events;
 
@@ -752,10 +752,10 @@ static void mgsl_trace_block(struct mgsl
 /*
  * Adapter diagnostic routines
  */
-static BOOLEAN mgsl_register_test( struct mgsl_struct *info );
-static BOOLEAN mgsl_irq_test( struct mgsl_struct *info );
-static BOOLEAN mgsl_dma_test( struct mgsl_struct *info );
-static BOOLEAN mgsl_memory_test( struct mgsl_struct *info );
+static bool mgsl_register_test( struct mgsl_struct *info );
+static bool mgsl_irq_test( struct mgsl_struct *info );
+static bool mgsl_dma_test( struct mgsl_struct *info );
+static bool mgsl_memory_test( struct mgsl_struct *info );
 static int mgsl_adapter_test( struct mgsl_struct *info );
 
 /*
@@ -770,8 +770,8 @@ static struct mgsl_struct* mgsl_allocate
  * DMA buffer manupulation functions.
  */
 static void mgsl_free_rx_frame_buffers( struct mgsl_struct *info, unsigned int StartIndex, unsigned int EndIndex );
-static int  mgsl_get_rx_frame( struct mgsl_struct *info );
-static int  mgsl_get_raw_rx_frame( struct mgsl_struct *info );
+static bool mgsl_get_rx_frame( struct mgsl_struct *info );
+static bool mgsl_get_raw_rx_frame( struct mgsl_struct *info );
 static void mgsl_reset_rx_dma_buffers( struct mgsl_struct *info );
 static void mgsl_reset_tx_dma_buffers( struct mgsl_struct *info );
 static int num_free_tx_dma_buffers(struct mgsl_struct *info);
@@ -791,7 +791,7 @@ static int mgsl_alloc_intermediate_rxbuf
 static void mgsl_free_intermediate_rxbuffer_memory(struct mgsl_struct *info);
 static int mgsl_alloc_intermediate_txbuffer_memory(struct mgsl_struct *info);
 static void mgsl_free_intermediate_txbuffer_memory(struct mgsl_struct *info);
-static int load_next_tx_holding_buffer(struct mgsl_struct *info);
+static bool load_next_tx_holding_buffer(struct mgsl_struct *info);
 static int save_tx_buffer_request(struct mgsl_struct *info,const char *Buffer, unsigned int BufferSize);
 
 /*
@@ -847,7 +847,7 @@ static int mgsl_wait_event(struct mgsl_s
 static int mgsl_loopmode_send_done( struct mgsl_struct * info );
 
 /* set non-zero on successful registration with PCI subsystem */
-static int pci_registered;
+static bool pci_registered;
 
 /*
  * Global linked list of SyncLink devices
@@ -1054,8 +1054,8 @@ static int mgsl_bh_action(struct mgsl_st
 
 	if (!rc) {
 		/* Mark BH routine as complete */
-		info->bh_running   = 0;
-		info->bh_requested = 0;
+		info->bh_running = false;
+		info->bh_requested = false;
 	}
 	
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
@@ -1079,7 +1079,7 @@ static void mgsl_bh_handler(struct work_
 		printk( "%s(%d):mgsl_bh_handler(%s) entry\n",
 			__FILE__,__LINE__,info->device_name);
 	
-	info->bh_running = 1;
+	info->bh_running = true;
 
 	while((action = mgsl_bh_action(info)) != 0) {
 	
@@ -1113,7 +1113,7 @@ static void mgsl_bh_handler(struct work_
 
 static void mgsl_bh_receive(struct mgsl_struct *info)
 {
-	int (*get_rx_frame)(struct mgsl_struct *info) =
+	bool (*get_rx_frame)(struct mgsl_struct *info) =
 		(info->params.mode == MGSL_MODE_HDLC ? mgsl_get_rx_frame : mgsl_get_raw_rx_frame);
 
 	if ( debug_level >= DEBUG_LEVEL_BH )
@@ -1187,7 +1187,7 @@ static void mgsl_isr_receive_status( str
  		usc_loopmode_active(info) )
  	{
 		++info->icount.rxabort;
-	 	info->loopmode_insert_requested = FALSE;
+	 	info->loopmode_insert_requested = false;
  
  		/* clear CMR:13 to start echoing RxD to TxD */
 		info->cmr_value &= ~BIT13;
@@ -1257,7 +1257,7 @@ static void mgsl_isr_transmit_status( st
 	else
 		info->icount.txunder++;
 			
-	info->tx_active = 0;
+	info->tx_active = false;
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 	del_timer(&info->tx_timer);	
 	
@@ -1267,7 +1267,7 @@ static void mgsl_isr_transmit_status( st
 			info->serial_signals &= ~SerialSignal_RTS;
 			usc_set_serial_signals( info );
 		}
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 	}
 
 #if SYNCLINK_GENERIC_HDLC
@@ -1403,7 +1403,7 @@ static void mgsl_isr_io_pin( struct mgsl
 		usc_OutReg( info, SICR,
 			(unsigned short)(usc_InReg(info,SICR) & ~(SICR_TXC_ACTIVE+SICR_TXC_INACTIVE)) );
 		usc_UnlatchIostatusBits( info, MISCSTATUS_TXC_LATCHED );
-		info->irq_occurred = 1;
+		info->irq_occurred = true;
 	}
 
 }	/* end of mgsl_isr_io_pin() */
@@ -1431,7 +1431,7 @@ static void mgsl_isr_transmit_data( stru
 	if ( info->xmit_cnt )
 		usc_load_txfifo( info );
 	else
-		info->tx_active = 0;
+		info->tx_active = false;
 		
 	if (info->xmit_cnt < WAKEUP_CHARS)
 		info->pending_bh |= BH_TRANSMIT;
@@ -1568,7 +1568,7 @@ static void mgsl_isr_misc( struct mgsl_s
 
 		/* schedule BH handler to restart receiver */
 		info->pending_bh |= BH_RECEIVE;
-		info->rx_rcc_underrun = 1;
+		info->rx_rcc_underrun = true;
 	}
 
 	usc_ClearIrqPendingBits( info, MISC );
@@ -1626,7 +1626,7 @@ static void mgsl_isr_receive_dma( struct
 	info->pending_bh |= BH_RECEIVE;
 	
 	if ( status & BIT3 ) {
-		info->rx_overflow = 1;
+		info->rx_overflow = true;
 		info->icount.buf_overrun++;
 	}
 
@@ -1749,7 +1749,7 @@ static irqreturn_t mgsl_interrupt(int ir
 			printk("%s(%d):%s queueing bh task.\n",
 				__FILE__,__LINE__,info->device_name);
 		schedule_work(&info->task);
-		info->bh_requested = 1;
+		info->bh_requested = true;
 	}
 
 	spin_unlock(&info->irq_spinlock);
@@ -3306,7 +3306,8 @@ static int block_til_ready(struct tty_st
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
-	int		do_clocal = 0, extra_count = 0;
+	bool		do_clocal = false;
+	bool		extra_count = false;
 	unsigned long	flags;
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -3320,7 +3321,7 @@ static int block_til_ready(struct tty_st
 	}
 
 	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
+		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
@@ -3338,7 +3339,7 @@ static int block_til_ready(struct tty_st
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
 	if (!tty_hung_up_p(filp)) {
-		extra_count = 1;
+		extra_count = true;
 		info->count--;
 	}
 	spin_unlock_irqrestore(&info->irq_spinlock, flags);
@@ -4046,13 +4047,13 @@ static void mgsl_free_intermediate_txbuf
  *
  *	info		pointer to device instance data
  *
- * Return Value:	1 if next buffered tx request loaded
+ * Return Value:	true if next buffered tx request loaded
  * 			into adapter's tx dma buffer,
- * 			0 otherwise
+ * 			false otherwise
  */
-static int load_next_tx_holding_buffer(struct mgsl_struct *info)
+static bool load_next_tx_holding_buffer(struct mgsl_struct *info)
 {
-	int ret = 0;
+	bool ret = false;
 
 	if ( info->tx_holding_count ) {
 		/* determine if we have enough tx dma buffers
@@ -4076,7 +4077,7 @@ static int load_next_tx_holding_buffer(s
 			/* restart transmit timer */
 			mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(5000));
 
-			ret = 1;
+			ret = true;
 		}
 	}
 
@@ -4122,7 +4123,7 @@ static int mgsl_claim_resources(struct m
 			__FILE__,__LINE__,info->device_name, info->io_base);
 		return -ENODEV;
 	}
-	info->io_addr_requested = 1;
+	info->io_addr_requested = true;
 	
 	if ( request_irq(info->irq_level,mgsl_interrupt,info->irq_flags,
 		info->device_name, info ) < 0 ) {
@@ -4130,7 +4131,7 @@ static int mgsl_claim_resources(struct m
 			__FILE__,__LINE__,info->device_name, info->irq_level );
 		goto errout;
 	}
-	info->irq_requested = 1;
+	info->irq_requested = true;
 	
 	if ( info->bus_type == MGSL_BUS_TYPE_PCI ) {
 		if (request_mem_region(info->phys_memory_base,0x40000,"synclink") == NULL) {
@@ -4138,13 +4139,13 @@ static int mgsl_claim_resources(struct m
 				__FILE__,__LINE__,info->device_name, info->phys_memory_base);
 			goto errout;
 		}
-		info->shared_mem_requested = 1;
+		info->shared_mem_requested = true;
 		if (request_mem_region(info->phys_lcr_base + info->lcr_offset,128,"synclink") == NULL) {
 			printk( "%s(%d):lcr mem addr conflict device %s Addr=%08X\n",
 				__FILE__,__LINE__,info->device_name, info->phys_lcr_base + info->lcr_offset);
 			goto errout;
 		}
-		info->lcr_mem_requested = 1;
+		info->lcr_mem_requested = true;
 
 		info->memory_base = ioremap(info->phys_memory_base,0x40000);
 		if (!info->memory_base) {
@@ -4175,7 +4176,7 @@ static int mgsl_claim_resources(struct m
 			mgsl_release_resources( info );
 			return -ENODEV;
 		}
-		info->dma_requested = 1;
+		info->dma_requested = true;
 
 		/* ISA adapter uses bus master DMA */		
 		set_dma_mode(info->dma_level,DMA_MODE_CASCADE);
@@ -4203,12 +4204,12 @@ static void mgsl_release_resources(struc
 			
 	if ( info->irq_requested ) {
 		free_irq(info->irq_level, info);
-		info->irq_requested = 0;
+		info->irq_requested = false;
 	}
 	if ( info->dma_requested ) {
 		disable_dma(info->dma_level);
 		free_dma(info->dma_level);
-		info->dma_requested = 0;
+		info->dma_requested = false;
 	}
 	mgsl_free_dma_buffers(info);
 	mgsl_free_intermediate_rxbuffer_memory(info);
@@ -4216,15 +4217,15 @@ static void mgsl_release_resources(struc
 	
 	if ( info->io_addr_requested ) {
 		release_region(info->io_base,info->io_addr_size);
-		info->io_addr_requested = 0;
+		info->io_addr_requested = false;
 	}
 	if ( info->shared_mem_requested ) {
 		release_mem_region(info->phys_memory_base,0x40000);
-		info->shared_mem_requested = 0;
+		info->shared_mem_requested = false;
 	}
 	if ( info->lcr_mem_requested ) {
 		release_mem_region(info->phys_lcr_base + info->lcr_offset,128);
-		info->lcr_mem_requested = 0;
+		info->lcr_mem_requested = false;
 	}
 	if (info->memory_base){
 		iounmap(info->memory_base);
@@ -4489,7 +4490,7 @@ static int __init synclink_init(void)
 	if ((rc = pci_register_driver(&synclink_pci_driver)) < 0)
 		printk("%s:failed to register PCI driver, error=%d\n",__FILE__,rc);
 	else
-		pci_registered = 1;
+		pci_registered = true;
 
 	if ((rc = mgsl_init_tty()) < 0)
 		goto error;
@@ -4682,7 +4683,7 @@ static u16 usc_InReg( struct mgsl_struct
 static void usc_set_sdlc_mode( struct mgsl_struct *info )
 {
 	u16 RegValue;
-	int PreSL1660;
+	bool PreSL1660;
 	
 	/*
 	 * determine if the IUSC on the adapter is pre-SL1660. If
@@ -4695,11 +4696,7 @@ static void usc_set_sdlc_mode( struct mg
 	 */
 	usc_OutReg(info,TMCR,0x1f);
 	RegValue=usc_InReg(info,TMDR);
-	if ( RegValue == IUSC_PRE_SL1660 )
-		PreSL1660 = 1;
-	else
-		PreSL1660 = 0;
-	
+	PreSL1660 = (RegValue == IUSC_PRE_SL1660);
 
  	if ( info->params.flags & HDLC_FLAG_HDLC_LOOPMODE )
  	{
@@ -5385,9 +5382,9 @@ static void usc_process_rxoverrun_sync( 
 	int start_index;
 	int end_index;
 	int frame_start_index;
-	int start_of_frame_found = FALSE;
-	int end_of_frame_found = FALSE;
-	int reprogram_dma = FALSE;
+	bool start_of_frame_found = false;
+	bool end_of_frame_found = false;
+	bool reprogram_dma = false;
 
 	DMABUFFERENTRY *buffer_list = info->rx_buffer_list;
 	u32 phys_addr;
@@ -5413,9 +5410,9 @@ static void usc_process_rxoverrun_sync( 
 
 		if ( !start_of_frame_found )
 		{
-			start_of_frame_found = TRUE;
+			start_of_frame_found = true;
 			frame_start_index = end_index;
-			end_of_frame_found = FALSE;
+			end_of_frame_found = false;
 		}
 
 		if ( buffer_list[end_index].status )
@@ -5426,8 +5423,8 @@ static void usc_process_rxoverrun_sync( 
 			/* We want to leave the buffers for this frame intact. */
 			/* Move on to next possible frame. */
 
-			start_of_frame_found = FALSE;
-			end_of_frame_found = TRUE;
+			start_of_frame_found = false;
+			end_of_frame_found = true;
 		}
 
   		/* advance to next buffer entry in linked list */
@@ -5442,8 +5439,8 @@ static void usc_process_rxoverrun_sync( 
 			/* completely screwed, reset all receive buffers! */
 			mgsl_reset_rx_dma_buffers( info );
 			frame_start_index = 0;
-			start_of_frame_found = FALSE;
-			reprogram_dma = TRUE;
+			start_of_frame_found = false;
+			reprogram_dma = true;
 			break;
 		}
 	}
@@ -5469,7 +5466,7 @@ static void usc_process_rxoverrun_sync( 
 
 		} while( start_index != end_index );
 
-		reprogram_dma = TRUE;
+		reprogram_dma = true;
 	}
 
 	if ( reprogram_dma )
@@ -5539,9 +5536,9 @@ static void usc_stop_receiver( struct mg
 	usc_OutReg( info, CCSR, (u16)(usc_InReg(info,CCSR) | BIT13) );
 	usc_RTCmd( info, RTCmd_PurgeRxFifo );
 
-	info->rx_enabled = 0;
-	info->rx_overflow = 0;
-	info->rx_rcc_underrun = 0;
+	info->rx_enabled = false;
+	info->rx_overflow = false;
+	info->rx_rcc_underrun = false;
 	
 }	/* end of stop_receiver() */
 
@@ -5604,7 +5601,7 @@ static void usc_start_receiver( struct m
 
 	usc_OutReg( info, CCSR, 0x1020 );
 
-	info->rx_enabled = 1;
+	info->rx_enabled = true;
 
 }	/* end of usc_start_receiver() */
 
@@ -5631,14 +5628,14 @@ static void usc_start_transmitter( struc
 		/* RTS and set a flag indicating that the driver should */
 		/* negate RTS when the transmission completes. */
 
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 
 		if ( info->params.flags & HDLC_FLAG_AUTO_RTS ) {
 			usc_get_serial_signals( info );
 			if ( !(info->serial_signals & SerialSignal_RTS) ) {
 				info->serial_signals |= SerialSignal_RTS;
 				usc_set_serial_signals( info );
-				info->drop_rts_on_tx_done = 1;
+				info->drop_rts_on_tx_done = true;
 			}
 		}
 
@@ -5702,11 +5699,11 @@ static void usc_start_transmitter( struc
 			mod_timer(&info->tx_timer, jiffies +
 					msecs_to_jiffies(5000));
 		}
-		info->tx_active = 1;
+		info->tx_active = true;
 	}
 
 	if ( !info->tx_enabled ) {
-		info->tx_enabled = 1;
+		info->tx_enabled = true;
 		if ( info->params.flags & HDLC_FLAG_AUTO_CTS )
 			usc_EnableTransmitter(info,ENABLE_AUTO_CTS);
 		else
@@ -5738,8 +5735,8 @@ static void usc_stop_transmitter( struct
 	usc_DmaCmd( info, DmaCmd_ResetTxChannel );
 	usc_RTCmd( info, RTCmd_PurgeTxFifo );
 
-	info->tx_enabled = 0;
-	info->tx_active  = 0;
+	info->tx_enabled = false;
+	info->tx_active = false;
 
 }	/* end of usc_stop_transmitter() */
 
@@ -6523,7 +6520,7 @@ static void mgsl_reset_rx_dma_buffers( s
  */
 static void mgsl_free_rx_frame_buffers( struct mgsl_struct *info, unsigned int StartIndex, unsigned int EndIndex )
 {
-	int Done = 0;
+	bool Done = false;
 	DMABUFFERENTRY *pBufEntry;
 	unsigned int Index;
 
@@ -6537,7 +6534,7 @@ static void mgsl_free_rx_frame_buffers( 
 
 		if ( Index == EndIndex ) {
 			/* This is the last buffer of the frame! */
-			Done = 1;
+			Done = true;
 		}
 
 		/* reset current buffer for reuse */
@@ -6562,18 +6559,18 @@ static void mgsl_free_rx_frame_buffers( 
  * 	receive DMA buffers. Only frames received without errors are returned.
  *
  * Arguments:	 	info	pointer to device extension
- * Return Value:	1 if frame returned, otherwise 0
+ * Return Value:	true if frame returned, otherwise false
  */
-static int mgsl_get_rx_frame(struct mgsl_struct *info)
+static bool mgsl_get_rx_frame(struct mgsl_struct *info)
 {
 	unsigned int StartIndex, EndIndex;	/* index of 1st and last buffers of Rx frame */
 	unsigned short status;
 	DMABUFFERENTRY *pBufEntry;
 	unsigned int framesize = 0;
-	int ReturnCode = 0;
+	bool ReturnCode = false;
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
-	int return_frame = 0;
+	bool return_frame = false;
 	
 	/*
 	 * current_rx_buffer points to the 1st buffer of the next available
@@ -6632,7 +6629,7 @@ static int mgsl_get_rx_frame(struct mgsl
 		else {
 			info->icount.rxcrc++;
 			if ( info->params.crc_type & HDLC_CRC_RETURN_EX )
-				return_frame = 1;
+				return_frame = true;
 		}
 		framesize = 0;
 #if SYNCLINK_GENERIC_HDLC
@@ -6643,7 +6640,7 @@ static int mgsl_get_rx_frame(struct mgsl
 		}
 #endif
 	} else
-		return_frame = 1;
+		return_frame = true;
 
 	if ( return_frame ) {
 		/* receive frame has no errors, get frame size.
@@ -6722,7 +6719,7 @@ static int mgsl_get_rx_frame(struct mgsl
 	/* Free the buffers used by this frame. */
 	mgsl_free_rx_frame_buffers( info, StartIndex, EndIndex );
 
-	ReturnCode = 1;
+	ReturnCode = true;
 
 Cleanup:
 
@@ -6761,15 +6758,15 @@ Cleanup:
  *	last Rx DMA buffer and return that last portion of the frame.
  *
  * Arguments:	 	info	pointer to device extension
- * Return Value:	1 if frame returned, otherwise 0
+ * Return Value:	true if frame returned, otherwise false
  */
-static int mgsl_get_raw_rx_frame(struct mgsl_struct *info)
+static bool mgsl_get_raw_rx_frame(struct mgsl_struct *info)
 {
 	unsigned int CurrentIndex, NextIndex;
 	unsigned short status;
 	DMABUFFERENTRY *pBufEntry;
 	unsigned int framesize = 0;
-	int ReturnCode = 0;
+	bool ReturnCode = false;
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
 
@@ -6894,7 +6891,7 @@ static int mgsl_get_raw_rx_frame(struct 
 		/* Free the buffers used by this frame. */
 		mgsl_free_rx_frame_buffers( info, CurrentIndex, CurrentIndex );
 
-		ReturnCode = 1;
+		ReturnCode = true;
 	}
 
 
@@ -7003,15 +7000,15 @@ static void mgsl_load_tx_dma_buffer(stru
  * 	Performs a register test of the 16C32.
  * 	
  * Arguments:		info	pointer to device instance data
- * Return Value:		TRUE if test passed, otherwise FALSE
+ * Return Value:		true if test passed, otherwise false
  */
-static BOOLEAN mgsl_register_test( struct mgsl_struct *info )
+static bool mgsl_register_test( struct mgsl_struct *info )
 {
 	static unsigned short BitPatterns[] =
 		{ 0x0000, 0xffff, 0xaaaa, 0x5555, 0x1234, 0x6969, 0x9696, 0x0f0f };
 	static unsigned int Patterncount = ARRAY_SIZE(BitPatterns);
 	unsigned int i;
-	BOOLEAN rc = TRUE;
+	bool rc = true;
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->irq_spinlock,flags);
@@ -7022,10 +7019,10 @@ static BOOLEAN mgsl_register_test( struc
 	if ( (usc_InReg( info, SICR ) != 0) ||
 		  (usc_InReg( info, IVR  ) != 0) ||
 		  (usc_InDmaReg( info, DIVR ) != 0) ){
-		rc = FALSE;
+		rc = false;
 	}
 
-	if ( rc == TRUE ){
+	if ( rc ){
 		/* Write bit patterns to various registers but do it out of */
 		/* sync, then read back and verify values. */
 
@@ -7043,7 +7040,7 @@ static BOOLEAN mgsl_register_test( struc
 				  (usc_InReg( info, RCLR ) != BitPatterns[(i+3)%Patterncount]) ||
 				  (usc_InReg( info, RSR )  != BitPatterns[(i+4)%Patterncount]) ||
 				  (usc_InDmaReg( info, TBCR ) != BitPatterns[(i+5)%Patterncount]) ){
-				rc = FALSE;
+				rc = false;
 				break;
 			}
 		}
@@ -7059,9 +7056,9 @@ static BOOLEAN mgsl_register_test( struc
 /* mgsl_irq_test() 	Perform interrupt test of the 16C32.
  * 
  * Arguments:		info	pointer to device instance data
- * Return Value:	TRUE if test passed, otherwise FALSE
+ * Return Value:	true if test passed, otherwise false
  */
-static BOOLEAN mgsl_irq_test( struct mgsl_struct *info )
+static bool mgsl_irq_test( struct mgsl_struct *info )
 {
 	unsigned long EndTime;
 	unsigned long flags;
@@ -7071,10 +7068,10 @@ static BOOLEAN mgsl_irq_test( struct mgs
 
 	/*
 	 * Setup 16C32 to interrupt on TxC pin (14MHz clock) transition. 
-	 * The ISR sets irq_occurred to 1. 
+	 * The ISR sets irq_occurred to true.
 	 */
 
-	info->irq_occurred = FALSE;
+	info->irq_occurred = false;
 
 	/* Enable INTEN gate for ISA adapter (Port 6, Bit12) */
 	/* Enable INTEN (Port 6, Bit12) */
@@ -7100,10 +7097,7 @@ static BOOLEAN mgsl_irq_test( struct mgs
 	usc_reset(info);
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
 	
-	if ( !info->irq_occurred ) 
-		return FALSE;
-	else
-		return TRUE;
+	return info->irq_occurred;
 
 }	/* end of mgsl_irq_test() */
 
@@ -7114,16 +7108,16 @@ static BOOLEAN mgsl_irq_test( struct mgs
  * 	using single buffer DMA mode.
  * 	
  * Arguments:		info	pointer to device instance data
- * Return Value:	TRUE if test passed, otherwise FALSE
+ * Return Value:	true if test passed, otherwise false
  */
-static BOOLEAN mgsl_dma_test( struct mgsl_struct *info )
+static bool mgsl_dma_test( struct mgsl_struct *info )
 {
 	unsigned short FifoLevel;
 	unsigned long phys_addr;
 	unsigned int FrameSize;
 	unsigned int i;
 	char *TmpPtr;
-	BOOLEAN rc = TRUE;
+	bool rc = true;
 	unsigned short status=0;
 	unsigned long EndTime;
 	unsigned long flags;
@@ -7236,7 +7230,7 @@ static BOOLEAN mgsl_dma_test( struct mgs
 
 	for(;;) {
 		if (time_after(jiffies, EndTime)) {
-			rc = FALSE;
+			rc = false;
 			break;
 		}
 
@@ -7292,7 +7286,7 @@ static BOOLEAN mgsl_dma_test( struct mgs
 
 	for(;;) {
 		if (time_after(jiffies, EndTime)) {
-			rc = FALSE;
+			rc = false;
 			break;
 		}
 
@@ -7312,7 +7306,7 @@ static BOOLEAN mgsl_dma_test( struct mgs
 	}
 
 
-	if ( rc == TRUE )
+	if ( rc )
 	{
 		/* Enable 16C32 transmitter. */
 
@@ -7340,7 +7334,7 @@ static BOOLEAN mgsl_dma_test( struct mgs
 
 		while ( !(status & (BIT6+BIT5+BIT4+BIT2+BIT1)) ) {
 			if (time_after(jiffies, EndTime)) {
-				rc = FALSE;
+				rc = false;
 				break;
 			}
 
@@ -7351,13 +7345,13 @@ static BOOLEAN mgsl_dma_test( struct mgs
 	}
 
 
-	if ( rc == TRUE ){
+	if ( rc ){
 		/* CHECK FOR TRANSMIT ERRORS */
 		if ( status & (BIT5 + BIT1) ) 
-			rc = FALSE;
+			rc = false;
 	}
 
-	if ( rc == TRUE ) {
+	if ( rc ) {
 		/* WAIT FOR RECEIVE COMPLETE */
 
 		/* Wait 100ms */
@@ -7367,7 +7361,7 @@ static BOOLEAN mgsl_dma_test( struct mgs
 		status=info->rx_buffer_list[0].status;
 		while ( status == 0 ) {
 			if (time_after(jiffies, EndTime)) {
-				rc = FALSE;
+				rc = false;
 				break;
 			}
 			status=info->rx_buffer_list[0].status;
@@ -7375,17 +7369,17 @@ static BOOLEAN mgsl_dma_test( struct mgs
 	}
 
 
-	if ( rc == TRUE ) {
+	if ( rc ) {
 		/* CHECK FOR RECEIVE ERRORS */
 		status = info->rx_buffer_list[0].status;
 
 		if ( status & (BIT8 + BIT3 + BIT1) ) {
 			/* receive error has occurred */
-			rc = FALSE;
+			rc = false;
 		} else {
 			if ( memcmp( info->tx_buffer_list[0].virt_addr ,
 				info->rx_buffer_list[0].virt_addr, FrameSize ) ){
-				rc = FALSE;
+				rc = false;
 			}
 		}
 	}
@@ -7448,9 +7442,9 @@ static int mgsl_adapter_test( struct mgs
  * 	Test the shared memory on a PCI adapter.
  * 
  * Arguments:		info	pointer to device instance data
- * Return Value:	TRUE if test passed, otherwise FALSE
+ * Return Value:	true if test passed, otherwise false
  */
-static BOOLEAN mgsl_memory_test( struct mgsl_struct *info )
+static bool mgsl_memory_test( struct mgsl_struct *info )
 {
 	static unsigned long BitPatterns[] =
 		{ 0x0, 0x55555555, 0xaaaaaaaa, 0x66666666, 0x99999999, 0xffffffff, 0x12345678 };
@@ -7460,7 +7454,7 @@ static BOOLEAN mgsl_memory_test( struct 
 	unsigned long * TestAddr;
 
 	if ( info->bus_type != MGSL_BUS_TYPE_PCI )
-		return TRUE;
+		return true;
 
 	TestAddr = (unsigned long *)info->memory_base;
 
@@ -7469,7 +7463,7 @@ static BOOLEAN mgsl_memory_test( struct 
 	for ( i = 0 ; i < Patterncount ; i++ ) {
 		*TestAddr = BitPatterns[i];
 		if ( *TestAddr != BitPatterns[i] )
-			return FALSE;
+			return false;
 	}
 
 	/* Test address lines with incrementing pattern over */
@@ -7484,13 +7478,13 @@ static BOOLEAN mgsl_memory_test( struct 
 
 	for ( i = 0 ; i < TestLimit ; i++ ) {
 		if ( *TestAddr != i * 4 )
-			return FALSE;
+			return false;
 		TestAddr++;
 	}
 
 	memset( info->memory_base, 0, SHARED_MEM_ADDRESS_SIZE );
 
-	return TRUE;
+	return true;
 
 }	/* End Of mgsl_memory_test() */
 
@@ -7607,7 +7601,7 @@ static void mgsl_tx_timeout(unsigned lon
 		info->icount.txtimeout++;
 	}
 	spin_lock_irqsave(&info->irq_spinlock,flags);
-	info->tx_active = 0;
+	info->tx_active = false;
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 
 	if ( info->params.flags & HDLC_FLAG_HDLC_LOOPMODE )
@@ -7635,7 +7629,7 @@ static int mgsl_loopmode_send_done( stru
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	if (info->params.flags & HDLC_FLAG_HDLC_LOOPMODE) {
 		if (info->tx_active)
-			info->loopmode_send_done_requested = TRUE;
+			info->loopmode_send_done_requested = true;
 		else
 			usc_loopmode_send_done(info);
 	}
@@ -7649,7 +7643,7 @@ static int mgsl_loopmode_send_done( stru
  */
 static void usc_loopmode_send_done( struct mgsl_struct * info )
 {
- 	info->loopmode_send_done_requested = FALSE;
+ 	info->loopmode_send_done_requested = false;
  	/* clear CMR:13 to 0 to start echoing RxData to TxData */
  	info->cmr_value &= ~BIT13;			  
  	usc_OutReg(info, CMR, info->cmr_value);
@@ -7671,7 +7665,7 @@ static void usc_loopmode_cancel_transmit
  */
 static void usc_loopmode_insert_request( struct mgsl_struct * info )
 {
- 	info->loopmode_insert_requested = TRUE;
+ 	info->loopmode_insert_requested = true;
  
  	/* enable RxAbort irq. On next RxAbort, clear CMR:13 to
  	 * begin repeating TxData on RxData (complete insertion)
diff -puN drivers/char/synclink_gt.c~synclink-drivers-bool-conversion drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink-drivers-bool-conversion
+++ a/drivers/char/synclink_gt.c
@@ -117,7 +117,7 @@ static struct pci_driver pci_driver = {
 	.remove		= __devexit_p(remove_one),
 };
 
-static int pci_registered;
+static bool pci_registered;
 
 /*
  * module configuration and status
@@ -289,12 +289,12 @@ struct slgt_info {
 
 	struct work_struct task;
 	u32 pending_bh;
-	int bh_requested;
-	int bh_running;
+	bool bh_requested;
+	bool bh_running;
 
 	int isr_overflow;
-	int irq_requested;	/* nonzero if IRQ requested */
-	int irq_occurred;	/* for diagnostics use */
+	bool irq_requested;	/* true if IRQ requested */
+	bool irq_occurred;	/* for diagnostics use */
 
 	/* device configuration */
 
@@ -304,7 +304,7 @@ struct slgt_info {
 
 	unsigned char __iomem * reg_addr;  /* memory mapped registers address */
 	u32 phys_reg_addr;
-	int reg_addr_requested;
+	bool reg_addr_requested;
 
 	MGSL_PARAMS params;       /* communications parameters */
 	u32 idle_mode;
@@ -315,11 +315,11 @@ struct slgt_info {
 
 	/* device status */
 
-	int rx_enabled;
-	int rx_restart;
+	bool rx_enabled;
+	bool rx_restart;
 
-	int tx_enabled;
-	int tx_active;
+	bool tx_enabled;
+	bool tx_active;
 
 	unsigned char signals;    /* serial signal states */
 	int init_error;  /* initialization error */
@@ -329,7 +329,7 @@ struct slgt_info {
 
 	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
 	char char_buf[MAX_ASYNC_BUFFER_SIZE];
-	BOOLEAN drop_rts_on_tx_done;
+	bool drop_rts_on_tx_done;
 	struct	_input_signal_events	input_signal_events;
 
 	int dcd_chkcount;	/* check counts to prevent */
@@ -467,8 +467,8 @@ static void rx_start(struct slgt_info *i
 static void reset_rbufs(struct slgt_info *info);
 static void free_rbufs(struct slgt_info *info, unsigned int first, unsigned int last);
 static void rdma_reset(struct slgt_info *info);
-static int  rx_get_frame(struct slgt_info *info);
-static int  rx_get_buf(struct slgt_info *info);
+static bool rx_get_frame(struct slgt_info *info);
+static bool rx_get_buf(struct slgt_info *info);
 
 static void tx_start(struct slgt_info *info);
 static void tx_stop(struct slgt_info *info);
@@ -1969,8 +1969,8 @@ static int bh_action(struct slgt_info *i
 		rc = BH_STATUS;
 	} else {
 		/* Mark BH routine as complete */
-		info->bh_running   = 0;
-		info->bh_requested = 0;
+		info->bh_running = false;
+		info->bh_requested = false;
 		rc = 0;
 	}
 
@@ -1989,7 +1989,7 @@ static void bh_handler(struct work_struc
 
 	if (!info)
 		return;
-	info->bh_running = 1;
+	info->bh_running = true;
 
 	while((action = bh_action(info))) {
 		switch (action) {
@@ -2159,7 +2159,7 @@ static void isr_serial(struct slgt_info 
 
 	wr_reg16(info, SSR, status); /* clear pending */
 
-	info->irq_occurred = 1;
+	info->irq_occurred = true;
 
 	if (info->params.mode == MGSL_MODE_ASYNC) {
 		if (status & IRQ_TXIDLE) {
@@ -2226,7 +2226,7 @@ static void isr_rdma(struct slgt_info *i
 
 	if (status & (BIT5 + BIT4)) {
 		DBGISR(("%s isr_rdma rx_restart=1\n", info->device_name));
-		info->rx_restart = 1;
+		info->rx_restart = true;
 	}
 	info->pending_bh |= BH_RECEIVE;
 }
@@ -2277,14 +2277,14 @@ static void isr_txeom(struct slgt_info *
 				info->icount.txok++;
 		}
 
-		info->tx_active = 0;
+		info->tx_active = false;
 		info->tx_count = 0;
 
 		del_timer(&info->tx_timer);
 
 		if (info->params.mode != MGSL_MODE_ASYNC && info->drop_rts_on_tx_done) {
 			info->signals &= ~SerialSignal_RTS;
-			info->drop_rts_on_tx_done = 0;
+			info->drop_rts_on_tx_done = false;
 			set_signals(info);
 		}
 
@@ -2342,7 +2342,7 @@ static irqreturn_t slgt_interrupt(int ir
 
 	while((gsr = rd_reg32(info, GSR) & 0xffffff00)) {
 		DBGISR(("%s gsr=%08x\n", info->device_name, gsr));
-		info->irq_occurred = 1;
+		info->irq_occurred = true;
 		for(i=0; i < info->port_count ; i++) {
 			if (info->port_array[i] == NULL)
 				continue;
@@ -2379,7 +2379,7 @@ static irqreturn_t slgt_interrupt(int ir
 		    !port->bh_requested) {
 			DBGISR(("%s bh queued\n", port->device_name));
 			schedule_work(&port->task);
-			port->bh_requested = 1;
+			port->bh_requested = true;
 		}
 	}
 
@@ -3115,7 +3115,8 @@ static int block_til_ready(struct tty_st
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
-	int		do_clocal = 0, extra_count = 0;
+	bool		do_clocal = false;
+	bool		extra_count = false;
 	unsigned long	flags;
 
 	DBGINFO(("%s block_til_ready\n", tty->driver->name));
@@ -3127,7 +3128,7 @@ static int block_til_ready(struct tty_st
 	}
 
 	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
+		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
@@ -3141,7 +3142,7 @@ static int block_til_ready(struct tty_st
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (!tty_hung_up_p(filp)) {
-		extra_count = 1;
+		extra_count = true;
 		info->count--;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
@@ -3326,7 +3327,7 @@ static int claim_resources(struct slgt_i
 		goto errout;
 	}
 	else
-		info->reg_addr_requested = 1;
+		info->reg_addr_requested = true;
 
 	info->reg_addr = ioremap(info->phys_reg_addr, SLGT_REG_SIZE);
 	if (!info->reg_addr) {
@@ -3346,12 +3347,12 @@ static void release_resources(struct slg
 {
 	if (info->irq_requested) {
 		free_irq(info->irq_level, info);
-		info->irq_requested = 0;
+		info->irq_requested = false;
 	}
 
 	if (info->reg_addr_requested) {
 		release_mem_region(info->phys_reg_addr, SLGT_REG_SIZE);
-		info->reg_addr_requested = 0;
+		info->reg_addr_requested = false;
 	}
 
 	if (info->reg_addr) {
@@ -3516,7 +3517,7 @@ static void device_init(int adapter_num,
 				port_array[0]->device_name,
 				port_array[0]->irq_level));
 		} else {
-			port_array[0]->irq_requested = 1;
+			port_array[0]->irq_requested = true;
 			adapter_test(port_array[0]);
 			for (i=1 ; i < port_count ; i++) {
 				port_array[i]->init_error = port_array[0]->init_error;
@@ -3659,7 +3660,7 @@ static int __init slgt_init(void)
 		printk("%s pci_register_driver error=%d\n", driver_name, rc);
 		goto error;
 	}
-	pci_registered = 1;
+	pci_registered = true;
 
 	if (!slgt_device_list)
 		printk("%s no devices found\n",driver_name);
@@ -3817,8 +3818,8 @@ static void rx_stop(struct slgt_info *in
 
 	rdma_reset(info);
 
-	info->rx_enabled = 0;
-	info->rx_restart = 0;
+	info->rx_enabled = false;
+	info->rx_restart = false;
 }
 
 static void rx_start(struct slgt_info *info)
@@ -3854,8 +3855,8 @@ static void rx_start(struct slgt_info *i
 	/* enable receiver */
 	wr_reg16(info, RCR, (unsigned short)(rd_reg16(info, RCR) | BIT1));
 
-	info->rx_restart = 0;
-	info->rx_enabled = 1;
+	info->rx_restart = false;
+	info->rx_enabled = true;
 }
 
 static void tx_start(struct slgt_info *info)
@@ -3863,11 +3864,11 @@ static void tx_start(struct slgt_info *i
 	if (!info->tx_enabled) {
 		wr_reg16(info, TCR,
 			 (unsigned short)((rd_reg16(info, TCR) | BIT1) & ~BIT2));
-		info->tx_enabled = TRUE;
+		info->tx_enabled = true;
 	}
 
 	if (info->tx_count) {
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 
 		if (info->params.mode != MGSL_MODE_ASYNC) {
 			if (info->params.flags & HDLC_FLAG_AUTO_RTS) {
@@ -3875,7 +3876,7 @@ static void tx_start(struct slgt_info *i
 				if (!(info->signals & SerialSignal_RTS)) {
 					info->signals |= SerialSignal_RTS;
 					set_signals(info);
-					info->drop_rts_on_tx_done = 1;
+					info->drop_rts_on_tx_done = true;
 				}
 			}
 
@@ -3893,7 +3894,7 @@ static void tx_start(struct slgt_info *i
 			wr_reg16(info, SSR, IRQ_TXIDLE);
 		}
 		tdma_start(info);
-		info->tx_active = 1;
+		info->tx_active = true;
 	}
 }
 
@@ -3954,8 +3955,8 @@ static void tx_stop(struct slgt_info *in
 
 	reset_tbufs(info);
 
-	info->tx_enabled = 0;
-	info->tx_active  = 0;
+	info->tx_enabled = false;
+	info->tx_active = false;
 }
 
 static void reset_port(struct slgt_info *info)
@@ -4475,14 +4476,13 @@ static void reset_rbufs(struct slgt_info
 /*
  * pass receive HDLC frame to upper layer
  *
- * return 1 if frame available, otherwise 0
+ * return true if frame available, otherwise false
  */
-static int rx_get_frame(struct slgt_info *info)
+static bool rx_get_frame(struct slgt_info *info)
 {
 	unsigned int start, end;
 	unsigned short status;
 	unsigned int framesize = 0;
-	int rc = 0;
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
 	unsigned char addr_field = 0xff;
@@ -4606,23 +4606,23 @@ check_again:
 		}
 	}
 	free_rbufs(info, start, end);
-	rc = 1;
+	return true;
 
 cleanup:
-	return rc;
+	return false;
 }
 
 /*
  * pass receive buffer (RAW synchronous mode) to tty layer
- * return 1 if buffer available, otherwise 0
+ * return true if buffer available, otherwise false
  */
-static int rx_get_buf(struct slgt_info *info)
+static bool rx_get_buf(struct slgt_info *info)
 {
 	unsigned int i = info->rbuf_current;
 	unsigned int count;
 
 	if (!desc_complete(info->rbufs[i]))
-		return 0;
+		return false;
 	count = desc_count(info->rbufs[i]);
 	switch(info->params.mode) {
 	case MGSL_MODE_MONOSYNC:
@@ -4638,7 +4638,7 @@ static int rx_get_buf(struct slgt_info *
 		ldisc_receive_buf(info->tty, info->rbufs[i].buf,
 				  info->flag_buf, count);
 	free_rbufs(info, i, i);
-	return 1;
+	return true;
 }
 
 static void reset_tbufs(struct slgt_info *info)
@@ -4763,7 +4763,7 @@ static int irq_test(struct slgt_info *in
 
 	/* assume failure */
 	info->init_error = DiagStatus_IrqFailure;
-	info->irq_occurred = FALSE;
+	info->irq_occurred = false;
 
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -4896,7 +4896,7 @@ static void tx_timeout(unsigned long con
 		info->icount.txtimeout++;
 	}
 	spin_lock_irqsave(&info->lock,flags);
-	info->tx_active = 0;
+	info->tx_active = false;
 	info->tx_count = 0;
 	spin_unlock_irqrestore(&info->lock,flags);
 
diff -puN drivers/char/synclinkmp.c~synclink-drivers-bool-conversion drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~synclink-drivers-bool-conversion
+++ a/drivers/char/synclinkmp.c
@@ -188,9 +188,9 @@ typedef struct _synclinkmp_info {
 
 	u32 pending_bh;
 
-	int bh_running;				/* Protection from multiple */
+	bool bh_running;				/* Protection from multiple */
 	int isr_overflow;
-	int bh_requested;
+	bool bh_requested;
 
 	int dcd_chkcount;			/* check counts to prevent */
 	int cts_chkcount;			/* too many IRQs if a signal */
@@ -213,11 +213,11 @@ typedef struct _synclinkmp_info {
 	unsigned char *tmp_rx_buf;
 	unsigned int tmp_rx_buf_count;
 
-	int rx_enabled;
-	int rx_overflow;
+	bool rx_enabled;
+	bool rx_overflow;
 
-	int tx_enabled;
-	int tx_active;
+	bool tx_enabled;
+	bool tx_active;
 	u32 idle_mode;
 
 	unsigned char ie0_value;
@@ -238,13 +238,13 @@ typedef struct _synclinkmp_info {
 
 	unsigned int irq_level;			/* interrupt level */
 	unsigned long irq_flags;
-	int irq_requested;			/* nonzero if IRQ requested */
+	bool irq_requested;			/* true if IRQ requested */
 
 	MGSL_PARAMS params;			/* communications parameters */
 
 	unsigned char serial_signals;		/* current serial signal states */
 
-	int irq_occurred;			/* for diagnostics use */
+	bool irq_occurred;			/* for diagnostics use */
 	unsigned int init_error;		/* Initialization startup error */
 
 	u32 last_mem_alloc;
@@ -255,7 +255,7 @@ typedef struct _synclinkmp_info {
 	unsigned char* sca_base;		/* HD64570 SCA Memory address */
 	u32 phys_sca_base;
 	u32 sca_offset;
-	int sca_base_requested;
+	bool sca_base_requested;
 
 	unsigned char* lcr_base;		/* local config registers (PCI only) */
 	u32 phys_lcr_base;
@@ -265,12 +265,12 @@ typedef struct _synclinkmp_info {
 	unsigned char* statctrl_base;		/* status/control register memory */
 	u32 phys_statctrl_base;
 	u32 statctrl_offset;
-	int sca_statctrl_requested;
+	bool sca_statctrl_requested;
 
 	u32 misc_ctrl_value;
 	char flag_buf[MAX_ASYNC_BUFFER_SIZE];
 	char char_buf[MAX_ASYNC_BUFFER_SIZE];
-	BOOLEAN drop_rts_on_tx_done;
+	bool drop_rts_on_tx_done;
 
 	struct	_input_signal_events	input_signal_events;
 
@@ -571,12 +571,12 @@ static void shutdown(SLMP_INFO *info);
 static void program_hw(SLMP_INFO *info);
 static void change_params(SLMP_INFO *info);
 
-static int  init_adapter(SLMP_INFO *info);
-static int  register_test(SLMP_INFO *info);
-static int  irq_test(SLMP_INFO *info);
-static int  loopback_test(SLMP_INFO *info);
+static bool init_adapter(SLMP_INFO *info);
+static bool register_test(SLMP_INFO *info);
+static bool irq_test(SLMP_INFO *info);
+static bool loopback_test(SLMP_INFO *info);
 static int  adapter_test(SLMP_INFO *info);
-static int  memory_test(SLMP_INFO *info);
+static bool memory_test(SLMP_INFO *info);
 
 static void reset_adapter(SLMP_INFO *info);
 static void reset_port(SLMP_INFO *info);
@@ -587,7 +587,7 @@ static void rx_stop(SLMP_INFO *info);
 static void rx_start(SLMP_INFO *info);
 static void rx_reset_buffers(SLMP_INFO *info);
 static void rx_free_frame_buffers(SLMP_INFO *info, unsigned int first, unsigned int last);
-static int  rx_get_frame(SLMP_INFO *info);
+static bool rx_get_frame(SLMP_INFO *info);
 
 static void tx_start(SLMP_INFO *info);
 static void tx_stop(SLMP_INFO *info);
@@ -2044,8 +2044,8 @@ int bh_action(SLMP_INFO *info)
 
 	if (!rc) {
 		/* Mark BH routine as complete */
-		info->bh_running   = 0;
-		info->bh_requested = 0;
+		info->bh_running = false;
+		info->bh_requested = false;
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
@@ -2067,7 +2067,7 @@ void bh_handler(struct work_struct *work
 		printk( "%s(%d):%s bh_handler() entry\n",
 			__FILE__,__LINE__,info->device_name);
 
-	info->bh_running = 1;
+	info->bh_running = true;
 
 	while((action = bh_action(info)) != 0) {
 
@@ -2152,7 +2152,7 @@ void isr_timer(SLMP_INFO * info)
 	 */
 	write_reg(info, (unsigned char)(timer + TMCS), 0);
 
-	info->irq_occurred = TRUE;
+	info->irq_occurred = true;
 
 	if ( debug_level >= DEBUG_LEVEL_ISR )
 		printk("%s(%d):%s isr_timer()\n",
@@ -2232,7 +2232,7 @@ void isr_rxrdy(SLMP_INFO * info)
 	while((status = read_reg(info,CST0)) & BIT0)
 	{
 		int flag = 0;
-		int over = 0;
+		bool over = false;
 		DataByte = read_reg(info,TRB);
 
 		icount->rx++;
@@ -2265,7 +2265,7 @@ void isr_rxrdy(SLMP_INFO * info)
 					 * reported immediately, and doesn't
 					 * affect the current character
 					 */
-					over = 1;
+					over = true;
 				}
 			}
 		}	/* end of if (error) */
@@ -2318,14 +2318,14 @@ static void isr_txeom(SLMP_INFO * info, 
 				info->icount.txok++;
 		}
 
-		info->tx_active = 0;
+		info->tx_active = false;
 		info->tx_count = info->tx_put = info->tx_get = 0;
 
 		del_timer(&info->tx_timer);
 
 		if (info->params.mode != MGSL_MODE_ASYNC && info->drop_rts_on_tx_done ) {
 			info->serial_signals &= ~SerialSignal_RTS;
-			info->drop_rts_on_tx_done = 0;
+			info->drop_rts_on_tx_done = false;
 			set_signals(info);
 		}
 
@@ -2398,7 +2398,7 @@ void isr_txrdy(SLMP_INFO * info)
 	if ( info->tx_count )
 		tx_load_fifo( info );
 	else {
-		info->tx_active = 0;
+		info->tx_active = false;
 		info->ie0_value &= ~TXRDYE;
 		write_reg(info, IE0, info->ie0_value);
 	}
@@ -2438,7 +2438,7 @@ void isr_rxdmaerror(SLMP_INFO * info)
 		printk("%s(%d):%s isr_rxdmaerror(), status=%02x\n",
 			__FILE__,__LINE__,info->device_name,status);
 
-	info->rx_overflow = TRUE;
+	info->rx_overflow = true;
 	info->pending_bh |= BH_RECEIVE;
 }
 
@@ -2695,7 +2695,7 @@ static irqreturn_t synclinkmp_interrupt(
 				printk("%s(%d):%s queueing bh task.\n",
 					__FILE__,__LINE__,port->device_name);
 			schedule_work(&port->task);
-			port->bh_requested = 1;
+			port->bh_requested = true;
 		}
 	}
 
@@ -3324,7 +3324,8 @@ static int block_til_ready(struct tty_st
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int		retval;
-	int		do_clocal = 0, extra_count = 0;
+	bool		do_clocal = false;
+	bool		extra_count = false;
 	unsigned long	flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -3339,7 +3340,7 @@ static int block_til_ready(struct tty_st
 	}
 
 	if (tty->termios->c_cflag & CLOCAL)
-		do_clocal = 1;
+		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
@@ -3357,7 +3358,7 @@ static int block_til_ready(struct tty_st
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (!tty_hung_up_p(filp)) {
-		extra_count = 1;
+		extra_count = true;
 		info->count--;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
@@ -3600,7 +3601,7 @@ int claim_resources(SLMP_INFO *info)
 		goto errout;
 	}
 	else
-		info->shared_mem_requested = 1;
+		info->shared_mem_requested = true;
 
 	if (request_mem_region(info->phys_lcr_base + info->lcr_offset,128,"synclinkmp") == NULL) {
 		printk( "%s(%d):%s lcr mem addr conflict, Addr=%08X\n",
@@ -3609,7 +3610,7 @@ int claim_resources(SLMP_INFO *info)
 		goto errout;
 	}
 	else
-		info->lcr_mem_requested = 1;
+		info->lcr_mem_requested = true;
 
 	if (request_mem_region(info->phys_sca_base + info->sca_offset,SCA_BASE_SIZE,"synclinkmp") == NULL) {
 		printk( "%s(%d):%s sca mem addr conflict, Addr=%08X\n",
@@ -3618,7 +3619,7 @@ int claim_resources(SLMP_INFO *info)
 		goto errout;
 	}
 	else
-		info->sca_base_requested = 1;
+		info->sca_base_requested = true;
 
 	if (request_mem_region(info->phys_statctrl_base + info->statctrl_offset,SCA_REG_SIZE,"synclinkmp") == NULL) {
 		printk( "%s(%d):%s stat/ctrl mem addr conflict, Addr=%08X\n",
@@ -3627,7 +3628,7 @@ int claim_resources(SLMP_INFO *info)
 		goto errout;
 	}
 	else
-		info->sca_statctrl_requested = 1;
+		info->sca_statctrl_requested = true;
 
 	info->memory_base = ioremap(info->phys_memory_base,SCA_MEM_SIZE);
 	if (!info->memory_base) {
@@ -3686,24 +3687,24 @@ void release_resources(SLMP_INFO *info)
 
 	if ( info->irq_requested ) {
 		free_irq(info->irq_level, info);
-		info->irq_requested = 0;
+		info->irq_requested = false;
 	}
 
 	if ( info->shared_mem_requested ) {
 		release_mem_region(info->phys_memory_base,SCA_MEM_SIZE);
-		info->shared_mem_requested = 0;
+		info->shared_mem_requested = false;
 	}
 	if ( info->lcr_mem_requested ) {
 		release_mem_region(info->phys_lcr_base + info->lcr_offset,128);
-		info->lcr_mem_requested = 0;
+		info->lcr_mem_requested = false;
 	}
 	if ( info->sca_base_requested ) {
 		release_mem_region(info->phys_sca_base + info->sca_offset,SCA_BASE_SIZE);
-		info->sca_base_requested = 0;
+		info->sca_base_requested = false;
 	}
 	if ( info->sca_statctrl_requested ) {
 		release_mem_region(info->phys_statctrl_base + info->statctrl_offset,SCA_REG_SIZE);
-		info->sca_statctrl_requested = 0;
+		info->sca_statctrl_requested = false;
 	}
 
 	if (info->memory_base){
@@ -3906,7 +3907,7 @@ void device_init(int adapter_num, struct
 				port_array[0]->irq_level );
 		}
 		else {
-			port_array[0]->irq_requested = 1;
+			port_array[0]->irq_requested = true;
 			adapter_test(port_array[0]);
 		}
 	}
@@ -4159,8 +4160,8 @@ void rx_stop(SLMP_INFO *info)
 	write_reg(info, RXDMA + DCMD, SWABORT);	/* reset/init Rx DMA */
 	write_reg(info, RXDMA + DIR, 0);	/* disable Rx DMA interrupts */
 
-	info->rx_enabled = 0;
-	info->rx_overflow = 0;
+	info->rx_enabled = false;
+	info->rx_overflow = false;
 }
 
 /* enable the receiver
@@ -4215,8 +4216,8 @@ void rx_start(SLMP_INFO *info)
 
 	write_reg(info, CMD, RXENABLE);
 
-	info->rx_overflow = FALSE;
-	info->rx_enabled = 1;
+	info->rx_overflow = false;
+	info->rx_enabled = true;
 }
 
 /* Enable the transmitter and send a transmit frame if
@@ -4231,7 +4232,7 @@ void tx_start(SLMP_INFO *info)
 	if (!info->tx_enabled ) {
 		write_reg(info, CMD, TXRESET);
 		write_reg(info, CMD, TXENABLE);
-		info->tx_enabled = TRUE;
+		info->tx_enabled = true;
 	}
 
 	if ( info->tx_count ) {
@@ -4240,7 +4241,7 @@ void tx_start(SLMP_INFO *info)
 		/* RTS and set a flag indicating that the driver should */
 		/* negate RTS when the transmission completes. */
 
-		info->drop_rts_on_tx_done = 0;
+		info->drop_rts_on_tx_done = false;
 
 		if (info->params.mode != MGSL_MODE_ASYNC) {
 
@@ -4249,7 +4250,7 @@ void tx_start(SLMP_INFO *info)
 				if ( !(info->serial_signals & SerialSignal_RTS) ) {
 					info->serial_signals |= SerialSignal_RTS;
 					set_signals( info );
-					info->drop_rts_on_tx_done = 1;
+					info->drop_rts_on_tx_done = true;
 				}
 			}
 
@@ -4286,7 +4287,7 @@ void tx_start(SLMP_INFO *info)
 			write_reg(info, IE0, info->ie0_value);
 		}
 
-		info->tx_active = 1;
+		info->tx_active = true;
 	}
 }
 
@@ -4312,8 +4313,8 @@ void tx_stop( SLMP_INFO *info )
 	info->ie0_value &= ~TXRDYE;
 	write_reg(info, IE0, info->ie0_value);	/* disable tx data interrupts */
 
-	info->tx_enabled = 0;
-	info->tx_active  = 0;
+	info->tx_enabled = false;
+	info->tx_active = false;
 }
 
 /* Fill the transmit FIFO until the FIFO is full or
@@ -4836,14 +4837,14 @@ void rx_reset_buffers(SLMP_INFO *info)
  */
 void rx_free_frame_buffers(SLMP_INFO *info, unsigned int first, unsigned int last)
 {
-	int done = 0;
+	bool done = false;
 
 	while(!done) {
 	        /* reset current buffer for reuse */
 		info->rx_buf_list[first].status = 0xff;
 
 	        if (first == last) {
-	                done = 1;
+	                done = true;
 	                /* set new last rx descriptor address */
 			write_reg16(info, RXDMA + EDA, info->rx_buf_list_ex[first].phys_entry);
 	        }
@@ -4860,14 +4861,14 @@ void rx_free_frame_buffers(SLMP_INFO *in
 /* Return a received frame from the receive DMA buffers.
  * Only frames received without errors are returned.
  *
- * Return Value:	1 if frame returned, otherwise 0
+ * Return Value:	true if frame returned, otherwise false
  */
-int rx_get_frame(SLMP_INFO *info)
+bool rx_get_frame(SLMP_INFO *info)
 {
 	unsigned int StartIndex, EndIndex;	/* index of 1st and last buffers of Rx frame */
 	unsigned short status;
 	unsigned int framesize = 0;
-	int ReturnCode = 0;
+	bool ReturnCode = false;
 	unsigned long flags;
 	struct tty_struct *tty = info->tty;
 	unsigned char addr_field = 0xff;
@@ -5018,7 +5019,7 @@ CheckAgain:
 	/* Free the buffers used by this frame. */
 	rx_free_frame_buffers( info, StartIndex, EndIndex );
 
-	ReturnCode = 1;
+	ReturnCode = true;
 
 Cleanup:
 	if ( info->rx_enabled && info->rx_overflow ) {
@@ -5077,12 +5078,12 @@ void tx_load_dma_buffer(SLMP_INFO *info,
 	info->last_tx_buf = ++i;
 }
 
-int register_test(SLMP_INFO *info)
+bool register_test(SLMP_INFO *info)
 {
 	static unsigned char testval[] = {0x00, 0xff, 0xaa, 0x55, 0x69, 0x96};
 	static unsigned int count = ARRAY_SIZE(testval);
 	unsigned int i;
-	int rc = TRUE;
+	bool rc = true;
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->lock,flags);
@@ -5105,7 +5106,7 @@ int register_test(SLMP_INFO *info)
 			  (read_reg(info, SA0) != testval[(i+2)%count]) ||
 			  (read_reg(info, SA1) != testval[(i+3)%count]) )
 		{
-			rc = FALSE;
+			rc = false;
 			break;
 		}
 	}
@@ -5116,7 +5117,7 @@ int register_test(SLMP_INFO *info)
 	return rc;
 }
 
-int irq_test(SLMP_INFO *info)
+bool irq_test(SLMP_INFO *info)
 {
 	unsigned long timeout;
 	unsigned long flags;
@@ -5128,7 +5129,7 @@ int irq_test(SLMP_INFO *info)
 
 	/* assume failure */
 	info->init_error = DiagStatus_IrqFailure;
-	info->irq_occurred = FALSE;
+	info->irq_occurred = false;
 
 	/* setup timer0 on SCA0 to interrupt */
 
@@ -5167,7 +5168,7 @@ int irq_test(SLMP_INFO *info)
 
 /* initialize individual SCA device (2 ports)
  */
-static int sca_init(SLMP_INFO *info)
+static bool sca_init(SLMP_INFO *info)
 {
 	/* set wait controller to single mem partition (low), no wait states */
 	write_reg(info, PABR0, 0);	/* wait controller addr boundary 0 */
@@ -5203,12 +5204,12 @@ static int sca_init(SLMP_INFO *info)
 	 */
 	write_reg(info, ITCR, 0);
 
-	return TRUE;
+	return true;
 }
 
 /* initialize adapter hardware
  */
-int init_adapter(SLMP_INFO *info)
+bool init_adapter(SLMP_INFO *info)
 {
 	int i;
 
@@ -5261,20 +5262,20 @@ int init_adapter(SLMP_INFO *info)
 	sca_init(info->port_array[0]);
 	sca_init(info->port_array[2]);
 
-	return TRUE;
+	return true;
 }
 
 /* Loopback an HDLC frame to test the hardware
  * interrupt and DMA functions.
  */
-int loopback_test(SLMP_INFO *info)
+bool loopback_test(SLMP_INFO *info)
 {
 #define TESTFRAMESIZE 20
 
 	unsigned long timeout;
 	u16 count = TESTFRAMESIZE;
 	unsigned char buf[TESTFRAMESIZE];
-	int rc = FALSE;
+	bool rc = false;
 	unsigned long flags;
 
 	struct tty_struct *oldtty = info->tty;
@@ -5308,16 +5309,16 @@ int loopback_test(SLMP_INFO *info)
 		msleep_interruptible(10);
 
 		if (rx_get_frame(info)) {
-			rc = TRUE;
+			rc = true;
 			break;
 		}
 	}
 
 	/* verify received frame length and contents */
-	if (rc == TRUE &&
-		( info->tmp_rx_buf_count != count ||
-		  memcmp(buf, info->tmp_rx_buf,count))) {
-		rc = FALSE;
+	if (rc &&
+	    ( info->tmp_rx_buf_count != count ||
+	      memcmp(buf, info->tmp_rx_buf,count))) {
+		rc = false;
 	}
 
 	spin_lock_irqsave(&info->lock,flags);
@@ -5394,7 +5395,7 @@ int adapter_test( SLMP_INFO *info )
 
 /* Test the shared memory on a PCI adapter.
  */
-int memory_test(SLMP_INFO *info)
+bool memory_test(SLMP_INFO *info)
 {
 	static unsigned long testval[] = { 0x0, 0x55555555, 0xaaaaaaaa,
 		0x66666666, 0x99999999, 0xffffffff, 0x12345678 };
@@ -5408,7 +5409,7 @@ int memory_test(SLMP_INFO *info)
 	for ( i = 0 ; i < count ; i++ ) {
 		*addr = testval[i];
 		if ( *addr != testval[i] )
-			return FALSE;
+			return false;
 	}
 
 	/* Test address lines with incrementing pattern over */
@@ -5423,12 +5424,12 @@ int memory_test(SLMP_INFO *info)
 
 	for ( i = 0 ; i < limit ; i++ ) {
 		if ( *addr != i * 4 )
-			return FALSE;
+			return false;
 		addr++;
 	}
 
 	memset( info->memory_base, 0, SCA_MEM_SIZE );
-	return TRUE;
+	return true;
 }
 
 /* Load data into PCI adapter shared memory.
@@ -5512,7 +5513,7 @@ void tx_timeout(unsigned long context)
 		info->icount.txtimeout++;
 	}
 	spin_lock_irqsave(&info->lock,flags);
-	info->tx_active = 0;
+	info->tx_active = false;
 	info->tx_count = info->tx_put = info->tx_get = 0;
 
 	spin_unlock_irqrestore(&info->lock,flags);
diff -puN include/linux/synclink.h~synclink-drivers-bool-conversion include/linux/synclink.h
--- a/include/linux/synclink.h~synclink-drivers-bool-conversion
+++ a/include/linux/synclink.h
@@ -13,10 +13,6 @@
 #define _SYNCLINK_H_
 #define SYNCLINK_H_VERSION 3.6
 
-#define BOOLEAN int
-#define TRUE 1
-#define FALSE 0
