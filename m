From: akpm@linux-foundation.org
Subject: + cyclades-remove-custom-types.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:43:25 -0800
Message-ID: <200703180743.l2I7hPNQ018237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbXCRHnb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: klaus.kudielka@gmx.net


The patch titled
     cyclades: remove custom types
has been added to the -mm tree.  Its filename is
     cyclades-remove-custom-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyclades: remove custom types
From: Klaus Kudielka <klaus.kudielka@gmx.net>

Switch from private uclong, etc over to standard types.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c  |   49 ++++------
 include/linux/cyclades.h |  180 ++++++++++++++++++-------------------
 2 files changed, 115 insertions(+), 114 deletions(-)

diff -puN drivers/char/cyclades.c~cyclades-remove-custom-types drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-remove-custom-types
+++ a/drivers/char/cyclades.c
@@ -669,7 +669,6 @@
 		spin_unlock_irqrestore(&cy_card[info->card].card_lock, flags); \
 		} while (0)
 
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 
@@ -845,7 +844,7 @@ MODULE_DEVICE_TABLE(pci, cy_pci_dev_id);
 
 static void cy_start(struct tty_struct *);
 static void set_line_char(struct cyclades_port *);
-static int cyz_issue_cmd(struct cyclades_card *, uclong, ucchar, uclong);
+static int cyz_issue_cmd(struct cyclades_card *, u32, u8, u32);
 #ifdef CONFIG_ISA
 static unsigned detect_isa_irq(void __iomem *);
 #endif				/* CONFIG_ISA */
