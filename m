From: akpm@linux-foundation.org
Subject: - char-make-functions-static-in-synclinkmpc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:20 -0700
Message-ID: <200804282155.m3SLtK1j018094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935084AbYD1Vz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     char: make functions static in synclinkmp.c
has been removed from the -mm tree.  Its filename was
     char-make-functions-static-in-synclinkmpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: make functions static in synclinkmp.c
From: Harvey Harrison <harvey.harrison@gmail.com>

All were forward declared with static.

Fixes sparse warnings:
drivers/char/synclinkmp.c:1476:5: warning: symbol 'read_proc' was not declared. Should it be static?
drivers/char/synclinkmp.c:2027:5: warning: symbol 'bh_action' was not declared. Should it be static?
drivers/char/synclinkmp.c:2058:6: warning: symbol 'bh_handler' was not declared. Should it be static?
drivers/char/synclinkmp.c:2103:6: warning: symbol 'bh_receive' was not declared. Should it be static?
drivers/char/synclinkmp.c:2112:6: warning: symbol 'bh_transmit' was not declared. Should it be static?
drivers/char/synclinkmp.c:2124:6: warning: symbol 'bh_status' was not declared. Should it be static?
drivers/char/synclinkmp.c:2136:6: warning: symbol 'isr_timer' was not declared. Should it be static?
drivers/char/synclinkmp.c:2162:6: warning: symbol 'isr_rxint' was not declared. Should it be static?
drivers/char/synclinkmp.c:2221:6: warning: symbol 'isr_rxrdy' was not declared. Should it be static?
drivers/char/synclinkmp.c:2351:6: warning: symbol 'isr_txint' was not declared. Should it be static?
drivers/char/synclinkmp.c:2379:6: warning: symbol 'isr_txrdy' was not declared. Should it be static?
drivers/char/synclinkmp.c:2410:6: warning: symbol 'isr_rxdmaok' was not declared. Should it be static?
drivers/char/synclinkmp.c:2427:6: warning: symbol 'isr_rxdmaerror' was not declared. Should it be static?
drivers/char/synclinkmp.c:2445:6: warning: symbol 'isr_txdmaok' was not declared. Should it be static?
drivers/char/synclinkmp.c:2463:6: warning: symbol 'isr_txdmaerror' was not declared. Should it be static?
drivers/char/synclinkmp.c:2480:6: warning: symbol 'isr_io_pin' was not declared. Should it be static?
drivers/char/synclinkmp.c:3420:5: warning: symbol 'alloc_dma_bufs' was not declared. Should it be static?
drivers/char/synclinkmp.c:3494:5: warning: symbol 'alloc_buf_list' was not declared. Should it be static?
drivers/char/synclinkmp.c:3553:5: warning: symbol 'alloc_frame_bufs' was not declared. Should it be static?
drivers/char/synclinkmp.c:3570:6: warning: symbol 'free_dma_bufs' was not declared. Should it be static?
drivers/char/synclinkmp.c:3580:5: warning: symbol 'alloc_tmp_rx_buf' was not declared. Should it be static?
drivers/char/synclinkmp.c:3588:6: warning: symbol 'free_tmp_rx_buf' was not declared. Should it be static?
drivers/char/synclinkmp.c:3594:5: warning: symbol 'claim_resources' was not declared. Should it be static?
drivers/char/synclinkmp.c:3681:6: warning: symbol 'release_resources' was not declared. Should it be static?
drivers/char/synclinkmp.c:3737:6: warning: symbol 'add_device' was not declared. Should it be static?
drivers/char/synclinkmp.c:3860:6: warning: symbol 'device_init' was not declared. Should it be static?
drivers/char/synclinkmp.c:4054:6: warning: symbol 'enable_loopback' was not declared. Should it be static?
drivers/char/synclinkmp.c:4101:6: warning: symbol 'set_rate' was not declared. Should it be static?
drivers/char/synclinkmp.c:4147:6: warning: symbol 'rx_stop' was not declared. Should it be static?
drivers/char/synclinkmp.c:4168:6: warning: symbol 'rx_start' was not declared. Should it be static?
drivers/char/synclinkmp.c:4225:6: warning: symbol 'tx_start' was not declared. Should it be static?
drivers/char/synclinkmp.c:4295:6: warning: symbol 'tx_stop' was not declared. Should it be static?
drivers/char/synclinkmp.c:4322:6: warning: symbol 'tx_load_fifo' was not declared. Should it be static?
drivers/char/synclinkmp.c:4371:6: warning: symbol 'reset_port' was not declared. Should it be static?
drivers/char/synclinkmp.c:4395:6: warning: symbol 'reset_adapter' was not declared. Should it be static?
drivers/char/synclinkmp.c:4407:6: warning: symbol 'async_mode' was not declared. Should it be static?
drivers/char/synclinkmp.c:4546:6: warning: symbol 'hdlc_mode' was not declared. Should it be static?
drivers/char/synclinkmp.c:4748:6: warning: symbol 'tx_set_idle' was not declared. Should it be static?
drivers/char/synclinkmp.c:4768:6: warning: symbol 'get_signals' was not declared. Should it be static?
drivers/char/synclinkmp.c:4797:6: warning: symbol 'set_signals' was not declared. Should it be static?
drivers/char/synclinkmp.c:4826:6: warning: symbol 'rx_reset_buffers' was not declared. Should it be static?
drivers/char/synclinkmp.c:4837:6: warning: symbol 'rx_free_frame_buffers' was not declared. Should it be static?
drivers/char/synclinkmp.c:4865:5: warning: symbol 'rx_get_frame' was not declared. Should it be static?
drivers/char/synclinkmp.c:5040:6: warning: symbol 'tx_load_dma_buffer' was not declared. Should it be static?
drivers/char/synclinkmp.c:5080:5: warning: symbol 'register_test' was not declared. Should it be static?
drivers/char/synclinkmp.c:5119:5: warning: symbol 'irq_test' was not declared. Should it be static?
drivers/char/synclinkmp.c:5211:5: warning: symbol 'init_adapter' was not declared. Should it be static?
drivers/char/synclinkmp.c:5270:5: warning: symbol 'loopback_test' was not declared. Should it be static?
drivers/char/synclinkmp.c:5335:5: warning: symbol 'adapter_test' was not declared. Should it be static?
drivers/char/synclinkmp.c:5397:5: warning: symbol 'memory_test' was not declared. Should it be static?
drivers/char/synclinkmp.c:5449:6: warning: symbol 'load_pci_memory' was not declared. Should it be static?
drivers/char/synclinkmp.c:5468:6: warning: symbol 'trace_block' was not declared. Should it be static?
drivers/char/synclinkmp.c:5503:6: warning: symbol 'tx_timeout' was not declared. Should it be static?
drivers/char/synclinkmp.c:5530:6: warning: symbol 'status_timeout' was not declared. Should it be static?
drivers/char/synclinkmp.c:5581:15: warning: symbol 'read_reg' was not declared. Should it be static?
drivers/char/synclinkmp.c:5586:6: warning: symbol 'write_reg' was not declared. Should it be static?
drivers/char/synclinkmp.c:5592:5: warning: symbol 'read_reg16' was not declared. Should it be static?
drivers/char/synclinkmp.c:5598:6: warning: symbol 'write_reg16' was not declared. Should it be static?
drivers/char/synclinkmp.c:5604:15: warning: symbol 'read_status_reg' was not declared. Should it be static?
drivers/char/synclinkmp.c:5610:6: warning: symbol 'write_control_reg' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclinkmp.c |  120 ++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff -puN drivers/char/synclinkmp.c~char-make-functions-static-in-synclinkmpc drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~char-make-functions-static-in-synclinkmpc
+++ a/drivers/char/synclinkmp.c
@@ -1473,7 +1473,7 @@ static inline int line_info(char *buf, S
 
 /* Called to print information about devices
  */
-int read_proc(char *page, char **start, off_t off, int count,
+static int read_proc(char *page, char **start, off_t off, int count,
 	      int *eof, void *data)
 {
 	int len = 0, l;
@@ -2024,7 +2024,7 @@ static void hdlcdev_exit(SLMP_INFO *info
 /* Return next bottom half action to perform.
  * Return Value:	BH action code or 0 if nothing to do.
  */
-int bh_action(SLMP_INFO *info)
+static int bh_action(SLMP_INFO *info)
 {
 	unsigned long flags;
 	int rc = 0;
@@ -2055,7 +2055,7 @@ int bh_action(SLMP_INFO *info)
 
 /* Perform bottom half processing of work items queued by ISR.
  */
-void bh_handler(struct work_struct *work)
+static void bh_handler(struct work_struct *work)
 {
 	SLMP_INFO *info = container_of(work, SLMP_INFO, task);
 	int action;
@@ -2100,7 +2100,7 @@ void bh_handler(struct work_struct *work
 			__FILE__,__LINE__,info->device_name);
 }
 
-void bh_receive(SLMP_INFO *info)
+static void bh_receive(SLMP_INFO *info)
 {
 	if ( debug_level >= DEBUG_LEVEL_BH )
 		printk( "%s(%d):%s bh_receive()\n",
@@ -2109,7 +2109,7 @@ void bh_receive(SLMP_INFO *info)
 	while( rx_get_frame(info) );
 }
 
-void bh_transmit(SLMP_INFO *info)
+static void bh_transmit(SLMP_INFO *info)
 {
 	struct tty_struct *tty = info->tty;
 
@@ -2121,7 +2121,7 @@ void bh_transmit(SLMP_INFO *info)
 		tty_wakeup(tty);
 }
 
-void bh_status(SLMP_INFO *info)
+static void bh_status(SLMP_INFO *info)
 {
 	if ( debug_level >= DEBUG_LEVEL_BH )
 		printk( "%s(%d):%s bh_status() entry\n",
@@ -2133,7 +2133,7 @@ void bh_status(SLMP_INFO *info)
 	info->cts_chkcount = 0;
 }
 
-void isr_timer(SLMP_INFO * info)
+static void isr_timer(SLMP_INFO * info)
 {
 	unsigned char timer = (info->port_num & 1) ? TIMER2 : TIMER0;
 
@@ -2159,7 +2159,7 @@ void isr_timer(SLMP_INFO * info)
 			__FILE__,__LINE__,info->device_name);
 }
 
-void isr_rxint(SLMP_INFO * info)
+static void isr_rxint(SLMP_INFO * info)
 {
  	struct tty_struct *tty = info->tty;
  	struct	mgsl_icount *icount = &info->icount;
@@ -2218,7 +2218,7 @@ void isr_rxint(SLMP_INFO * info)
 /*
  * handle async rx data interrupts
  */
-void isr_rxrdy(SLMP_INFO * info)
+static void isr_rxrdy(SLMP_INFO * info)
 {
 	u16 status;
 	unsigned char DataByte;
@@ -2348,7 +2348,7 @@ static void isr_txeom(SLMP_INFO * info, 
 /*
  * handle tx status interrupts
  */
-void isr_txint(SLMP_INFO * info)
+static void isr_txint(SLMP_INFO * info)
 {
 	unsigned char status = read_reg(info, SR1) & info->ie1_value & (UDRN + IDLE + CCTS);
 
@@ -2376,7 +2376,7 @@ void isr_txint(SLMP_INFO * info)
 /*
  * handle async tx data interrupts
  */
-void isr_txrdy(SLMP_INFO * info)
+static void isr_txrdy(SLMP_INFO * info)
 {
 	if ( debug_level >= DEBUG_LEVEL_ISR )
 		printk("%s(%d):%s isr_txrdy() tx_count=%d\n",
@@ -2407,7 +2407,7 @@ void isr_txrdy(SLMP_INFO * info)
 		info->pending_bh |= BH_TRANSMIT;
 }
 
-void isr_rxdmaok(SLMP_INFO * info)
+static void isr_rxdmaok(SLMP_INFO * info)
 {
 	/* BIT7 = EOT (end of transfer)
 	 * BIT6 = EOM (end of message/frame)
@@ -2424,7 +2424,7 @@ void isr_rxdmaok(SLMP_INFO * info)
 	info->pending_bh |= BH_RECEIVE;
 }
 
-void isr_rxdmaerror(SLMP_INFO * info)
+static void isr_rxdmaerror(SLMP_INFO * info)
 {
 	/* BIT5 = BOF (buffer overflow)
 	 * BIT4 = COF (counter overflow)
@@ -2442,7 +2442,7 @@ void isr_rxdmaerror(SLMP_INFO * info)
 	info->pending_bh |= BH_RECEIVE;
 }
 
-void isr_txdmaok(SLMP_INFO * info)
+static void isr_txdmaok(SLMP_INFO * info)
 {
 	unsigned char status_reg1 = read_reg(info, SR1);
 
@@ -2460,7 +2460,7 @@ void isr_txdmaok(SLMP_INFO * info)
 	write_reg(info, IE0, info->ie0_value);
 }
 
-void isr_txdmaerror(SLMP_INFO * info)
+static void isr_txdmaerror(SLMP_INFO * info)
 {
 	/* BIT5 = BOF (buffer overflow)
 	 * BIT4 = COF (counter overflow)
@@ -2477,7 +2477,7 @@ void isr_txdmaerror(SLMP_INFO * info)
 
 /* handle input serial signal changes
  */
-void isr_io_pin( SLMP_INFO *info, u16 status )
+static void isr_io_pin( SLMP_INFO *info, u16 status )
 {
  	struct	mgsl_icount *icount;
 
@@ -3414,7 +3414,7 @@ static int block_til_ready(struct tty_st
 	return retval;
 }
 
-int alloc_dma_bufs(SLMP_INFO *info)
+static int alloc_dma_bufs(SLMP_INFO *info)
 {
 	unsigned short BuffersPerFrame;
 	unsigned short BufferCount;
@@ -3488,7 +3488,7 @@ int alloc_dma_bufs(SLMP_INFO *info)
 
 /* Allocate DMA buffers for the transmit and receive descriptor lists.
  */
-int alloc_buf_list(SLMP_INFO *info)
+static int alloc_buf_list(SLMP_INFO *info)
 {
 	unsigned int i;
 
@@ -3547,7 +3547,7 @@ int alloc_buf_list(SLMP_INFO *info)
 
 /* Allocate the frame DMA buffers used by the specified buffer list.
  */
-int alloc_frame_bufs(SLMP_INFO *info, SCADESC *buf_list,SCADESC_EX *buf_list_ex,int count)
+static int alloc_frame_bufs(SLMP_INFO *info, SCADESC *buf_list,SCADESC_EX *buf_list_ex,int count)
 {
 	int i;
 	unsigned long phys_addr;
@@ -3564,7 +3564,7 @@ int alloc_frame_bufs(SLMP_INFO *info, SC
 	return 0;
 }
 
-void free_dma_bufs(SLMP_INFO *info)
+static void free_dma_bufs(SLMP_INFO *info)
 {
 	info->buffer_list = NULL;
 	info->rx_buf_list = NULL;
@@ -3574,7 +3574,7 @@ void free_dma_bufs(SLMP_INFO *info)
 /* allocate buffer large enough to hold max_frame_size.
  * This buffer is used to pass an assembled frame to the line discipline.
  */
-int alloc_tmp_rx_buf(SLMP_INFO *info)
+static int alloc_tmp_rx_buf(SLMP_INFO *info)
 {
 	info->tmp_rx_buf = kmalloc(info->max_frame_size, GFP_KERNEL);
 	if (info->tmp_rx_buf == NULL)
@@ -3582,13 +3582,13 @@ int alloc_tmp_rx_buf(SLMP_INFO *info)
 	return 0;
 }
 
-void free_tmp_rx_buf(SLMP_INFO *info)
+static void free_tmp_rx_buf(SLMP_INFO *info)
 {
 	kfree(info->tmp_rx_buf);
 	info->tmp_rx_buf = NULL;
 }
 
-int claim_resources(SLMP_INFO *info)
+static int claim_resources(SLMP_INFO *info)
 {
 	if (request_mem_region(info->phys_memory_base,SCA_MEM_SIZE,"synclinkmp") == NULL) {
 		printk( "%s(%d):%s mem addr conflict, Addr=%08X\n",
@@ -3675,7 +3675,7 @@ errout:
 	return -ENODEV;
 }
 
-void release_resources(SLMP_INFO *info)
+static void release_resources(SLMP_INFO *info)
 {
 	if ( debug_level >= DEBUG_LEVEL_INFO )
 		printk( "%s(%d):%s release_resources() entry\n",
@@ -3731,7 +3731,7 @@ void release_resources(SLMP_INFO *info)
 /* Add the specified device instance data structure to the
  * global linked list of devices and increment the device count.
  */
-void add_device(SLMP_INFO *info)
+static void add_device(SLMP_INFO *info)
 {
 	info->next_device = NULL;
 	info->line = synclinkmp_device_count;
@@ -3854,7 +3854,7 @@ static SLMP_INFO *alloc_dev(int adapter_
 	return info;
 }
 
-void device_init(int adapter_num, struct pci_dev *pdev)
+static void device_init(int adapter_num, struct pci_dev *pdev)
 {
 	SLMP_INFO *port_array[SCA_MAX_PORTS];
 	int port;
@@ -4048,7 +4048,7 @@ module_exit(synclinkmp_exit);
  * The TxCLK and RxCLK signals are generated from the BRG and
  * the TxD is looped back to the RxD internally.
  */
-void enable_loopback(SLMP_INFO *info, int enable)
+static void enable_loopback(SLMP_INFO *info, int enable)
 {
 	if (enable) {
 		/* MD2 (Mode Register 2)
@@ -4095,7 +4095,7 @@ void enable_loopback(SLMP_INFO *info, in
  *	data_rate	data rate of clock in bits per second
  *			A data rate of 0 disables the AUX clock.
  */
-void set_rate( SLMP_INFO *info, u32 data_rate )
+static void set_rate( SLMP_INFO *info, u32 data_rate )
 {
        	u32 TMCValue;
        	unsigned char BRValue;
@@ -4141,7 +4141,7 @@ void set_rate( SLMP_INFO *info, u32 data
 
 /* Disable receiver
  */
-void rx_stop(SLMP_INFO *info)
+static void rx_stop(SLMP_INFO *info)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):%s rx_stop()\n",
@@ -4162,7 +4162,7 @@ void rx_stop(SLMP_INFO *info)
 
 /* enable the receiver
  */
-void rx_start(SLMP_INFO *info)
+static void rx_start(SLMP_INFO *info)
 {
 	int i;
 
@@ -4219,7 +4219,7 @@ void rx_start(SLMP_INFO *info)
 /* Enable the transmitter and send a transmit frame if
  * one is loaded in the DMA buffers.
  */
-void tx_start(SLMP_INFO *info)
+static void tx_start(SLMP_INFO *info)
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):%s tx_start() tx_count=%d\n",
@@ -4289,7 +4289,7 @@ void tx_start(SLMP_INFO *info)
 
 /* stop the transmitter and DMA
  */
-void tx_stop( SLMP_INFO *info )
+static void tx_stop( SLMP_INFO *info )
 {
 	if (debug_level >= DEBUG_LEVEL_ISR)
 		printk("%s(%d):%s tx_stop()\n",
@@ -4316,7 +4316,7 @@ void tx_stop( SLMP_INFO *info )
 /* Fill the transmit FIFO until the FIFO is full or
  * there is no more data to load.
  */
-void tx_load_fifo(SLMP_INFO *info)
+static void tx_load_fifo(SLMP_INFO *info)
 {
 	u8 TwoBytes[2];
 
@@ -4365,7 +4365,7 @@ void tx_load_fifo(SLMP_INFO *info)
 
 /* Reset a port to a known state
  */
-void reset_port(SLMP_INFO *info)
+static void reset_port(SLMP_INFO *info)
 {
 	if (info->sca_base) {
 
@@ -4389,7 +4389,7 @@ void reset_port(SLMP_INFO *info)
 
 /* Reset all the ports to a known state.
  */
-void reset_adapter(SLMP_INFO *info)
+static void reset_adapter(SLMP_INFO *info)
 {
 	int i;
 
@@ -4401,7 +4401,7 @@ void reset_adapter(SLMP_INFO *info)
 
 /* Program port for asynchronous communications.
  */
-void async_mode(SLMP_INFO *info)
+static void async_mode(SLMP_INFO *info)
 {
 
   	unsigned char RegValue;
@@ -4540,7 +4540,7 @@ void async_mode(SLMP_INFO *info)
 
 /* Program the SCA for HDLC communications.
  */
-void hdlc_mode(SLMP_INFO *info)
+static void hdlc_mode(SLMP_INFO *info)
 {
 	unsigned char RegValue;
 	u32 DpllDivisor;
@@ -4742,7 +4742,7 @@ void hdlc_mode(SLMP_INFO *info)
 
 /* Set the transmit HDLC idle mode
  */
-void tx_set_idle(SLMP_INFO *info)
+static void tx_set_idle(SLMP_INFO *info)
 {
 	unsigned char RegValue = 0xff;
 
@@ -4762,7 +4762,7 @@ void tx_set_idle(SLMP_INFO *info)
 
 /* Query the adapter for the state of the V24 status (input) signals.
  */
-void get_signals(SLMP_INFO *info)
+static void get_signals(SLMP_INFO *info)
 {
 	u16 status = read_reg(info, SR3);
 	u16 gpstatus = read_status_reg(info);
@@ -4791,7 +4791,7 @@ void get_signals(SLMP_INFO *info)
 /* Set the state of DTR and RTS based on contents of
  * serial_signals member of device context.
  */
-void set_signals(SLMP_INFO *info)
+static void set_signals(SLMP_INFO *info)
 {
 	unsigned char RegValue;
 	u16 EnableBit;
@@ -4820,7 +4820,7 @@ void set_signals(SLMP_INFO *info)
  * and set the current buffer to the first buffer. This effectively
  * makes all buffers free and discards any data in buffers.
  */
-void rx_reset_buffers(SLMP_INFO *info)
+static void rx_reset_buffers(SLMP_INFO *info)
 {
 	rx_free_frame_buffers(info, 0, info->rx_buf_count - 1);
 }
@@ -4831,7 +4831,7 @@ void rx_reset_buffers(SLMP_INFO *info)
  * first  index of 1st receive buffer of frame
  * last   index of last receive buffer of frame
  */
-void rx_free_frame_buffers(SLMP_INFO *info, unsigned int first, unsigned int last)
+static void rx_free_frame_buffers(SLMP_INFO *info, unsigned int first, unsigned int last)
 {
 	bool done = false;
 
@@ -4859,7 +4859,7 @@ void rx_free_frame_buffers(SLMP_INFO *in
  *
  * Return Value:	true if frame returned, otherwise false
  */
-bool rx_get_frame(SLMP_INFO *info)
+static bool rx_get_frame(SLMP_INFO *info)
 {
 	unsigned int StartIndex, EndIndex;	/* index of 1st and last buffers of Rx frame */
 	unsigned short status;
@@ -5034,7 +5034,7 @@ Cleanup:
 
 /* load the transmit DMA buffer with data
  */
-void tx_load_dma_buffer(SLMP_INFO *info, const char *buf, unsigned int count)
+static void tx_load_dma_buffer(SLMP_INFO *info, const char *buf, unsigned int count)
 {
 	unsigned short copy_count;
 	unsigned int i = 0;
@@ -5074,7 +5074,7 @@ void tx_load_dma_buffer(SLMP_INFO *info,
 	info->last_tx_buf = ++i;
 }
 
-bool register_test(SLMP_INFO *info)
+static bool register_test(SLMP_INFO *info)
 {
 	static unsigned char testval[] = {0x00, 0xff, 0xaa, 0x55, 0x69, 0x96};
 	static unsigned int count = ARRAY_SIZE(testval);
@@ -5113,7 +5113,7 @@ bool register_test(SLMP_INFO *info)
 	return rc;
 }
 
-bool irq_test(SLMP_INFO *info)
+static bool irq_test(SLMP_INFO *info)
 {
 	unsigned long timeout;
 	unsigned long flags;
@@ -5205,7 +5205,7 @@ static bool sca_init(SLMP_INFO *info)
 
 /* initialize adapter hardware
  */
-bool init_adapter(SLMP_INFO *info)
+static bool init_adapter(SLMP_INFO *info)
 {
 	int i;
 
@@ -5264,7 +5264,7 @@ bool init_adapter(SLMP_INFO *info)
 /* Loopback an HDLC frame to test the hardware
  * interrupt and DMA functions.
  */
-bool loopback_test(SLMP_INFO *info)
+static bool loopback_test(SLMP_INFO *info)
 {
 #define TESTFRAMESIZE 20
 
@@ -5329,7 +5329,7 @@ bool loopback_test(SLMP_INFO *info)
 
 /* Perform diagnostics on hardware
  */
-int adapter_test( SLMP_INFO *info )
+static int adapter_test( SLMP_INFO *info )
 {
 	unsigned long flags;
 	if ( debug_level >= DEBUG_LEVEL_INFO )
@@ -5391,7 +5391,7 @@ int adapter_test( SLMP_INFO *info )
 
 /* Test the shared memory on a PCI adapter.
  */
-bool memory_test(SLMP_INFO *info)
+static bool memory_test(SLMP_INFO *info)
 {
 	static unsigned long testval[] = { 0x0, 0x55555555, 0xaaaaaaaa,
 		0x66666666, 0x99999999, 0xffffffff, 0x12345678 };
@@ -5443,7 +5443,7 @@ bool memory_test(SLMP_INFO *info)
  * the write transation. This allows any pending DMA request to gain control
  * of the local bus in a timely fasion.
  */
-void load_pci_memory(SLMP_INFO *info, char* dest, const char* src, unsigned short count)
+static void load_pci_memory(SLMP_INFO *info, char* dest, const char* src, unsigned short count)
 {
 	/* A load interval of 16 allows for 4 32-bit writes at */
 	/* 136ns each for a maximum latency of 542ns on the local bus.*/
@@ -5462,7 +5462,7 @@ void load_pci_memory(SLMP_INFO *info, ch
 	memcpy(dest, src, count % sca_pci_load_interval);
 }
 
-void trace_block(SLMP_INFO *info,const char* data, int count, int xmit)
+static void trace_block(SLMP_INFO *info,const char* data, int count, int xmit)
 {
 	int i;
 	int linecount;
@@ -5497,7 +5497,7 @@ void trace_block(SLMP_INFO *info,const c
 /* called when HDLC frame times out
  * update stats and do tx completion processing
  */
-void tx_timeout(unsigned long context)
+static void tx_timeout(unsigned long context)
 {
 	SLMP_INFO *info = (SLMP_INFO*)context;
 	unsigned long flags;
@@ -5524,7 +5524,7 @@ void tx_timeout(unsigned long context)
 
 /* called to periodically check the DSR/RI modem signal input status
  */
-void status_timeout(unsigned long context)
+static void status_timeout(unsigned long context)
 {
 	u16 status = 0;
 	SLMP_INFO *info = (SLMP_INFO*)context;
@@ -5575,36 +5575,36 @@ void status_timeout(unsigned long contex
 	}
 
 
-unsigned char read_reg(SLMP_INFO * info, unsigned char Addr)
+static unsigned char read_reg(SLMP_INFO * info, unsigned char Addr)
 {
 	CALC_REGADDR();
 	return *RegAddr;
 }
-void write_reg(SLMP_INFO * info, unsigned char Addr, unsigned char Value)
+static void write_reg(SLMP_INFO * info, unsigned char Addr, unsigned char Value)
 {
 	CALC_REGADDR();
 	*RegAddr = Value;
 }
 
-u16 read_reg16(SLMP_INFO * info, unsigned char Addr)
+static u16 read_reg16(SLMP_INFO * info, unsigned char Addr)
 {
 	CALC_REGADDR();
 	return *((u16 *)RegAddr);
 }
 
-void write_reg16(SLMP_INFO * info, unsigned char Addr, u16 Value)
+static void write_reg16(SLMP_INFO * info, unsigned char Addr, u16 Value)
 {
 	CALC_REGADDR();
 	*((u16 *)RegAddr) = Value;
 }
 
-unsigned char read_status_reg(SLMP_INFO * info)
+static unsigned char read_status_reg(SLMP_INFO * info)
 {
 	unsigned char *RegAddr = (unsigned char *)info->statctrl_base;
 	return *RegAddr;
 }
 
-void write_control_reg(SLMP_INFO * info)
+static void write_control_reg(SLMP_INFO * info)
 {
 	unsigned char *RegAddr = (unsigned char *)info->statctrl_base;
 	*RegAddr = info->port_array[0]->ctrlreg_value;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