@@ -1498,7 +1497,7 @@ static irqreturn_t cyy_interrupt(int irq
 
 static int
 cyz_fetch_msg(struct cyclades_card *cinfo,
-		uclong * channel, ucchar * cmd, uclong * param)
+		u32 * channel, u8 * cmd, u32 * param)
 {
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
@@ -1518,7 +1517,7 @@ cyz_fetch_msg(struct cyclades_card *cinf
 	if (loc_doorbell) {
 		*cmd = (char)(0xff & loc_doorbell);
 		*channel = cy_readl(&board_ctrl->fwcmd_channel);
-		*param = (uclong) cy_readl(&board_ctrl->fwcmd_param);
+		*param = (u32) cy_readl(&board_ctrl->fwcmd_param);
 		cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
 			  loc_doorbell, 0xffffffff);
 		return 1;
@@ -1528,12 +1527,12 @@ cyz_fetch_msg(struct cyclades_card *cinf
 
 static int
 cyz_issue_cmd(struct cyclades_card *cinfo,
-		uclong channel, ucchar cmd, uclong param)
+		u32 channel, u8 cmd, u32 param)
 {
 	struct FIRM_ID __iomem *firm_id;
 	struct ZFW_CTRL __iomem *zfw_ctrl;
 	struct BOARD_CTRL __iomem *board_ctrl;
-	uclong __iomem *pci_doorbell;
+	u32 __iomem *pci_doorbell;
 	int index;
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
@@ -1574,7 +1573,7 @@ cyz_handle_rx(struct cyclades_port *info
 #else
 	char data;
 #endif
-	volatile uclong rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+	volatile u32 rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
 
 	rx_get = new_rx_get = cy_readl(&buf_ctrl->rx_get);
 	rx_put = cy_readl(&buf_ctrl->rx_put);
@@ -1670,7 +1669,7 @@ cyz_handle_tx(struct cyclades_port *info
 #ifdef BLOCKMOVE
 	int small_count;
 #endif
-	volatile uclong tx_put, tx_get, tx_bufsize, tx_bufaddr;
+	volatile u32 tx_put, tx_get, tx_bufsize, tx_bufaddr;
 
 	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
 		return;
@@ -1755,10 +1754,10 @@ static void cyz_handle_cmd(struct cyclad
 	static volatile struct BOARD_CTRL __iomem *board_ctrl;
 	static volatile struct CH_CTRL __iomem *ch_ctrl;
 	static volatile struct BUF_CTRL __iomem *buf_ctrl;
-	uclong channel;
-	ucchar cmd;
-	uclong param;
-	uclong hw_ver, fw_ver;
+	u32 channel;
+	u8 cmd;
+	u32 param;
+	u32 hw_ver, fw_ver;
 	int special_count;
 	int delta_count;
 
@@ -1892,7 +1891,7 @@ static void cyz_rx_restart(unsigned long
 	struct cyclades_port *info = (struct cyclades_port *)arg;
 	int retval;
 	int card = info->card;
-	uclong channel = (info->line) - (cy_card[card].first_line);
+	u32 channel = (info->line) - (cy_card[card].first_line);
 	unsigned long flags;
 
 	CY_LOCK(info, flags);
@@ -2289,7 +2288,7 @@ static void shutdown(struct cyclades_por
 
 		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
 			cy_writel(&ch_ctrl[channel].rs_control,
-				(uclong)(cy_readl(&ch_ctrl[channel].rs_control)&
+				(u32)(cy_readl(&ch_ctrl[channel].rs_control)&
 					~(C_RS_RTS | C_RS_DTR)));
 			retval = cyz_issue_cmd(&cy_card[info->card], channel,
 					C_CM_IOCTLM, 0L);
@@ -3026,7 +3025,7 @@ static int cy_chars_in_buffer(struct tty
 		static volatile struct CH_CTRL *ch_ctrl;
 		static volatile struct BUF_CTRL *buf_ctrl;
 		int char_count;
-		volatile uclong tx_put, tx_get, tx_bufsize;
+		volatile u32 tx_put, tx_get, tx_bufsize;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
 		zfw_ctrl = cy_card[card].base_addr +
@@ -3055,10 +3054,10 @@ static int cy_chars_in_buffer(struct tty
  * ------------------------------------------------------------
  */
 
-static void cyy_baud_calc(struct cyclades_port *info, uclong baud)
+static void cyy_baud_calc(struct cyclades_port *info, u32 baud)
 {
 	int co, co_val, bpr;
-	uclong cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 :
+	u32 cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 :
 			25000000);
 
 	if (baud == 0) {
@@ -3348,7 +3347,7 @@ static void set_line_char(struct cyclade
 		struct BOARD_CTRL __iomem *board_ctrl;
 		struct CH_CTRL __iomem *ch_ctrl;
 		struct BUF_CTRL __iomem *buf_ctrl;
-		uclong sw_flow;
+		u32 sw_flow;
 		int retval;
 
 		firm_id = cy_card[card].base_addr + ID_ADDRESS;
@@ -4721,7 +4720,7 @@ static int __init cy_detect_isa(void)
 #endif				/* CONFIG_ISA */
 }				/* cy_detect_isa */
 
-static void plx_init(void __iomem * addr, uclong initctl)
+static void plx_init(void __iomem * addr, u32 initctl)
 {
 	/* Reset PLX */
 	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x40000000);
@@ -4747,14 +4746,14 @@ static int __init cy_detect_pci(void)
 	struct pci_dev *pdev = NULL;
 	unsigned char cyy_rev_id;
 	unsigned char cy_pci_irq = 0;
-	uclong cy_pci_phys0, cy_pci_phys2;
+	u32 cy_pci_phys0, cy_pci_phys2;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned short i, j, cy_pci_nchan, plx_ver;
 	unsigned short device_id, dev_index = 0;
-	uclong mailbox;
-	uclong ZeIndex = 0;
+	u32 mailbox;
+	u32 ZeIndex = 0;
 	void __iomem *Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
-	uclong Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
+	u32 Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
 	unsigned char Ze_irq[NR_CARDS];
 	struct pci_dev *Ze_pdev[NR_CARDS];
 
@@ -4959,7 +4958,7 @@ static int __init cy_detect_pci(void)
 						cy_pci_irq);
 
 			mailbox =
-			    (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+			    (u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
 						cy_pci_addr0)->mail_box_0);
 
 			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
@@ -5122,7 +5121,7 @@ static int __init cy_detect_pci(void)
 			Ze_pdev[j] = Ze_pdev[j + 1];
 		}
 		ZeIndex--;
-		mailbox = (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+		mailbox = (u32)cy_readl(&((struct RUNTIME_9060 __iomem *)
 						cy_pci_addr0)->mail_box_0);
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
diff -puN include/linux/cyclades.h~cyclades-remove-custom-types include/linux/cyclades.h
--- a/include/linux/cyclades.h~cyclades-remove-custom-types
+++ a/include/linux/cyclades.h
@@ -67,6 +67,8 @@
 #ifndef _LINUX_CYCLADES_H
 #define _LINUX_CYCLADES_H
 
+#include <linux/types.h>
+
 struct cyclades_monitor {
         unsigned long           int_count;
         unsigned long           char_count;
@@ -172,24 +174,24 @@ typedef __u8   ucchar;			/* 8 bits, unsi
  */
 
 struct	CUSTOM_REG {
-	uclong	fpga_id;		/* FPGA Identification Register */
-	uclong	fpga_version;		/* FPGA Version Number Register */
-	uclong	cpu_start;		/* CPU start Register (write) */
-	uclong	cpu_stop;		/* CPU stop Register (write) */
-	uclong	misc_reg;		/* Miscelaneous Register */
-	uclong	idt_mode;		/* IDT mode Register */
-	uclong	uart_irq_status;	/* UART IRQ status Register */
-	uclong	clear_timer0_irq;	/* Clear timer interrupt Register */
-	uclong	clear_timer1_irq;	/* Clear timer interrupt Register */
-	uclong	clear_timer2_irq;	/* Clear timer interrupt Register */
-	uclong	test_register;		/* Test Register */
-	uclong	test_count;		/* Test Count Register */
-	uclong	timer_select;		/* Timer select register */
-	uclong	pr_uart_irq_status;	/* Prioritized UART IRQ stat Reg */
-	uclong	ram_wait_state;		/* RAM wait-state Register */
-	uclong	uart_wait_state;	/* UART wait-state Register */
-	uclong	timer_wait_state;	/* timer wait-state Register */
-	uclong	ack_wait_state;		/* ACK wait State Register */
+	u32	fpga_id;		/* FPGA Identification Register */
+	u32	fpga_version;		/* FPGA Version Number Register */
+	u32	cpu_start;		/* CPU start Register (write) */
+	u32	cpu_stop;		/* CPU stop Register (write) */
+	u32	misc_reg;		/* Miscelaneous Register */
+	u32	idt_mode;		/* IDT mode Register */
+	u32	uart_irq_status;	/* UART IRQ status Register */
+	u32	clear_timer0_irq;	/* Clear timer interrupt Register */
+	u32	clear_timer1_irq;	/* Clear timer interrupt Register */
+	u32	clear_timer2_irq;	/* Clear timer interrupt Register */
+	u32	test_register;		/* Test Register */
+	u32	test_count;		/* Test Count Register */
+	u32	timer_select;		/* Timer select register */
+	u32	pr_uart_irq_status;	/* Prioritized UART IRQ stat Reg */
+	u32	ram_wait_state;		/* RAM wait-state Register */
+	u32	uart_wait_state;	/* UART wait-state Register */
+	u32	timer_wait_state;	/* timer wait-state Register */
+	u32	ack_wait_state;		/* ACK wait State Register */
 };
 
 /*
@@ -199,34 +201,34 @@ struct	CUSTOM_REG {
  */
 
 struct RUNTIME_9060 {
-	uclong	loc_addr_range;	/* 00h - Local Address Range */
-	uclong	loc_addr_base;	/* 04h - Local Address Base */
-	uclong	loc_arbitr;	/* 08h - Local Arbitration */
-	uclong	endian_descr;	/* 0Ch - Big/Little Endian Descriptor */
-	uclong	loc_rom_range;	/* 10h - Local ROM Range */
-	uclong	loc_rom_base;	/* 14h - Local ROM Base */
-	uclong	loc_bus_descr;	/* 18h - Local Bus descriptor */
-	uclong	loc_range_mst;	/* 1Ch - Local Range for Master to PCI */
-	uclong	loc_base_mst;	/* 20h - Local Base for Master PCI */
-	uclong	loc_range_io;	/* 24h - Local Range for Master IO */
-	uclong	pci_base_mst;	/* 28h - PCI Base for Master PCI */
-	uclong	pci_conf_io;	/* 2Ch - PCI configuration for Master IO */
-	uclong	filler1;	/* 30h */
-	uclong	filler2;	/* 34h */
-	uclong	filler3;	/* 38h */
-	uclong	filler4;	/* 3Ch */
-	uclong	mail_box_0;	/* 40h - Mail Box 0 */
-	uclong	mail_box_1;	/* 44h - Mail Box 1 */
-	uclong	mail_box_2;	/* 48h - Mail Box 2 */
-	uclong	mail_box_3;	/* 4Ch - Mail Box 3 */
-	uclong	filler5;	/* 50h */
-	uclong	filler6;	/* 54h */
-	uclong	filler7;	/* 58h */
-	uclong	filler8;	/* 5Ch */
-	uclong	pci_doorbell;	/* 60h - PCI to Local Doorbell */
-	uclong	loc_doorbell;	/* 64h - Local to PCI Doorbell */
-	uclong	intr_ctrl_stat;	/* 68h - Interrupt Control/Status */
-	uclong	init_ctrl;	/* 6Ch - EEPROM control, Init Control, etc */
+	u32	loc_addr_range;	/* 00h - Local Address Range */
+	u32	loc_addr_base;	/* 04h - Local Address Base */
+	u32	loc_arbitr;	/* 08h - Local Arbitration */
+	u32	endian_descr;	/* 0Ch - Big/Little Endian Descriptor */
+	u32	loc_rom_range;	/* 10h - Local ROM Range */
+	u32	loc_rom_base;	/* 14h - Local ROM Base */
+	u32	loc_bus_descr;	/* 18h - Local Bus descriptor */
+	u32	loc_range_mst;	/* 1Ch - Local Range for Master to PCI */
+	u32	loc_base_mst;	/* 20h - Local Base for Master PCI */
+	u32	loc_range_io;	/* 24h - Local Range for Master IO */
+	u32	pci_base_mst;	/* 28h - PCI Base for Master PCI */
+	u32	pci_conf_io;	/* 2Ch - PCI configuration for Master IO */
+	u32	filler1;	/* 30h */
+	u32	filler2;	/* 34h */
+	u32	filler3;	/* 38h */
+	u32	filler4;	/* 3Ch */
+	u32	mail_box_0;	/* 40h - Mail Box 0 */
+	u32	mail_box_1;	/* 44h - Mail Box 1 */
+	u32	mail_box_2;	/* 48h - Mail Box 2 */
+	u32	mail_box_3;	/* 4Ch - Mail Box 3 */
+	u32	filler5;	/* 50h */
+	u32	filler6;	/* 54h */
+	u32	filler7;	/* 58h */
+	u32	filler8;	/* 5Ch */
+	u32	pci_doorbell;	/* 60h - PCI to Local Doorbell */
+	u32	loc_doorbell;	/* 64h - Local to PCI Doorbell */
+	u32	intr_ctrl_stat;	/* 68h - Interrupt Control/Status */
+	u32	init_ctrl;	/* 6Ch - EEPROM control, Init Control, etc */
 };
 
 /* Values for the Local Base Address re-map register */
@@ -268,8 +270,8 @@ struct RUNTIME_9060 {
 #define	ZF_TINACT	ZF_TINACT_DEF
 
 struct	FIRM_ID {
-	uclong	signature;		/* ZFIRM/U signature */
-	uclong	zfwctrl_addr;		/* pointer to ZFW_CTRL structure */
+	u32	signature;		/* ZFIRM/U signature */
+	u32	zfwctrl_addr;		/* pointer to ZFW_CTRL structure */
 };
 
 /* Op. System id */
@@ -406,24 +408,24 @@ struct	FIRM_ID {
  */
 
 struct CH_CTRL {
-	uclong	op_mode;	/* operation mode */
-	uclong	intr_enable;	/* interrupt masking */
-	uclong	sw_flow;	/* SW flow control */
-	uclong	flow_status;	/* output flow status */
-	uclong	comm_baud;	/* baud rate  - numerically specified */
-	uclong	comm_parity;	/* parity */
-	uclong	comm_data_l;	/* data length/stop */
-	uclong	comm_flags;	/* other flags */
-	uclong	hw_flow;	/* HW flow control */
-	uclong	rs_control;	/* RS-232 outputs */
-	uclong	rs_status;	/* RS-232 inputs */
-	uclong	flow_xon;	/* xon char */
-	uclong	flow_xoff;	/* xoff char */
-	uclong	hw_overflow;	/* hw overflow counter */
-	uclong	sw_overflow;	/* sw overflow counter */
-	uclong	comm_error;	/* frame/parity error counter */
-	uclong ichar;
-	uclong filler[7];
+	u32	op_mode;	/* operation mode */
+	u32	intr_enable;	/* interrupt masking */
+	u32	sw_flow;	/* SW flow control */
+	u32	flow_status;	/* output flow status */
+	u32	comm_baud;	/* baud rate  - numerically specified */
+	u32	comm_parity;	/* parity */
+	u32	comm_data_l;	/* data length/stop */
+	u32	comm_flags;	/* other flags */
+	u32	hw_flow;	/* HW flow control */
+	u32	rs_control;	/* RS-232 outputs */
+	u32	rs_status;	/* RS-232 inputs */
+	u32	flow_xon;	/* xon char */
+	u32	flow_xoff;	/* xoff char */
+	u32	hw_overflow;	/* hw overflow counter */
+	u32	sw_overflow;	/* sw overflow counter */
+	u32	comm_error;	/* frame/parity error counter */
+	u32 ichar;
+	u32 filler[7];
 };
 
 
@@ -433,18 +435,18 @@ struct CH_CTRL {
  */
 
 struct	BUF_CTRL	{
-	uclong	flag_dma;	/* buffers are in Host memory */
-	uclong	tx_bufaddr;	/* address of the tx buffer */
-	uclong	tx_bufsize;	/* tx buffer size */
-	uclong	tx_threshold;	/* tx low water mark */
-	uclong	tx_get;		/* tail index tx buf */
-	uclong	tx_put;		/* head index tx buf */
-	uclong	rx_bufaddr;	/* address of the rx buffer */
-	uclong	rx_bufsize;	/* rx buffer size */
-	uclong	rx_threshold;	/* rx high water mark */
-	uclong	rx_get;		/* tail index rx buf */
-	uclong	rx_put;		/* head index rx buf */
-	uclong	filler[5];	/* filler to align structures */
+	u32	flag_dma;	/* buffers are in Host memory */
+	u32	tx_bufaddr;	/* address of the tx buffer */
+	u32	tx_bufsize;	/* tx buffer size */
+	u32	tx_threshold;	/* tx low water mark */
+	u32	tx_get;		/* tail index tx buf */
+	u32	tx_put;		/* head index tx buf */
+	u32	rx_bufaddr;	/* address of the rx buffer */
+	u32	rx_bufsize;	/* rx buffer size */
+	u32	rx_threshold;	/* rx high water mark */
+	u32	rx_get;		/* tail index rx buf */
+	u32	rx_put;		/* head index rx buf */
+	u32	filler[5];	/* filler to align structures */
 };
 
 /*
@@ -455,27 +457,27 @@ struct	BUF_CTRL	{
 struct BOARD_CTRL {
 
 	/* static info provided by the on-board CPU */
-	uclong	n_channel;	/* number of channels */
-	uclong	fw_version;	/* firmware version */
+	u32	n_channel;	/* number of channels */
+	u32	fw_version;	/* firmware version */
 
 	/* static info provided by the driver */
-	uclong	op_system;	/* op_system id */
-	uclong	dr_version;	/* driver version */
+	u32	op_system;	/* op_system id */
+	u32	dr_version;	/* driver version */
 
 	/* board control area */
-	uclong	inactivity;	/* inactivity control */
+	u32	inactivity;	/* inactivity control */
 
 	/* host to FW commands */
-	uclong	hcmd_channel;	/* channel number */
-	uclong	hcmd_param;	/* pointer to parameters */
+	u32	hcmd_channel;	/* channel number */
+	u32	hcmd_param;	/* pointer to parameters */
 
 	/* FW to Host commands */
-	uclong	fwcmd_channel;	/* channel number */
-	uclong	fwcmd_param;	/* pointer to parameters */
-	uclong	zf_int_queue_addr; /* offset for INT_QUEUE structure */
+	u32	fwcmd_channel;	/* channel number */
+	u32	fwcmd_param;	/* pointer to parameters */
+	u32	zf_int_queue_addr; /* offset for INT_QUEUE structure */
 
 	/* filler so the structures are aligned */
-	uclong	filler[6];
+	u32	filler[6];
 };
 
 /* Host Interrupt Queue */
_

Patches currently in -mm which might be from klaus.kudielka@gmx.net are

fix-cycladesh-for-x86_64-and-probably-others.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
cyclades-remove-custom-types.patch
