From: akpm@osdl.org
Subject: - char-cyclades-lindent-the-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:34 -0800
Message-ID: <200612082010.kB8KAYG4002823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946522AbWLHUKx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, Lindent the code
has been removed from the -mm tree.  Its filename was
     char-cyclades-lindent-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, Lindent the code
From: Jiri Slaby <jirislaby@gmail.com>

make the code indented by tabs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/cyclades.c | 7820 +++++++++++++++++++-------------------
 1 file changed, 3977 insertions(+), 3843 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-lindent-the-code drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-lindent-the-code
+++ a/drivers/char/cyclades.c
@@ -1,8 +1,7 @@
 #undef	BLOCKMOVE
 #define	Z_WAKE
 #undef	Z_EXT_CHARS_IN_BUFFER
-static char rcsid[] =
-"$Revision: 2.3.2.20 $$Date: 2004/02/25 18:14:16 $";
+static char rcsid[] = "$Revision: 2.3.2.20 $$Date: 2004/02/25 18:14:16 $";
 
 /*
  *  linux/drivers/char/cyclades.c
@@ -597,14 +596,14 @@ static char rcsid[] =
    in the definition below. No other change is necessary to support up to
    eight boards. Beyond that you'll have to extend cy_isa_addresses. */
 
-#define NR_CARDS        4
+#define NR_CARDS	4
 
 /*
    If the total number of ports is larger than NR_PORTS, change this
    constant in the definition below. No other change is necessary to
    support more boards/ports. */
 
-#define NR_PORTS        256
+#define NR_PORTS	256
 
 #define ZE_V1_NPORTS	64
 #define ZO_V1	0
@@ -663,7 +662,7 @@ static char rcsid[] =
 		do {						\
 		spin_lock_irqsave(&cy_card[info->card].card_lock, flags); \
 		} while (0)
-		
+
 #define	CY_UNLOCK(info,flags)					\
 		do {						\
 		spin_unlock_irqrestore(&cy_card[info->card].card_lock, flags); \
@@ -676,14 +675,14 @@ static char rcsid[] =
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
-static void cy_throttle (struct tty_struct *tty);
-static void cy_send_xchar (struct tty_struct *tty, char ch);
+static void cy_throttle(struct tty_struct *tty);
+static void cy_send_xchar(struct tty_struct *tty, char ch);
 
 #define IS_CYC_Z(card) ((card).num_chips == -1)
 
 #define Z_FPGA_CHECK(card) \
-    ((cy_readl(&((struct RUNTIME_9060 __iomem *) \
-		 ((card).ctl_addr))->init_ctrl) & (1<<17)) != 0)
+	((cy_readl(&((struct RUNTIME_9060 __iomem *) \
+		((card).ctl_addr))->init_ctrl) & (1<<17)) != 0)
 
 #define ISZLOADED(card)	(((ZO_V1==cy_readl(&((struct RUNTIME_9060 __iomem *) \
 			((card).ctl_addr))->mail_box_0)) || \
@@ -713,27 +712,28 @@ static struct tty_driver *cy_serial_driv
 */
 
 static unsigned int cy_isa_addresses[] = {
-        0xD0000,
-        0xD2000,
-        0xD4000,
-        0xD6000,
-        0xD8000,
-        0xDA000,
-        0xDC000,
-        0xDE000,
-        0,0,0,0,0,0,0,0
+	0xD0000,
+	0xD2000,
+	0xD4000,
+	0xD6000,
+	0xD8000,
+	0xDA000,
+	0xDC000,
+	0xDE000,
+	0, 0, 0, 0, 0, 0, 0, 0
 };
+
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
 #ifdef MODULE
 static long maddr[NR_CARDS] = { 0, };
-static int irq[NR_CARDS]  = { 0, };
+static int irq[NR_CARDS] = { 0, };
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
 #endif
 
-#endif /* CONFIG_ISA */
+#endif				/* CONFIG_ISA */
 
 /* This is the per-card data structure containing address, irq, number of
    channels, etc. This driver supports a maximum of NR_CARDS cards.
@@ -745,7 +745,7 @@ static struct cyclades_card cy_card[NR_C
 */
 static struct cyclades_port cy_port[NR_PORTS];
 
-static int cy_next_channel; /* next minor available */
+static int cy_next_channel;	/* next minor available */
 
 /*
  * This is used to look up the divisor speeds and the timeouts
@@ -757,36 +757,42 @@ static int cy_next_channel; /* next mino
  *     20
  */
 static int baud_table[] = {
-       0,    50,    75,   110,   134,   150,   200,   300,   600,  1200,
-    1800,  2400,  4800,  9600, 19200, 38400, 57600, 76800,115200,150000,
-  230400,     0};
-
-static char baud_co_25[] = {  /* 25 MHz clock option table */
-    /* value =>    00    01   02    03    04 */
-    /* divide by    8    32   128   512  2048 */
-    0x00,  0x04,  0x04,  0x04,  0x04,  0x04,  0x03,  0x03,  0x03,  0x02,
-    0x02,  0x02,  0x01,  0x01,  0x00,  0x00,  0x00,  0x00,  0x00,  0x00};
-
-static char baud_bpr_25[] = {  /* 25 MHz baud rate period table */
-    0x00,  0xf5,  0xa3,  0x6f,  0x5c,  0x51,  0xf5,  0xa3,  0x51,  0xa3,
-    0x6d,  0x51,  0xa3,  0x51,  0xa3,  0x51,  0x36,  0x29,  0x1b,  0x15};
-
-static char baud_co_60[] = {  /* 60 MHz clock option table (CD1400 J) */
-    /* value =>    00    01   02    03    04 */
-    /* divide by    8    32   128   512  2048 */
-    0x00,  0x00,  0x00,  0x04,  0x04,  0x04,  0x04,  0x04,  0x03,  0x03,
-    0x03,  0x02,  0x02,  0x01,  0x01,  0x00,  0x00,  0x00,  0x00,  0x00,
-    0x00};
-
-static char baud_bpr_60[] = {  /* 60 MHz baud rate period table (CD1400 J) */
-    0x00,  0x82,  0x21,  0xff,  0xdb,  0xc3,  0x92,  0x62,  0xc3,  0x62,
-    0x41,  0xc3,  0x62,  0xc3,  0x62,  0xc3,  0x82,  0x62,  0x41,  0x32,
-    0x21};
-
-static char baud_cor3[] = {  /* receive threshold */
-    0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,
-    0x0a,  0x0a,  0x0a,  0x09,  0x09,  0x08,  0x08,  0x08,  0x08,  0x07,
-    0x07};
+	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200,
+	1800, 2400, 4800, 9600, 19200, 38400, 57600, 76800, 115200, 150000,
+	230400, 0
+};
+
+static char baud_co_25[] = {	/* 25 MHz clock option table */
+	/* value =>    00    01   02    03    04 */
+	/* divide by    8    32   128   512  2048 */
+	0x00, 0x04, 0x04, 0x04, 0x04, 0x04, 0x03, 0x03, 0x03, 0x02,
+	0x02, 0x02, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+};
+
+static char baud_bpr_25[] = {	/* 25 MHz baud rate period table */
+	0x00, 0xf5, 0xa3, 0x6f, 0x5c, 0x51, 0xf5, 0xa3, 0x51, 0xa3,
+	0x6d, 0x51, 0xa3, 0x51, 0xa3, 0x51, 0x36, 0x29, 0x1b, 0x15
+};
+
+static char baud_co_60[] = {	/* 60 MHz clock option table (CD1400 J) */
+	/* value =>    00    01   02    03    04 */
+	/* divide by    8    32   128   512  2048 */
+	0x00, 0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x04, 0x03, 0x03,
+	0x03, 0x02, 0x02, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00
+};
+
+static char baud_bpr_60[] = {	/* 60 MHz baud rate period table (CD1400 J) */
+	0x00, 0x82, 0x21, 0xff, 0xdb, 0xc3, 0x92, 0x62, 0xc3, 0x62,
+	0x41, 0xc3, 0x62, 0xc3, 0x62, 0xc3, 0x82, 0x62, 0x41, 0x32,
+	0x21
+};
+
+static char baud_cor3[] = {	/* receive threshold */
+	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
+	0x0a, 0x0a, 0x0a, 0x09, 0x09, 0x08, 0x08, 0x08, 0x08, 0x07,
+	0x07
+};
 
 /*
  * The Cyclades driver implements HW flow control as any serial driver.
@@ -799,42 +805,42 @@ static char baud_cor3[] = {  /* receive 
  * cables.
  */
 
-static char rflow_thr[] = {  /* rflow threshold */
-    0x00,  0x00,  0x00,  0x00,  0x00,  0x00,  0x00,  0x00,  0x00,  0x00,
-    0x00,  0x00,  0x00,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,  0x0a,
-    0x0a};
+static char rflow_thr[] = {	/* rflow threshold */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
+	0x0a
+};
 
 /*  The Cyclom-Ye has placed the sequential chips in non-sequential
  *  address order.  This look-up table overcomes that problem.
  */
-static int cy_chip_offset [] =
-    { 0x0000,
-      0x0400,
-      0x0800,
-      0x0C00,
-      0x0200,
-      0x0600,
-      0x0A00,
-      0x0E00
-    };
+static int cy_chip_offset[] = { 0x0000,
+	0x0400,
+	0x0800,
+	0x0C00,
+	0x0200,
+	0x0600,
+	0x0A00,
+	0x0E00
+};
 
 /* PCI related definitions */
 
-static unsigned short	cy_pci_nboard;
-static unsigned short	cy_isa_nboard;
-static unsigned short	cy_nboard;
+static unsigned short cy_pci_nboard;
+static unsigned short cy_isa_nboard;
+static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
-static unsigned short	cy_pci_dev_id[] = {
-			    PCI_DEVICE_ID_CYCLOM_Y_Lo,	/* PCI < 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_Y_Hi,	/* PCI > 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_4Y_Lo,	/* 4Y PCI < 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_4Y_Hi,	/* 4Y PCI > 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_8Y_Lo,	/* 8Y PCI < 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_8Y_Hi,	/* 8Y PCI > 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_Z_Lo,	/* Z PCI < 1Mb */
-			    PCI_DEVICE_ID_CYCLOM_Z_Hi,	/* Z PCI > 1Mb */
-			    0				/* end of table */
-			};
+static unsigned short cy_pci_dev_id[] = {
+	PCI_DEVICE_ID_CYCLOM_Y_Lo,	/* PCI < 1Mb */
+	PCI_DEVICE_ID_CYCLOM_Y_Hi,	/* PCI > 1Mb */
+	PCI_DEVICE_ID_CYCLOM_4Y_Lo,	/* 4Y PCI < 1Mb */
+	PCI_DEVICE_ID_CYCLOM_4Y_Hi,	/* 4Y PCI > 1Mb */
+	PCI_DEVICE_ID_CYCLOM_8Y_Lo,	/* 8Y PCI < 1Mb */
+	PCI_DEVICE_ID_CYCLOM_8Y_Hi,	/* 8Y PCI > 1Mb */
+	PCI_DEVICE_ID_CYCLOM_Z_Lo,	/* Z PCI < 1Mb */
+	PCI_DEVICE_ID_CYCLOM_Z_Hi,	/* Z PCI > 1Mb */
+	0			/* end of table */
+};
 #endif
 
 static void cy_start(struct tty_struct *);
@@ -842,9 +848,9 @@ static void set_line_char(struct cyclade
 static int cyz_issue_cmd(struct cyclades_card *, uclong, ucchar, uclong);
 #ifdef CONFIG_ISA
 static unsigned detect_isa_irq(void __iomem *);
-#endif /* CONFIG_ISA */
+#endif				/* CONFIG_ISA */
 
-static int cyclades_get_proc_info(char *, char **, off_t , int , int *, void *);
+static int cyclades_get_proc_info(char *, char **, off_t, int, int *, void *);
 
 #ifndef CONFIG_CYZ_INTR
 static void cyz_poll(unsigned long);
@@ -855,41 +861,40 @@ static long cyz_polling_cycle = CZ_DEF_P
 static int cyz_timeron = 0;
 static DEFINE_TIMER(cyz_timerlist, cyz_poll, 0, 0);
 
-#else /* CONFIG_CYZ_INTR */
+#else				/* CONFIG_CYZ_INTR */
 static void cyz_rx_restart(unsigned long);
 static struct timer_list cyz_rx_full_timer[NR_PORTS];
-#endif /* CONFIG_CYZ_INTR */
+#endif				/* CONFIG_CYZ_INTR */
 
-static inline int
-serial_paranoia_check(struct cyclades_port *info,
-                        char *name, const char *routine)
+static inline int serial_paranoia_check(struct cyclades_port *info,
+		char *name, const char *routine)
 {
 #ifdef SERIAL_PARANOIA_CHECK
-    static const char *badmagic =
-        "cyc Warning: bad magic number for serial struct (%s) in %s\n";
-    static const char *badinfo =
-        "cyc Warning: null cyclades_port for (%s) in %s\n";
-    static const char *badrange =
-        "cyc Warning: cyclades_port out of range for (%s) in %s\n";
-
-    if (!info) {
-        printk(badinfo, name, routine);
-        return 1;
-    }
-
-    if( (long)info < (long)(&cy_port[0])
-    || (long)(&cy_port[NR_PORTS]) < (long)info ){
-        printk(badrange, name, routine);
-        return 1;
-    }
-
-    if (info->magic != CYCLADES_MAGIC) {
-        printk(badmagic, name, routine);
-        return 1;
-    }
+	static const char *badmagic =
+		"cyc Warning: bad magic number for serial struct (%s) in %s\n";
+	static const char *badinfo =
+		"cyc Warning: null cyclades_port for (%s) in %s\n";
+	static const char *badrange =
+		"cyc Warning: cyclades_port out of range for (%s) in %s\n";
+
+	if (!info) {
+		printk(badinfo, name, routine);
+		return 1;
+	}
+
+	if ((long)info < (long)(&cy_port[0]) ||
+			(long)(&cy_port[NR_PORTS]) < (long)info) {
+		printk(badrange, name, routine);
+		return 1;
+	}
+
+	if (info->magic != CYCLADES_MAGIC) {
+		printk(badmagic, name, routine);
+		return 1;
+	}
 #endif
-        return 0;
-} /* serial_paranoia_check */
+	return 0;
+}				/* serial_paranoia_check */
 
 /*
  * This routine is used by the interrupt handler to schedule
@@ -897,13 +902,11 @@ serial_paranoia_check(struct cyclades_po
  * (also known as the "bottom half").  This can be called any
  * number of times for any channel without harm.
  */
-static inline void
-cy_sched_event(struct cyclades_port *info, int event)
+static inline void cy_sched_event(struct cyclades_port *info, int event)
 {
-    info->event |= 1 << event; /* remember what kind of event and who */
-    schedule_work(&info->tqueue);
-} /* cy_sched_event */
-
+	info->event |= 1 << event; /* remember what kind of event and who */
+	schedule_work(&info->tqueue);
+}				/* cy_sched_event */
 
 /*
  * This routine is used to handle the "bottom half" processing for the
@@ -930,41 +933,36 @@ do_softint(struct work_struct *work)
 {
 	struct cyclades_port *info =
 		container_of(work, struct cyclades_port, tqueue);
-  struct tty_struct    *tty;
+	struct tty_struct    *tty;
 
-    tty = info->tty;
-    if (!tty)
-        return;
-
-    if (test_and_clear_bit(Cy_EVENT_HANGUP, &info->event)) {
-        tty_hangup(info->tty);
-        wake_up_interruptible(&info->open_wait);
-        info->flags &= ~ASYNC_NORMAL_ACTIVE;
-    }
-    if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event)) {
-        wake_up_interruptible(&info->open_wait);
-    }
+	tty = info->tty;
+	if (!tty)
+		return;
+
+	if (test_and_clear_bit(Cy_EVENT_HANGUP, &info->event)) {
+		tty_hangup(info->tty);
+		wake_up_interruptible(&info->open_wait);
+		        info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	}
+	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event))
+		wake_up_interruptible(&info->open_wait);
 #ifdef CONFIG_CYZ_INTR
-    if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event)) {
-	if (cyz_rx_full_timer[info->line].function == NULL) {
-	    cyz_rx_full_timer[info->line].expires = jiffies + 1;
-	    cyz_rx_full_timer[info->line].function = cyz_rx_restart;
-	    cyz_rx_full_timer[info->line].data = (unsigned long)info;
-	    add_timer(&cyz_rx_full_timer[info->line]);
-	}
-    }
-#endif
-    if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event)) {
-	wake_up_interruptible(&info->delta_msr_wait);
-    }
-    if (test_and_clear_bit(Cy_EVENT_WRITE_WAKEUP, &info->event)) {
-        tty_wakeup(tty);
-        wake_up_interruptible(&tty->write_wait);
-    }
+	if (test_and_clear_bit(Cy_EVENT_Z_RX_FULL, &info->event)) {
+		if (cyz_rx_full_timer[info->line].function == NULL) {
+			cyz_rx_full_timer[info->line].expires = jiffies + 1;
+			cyz_rx_full_timer[info->line].function = cyz_rx_restart;
+			cyz_rx_full_timer[info->line].data =
+						(unsigned long)info;
+			add_timer(&cyz_rx_full_timer[info->line]);
+		}
+	}
+#endif
+	if (test_and_clear_bit(Cy_EVENT_DELTA_WAKEUP, &info->event))
+		wake_up_interruptible(&info->delta_msr_wait);
+	tty_wakeup(tty);
 #ifdef Z_WAKE
-    if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event)) {
-        wake_up_interruptible(&info->shutdown_wait);
-    }
+	if (test_and_clear_bit(Cy_EVENT_SHUTDOWN_WAKEUP, &info->event))
+		wake_up_interruptible(&info->shutdown_wait);
 #endif
 } /* do_softint */
 
@@ -979,82 +977,81 @@ do_softint(struct work_struct *work)
 
    This function is only called from inside spinlock-protected code.
  */
-static int
-cyy_issue_cmd(void __iomem *base_addr, u_char cmd, int index)
+static int cyy_issue_cmd(void __iomem * base_addr, u_char cmd, int index)
 {
-  volatile int  i;
+	volatile int i;
 
-    /* Check to see that the previous command has completed */
-    for(i = 0 ; i < 100 ; i++){
-	if (cy_readb(base_addr+(CyCCR<<index)) == 0){
-	    break;
-	}
-	udelay(10L);
-    }
-    /* if the CCR never cleared, the previous command
-       didn't finish within the "reasonable time" */
-    if (i == 100)	return (-1);
+	/* Check to see that the previous command has completed */
+	for (i = 0; i < 100; i++) {
+		if (cy_readb(base_addr + (CyCCR << index)) == 0) {
+			break;
+		}
+		udelay(10L);
+	}
+	/* if the CCR never cleared, the previous command
+	   didn't finish within the "reasonable time" */
+	if (i == 100)
+		return (-1);
 
-    /* Issue the new command */
-    cy_writeb(base_addr+(CyCCR<<index), cmd);
+	/* Issue the new command */
+	cy_writeb(base_addr + (CyCCR << index), cmd);
 
-    return(0);
-} /* cyy_issue_cmd */
+	return (0);
+}				/* cyy_issue_cmd */
 
 #ifdef CONFIG_ISA
 /* ISA interrupt detection code */
-static unsigned 
-detect_isa_irq(void __iomem *address)
+static unsigned detect_isa_irq(void __iomem * address)
 {
-  int irq;
-  unsigned long irqs, flags;
-  int save_xir, save_car;
-  int index = 0; /* IRQ probing is only for ISA */
-
-    /* forget possible initially masked and pending IRQ */
-    irq = probe_irq_off(probe_irq_on());
-
-    /* Clear interrupts on the board first */
-    cy_writeb(address + (Cy_ClrIntr<<index), 0);
-			      /* Cy_ClrIntr is 0x1800 */
-
-    irqs = probe_irq_on();
-    /* Wait ... */
-    udelay(5000L);
-
-    /* Enable the Tx interrupts on the CD1400 */
-    local_irq_save(flags);
-	cy_writeb(address + (CyCAR<<index), 0);
-	cyy_issue_cmd(address, CyCHAN_CTL|CyENB_XMTR, index);
-
-	cy_writeb(address + (CyCAR<<index), 0);
-	cy_writeb(address + (CySRER<<index), 
-		cy_readb(address + (CySRER<<index)) | CyTxRdy);
-    local_irq_restore(flags);
-
-    /* Wait ... */
-    udelay(5000L);
-
-    /* Check which interrupt is in use */
-    irq = probe_irq_off(irqs);
-
-    /* Clean up */
-    save_xir = (u_char) cy_readb(address + (CyTIR<<index));
-    save_car = cy_readb(address + (CyCAR<<index));
-    cy_writeb(address + (CyCAR<<index), (save_xir & 0x3));
-    cy_writeb(address + (CySRER<<index),
-	cy_readb(address + (CySRER<<index)) & ~CyTxRdy);
-    cy_writeb(address + (CyTIR<<index), (save_xir & 0x3f));
-    cy_writeb(address + (CyCAR<<index), (save_car));
-    cy_writeb(address + (Cy_ClrIntr<<index), 0);
-			      /* Cy_ClrIntr is 0x1800 */
+	int irq;
+	unsigned long irqs, flags;
+	int save_xir, save_car;
+	int index = 0;		/* IRQ probing is only for ISA */
+
+	/* forget possible initially masked and pending IRQ */
+	irq = probe_irq_off(probe_irq_on());
+
+	/* Clear interrupts on the board first */
+	cy_writeb(address + (Cy_ClrIntr << index), 0);
+	/* Cy_ClrIntr is 0x1800 */
+
+	irqs = probe_irq_on();
+	/* Wait ... */
+	udelay(5000L);
+
+	/* Enable the Tx interrupts on the CD1400 */
+	local_irq_save(flags);
+	cy_writeb(address + (CyCAR << index), 0);
+	cyy_issue_cmd(address, CyCHAN_CTL | CyENB_XMTR, index);
+
+	cy_writeb(address + (CyCAR << index), 0);
+	cy_writeb(address + (CySRER << index),
+		  cy_readb(address + (CySRER << index)) | CyTxRdy);
+	local_irq_restore(flags);
+
+	/* Wait ... */
+	udelay(5000L);
+
+	/* Check which interrupt is in use */
+	irq = probe_irq_off(irqs);
+
+	/* Clean up */
+	save_xir = (u_char) cy_readb(address + (CyTIR << index));
+	save_car = cy_readb(address + (CyCAR << index));
+	cy_writeb(address + (CyCAR << index), (save_xir & 0x3));
+	cy_writeb(address + (CySRER << index),
+		  cy_readb(address + (CySRER << index)) & ~CyTxRdy);
+	cy_writeb(address + (CyTIR << index), (save_xir & 0x3f));
+	cy_writeb(address + (CyCAR << index), (save_car));
+	cy_writeb(address + (Cy_ClrIntr << index), 0);
+	/* Cy_ClrIntr is 0x1800 */
 
-    return (irq > 0)? irq : 0;
+	return (irq > 0) ? irq : 0;
 }
-#endif /* CONFIG_ISA */
+#endif				/* CONFIG_ISA */
 
 static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
-		void __iomem *base_addr, int status, int index)
+			void __iomem * base_addr, int status, int index)
 {
 	struct cyclades_port *info;
 	struct tty_struct *tty;
@@ -1063,328 +1060,378 @@ static void cyy_intr_chip(struct cyclade
 	int save_xir, channel, save_car;
 	char data;
 
-	if (status & CySRReceive) { /* reception interrupt */
+	if (status & CySRReceive) {	/* reception interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-	    printk("cyy_interrupt: rcvd intr, chip %d\n\r", chip);
+		printk("cyy_interrupt: rcvd intr, chip %d\n\r", chip);
 #endif
-	    /* determine the channel & change to that context */
-	    spin_lock(&cinfo->card_lock);
-	    save_xir = (u_char) cy_readb(base_addr+(CyRIR<<index));
-	    channel = (u_short ) (save_xir & CyIRChannel);
-	    i = channel + chip * 4 + cinfo->first_line;
-	    info = &cy_port[i];
-	    info->last_active = jiffies;
-	    save_car = cy_readb(base_addr+(CyCAR<<index));
-	    cy_writeb(base_addr+(CyCAR<<index), save_xir);
-
-	    /* if there is nowhere to put the data, discard it */
-	    if(info->tty == 0){
-		j = (cy_readb(base_addr+(CyRIVR<<index)) & CyIVRMask);
-		if ( j == CyIVRRxEx ) { /* exception */
-		    data = cy_readb(base_addr+(CyRDSR<<index));
-		} else { /* normal character reception */
-		    char_count = cy_readb(base_addr+(CyRDCR<<index));
-		    while(char_count--){
-			data = cy_readb(base_addr+(CyRDSR<<index));
-		    }
-		}
-	    }else{ /* there is an open port for this data */
-		tty = info->tty;
-		j = (cy_readb(base_addr+(CyRIVR<<index)) & CyIVRMask);
-		if ( j == CyIVRRxEx ) { /* exception */
-		    data = cy_readb(base_addr+(CyRDSR<<index));
-
-		    /* For statistics only */
-		    if (data & CyBREAK)
-			info->icount.brk++;
-		    else if(data & CyFRAME)
-			info->icount.frame++;
-		    else if(data & CyPARITY)
-			info->icount.parity++;
-		    else if(data & CyOVERRUN)
-			info->icount.overrun++;
-
-		    if(data & info->ignore_status_mask){
-			info->icount.rx++;
-			return;
-		    }
-		    if (tty_buffer_request_room(tty, 1)) {
-			if (data & info->read_status_mask){
-			    if(data & CyBREAK){
-				tty_insert_flip_char(tty, cy_readb(base_addr+(CyRDSR<<index)), TTY_BREAK);
-				info->icount.rx++;
-				if (info->flags & ASYNC_SAK){
-				    do_SAK(tty);
+		/* determine the channel & change to that context */
+		spin_lock(&cinfo->card_lock);
+		save_xir = (u_char) cy_readb(base_addr + (CyRIR << index));
+		channel = (u_short) (save_xir & CyIRChannel);
+		i = channel + chip * 4 + cinfo->first_line;
+		info = &cy_port[i];
+		info->last_active = jiffies;
+		save_car = cy_readb(base_addr + (CyCAR << index));
+		cy_writeb(base_addr + (CyCAR << index), save_xir);
+
+		/* if there is nowhere to put the data, discard it */
+		if (info->tty == 0) {
+			j = (cy_readb(base_addr + (CyRIVR << index)) &
+				CyIVRMask);
+			if (j == CyIVRRxEx) {	/* exception */
+				data = cy_readb(base_addr + (CyRDSR << index));
+			} else {	/* normal character reception */
+				char_count = cy_readb(base_addr +
+						(CyRDCR << index));
+				while (char_count--) {
+					data = cy_readb(base_addr +
+						(CyRDSR << index));
 				}
-			    }else if(data & CyFRAME){
-				tty_insert_flip_char(tty, cy_readb(base_addr+(CyRDSR<<index)), TTY_FRAME);
-				info->icount.rx++;
-				info->idle_stats.frame_errs++;
-			    }else if(data & CyPARITY){
-				/* Pieces of seven... */
-				tty_insert_flip_char(tty, cy_readb(base_addr+(CyRDSR<<index)), TTY_PARITY);
-				info->icount.rx++;
-				info->idle_stats.parity_errs++;
-			    }else if(data & CyOVERRUN){
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-				info->icount.rx++;
-				/* If the flip buffer itself is
-				   overflowing, we still lose
-				   the next incoming character.
-				 */
-				tty_insert_flip_char(tty, cy_readb(base_addr+(CyRDSR<<index)), TTY_FRAME);
-				info->icount.rx++;
-				info->idle_stats.overruns++;
-			    /* These two conditions may imply */
-			    /* a normal read should be done. */
-			    /* }else if(data & CyTIMEOUT){ */
-			    /* }else if(data & CySPECHAR){ */
-			    }else {
-				tty_insert_flip_char(tty, 0, TTY_NORMAL);
-				info->icount.rx++;
-			    }
-			}else{
-			    tty_insert_flip_char(tty, 0, TTY_NORMAL);
-			    info->icount.rx++;
-			}
-		    }else{
-			/* there was a software buffer
-			   overrun and nothing could be
-			   done about it!!! */
-			info->icount.buf_overrun++;
-			info->idle_stats.overruns++;
-		    }
-		} else { /* normal character reception */
-		    /* load # chars available from the chip */
-		    char_count = cy_readb(base_addr+(CyRDCR<<index));
+			}
+		} else {	/* there is an open port for this data */
+			tty = info->tty;
+			j = (cy_readb(base_addr + (CyRIVR << index)) &
+					CyIVRMask);
+			if (j == CyIVRRxEx) {	/* exception */
+				data = cy_readb(base_addr + (CyRDSR << index));
+
+				/* For statistics only */
+				if (data & CyBREAK)
+					info->icount.brk++;
+				else if (data & CyFRAME)
+					info->icount.frame++;
+				else if (data & CyPARITY)
+					info->icount.parity++;
+				else if (data & CyOVERRUN)
+					info->icount.overrun++;
+
+				if (data & info->ignore_status_mask) {
+					info->icount.rx++;
+					return;
+				}
+				if (tty_buffer_request_room(tty, 1)) {
+					if (data & info->read_status_mask) {
+						if (data & CyBREAK) {
+							tty_insert_flip_char(
+								tty,
+								cy_readb(
+								base_addr +
+								(CyRDSR <<
+									index)),
+								TTY_BREAK);
+							info->icount.rx++;
+							if (info->flags &
+							    ASYNC_SAK) {
+								do_SAK(tty);
+							}
+						} else if (data & CyFRAME) {
+							tty_insert_flip_char(
+								tty,
+								cy_readb(
+								base_addr +
+								(CyRDSR <<
+									index)),
+								TTY_FRAME);
+							info->icount.rx++;
+							info->idle_stats.
+								frame_errs++;
+						} else if (data & CyPARITY) {
+							/* Pieces of seven... */
+							tty_insert_flip_char(
+								tty,
+								cy_readb(
+								base_addr +
+								(CyRDSR <<
+									index)),
+								TTY_PARITY);
+							info->icount.rx++;
+							info->idle_stats.
+								parity_errs++;
+						} else if (data & CyOVERRUN) {
+							tty_insert_flip_char(
+								tty, 0,
+								TTY_OVERRUN);
+							info->icount.rx++;
+						/* If the flip buffer itself is
+						   overflowing, we still lose
+						   the next incoming character.
+						 */
+							tty_insert_flip_char(
+								tty,
+								cy_readb(
+								base_addr +
+								(CyRDSR <<
+									index)),
+								TTY_FRAME);
+							info->icount.rx++;
+							info->idle_stats.
+								overruns++;
+					/* These two conditions may imply */
+					/* a normal read should be done. */
+					/* }else if(data & CyTIMEOUT){ */
+					/* }else if(data & CySPECHAR){ */
+						} else {
+							tty_insert_flip_char(
+								tty, 0,
+								TTY_NORMAL);
+							info->icount.rx++;
+						}
+					} else {
+						tty_insert_flip_char(tty, 0,
+								TTY_NORMAL);
+						info->icount.rx++;
+					}
+				} else {
+					/* there was a software buffer
+					   overrun and nothing could be
+					   done about it!!! */
+					info->icount.buf_overrun++;
+					info->idle_stats.overruns++;
+				}
+			} else {	/* normal character reception */
+				/* load # chars available from the chip */
+				char_count = cy_readb(base_addr +
+						(CyRDCR << index));
 
 #ifdef CY_ENABLE_MONITORING
-		    ++info->mon.int_count;
-		    info->mon.char_count += char_count;
-		    if (char_count > info->mon.char_max)
-		       info->mon.char_max = char_count;
-		    info->mon.char_last = char_count;
-#endif
-		    len = tty_buffer_request_room(tty, char_count);
-		    while(len--){
-			data = cy_readb(base_addr+(CyRDSR<<index));
-			tty_insert_flip_char(tty, data, TTY_NORMAL);
-			info->idle_stats.recv_bytes++;
-			info->icount.rx++;
+				++info->mon.int_count;
+				info->mon.char_count += char_count;
+				if (char_count > info->mon.char_max)
+					info->mon.char_max = char_count;
+				info->mon.char_last = char_count;
+#endif
+				len = tty_buffer_request_room(tty, char_count);
+				while (len--) {
+					data = cy_readb(base_addr +
+							(CyRDSR << index));
+					tty_insert_flip_char(tty, data,
+							TTY_NORMAL);
+					info->idle_stats.recv_bytes++;
+					info->icount.rx++;
 #ifdef CY_16Y_HACK
-			udelay(10L);
+					udelay(10L);
 #endif
-		    }
-		     info->idle_stats.recv_idle = jiffies;
+				}
+				info->idle_stats.recv_idle = jiffies;
+			}
+			tty_schedule_flip(tty);
 		}
-		tty_schedule_flip(tty);
-	    }
-	    /* end of service */
-	    cy_writeb(base_addr+(CyRIR<<index), (save_xir & 0x3f));
-	    cy_writeb(base_addr+(CyCAR<<index), (save_car));
-	    spin_unlock(&cinfo->card_lock);
+		/* end of service */
+		cy_writeb(base_addr + (CyRIR << index), (save_xir & 0x3f));
+		cy_writeb(base_addr + (CyCAR << index), (save_car));
+		spin_unlock(&cinfo->card_lock);
 	}
 
-
-	if (status & CySRTransmit) { /* transmission interrupt */
-	    /* Since we only get here when the transmit buffer
-	       is empty, we know we can always stuff a dozen
-	       characters. */
+	if (status & CySRTransmit) {	/* transmission interrupt */
+		/* Since we only get here when the transmit buffer
+		   is empty, we know we can always stuff a dozen
+		   characters. */
 #ifdef CY_DEBUG_INTERRUPTS
-	    printk("cyy_interrupt: xmit intr, chip %d\n\r", chip);
+		printk("cyy_interrupt: xmit intr, chip %d\n\r", chip);
 #endif
 
-	    /* determine the channel & change to that context */
-	    spin_lock(&cinfo->card_lock);
-	    save_xir = (u_char) cy_readb(base_addr+(CyTIR<<index));
-	    channel = (u_short ) (save_xir & CyIRChannel);
-	    i = channel + chip * 4 + cinfo->first_line;
-	    save_car = cy_readb(base_addr+(CyCAR<<index));
-	    cy_writeb(base_addr+(CyCAR<<index), save_xir);
-
-	    /* validate the port# (as configured and open) */
-	    if( (i < 0) || (NR_PORTS <= i) ){
-		cy_writeb(base_addr+(CySRER<<index),
-		     cy_readb(base_addr+(CySRER<<index)) & ~CyTxRdy);
-		goto txend;
-	    }
-	    info = &cy_port[i];
-	    info->last_active = jiffies;
-	    if(info->tty == 0){
-		cy_writeb(base_addr+(CySRER<<index),
-		     cy_readb(base_addr+(CySRER<<index)) & ~CyTxRdy);
-		goto txdone;
-	    }
-
-	    /* load the on-chip space for outbound data */
-	    char_count = info->xmit_fifo_size;
-
-	    if(info->x_char) { /* send special char */
-		outch = info->x_char;
-		cy_writeb(base_addr+(CyTDR<<index), outch);
-		char_count--;
-		info->icount.tx++;
-		info->x_char = 0;
-	    }
-
-	    if (info->breakon || info->breakoff) {
-		if (info->breakon) {
-		    cy_writeb(base_addr + (CyTDR<<index), 0);
-		    cy_writeb(base_addr + (CyTDR<<index), 0x81);
-		    info->breakon = 0;
-		    char_count -= 2;
-		}
-		if (info->breakoff) {
-		    cy_writeb(base_addr + (CyTDR<<index), 0);
-		    cy_writeb(base_addr + (CyTDR<<index), 0x83);
-		    info->breakoff = 0;
-		    char_count -= 2;
-		}
-	    }
-
-	    while (char_count-- > 0){
-		if (!info->xmit_cnt){
-		    if (cy_readb(base_addr+(CySRER<<index))&CyTxMpty) {
-			cy_writeb(base_addr+(CySRER<<index),
-				  cy_readb(base_addr+(CySRER<<index)) &
-				  ~CyTxMpty);
-		    } else {
-			cy_writeb(base_addr+(CySRER<<index),
-				  ((cy_readb(base_addr+(CySRER<<index))
-				    & ~CyTxRdy)
-				   | CyTxMpty));
-		    }
-		    goto txdone;
-		}
-		if (info->xmit_buf == 0){
-		    cy_writeb(base_addr+(CySRER<<index),
-			cy_readb(base_addr+(CySRER<<index)) &
-				~CyTxRdy);
-		    goto txdone;
-		}
-		if (info->tty->stopped || info->tty->hw_stopped){
-		    cy_writeb(base_addr+(CySRER<<index),
-			cy_readb(base_addr+(CySRER<<index)) &
-				~CyTxRdy);
-		    goto txdone;
-		}
-		/* Because the Embedded Transmit Commands have
-		   been enabled, we must check to see if the
-		   escape character, NULL, is being sent.  If it
-		   is, we must ensure that there is room for it
-		   to be doubled in the output stream.  Therefore
-		   we no longer advance the pointer when the
-		   character is fetched, but rather wait until
-		   after the check for a NULL output character.
-		   This is necessary because there may not be
-		   room for the two chars needed to send a NULL.)
-		 */
-		outch = info->xmit_buf[info->xmit_tail];
-		if( outch ){
-		    info->xmit_cnt--;
-		    info->xmit_tail = (info->xmit_tail + 1)
-					      & (SERIAL_XMIT_SIZE - 1);
-		    cy_writeb(base_addr+(CyTDR<<index), outch);
-		    info->icount.tx++;
-		}else{
-		    if(char_count > 1){
-			info->xmit_cnt--;
-			info->xmit_tail = (info->xmit_tail + 1)
-					      & (SERIAL_XMIT_SIZE - 1);
-			cy_writeb(base_addr+(CyTDR<<index),
-				  outch);
-			cy_writeb(base_addr+(CyTDR<<index), 0);
-			info->icount.tx++;
+		/* determine the channel & change to that context */
+		spin_lock(&cinfo->card_lock);
+		save_xir = (u_char) cy_readb(base_addr + (CyTIR << index));
+		channel = (u_short) (save_xir & CyIRChannel);
+		i = channel + chip * 4 + cinfo->first_line;
+		save_car = cy_readb(base_addr + (CyCAR << index));
+		cy_writeb(base_addr + (CyCAR << index), save_xir);
+
+		/* validate the port# (as configured and open) */
+		if ((i < 0) || (NR_PORTS <= i)) {
+			cy_writeb(base_addr + (CySRER << index),
+				  cy_readb(base_addr + (CySRER << index)) &
+				  ~CyTxRdy);
+			goto txend;
+		}
+		info = &cy_port[i];
+		info->last_active = jiffies;
+		if (info->tty == 0) {
+			cy_writeb(base_addr + (CySRER << index),
+				  cy_readb(base_addr + (CySRER << index)) &
+				  ~CyTxRdy);
+			goto txdone;
+		}
+
+		/* load the on-chip space for outbound data */
+		char_count = info->xmit_fifo_size;
+
+		if (info->x_char) {	/* send special char */
+			outch = info->x_char;
+			cy_writeb(base_addr + (CyTDR << index), outch);
 			char_count--;
-		    }else{
-		    }
+			info->icount.tx++;
+			info->x_char = 0;
+		}
+
+		if (info->breakon || info->breakoff) {
+			if (info->breakon) {
+				cy_writeb(base_addr + (CyTDR << index), 0);
+				cy_writeb(base_addr + (CyTDR << index), 0x81);
+				info->breakon = 0;
+				char_count -= 2;
+			}
+			if (info->breakoff) {
+				cy_writeb(base_addr + (CyTDR << index), 0);
+				cy_writeb(base_addr + (CyTDR << index), 0x83);
+				info->breakoff = 0;
+				char_count -= 2;
+			}
+		}
+
+		while (char_count-- > 0) {
+			if (!info->xmit_cnt) {
+				if (cy_readb(base_addr + (CySRER << index)) &
+						CyTxMpty) {
+					cy_writeb(base_addr + (CySRER << index),
+						cy_readb(base_addr +
+							(CySRER << index)) &
+						~CyTxMpty);
+				} else {
+					cy_writeb(base_addr + (CySRER << index),
+						(cy_readb(base_addr +
+						  	(CySRER << index)) &
+						~CyTxRdy) | CyTxMpty);
+				}
+				goto txdone;
+			}
+			if (info->xmit_buf == 0) {
+				cy_writeb(base_addr + (CySRER << index),
+					cy_readb(base_addr + (CySRER << index))&
+					~CyTxRdy);
+				goto txdone;
+			}
+			if (info->tty->stopped || info->tty->hw_stopped) {
+				cy_writeb(base_addr + (CySRER << index),
+					cy_readb(base_addr + (CySRER << index))&
+					~CyTxRdy);
+				goto txdone;
+			}
+			/* Because the Embedded Transmit Commands have
+			   been enabled, we must check to see if the
+			   escape character, NULL, is being sent.  If it
+			   is, we must ensure that there is room for it
+			   to be doubled in the output stream.  Therefore
+			   we no longer advance the pointer when the
+			   character is fetched, but rather wait until
+			   after the check for a NULL output character.
+			   This is necessary because there may not be
+			   room for the two chars needed to send a NULL.)
+			 */
+			outch = info->xmit_buf[info->xmit_tail];
+			if (outch) {
+				info->xmit_cnt--;
+				info->xmit_tail = (info->xmit_tail + 1) &
+						(SERIAL_XMIT_SIZE - 1);
+				cy_writeb(base_addr + (CyTDR << index), outch);
+				info->icount.tx++;
+			} else {
+				if (char_count > 1) {
+					info->xmit_cnt--;
+					info->xmit_tail = (info->xmit_tail + 1)&
+						(SERIAL_XMIT_SIZE - 1);
+					cy_writeb(base_addr + (CyTDR << index),
+						outch);
+					cy_writeb(base_addr + (CyTDR << index),
+						0);
+					info->icount.tx++;
+					char_count--;
+				} else {
+				}
+			}
 		}
-	    }
 
 txdone:
-	    if (info->xmit_cnt < WAKEUP_CHARS) {
-		cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-	    }
+		if (info->xmit_cnt < WAKEUP_CHARS) {
+			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
+		}
 txend:
-	    /* end of service */
-	    cy_writeb(base_addr+(CyTIR<<index),
-		      (save_xir & 0x3f));
-	    cy_writeb(base_addr+(CyCAR<<index), (save_car));
-	    spin_unlock(&cinfo->card_lock);
-	}
-
-	if (status & CySRModem) {        /* modem interrupt */
-
-	    /* determine the channel & change to that context */
-	    spin_lock(&cinfo->card_lock);
-	    save_xir = (u_char) cy_readb(base_addr+(CyMIR<<index));
-	    channel = (u_short ) (save_xir & CyIRChannel);
-	    info = &cy_port[channel + chip * 4
-				   + cinfo->first_line];
-	    info->last_active = jiffies;
-	    save_car = cy_readb(base_addr+(CyCAR<<index));
-	    cy_writeb(base_addr+(CyCAR<<index), save_xir);
-
-	    mdm_change = cy_readb(base_addr+(CyMISR<<index));
-	    mdm_status = cy_readb(base_addr+(CyMSVR1<<index));
-
-	    if(info->tty == 0){/* no place for data, ignore it*/
-		;
-	    }else{
-		if (mdm_change & CyANY_DELTA) {
-		    /* For statistics only */
-		    if (mdm_change & CyDCD)	info->icount.dcd++;
-		    if (mdm_change & CyCTS)	info->icount.cts++;
-		    if (mdm_change & CyDSR)	info->icount.dsr++;
-		    if (mdm_change & CyRI)	info->icount.rng++;
-
-		    cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
-		}
-
-		if((mdm_change & CyDCD)
-		&& (info->flags & ASYNC_CHECK_CD)){
-		    if(mdm_status & CyDCD){
-			cy_sched_event(info,
-			    Cy_EVENT_OPEN_WAKEUP);
-		    }else{
-			cy_sched_event(info,
-			    Cy_EVENT_HANGUP);
-		    }
-		}
-		if((mdm_change & CyCTS)
-		&& (info->flags & ASYNC_CTS_FLOW)){
-		    if(info->tty->hw_stopped){
-			if(mdm_status & CyCTS){
-			    /* cy_start isn't used
-				 because... !!! */
-			    info->tty->hw_stopped = 0;
-			  cy_writeb(base_addr+(CySRER<<index),
-			       cy_readb(base_addr+(CySRER<<index)) |
-			       CyTxRdy);
-			    cy_sched_event(info,
-				Cy_EVENT_WRITE_WAKEUP);
-			}
-		    }else{
-			if(!(mdm_status & CyCTS)){
-			    /* cy_stop isn't used
-				 because ... !!! */
-			    info->tty->hw_stopped = 1;
-			  cy_writeb(base_addr+(CySRER<<index),
-			       cy_readb(base_addr+(CySRER<<index)) &
-			       ~CyTxRdy);
-			}
-		    }
-		}
-		if(mdm_change & CyDSR){
-		}
-		if(mdm_change & CyRI){
-		}
-	    }
-	    /* end of service */
-	    cy_writeb(base_addr+(CyMIR<<index),
-		      (save_xir & 0x3f));
-	    cy_writeb(base_addr+(CyCAR<<index), save_car);
-	    spin_unlock(&cinfo->card_lock);
+		/* end of service */
+		cy_writeb(base_addr + (CyTIR << index), (save_xir & 0x3f));
+		cy_writeb(base_addr + (CyCAR << index), (save_car));
+		spin_unlock(&cinfo->card_lock);
+	}
+
+	if (status & CySRModem) {	/* modem interrupt */
+
+		/* determine the channel & change to that context */
+		spin_lock(&cinfo->card_lock);
+		save_xir = (u_char) cy_readb(base_addr + (CyMIR << index));
+		channel = (u_short) (save_xir & CyIRChannel);
+		info = &cy_port[channel + chip * 4 + cinfo->first_line];
+		info->last_active = jiffies;
+		save_car = cy_readb(base_addr + (CyCAR << index));
+		cy_writeb(base_addr + (CyCAR << index), save_xir);
+
+		mdm_change = cy_readb(base_addr + (CyMISR << index));
+		mdm_status = cy_readb(base_addr + (CyMSVR1 << index));
+
+		if (info->tty == 0) {	/* no place for data, ignore it */
+			;
+		} else {
+			if (mdm_change & CyANY_DELTA) {
+				/* For statistics only */
+				if (mdm_change & CyDCD)
+					info->icount.dcd++;
+				if (mdm_change & CyCTS)
+					info->icount.cts++;
+				if (mdm_change & CyDSR)
+					info->icount.dsr++;
+				if (mdm_change & CyRI)
+					info->icount.rng++;
+
+				cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
+			}
+
+			if ((mdm_change & CyDCD) &&
+					(info->flags & ASYNC_CHECK_CD)) {
+				if (mdm_status & CyDCD) {
+					cy_sched_event(info,
+							Cy_EVENT_OPEN_WAKEUP);
+				} else {
+					cy_sched_event(info, Cy_EVENT_HANGUP);
+				}
+			}
+			if ((mdm_change & CyCTS) &&
+					(info->flags & ASYNC_CTS_FLOW)) {
+				if (info->tty->hw_stopped) {
+					if (mdm_status & CyCTS) {
+						/* cy_start isn't used
+						   because... !!! */
+						info->tty->hw_stopped = 0;
+						cy_writeb(base_addr +
+							(CySRER << index),
+							cy_readb(base_addr +
+								(CySRER <<
+									index))|
+							CyTxRdy);
+						cy_sched_event(info,
+							Cy_EVENT_WRITE_WAKEUP);
+					}
+				} else {
+					if (!(mdm_status & CyCTS)) {
+						/* cy_stop isn't used
+						   because ... !!! */
+						info->tty->hw_stopped = 1;
+						cy_writeb(base_addr +
+							(CySRER << index),
+							cy_readb(base_addr +
+								(CySRER <<
+								index)) &
+							~CyTxRdy);
+					}
+				}
+			}
+			if (mdm_change & CyDSR) {
+			}
+			if (mdm_change & CyRI) {
+			}
+		}
+		/* end of service */
+		cy_writeb(base_addr + (CyMIR << index), (save_xir & 0x3f));
+		cy_writeb(base_addr + (CyCAR << index), save_car);
+		spin_unlock(&cinfo->card_lock);
 	}
 }
 
@@ -1392,60 +1439,61 @@ txend:
    whenever the card wants its hand held--chars
    received, out buffer empty, modem change, etc.
  */
-static irqreturn_t
-cyy_interrupt(int irq, void *dev_id)
+static irqreturn_t cyy_interrupt(int irq, void *dev_id)
 {
-  int status;
-  struct cyclades_card *cinfo;
-  void __iomem *base_addr, *card_base_addr;
-  int chip;
-  int index;
-  int too_many;
-  int had_work;
+	int status;
+	struct cyclades_card *cinfo;
+	void __iomem *base_addr, *card_base_addr;
+	int chip;
+	int index;
+	int too_many;
+	int had_work;
 
-    if((cinfo = (struct cyclades_card *)dev_id) == 0){
+	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
 #ifdef CY_DEBUG_INTERRUPTS
-	printk("cyy_interrupt: spurious interrupt %d\n\r", irq);
+		printk("cyy_interrupt: spurious interrupt %d\n\r", irq);
 #endif
-        return IRQ_NONE; /* spurious interrupt */
-    }
+		return IRQ_NONE;	/* spurious interrupt */
+	}
 
-    card_base_addr = cinfo->base_addr;
-    index = cinfo->bus_index;
+	card_base_addr = cinfo->base_addr;
+	index = cinfo->bus_index;
 
+	/* This loop checks all chips in the card.  Make a note whenever
+	   _any_ chip had some work to do, as this is considered an
+	   indication that there will be more to do.  Only when no chip
+	   has any work does this outermost loop exit.
+	 */
+	do {
+		had_work = 0;
+		for (chip = 0; chip < cinfo->num_chips; chip++) {
+			base_addr = cinfo->base_addr +
+					(cy_chip_offset[chip] << index);
+			too_many = 0;
+			while ((status = cy_readb(base_addr +
+						(CySVRR << index))) != 0x00) {
+				had_work++;
+			/* The purpose of the following test is to ensure that
+			   no chip can monopolize the driver.  This forces the
+			   chips to be checked in a round-robin fashion (after
+			   draining each of a bunch (1000) of characters).
+			 */
+				if (1000 < too_many++) {
+					break;
+				}
+				cyy_intr_chip(cinfo, chip, base_addr, status,
+						index);
+			}
+		}
+	} while (had_work);
 
-    /* This loop checks all chips in the card.  Make a note whenever
-       _any_ chip had some work to do, as this is considered an
-       indication that there will be more to do.  Only when no chip
-       has any work does this outermost loop exit.
-     */
-    do{
-        had_work = 0;
-        for ( chip = 0 ; chip < cinfo->num_chips ; chip ++) {
-            base_addr = cinfo->base_addr + (cy_chip_offset[chip]<<index);
-            too_many = 0;
-            while ( (status = cy_readb(base_addr+(CySVRR<<index))) != 0x00) {
-                had_work++;
-                /* The purpose of the following test is to ensure that
-                   no chip can monopolize the driver.  This forces the
-                   chips to be checked in a round-robin fashion (after
-                   draining each of a bunch (1000) of characters).
-                 */
-                if(1000<too_many++){
-                    break;
-                }
-		cyy_intr_chip(cinfo, chip, base_addr, status, index);
-            }
-        }
-    } while(had_work);
-
-   /* clear interrupts */
-   spin_lock(&cinfo->card_lock);
-   cy_writeb(card_base_addr + (Cy_ClrIntr<<index), 0);
-                                /* Cy_ClrIntr is 0x1800 */
-   spin_unlock(&cinfo->card_lock);
-   return IRQ_HANDLED;
-} /* cyy_interrupt */
+	/* clear interrupts */
+	spin_lock(&cinfo->card_lock);
+	cy_writeb(card_base_addr + (Cy_ClrIntr << index), 0);
+	/* Cy_ClrIntr is 0x1800 */
+	spin_unlock(&cinfo->card_lock);
+	return IRQ_HANDLED;
+}				/* cyy_interrupt */
 
 /***********************************************************/
 /********* End of block of Cyclom-Y specific code **********/
@@ -1453,643 +1501,656 @@ cyy_interrupt(int irq, void *dev_id)
 /***********************************************************/
 
 static int
-cyz_fetch_msg( struct cyclades_card *cinfo,
-	    uclong *channel, ucchar *cmd, uclong *param)
+cyz_fetch_msg(struct cyclades_card *cinfo,
+		uclong * channel, ucchar * cmd, uclong * param)
 {
-  struct FIRM_ID __iomem *firm_id;
-  struct ZFW_CTRL __iomem *zfw_ctrl;
-  struct BOARD_CTRL __iomem *board_ctrl;
-  unsigned long loc_doorbell;
-
-    firm_id = cinfo->base_addr + ID_ADDRESS;
-    if (!ISZLOADED(*cinfo)){
-	return (-1);
-    }
-    zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-    board_ctrl = &zfw_ctrl->board_ctrl;
-
-    loc_doorbell = cy_readl(&((struct RUNTIME_9060 __iomem *)
-                     (cinfo->ctl_addr))->loc_doorbell);
-    if (loc_doorbell){
-	*cmd = (char)(0xff & loc_doorbell);
-	*channel = cy_readl(&board_ctrl->fwcmd_channel);
-	*param = (uclong)cy_readl(&board_ctrl->fwcmd_param);
-	cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->loc_doorbell, 
-                 0xffffffff);
-	return 1;
-    }
-    return 0;
-} /* cyz_fetch_msg */
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	unsigned long loc_doorbell;
+
+	firm_id = cinfo->base_addr + ID_ADDRESS;
+	if (!ISZLOADED(*cinfo)) {
+		return (-1);
+	}
+	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
+			0xfffff);
+	board_ctrl = &zfw_ctrl->board_ctrl;
+
+	loc_doorbell = cy_readl(&((struct RUNTIME_9060 __iomem *)
+				  (cinfo->ctl_addr))->loc_doorbell);
+	if (loc_doorbell) {
+		*cmd = (char)(0xff & loc_doorbell);
+		*channel = cy_readl(&board_ctrl->fwcmd_channel);
+		*param = (uclong) cy_readl(&board_ctrl->fwcmd_param);
+		cy_writel(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
+			  loc_doorbell, 0xffffffff);
+		return 1;
+	}
+	return 0;
+}				/* cyz_fetch_msg */
 
 static int
-cyz_issue_cmd( struct cyclades_card *cinfo,
-	    uclong channel, ucchar cmd, uclong param)
+cyz_issue_cmd(struct cyclades_card *cinfo,
+		uclong channel, ucchar cmd, uclong param)
 {
-  struct FIRM_ID __iomem *firm_id;
-  struct ZFW_CTRL __iomem *zfw_ctrl;
-  struct BOARD_CTRL __iomem *board_ctrl;
-  unsigned long __iomem *pci_doorbell;
-  int index;
-
-    firm_id = cinfo->base_addr + ID_ADDRESS;
-    if (!ISZLOADED(*cinfo)){
-	return (-1);
-    }
-    zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-    board_ctrl = &zfw_ctrl->board_ctrl;
-
-    index = 0;
-    pci_doorbell = &((struct RUNTIME_9060 __iomem *) (cinfo->ctl_addr))->pci_doorbell;
-    while( (cy_readl(pci_doorbell) & 0xff) != 0){
-        if (index++ == 1000){
-	    return((int)(cy_readl(pci_doorbell) & 0xff));
-        }
-	udelay(50L);
-    }
-    cy_writel(&board_ctrl->hcmd_channel, channel);
-    cy_writel(&board_ctrl->hcmd_param , param);
-    cy_writel(pci_doorbell, (long)cmd);
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	unsigned long __iomem *pci_doorbell;
+	int index;
+
+	firm_id = cinfo->base_addr + ID_ADDRESS;
+	if (!ISZLOADED(*cinfo)) {
+		return (-1);
+	}
+	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
+			0xfffff);
+	board_ctrl = &zfw_ctrl->board_ctrl;
+
+	index = 0;
+	pci_doorbell =
+	    &((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->pci_doorbell;
+	while ((cy_readl(pci_doorbell) & 0xff) != 0) {
+		if (index++ == 1000) {
+			return ((int)(cy_readl(pci_doorbell) & 0xff));
+		}
+		udelay(50L);
+	}
+	cy_writel(&board_ctrl->hcmd_channel, channel);
+	cy_writel(&board_ctrl->hcmd_param, param);
+	cy_writel(pci_doorbell, (long)cmd);
 
-    return(0);
-} /* cyz_issue_cmd */
+	return (0);
+}				/* cyz_issue_cmd */
 
 static void
 cyz_handle_rx(struct cyclades_port *info,
-	      volatile struct CH_CTRL __iomem *ch_ctrl,
-	      volatile struct BUF_CTRL __iomem *buf_ctrl)
+		volatile struct CH_CTRL __iomem * ch_ctrl,
+		volatile struct BUF_CTRL __iomem * buf_ctrl)
 {
-  struct cyclades_card *cinfo = &cy_card[info->card];
-  struct tty_struct *tty = info->tty;
-  volatile int char_count;
-  int len;
+	struct cyclades_card *cinfo = &cy_card[info->card];
+	struct tty_struct *tty = info->tty;
+	volatile int char_count;
+	int len;
 #ifdef BLOCKMOVE
-  int small_count;
+	int small_count;
 #else
-  char data;
+	char data;
 #endif
-  volatile uclong rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+	volatile uclong rx_put, rx_get, new_rx_get, rx_bufsize, rx_bufaddr;
+
+	rx_get = new_rx_get = cy_readl(&buf_ctrl->rx_get);
+	rx_put = cy_readl(&buf_ctrl->rx_put);
+	rx_bufsize = cy_readl(&buf_ctrl->rx_bufsize);
+	rx_bufaddr = cy_readl(&buf_ctrl->rx_bufaddr);
+	if (rx_put >= rx_get)
+		char_count = rx_put - rx_get;
+	else
+		char_count = rx_put - rx_get + rx_bufsize;
 
-    rx_get = new_rx_get = cy_readl(&buf_ctrl->rx_get);
-    rx_put = cy_readl(&buf_ctrl->rx_put);
-    rx_bufsize = cy_readl(&buf_ctrl->rx_bufsize);
-    rx_bufaddr = cy_readl(&buf_ctrl->rx_bufaddr);
-    if (rx_put >= rx_get)
-	char_count = rx_put - rx_get;
-    else
-	char_count = rx_put - rx_get + rx_bufsize;
-
-    if ( char_count ) {
-	info->last_active = jiffies;
-	info->jiffies[1] = jiffies;
+	if (char_count) {
+		info->last_active = jiffies;
+		info->jiffies[1] = jiffies;
 
 #ifdef CY_ENABLE_MONITORING
-	info->mon.int_count++;
-	info->mon.char_count += char_count;
-	if (char_count > info->mon.char_max)
-	    info->mon.char_max = char_count;
-	info->mon.char_last = char_count;
-#endif
-	if(tty == 0){
-	    /* flush received characters */
-	    new_rx_get = (new_rx_get + char_count) & (rx_bufsize - 1);
-	    info->rflush_count++;
-	}else{
+		info->mon.int_count++;
+		info->mon.char_count += char_count;
+		if (char_count > info->mon.char_max)
+			info->mon.char_max = char_count;
+		info->mon.char_last = char_count;
+#endif
+		if (tty == 0) {
+			/* flush received characters */
+			new_rx_get = (new_rx_get + char_count) &
+					(rx_bufsize - 1);
+			info->rflush_count++;
+		} else {
 #ifdef BLOCKMOVE
-	    /* we'd like to use memcpy(t, f, n) and memset(s, c, count)
-	       for performance, but because of buffer boundaries, there
-	       may be several steps to the operation */
-	    while(0 < (small_count = 
-		       min_t(unsigned int, (rx_bufsize - new_rx_get),
-		       min_t(unsigned int, (TTY_FLIPBUF_SIZE - tty->flip.count), char_count))
-		 )) {
-		memcpy_fromio(tty->flip.char_buf_ptr,
-			      (char *)(cinfo->base_addr
-				       + rx_bufaddr + new_rx_get),
-			      small_count);
-
-		tty->flip.char_buf_ptr += small_count;
-		memset(tty->flip.flag_buf_ptr, TTY_NORMAL, small_count);
-		tty->flip.flag_buf_ptr += small_count;
-		new_rx_get = (new_rx_get + small_count) & (rx_bufsize - 1);
-		char_count -= small_count;
-		info->icount.rx += small_count;
-		info->idle_stats.recv_bytes += small_count;
-		tty->flip.count += small_count;
-	    }
+		/* we'd like to use memcpy(t, f, n) and memset(s, c, count)
+		   for performance, but because of buffer boundaries, there
+		   may be several steps to the operation */
+			while (0 < (small_count = min_t(unsigned int,
+					rx_bufsize - new_rx_get,
+					min_t(unsigned int, TTY_FLIPBUF_SIZE -
+						tty->flip.count, char_count)))){
+				memcpy_fromio(tty->flip.char_buf_ptr,
+					(char *)(cinfo->base_addr + rx_bufaddr +
+						new_rx_get),
+					small_count);
+
+				tty->flip.char_buf_ptr += small_count;
+				memset(tty->flip.flag_buf_ptr, TTY_NORMAL,
+					small_count);
+				tty->flip.flag_buf_ptr += small_count;
+				new_rx_get = (new_rx_get + small_count) &
+						(rx_bufsize - 1);
+				char_count -= small_count;
+				info->icount.rx += small_count;
+				info->idle_stats.recv_bytes += small_count;
+				tty->flip.count += small_count;
+			}
 #else
-	    len = tty_buffer_request_room(tty, char_count);
-	    while(len--){
-		data = cy_readb(cinfo->base_addr + rx_bufaddr + new_rx_get);
-		new_rx_get = (new_rx_get + 1) & (rx_bufsize - 1);
-		tty_insert_flip_char(tty, data, TTY_NORMAL);
-		info->idle_stats.recv_bytes++;
-		info->icount.rx++;
-	    }
+			len = tty_buffer_request_room(tty, char_count);
+			while (len--) {
+				data = cy_readb(cinfo->base_addr + rx_bufaddr +
+						new_rx_get);
+				new_rx_get = (new_rx_get + 1)& (rx_bufsize - 1);
+				tty_insert_flip_char(tty, data, TTY_NORMAL);
+				info->idle_stats.recv_bytes++;
+				info->icount.rx++;
+			}
 #endif
 #ifdef CONFIG_CYZ_INTR
-	    /* Recalculate the number of chars in the RX buffer and issue
-	       a cmd in case it's higher than the RX high water mark */
-	    rx_put = cy_readl(&buf_ctrl->rx_put);
-	    if (rx_put >= rx_get)
-		char_count = rx_put - rx_get;
-	    else
-		char_count = rx_put - rx_get + rx_bufsize;
-	    if(char_count >= cy_readl(&buf_ctrl->rx_threshold)) {
-		cy_sched_event(info, Cy_EVENT_Z_RX_FULL);
-	    }
-#endif
-	    info->idle_stats.recv_idle = jiffies;
-	    tty_schedule_flip(tty);
-	}
-	/* Update rx_get */
-	cy_writel(&buf_ctrl->rx_get, new_rx_get);
-    }
+		/* Recalculate the number of chars in the RX buffer and issue
+		   a cmd in case it's higher than the RX high water mark */
+			rx_put = cy_readl(&buf_ctrl->rx_put);
+			if (rx_put >= rx_get)
+				char_count = rx_put - rx_get;
+			else
+				char_count = rx_put - rx_get + rx_bufsize;
+			if (char_count >= cy_readl(&buf_ctrl->rx_threshold)) {
+				cy_sched_event(info, Cy_EVENT_Z_RX_FULL);
+			}
+#endif
+			info->idle_stats.recv_idle = jiffies;
+			tty_schedule_flip(tty);
+		}
+		/* Update rx_get */
+		cy_writel(&buf_ctrl->rx_get, new_rx_get);
+	}
 }
 
 static void
 cyz_handle_tx(struct cyclades_port *info,
-	      volatile struct CH_CTRL __iomem *ch_ctrl,
-	      volatile struct BUF_CTRL __iomem *buf_ctrl)
+		volatile struct CH_CTRL __iomem * ch_ctrl,
+		volatile struct BUF_CTRL __iomem * buf_ctrl)
 {
-  struct cyclades_card *cinfo = &cy_card[info->card];
-  struct tty_struct *tty = info->tty;
-  char data;
-  volatile int char_count;
+	struct cyclades_card *cinfo = &cy_card[info->card];
+	struct tty_struct *tty = info->tty;
+	char data;
+	volatile int char_count;
 #ifdef BLOCKMOVE
-  int small_count;
+	int small_count;
 #endif
-  volatile uclong tx_put, tx_get, tx_bufsize, tx_bufaddr;
+	volatile uclong tx_put, tx_get, tx_bufsize, tx_bufaddr;
 
-    if (info->xmit_cnt <= 0)	/* Nothing to transmit */
-	return;
+	if (info->xmit_cnt <= 0)	/* Nothing to transmit */
+		return;
 
-    tx_get = cy_readl(&buf_ctrl->tx_get);
-    tx_put = cy_readl(&buf_ctrl->tx_put);
-    tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
-    tx_bufaddr = cy_readl(&buf_ctrl->tx_bufaddr);
-    if (tx_put >= tx_get)
-	char_count = tx_get - tx_put - 1 + tx_bufsize;
-    else
-	char_count = tx_get - tx_put - 1;
-
-    if ( char_count ) {
-
-	if( tty == 0 ){
-	    goto ztxdone;
-	}
-
-	if(info->x_char) { /* send special char */
-	    data = info->x_char;
-
-	    cy_writeb((cinfo->base_addr + tx_bufaddr + tx_put), data);
-	    tx_put = (tx_put + 1) & (tx_bufsize - 1);
-	    info->x_char = 0;
-	    char_count--;
-	    info->icount.tx++;
-	    info->last_active = jiffies;
-	    info->jiffies[2] = jiffies;
-	}
+	tx_get = cy_readl(&buf_ctrl->tx_get);
+	tx_put = cy_readl(&buf_ctrl->tx_put);
+	tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
+	tx_bufaddr = cy_readl(&buf_ctrl->tx_bufaddr);
+	if (tx_put >= tx_get)
+		char_count = tx_get - tx_put - 1 + tx_bufsize;
+	else
+		char_count = tx_get - tx_put - 1;
+
+	if (char_count) {
+
+		if (tty == 0) {
+			goto ztxdone;
+		}
+
+		if (info->x_char) {	/* send special char */
+			data = info->x_char;
+
+			cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
+			tx_put = (tx_put + 1) & (tx_bufsize - 1);
+			info->x_char = 0;
+			char_count--;
+			info->icount.tx++;
+			info->last_active = jiffies;
+			info->jiffies[2] = jiffies;
+		}
 #ifdef BLOCKMOVE
-	while(0 < (small_count = 
-		   min_t(unsigned int, (tx_bufsize - tx_put),
-		       min_t(unsigned int, (SERIAL_XMIT_SIZE - info->xmit_tail),
-			   min_t(unsigned int, info->xmit_cnt, char_count))))) {
-
-	    memcpy_toio((char *)(cinfo->base_addr + tx_bufaddr + tx_put),
-			&info->xmit_buf[info->xmit_tail],
-			small_count);
-
-	    tx_put = (tx_put + small_count) & (tx_bufsize - 1);
-	    char_count -= small_count;
-	    info->icount.tx += small_count;
-	    info->xmit_cnt -= small_count;
-	    info->xmit_tail = 
-		(info->xmit_tail + small_count) & (SERIAL_XMIT_SIZE - 1);
-	    info->last_active = jiffies;
-	    info->jiffies[2] = jiffies;
-	}
+		while (0 < (small_count = min_t(unsigned int,
+				tx_bufsize - tx_put, min_t(unsigned int,
+					(SERIAL_XMIT_SIZE - info->xmit_tail),
+					min_t(unsigned int, info->xmit_cnt,
+						char_count))))) {
+
+			memcpy_toio((char *)(cinfo->base_addr + tx_bufaddr +
+					tx_put),
+					&info->xmit_buf[info->xmit_tail],
+					small_count);
+
+			tx_put = (tx_put + small_count) & (tx_bufsize - 1);
+			char_count -= small_count;
+			info->icount.tx += small_count;
+			info->xmit_cnt -= small_count;
+			info->xmit_tail = (info->xmit_tail + small_count) &
+					(SERIAL_XMIT_SIZE - 1);
+			info->last_active = jiffies;
+			info->jiffies[2] = jiffies;
+		}
 #else
-	while (info->xmit_cnt && char_count){
-	    data = info->xmit_buf[info->xmit_tail];
-	    info->xmit_cnt--;
-	    info->xmit_tail = (info->xmit_tail + 1) & (SERIAL_XMIT_SIZE - 1);
-
-	    cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
-	    tx_put = (tx_put + 1) & (tx_bufsize - 1);
-	    char_count--;
-	    info->icount.tx++;
-	    info->last_active = jiffies;
-	    info->jiffies[2] = jiffies;
-	}
-#endif
-    ztxdone:
-	if (info->xmit_cnt < WAKEUP_CHARS) {
-	    cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-	}
-	/* Update tx_put */
-	cy_writel(&buf_ctrl->tx_put, tx_put);
-    }
+		while (info->xmit_cnt && char_count) {
+			data = info->xmit_buf[info->xmit_tail];
+			info->xmit_cnt--;
+			info->xmit_tail = (info->xmit_tail + 1) &
+					(SERIAL_XMIT_SIZE - 1);
+
+			cy_writeb(cinfo->base_addr + tx_bufaddr + tx_put, data);
+			tx_put = (tx_put + 1) & (tx_bufsize - 1);
+			char_count--;
+			info->icount.tx++;
+			info->last_active = jiffies;
+			info->jiffies[2] = jiffies;
+		}
+#endif
+ztxdone:
+		if (info->xmit_cnt < WAKEUP_CHARS) {
+			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
+		}
+		/* Update tx_put */
+		cy_writel(&buf_ctrl->tx_put, tx_put);
+	}
 }
 
-static void
-cyz_handle_cmd(struct cyclades_card *cinfo)
+static void cyz_handle_cmd(struct cyclades_card *cinfo)
 {
-  struct tty_struct *tty;
-  struct cyclades_port *info;
-  static volatile struct FIRM_ID __iomem *firm_id;
-  static volatile struct ZFW_CTRL __iomem *zfw_ctrl;
-  static volatile struct BOARD_CTRL __iomem *board_ctrl;
-  static volatile struct CH_CTRL __iomem *ch_ctrl;
-  static volatile struct BUF_CTRL __iomem *buf_ctrl;
-  uclong channel;
-  ucchar cmd;
-  uclong param;
-  uclong hw_ver, fw_ver;
-  int special_count;
-  int delta_count;
-
-    firm_id = cinfo->base_addr + ID_ADDRESS;
-    zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-    board_ctrl = &zfw_ctrl->board_ctrl;
-    fw_ver = cy_readl(&board_ctrl->fw_version);
-    hw_ver = cy_readl(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->mail_box_0);
-
-
-    while(cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
-	special_count = 0;
-	delta_count = 0;
-	info = &cy_port[channel + cinfo->first_line];
-	if((tty = info->tty) == 0) {
-	    continue;
-	}
-	ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
-	buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
-
-	switch(cmd) {
-	    case C_CM_PR_ERROR:
-		tty_insert_flip_char(tty, 0, TTY_PARITY);
-		info->icount.rx++;
-		special_count++;
-		break;
-	    case C_CM_FR_ERROR:
-		tty_insert_flip_char(tty, 0, TTY_FRAME);
-		info->icount.rx++;
-		special_count++;
-		break;
-	    case C_CM_RXBRK:
-		tty_insert_flip_char(tty, 0, TTY_BREAK);
-		info->icount.rx++;
-		special_count++;
-		break;
-	    case C_CM_MDCD:
-		info->icount.dcd++;
-		delta_count++;
-		if (info->flags & ASYNC_CHECK_CD){
-		    if ((fw_ver > 241 ? 
-			  ((u_long)param) : 
-			  cy_readl(&ch_ctrl->rs_status)) & C_RS_DCD) {
-			cy_sched_event(info, Cy_EVENT_OPEN_WAKEUP);
-		    }else{
-			cy_sched_event(info, Cy_EVENT_HANGUP);
-		    }
+	struct tty_struct *tty;
+	struct cyclades_port *info;
+	static volatile struct FIRM_ID __iomem *firm_id;
+	static volatile struct ZFW_CTRL __iomem *zfw_ctrl;
+	static volatile struct BOARD_CTRL __iomem *board_ctrl;
+	static volatile struct CH_CTRL __iomem *ch_ctrl;
+	static volatile struct BUF_CTRL __iomem *buf_ctrl;
+	uclong channel;
+	ucchar cmd;
+	uclong param;
+	uclong hw_ver, fw_ver;
+	int special_count;
+	int delta_count;
+
+	firm_id = cinfo->base_addr + ID_ADDRESS;
+	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
+			0xfffff);
+	board_ctrl = &zfw_ctrl->board_ctrl;
+	fw_ver = cy_readl(&board_ctrl->fw_version);
+	hw_ver = cy_readl(&((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->
+			mail_box_0);
+
+	while (cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
+		special_count = 0;
+		delta_count = 0;
+		info = &cy_port[channel + cinfo->first_line];
+		if ((tty = info->tty) == 0) {
+			continue;
 		}
-		break;
-	    case C_CM_MCTS:
-		info->icount.cts++;
-		delta_count++;
-		break;
-	    case C_CM_MRI:
-		info->icount.rng++;
-		delta_count++;
-		break;
-	    case C_CM_MDSR:
-		info->icount.dsr++;
-		delta_count++;
-		break;
+		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
+		buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
+
+		switch (cmd) {
+		case C_CM_PR_ERROR:
+			tty_insert_flip_char(tty, 0, TTY_PARITY);
+			info->icount.rx++;
+			special_count++;
+			break;
+		case C_CM_FR_ERROR:
+			tty_insert_flip_char(tty, 0, TTY_FRAME);
+			info->icount.rx++;
+			special_count++;
+			break;
+		case C_CM_RXBRK:
+			tty_insert_flip_char(tty, 0, TTY_BREAK);
+			info->icount.rx++;
+			special_count++;
+			break;
+		case C_CM_MDCD:
+			info->icount.dcd++;
+			delta_count++;
+			if (info->flags & ASYNC_CHECK_CD) {
+				if ((fw_ver > 241 ? ((u_long) param) :
+						cy_readl(&ch_ctrl->rs_status)) &
+						C_RS_DCD) {
+					cy_sched_event(info,
+						 	Cy_EVENT_OPEN_WAKEUP);
+				} else {
+					cy_sched_event(info, Cy_EVENT_HANGUP);
+				}
+			}
+			break;
+		case C_CM_MCTS:
+			info->icount.cts++;
+			delta_count++;
+			break;
+		case C_CM_MRI:
+			info->icount.rng++;
+			delta_count++;
+			break;
+		case C_CM_MDSR:
+			info->icount.dsr++;
+			delta_count++;
+			break;
 #ifdef Z_WAKE
-	    case C_CM_IOCTLW:
-		cy_sched_event(info, Cy_EVENT_SHUTDOWN_WAKEUP);
-		break;
+		case C_CM_IOCTLW:
+			cy_sched_event(info, Cy_EVENT_SHUTDOWN_WAKEUP);
+			break;
 #endif
 #ifdef CONFIG_CYZ_INTR
-	    case C_CM_RXHIWM:
-	    case C_CM_RXNNDT:
-	    case C_CM_INTBACK2:
-		/* Reception Interrupt */
+		case C_CM_RXHIWM:
+		case C_CM_RXNNDT:
+		case C_CM_INTBACK2:
+			/* Reception Interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyz_interrupt: rcvd intr, card %d, port %ld\n\r", 
-			info->card, channel);
+			printk("cyz_interrupt: rcvd intr, card %d, "
+					"port %ld\n\r", info->card, channel);
 #endif
-		cyz_handle_rx(info, ch_ctrl, buf_ctrl);
-		break;
-	    case C_CM_TXBEMPTY:
-	    case C_CM_TXLOWWM:
-	    case C_CM_INTBACK:
-		/* Transmission Interrupt */
+			cyz_handle_rx(info, ch_ctrl, buf_ctrl);
+			break;
+		case C_CM_TXBEMPTY:
+		case C_CM_TXLOWWM:
+		case C_CM_INTBACK:
+			/* Transmission Interrupt */
 #ifdef CY_DEBUG_INTERRUPTS
-		printk("cyz_interrupt: xmit intr, card %d, port %ld\n\r", 
-			info->card, channel);
+			printk("cyz_interrupt: xmit intr, card %d, "
+					"port %ld\n\r", info->card, channel);
 #endif
-		cyz_handle_tx(info, ch_ctrl, buf_ctrl);
-		break;
-#endif /* CONFIG_CYZ_INTR */
-	    case C_CM_FATAL:
-		/* should do something with this !!! */
-		break;
-	    default:
-		break;
+			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
+			break;
+#endif				/* CONFIG_CYZ_INTR */
+		case C_CM_FATAL:
+			/* should do something with this !!! */
+			break;
+		default:
+			break;
+		}
+		if (delta_count)
+			cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
+		if (special_count)
+			tty_schedule_flip(tty);
 	}
-	if(delta_count)
-	    cy_sched_event(info, Cy_EVENT_DELTA_WAKEUP);
-	if(special_count)
-	    tty_schedule_flip(tty);
-    }
 }
 
 #ifdef CONFIG_CYZ_INTR
-static irqreturn_t
-cyz_interrupt(int irq, void *dev_id)
+static irqreturn_t cyz_interrupt(int irq, void *dev_id)
 {
-  struct cyclades_card *cinfo;
+	struct cyclades_card *cinfo;
 
-    if((cinfo = (struct cyclades_card *)dev_id) == 0){
+	if ((cinfo = (struct cyclades_card *)dev_id) == 0) {
 #ifdef CY_DEBUG_INTERRUPTS
-	printk("cyz_interrupt: spurious interrupt %d\n\r", irq);
+		printk("cyz_interrupt: spurious interrupt %d\n\r", irq);
 #endif
-        return IRQ_NONE; /* spurious interrupt */
-    }
+		return IRQ_NONE;	/* spurious interrupt */
+	}
 
-    if (!ISZLOADED(*cinfo)) {
+	if (!ISZLOADED(*cinfo)) {
 #ifdef CY_DEBUG_INTERRUPTS
-	printk("cyz_interrupt: board not yet loaded (IRQ%d).\n\r", irq);
+		printk("cyz_interrupt: board not yet loaded (IRQ%d).\n\r", irq);
 #endif
-	return IRQ_NONE;
-    }
+		return IRQ_NONE;
+	}
 
-    /* Handle the interrupts */
-    cyz_handle_cmd(cinfo);
+	/* Handle the interrupts */
+	cyz_handle_cmd(cinfo);
 
-    return IRQ_HANDLED;
-} /* cyz_interrupt */
+	return IRQ_HANDLED;
+}				/* cyz_interrupt */
 
-static void
-cyz_rx_restart(unsigned long arg)
+static void cyz_rx_restart(unsigned long arg)
 {
-    struct cyclades_port *info = (struct cyclades_port *)arg;
-    int retval;
-    int card = info->card;
-    uclong channel = (info->line) - (cy_card[card].first_line);
-    unsigned long flags;
-
-    CY_LOCK(info, flags);
-    retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK2, 0L);
-    if (retval != 0){
-	printk("cyc:cyz_rx_restart retval on ttyC%d was %x\n", 
-	       info->line, retval);
-    }
-    cyz_rx_full_timer[info->line].function = NULL;
-    CY_UNLOCK(info, flags);
+	struct cyclades_port *info = (struct cyclades_port *)arg;
+	int retval;
+	int card = info->card;
+	uclong channel = (info->line) - (cy_card[card].first_line);
+	unsigned long flags;
+
+	CY_LOCK(info, flags);
+	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK2, 0L);
+	if (retval != 0) {
+		printk("cyc:cyz_rx_restart retval on ttyC%d was %x\n",
+			info->line, retval);
+	}
+	cyz_rx_full_timer[info->line].function = NULL;
+	CY_UNLOCK(info, flags);
 }
 
-#else /* CONFIG_CYZ_INTR */
+#else				/* CONFIG_CYZ_INTR */
 
-static void
-cyz_poll(unsigned long arg)
+static void cyz_poll(unsigned long arg)
 {
-  struct cyclades_card *cinfo;
-  struct cyclades_port *info;
-  struct tty_struct *tty;
-  static volatile struct FIRM_ID *firm_id;
-  static volatile struct ZFW_CTRL *zfw_ctrl;
-  static volatile struct BOARD_CTRL *board_ctrl;
-  static volatile struct CH_CTRL *ch_ctrl;
-  static volatile struct BUF_CTRL *buf_ctrl;
-  int card, port;
-
-    cyz_timerlist.expires = jiffies + (HZ);
-    for (card = 0 ; card < NR_CARDS ; card++){
-	cinfo = &cy_card[card];
+	struct cyclades_card *cinfo;
+	struct cyclades_port *info;
+	struct tty_struct *tty;
+	static volatile struct FIRM_ID *firm_id;
+	static volatile struct ZFW_CTRL *zfw_ctrl;
+	static volatile struct BOARD_CTRL *board_ctrl;
+	static volatile struct CH_CTRL *ch_ctrl;
+	static volatile struct BUF_CTRL *buf_ctrl;
+	int card, port;
 
-	if (!IS_CYC_Z(*cinfo)) continue;
-	if (!ISZLOADED(*cinfo)) continue;
+	cyz_timerlist.expires = jiffies + (HZ);
+	for (card = 0; card < NR_CARDS; card++) {
+		cinfo = &cy_card[card];
 
-	firm_id = cinfo->base_addr + ID_ADDRESS;
-	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	board_ctrl = &(zfw_ctrl->board_ctrl);
+		if (!IS_CYC_Z(*cinfo))
+			continue;
+		if (!ISZLOADED(*cinfo))
+			continue;
+
+		firm_id = cinfo->base_addr + ID_ADDRESS;
+		zfw_ctrl = cinfo->base_addr +
+				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		board_ctrl = &(zfw_ctrl->board_ctrl);
 
 	/* Skip first polling cycle to avoid racing conditions with the FW */
-	if (!cinfo->intr_enabled) {
-	    cinfo->nports = (int) cy_readl(&board_ctrl->n_channel);
-	    cinfo->intr_enabled = 1;
-	    continue;
-	}
+		if (!cinfo->intr_enabled) {
+			cinfo->nports = (int)cy_readl(&board_ctrl->n_channel);
+			cinfo->intr_enabled = 1;
+			continue;
+		}
 
-	cyz_handle_cmd(cinfo);
+		cyz_handle_cmd(cinfo);
 
-	for (port = 0 ; port < cinfo->nports ; port++) {
-	    info = &cy_port[ port + cinfo->first_line ];
-            tty = info->tty;
-	    ch_ctrl = &(zfw_ctrl->ch_ctrl[port]);
-	    buf_ctrl = &(zfw_ctrl->buf_ctrl[port]);
-
-	    if (!info->throttle)
-	        cyz_handle_rx(info, ch_ctrl, buf_ctrl);
-	    cyz_handle_tx(info, ch_ctrl, buf_ctrl);
-	}
-	/* poll every 'cyz_polling_cycle' period */
-	cyz_timerlist.expires = jiffies + cyz_polling_cycle;
-    }
-    add_timer(&cyz_timerlist);
+		for (port = 0; port < cinfo->nports; port++) {
+			info = &cy_port[port + cinfo->first_line];
+			tty = info->tty;
+			ch_ctrl = &(zfw_ctrl->ch_ctrl[port]);
+			buf_ctrl = &(zfw_ctrl->buf_ctrl[port]);
+
+			if (!info->throttle)
+				cyz_handle_rx(info, ch_ctrl, buf_ctrl);
+			cyz_handle_tx(info, ch_ctrl, buf_ctrl);
+		}
+		/* poll every 'cyz_polling_cycle' period */
+		cyz_timerlist.expires = jiffies + cyz_polling_cycle;
+	}
+	add_timer(&cyz_timerlist);
 
-    return;
-} /* cyz_poll */
+	return;
+}				/* cyz_poll */
 
-#endif /* CONFIG_CYZ_INTR */
+#endif				/* CONFIG_CYZ_INTR */
 
 /********** End of block of Cyclades-Z specific code *********/
 /***********************************************************/
 
-
 /* This is called whenever a port becomes active;
    interrupts are enabled and DTR & RTS are turned on.
  */
-static int
-startup(struct cyclades_port * info)
+static int startup(struct cyclades_port *info)
 {
-  unsigned long flags;
-  int retval = 0;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
-  unsigned long page;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-
-    page = get_zeroed_page(GFP_KERNEL);
-    if (!page)
-	return -ENOMEM;
-
-    CY_LOCK(info, flags);
-
-    if (info->flags & ASYNC_INITIALIZED){
-	free_page(page);
-	goto errout;
-    }
-
-    if (!info->type){
-        if (info->tty){
-            set_bit(TTY_IO_ERROR, &info->tty->flags);
-        }
-	free_page(page);
-	goto errout;
-    }
-
-    if (info->xmit_buf)
-	free_page(page);
-    else
-	info->xmit_buf = (unsigned char *) page;
-
-    CY_UNLOCK(info, flags);
-
-    set_line_char(info);
-
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	unsigned long flags;
+	int retval = 0;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
+	unsigned long page;
 
-#ifdef CY_DEBUG_OPEN
-	printk("cyc startup card %d, chip %d, channel %d, base_addr %lx\n",
-	     card, chip, channel, (long)base_addr);/**/
-#endif
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+
+	page = get_zeroed_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
 
 	CY_LOCK(info, flags);
 
-	cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
+	if (info->flags & ASYNC_INITIALIZED) {
+		free_page(page);
+		goto errout;
+	}
+
+	if (!info->type) {
+		if (info->tty) {
+			set_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		free_page(page);
+		goto errout;
+	}
+
+	if (info->xmit_buf)
+		free_page(page);
+	else
+		info->xmit_buf = (unsigned char *)page;
+
+	CY_UNLOCK(info, flags);
+
+	set_line_char(info);
+
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr = cy_card[card].base_addr +
+				(cy_chip_offset[chip] << index);
 
-	cy_writeb(base_addr+(CyRTPR<<index), (info->default_timeout
-		 ? info->default_timeout : 0x02)); /* 10ms rx timeout */
+#ifdef CY_DEBUG_OPEN
+		printk("cyc startup card %d, chip %d, channel %d, "
+				"base_addr %lx\n",
+				card, chip, channel, (long)base_addr);
+		/**/
+#endif
+		CY_LOCK(info, flags);
 
-	cyy_issue_cmd(base_addr,CyCHAN_CTL|CyENB_RCVR|CyENB_XMTR,index);
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 
-	cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-	cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-	cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
+		cy_writeb(base_addr + (CyRTPR << index),
+			(info->default_timeout ? info->default_timeout : 0x02));
+		/* 10ms rx timeout */
+
+		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyENB_RCVR | CyENB_XMTR,
+				index);
+
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		cy_writeb(base_addr + (CyMSVR1 << index), CyRTS);
+		cy_writeb(base_addr + (CyMSVR2 << index), CyDTR);
 
 #ifdef CY_DEBUG_DTR
-	printk("cyc:startup raising DTR\n");
-	printk("     status: 0x%x, 0x%x\n",
-		cy_readb(base_addr+(CyMSVR1<<index)), 
-                cy_readb(base_addr+(CyMSVR2<<index)));
+		printk("cyc:startup raising DTR\n");
+		printk("     status: 0x%x, 0x%x\n",
+			cy_readb(base_addr + (CyMSVR1 << index)),
+			cy_readb(base_addr + (CyMSVR2 << index)));
 #endif
 
-	cy_writeb(base_addr+(CySRER<<index),
-		cy_readb(base_addr+(CySRER<<index)) | CyRxData);
-	info->flags |= ASYNC_INITIALIZED;
+		cy_writeb(base_addr + (CySRER << index),
+			cy_readb(base_addr + (CySRER << index)) | CyRxData);
+		info->flags |= ASYNC_INITIALIZED;
 
-	if (info->tty){
-	    clear_bit(TTY_IO_ERROR, &info->tty->flags);
-	}
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	info->breakon = info->breakoff = 0;
-	memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
-	info->idle_stats.in_use    =
-	info->idle_stats.recv_idle =
-	info->idle_stats.xmit_idle = jiffies;
+		if (info->tty) {
+			clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+		info->breakon = info->breakoff = 0;
+		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
+		info->idle_stats.in_use =
+		info->idle_stats.recv_idle =
+		info->idle_stats.xmit_idle = jiffies;
 
-	CY_UNLOCK(info, flags);
+		CY_UNLOCK(info, flags);
 
-    } else {
-      struct FIRM_ID __iomem *firm_id;
-      struct ZFW_CTRL __iomem *zfw_ctrl;
-      struct BOARD_CTRL __iomem *board_ctrl;
-      struct CH_CTRL __iomem *ch_ctrl;
-      int retval;
+	} else {
+		struct FIRM_ID __iomem *firm_id;
+		struct ZFW_CTRL __iomem *zfw_ctrl;
+		struct BOARD_CTRL __iomem *board_ctrl;
+		struct CH_CTRL __iomem *ch_ctrl;
+		int retval;
 
-	base_addr = cy_card[card].base_addr;
+		base_addr = cy_card[card].base_addr;
 
-        firm_id = base_addr + ID_ADDRESS;
-        if (!ISZLOADED(cy_card[card])){
-	    return -ENODEV;
-	}
+		firm_id = base_addr + ID_ADDRESS;
+		if (!ISZLOADED(cy_card[card])) {
+			return -ENODEV;
+		}
 
-	zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	board_ctrl = &zfw_ctrl->board_ctrl;
-	ch_ctrl = zfw_ctrl->ch_ctrl;
+		zfw_ctrl = cy_card[card].base_addr +
+				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		board_ctrl = &zfw_ctrl->board_ctrl;
+		ch_ctrl = zfw_ctrl->ch_ctrl;
 
 #ifdef CY_DEBUG_OPEN
-	printk("cyc startup Z card %d, channel %d, base_addr %lx\n",
-	     card, channel, (long)base_addr);/**/
+		printk("cyc startup Z card %d, channel %d, base_addr %lx\n",
+			card, channel, (long)base_addr);
+		/**/
 #endif
+		CY_LOCK(info, flags);
 
-	CY_LOCK(info, flags);
-
-	cy_writel(&ch_ctrl[channel].op_mode, C_CH_ENABLE);
+		cy_writel(&ch_ctrl[channel].op_mode, C_CH_ENABLE);
 #ifdef Z_WAKE
 #ifdef CONFIG_CYZ_INTR
-	cy_writel(&ch_ctrl[channel].intr_enable, 
-		  C_IN_TXBEMPTY|C_IN_TXLOWWM|C_IN_RXHIWM|C_IN_RXNNDT|
-		  C_IN_IOCTLW|
-		  C_IN_MDCD);
+		cy_writel(&ch_ctrl[channel].intr_enable,
+			  C_IN_TXBEMPTY | C_IN_TXLOWWM | C_IN_RXHIWM |
+			  C_IN_RXNNDT | C_IN_IOCTLW | C_IN_MDCD);
 #else
-	cy_writel(&ch_ctrl[channel].intr_enable, 
-		  C_IN_IOCTLW|
-		  C_IN_MDCD);
-#endif /* CONFIG_CYZ_INTR */
+		cy_writel(&ch_ctrl[channel].intr_enable,
+			  C_IN_IOCTLW | C_IN_MDCD);
+#endif				/* CONFIG_CYZ_INTR */
 #else
 #ifdef CONFIG_CYZ_INTR
-	cy_writel(&ch_ctrl[channel].intr_enable, 
-		  C_IN_TXBEMPTY|C_IN_TXLOWWM|C_IN_RXHIWM|C_IN_RXNNDT|
-		  C_IN_MDCD);
+		cy_writel(&ch_ctrl[channel].intr_enable,
+			  C_IN_TXBEMPTY | C_IN_TXLOWWM | C_IN_RXHIWM |
+			  C_IN_RXNNDT | C_IN_MDCD);
 #else
-	cy_writel(&ch_ctrl[channel].intr_enable, 
-		  C_IN_MDCD);
-#endif /* CONFIG_CYZ_INTR */
-#endif /* Z_WAKE */
+		cy_writel(&ch_ctrl[channel].intr_enable, C_IN_MDCD);
+#endif				/* CONFIG_CYZ_INTR */
+#endif				/* Z_WAKE */
+
+		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
+		if (retval != 0) {
+			printk("cyc:startup(1) retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
 
-	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
-	if (retval != 0){
-	    printk("cyc:startup(1) retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
-
-	/* Flush RX buffers before raising DTR and RTS */
-	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_RX, 0L);
-	if (retval != 0){
-	    printk("cyc:startup(2) retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
-
-	/* set timeout !!! */
-	/* set RTS and DTR !!! */
-	cy_writel(&ch_ctrl[channel].rs_control,
-             cy_readl(&ch_ctrl[channel].rs_control) | C_RS_RTS | C_RS_DTR) ;
-	retval = cyz_issue_cmd(&cy_card[info->card],
-	    channel, C_CM_IOCTLM, 0L);
-	if (retval != 0){
-	    printk("cyc:startup(3) retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
+		/* Flush RX buffers before raising DTR and RTS */
+		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_RX,
+				0L);
+		if (retval != 0) {
+			printk("cyc:startup(2) retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
+
+		/* set timeout !!! */
+		/* set RTS and DTR !!! */
+		cy_writel(&ch_ctrl[channel].rs_control,
+			cy_readl(&ch_ctrl[channel].rs_control) | C_RS_RTS |
+			C_RS_DTR);
+		retval = cyz_issue_cmd(&cy_card[info->card], channel,
+				C_CM_IOCTLM, 0L);
+		if (retval != 0) {
+			printk("cyc:startup(3) retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
 #ifdef CY_DEBUG_DTR
-	    printk("cyc:startup raising Z DTR\n");
+		printk("cyc:startup raising Z DTR\n");
 #endif
 
-	/* enable send, recv, modem !!! */
+		/* enable send, recv, modem !!! */
 
-	info->flags |= ASYNC_INITIALIZED;
-	if (info->tty){
-	    clear_bit(TTY_IO_ERROR, &info->tty->flags);
-	}
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	info->breakon = info->breakoff = 0;
-	memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
-	info->idle_stats.in_use    =
-	info->idle_stats.recv_idle =
-	info->idle_stats.xmit_idle = jiffies;
+		info->flags |= ASYNC_INITIALIZED;
+		if (info->tty) {
+			clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+		info->breakon = info->breakoff = 0;
+		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
+		info->idle_stats.in_use =
+		info->idle_stats.recv_idle =
+		info->idle_stats.xmit_idle = jiffies;
 
-	CY_UNLOCK(info, flags);
-    }
+		CY_UNLOCK(info, flags);
+	}
 
 #ifdef CY_DEBUG_OPEN
 	printk(" cyc startup done\n");
@@ -2099,165 +2160,166 @@ startup(struct cyclades_port * info)
 errout:
 	CY_UNLOCK(info, flags);
 	return retval;
-} /* startup */
-
+}				/* startup */
 
-static void
-start_xmit( struct cyclades_port *info )
+static void start_xmit(struct cyclades_port *info)
 {
-  unsigned long flags;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	unsigned long flags;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
 
-	CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyCAR<<index), channel);
-	    cy_writeb(base_addr+(CySRER<<index), 
-               cy_readb(base_addr+(CySRER<<index)) | CyTxRdy);
-	CY_UNLOCK(info, flags);
-    } else {
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr = cy_card[card].base_addr +
+				(cy_chip_offset[chip] << index);
+
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCAR << index), channel);
+		cy_writeb(base_addr + (CySRER << index),
+			cy_readb(base_addr + (CySRER << index)) | CyTxRdy);
+		CY_UNLOCK(info, flags);
+	} else {
 #ifdef CONFIG_CYZ_INTR
-      int retval;
+		int retval;
 
-	CY_LOCK(info, flags);
-	    retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK, 0L);
-	    if (retval != 0){
-		printk("cyc:start_xmit retval on ttyC%d was %x\n",
-		       info->line, retval);
-	    }
-	CY_UNLOCK(info, flags);
-#else /* CONFIG_CYZ_INTR */
-	/* Don't have to do anything at this time */
-#endif /* CONFIG_CYZ_INTR */
-    }
-} /* start_xmit */
+		CY_LOCK(info, flags);
+		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_INTBACK,
+				0L);
+		if (retval != 0) {
+			printk("cyc:start_xmit retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
+		CY_UNLOCK(info, flags);
+#else				/* CONFIG_CYZ_INTR */
+		/* Don't have to do anything at this time */
+#endif				/* CONFIG_CYZ_INTR */
+	}
+}				/* start_xmit */
 
 /*
  * This routine shuts down a serial port; interrupts are disabled,
  * and DTR is dropped if the hangup on close termio flag is on.
  */
-static void
-shutdown(struct cyclades_port * info)
+static void shutdown(struct cyclades_port *info)
 {
-  unsigned long flags;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
-
-    if (!(info->flags & ASYNC_INITIALIZED)){
-        return;
-    }
-
-    card = info->card;
-    channel = info->line - cy_card[card].first_line;
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	unsigned long flags;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
+
+	if (!(info->flags & ASYNC_INITIALIZED)) {
+		return;
+	}
+
+	card = info->card;
+	channel = info->line - cy_card[card].first_line;
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr = cy_card[card].base_addr +
+				(cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
-    printk("cyc shutdown Y card %d, chip %d, channel %d, base_addr %lx\n",
-		card, chip, channel, (long)base_addr);
+		printk("cyc shutdown Y card %d, chip %d, channel %d, "
+				"base_addr %lx\n",
+				card, chip, channel, (long)base_addr);
 #endif
 
-	CY_LOCK(info, flags);
+		CY_LOCK(info, flags);
 
-	    /* Clear delta_msr_wait queue to avoid mem leaks. */
-	    wake_up_interruptible(&info->delta_msr_wait);
+		/* Clear delta_msr_wait queue to avoid mem leaks. */
+		wake_up_interruptible(&info->delta_msr_wait);
 
-	    if (info->xmit_buf){
-		unsigned char * temp;
-		temp = info->xmit_buf;
-		info->xmit_buf = NULL;
-		free_page((unsigned long) temp);
-	    }
-	    cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-	    if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
-		cy_writeb(base_addr+(CyMSVR1<<index), ~CyRTS);
-		cy_writeb(base_addr+(CyMSVR2<<index), ~CyDTR);
+		if (info->xmit_buf) {
+			unsigned char *temp;
+			temp = info->xmit_buf;
+			info->xmit_buf = NULL;
+			free_page((unsigned long)temp);
+		}
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+			cy_writeb(base_addr + (CyMSVR1 << index), ~CyRTS);
+			cy_writeb(base_addr + (CyMSVR2 << index), ~CyDTR);
 #ifdef CY_DEBUG_DTR
-		printk("cyc shutdown dropping DTR\n");
-		printk("     status: 0x%x, 0x%x\n",
-		    cy_readb(base_addr+(CyMSVR1<<index)), 
-                    cy_readb(base_addr+(CyMSVR2<<index)));
+			printk("cyc shutdown dropping DTR\n");
+			printk("     status: 0x%x, 0x%x\n",
+				cy_readb(base_addr + (CyMSVR1 << index)),
+				cy_readb(base_addr + (CyMSVR2 << index)));
 #endif
-	    }
-	    cyy_issue_cmd(base_addr,CyCHAN_CTL|CyDIS_RCVR,index);
-	     /* it may be appropriate to clear _XMIT at
-	       some later date (after testing)!!! */
-
-	    if (info->tty){
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
-	    }
-	    info->flags &= ~ASYNC_INITIALIZED;
-	CY_UNLOCK(info, flags);
-    } else {
-      struct FIRM_ID __iomem *firm_id;
-      struct ZFW_CTRL __iomem *zfw_ctrl;
-      struct BOARD_CTRL __iomem *board_ctrl;
-      struct CH_CTRL __iomem *ch_ctrl;
-      int retval;
+		}
+		cyy_issue_cmd(base_addr, CyCHAN_CTL | CyDIS_RCVR, index);
+		/* it may be appropriate to clear _XMIT at
+		   some later date (after testing)!!! */
+
+		if (info->tty) {
+			set_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		info->flags &= ~ASYNC_INITIALIZED;
+		CY_UNLOCK(info, flags);
+	} else {
+		struct FIRM_ID __iomem *firm_id;
+		struct ZFW_CTRL __iomem *zfw_ctrl;
+		struct BOARD_CTRL __iomem *board_ctrl;
+		struct CH_CTRL __iomem *ch_ctrl;
+		int retval;
 
-	base_addr = cy_card[card].base_addr;
+		base_addr = cy_card[card].base_addr;
 #ifdef CY_DEBUG_OPEN
-    printk("cyc shutdown Z card %d, channel %d, base_addr %lx\n",
-		card, channel, (long)base_addr);
+		printk("cyc shutdown Z card %d, channel %d, base_addr %lx\n",
+			card, channel, (long)base_addr);
 #endif
 
-        firm_id = base_addr + ID_ADDRESS;
-        if (!ISZLOADED(cy_card[card])) {
-	    return;
-	}
+		firm_id = base_addr + ID_ADDRESS;
+		if (!ISZLOADED(cy_card[card])) {
+			return;
+		}
 
-	zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	board_ctrl = &zfw_ctrl->board_ctrl;
-	ch_ctrl = zfw_ctrl->ch_ctrl;
+		zfw_ctrl = cy_card[card].base_addr +
+				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		board_ctrl = &zfw_ctrl->board_ctrl;
+		ch_ctrl = zfw_ctrl->ch_ctrl;
 
-	CY_LOCK(info, flags);
+		CY_LOCK(info, flags);
 
-	    if (info->xmit_buf){
-		unsigned char * temp;
-		temp = info->xmit_buf;
-		info->xmit_buf = NULL;
-		free_page((unsigned long) temp);
-	    }
-	    
-	    if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
-		cy_writel(&ch_ctrl[channel].rs_control,
-                   (uclong)(cy_readl(&ch_ctrl[channel].rs_control) & 
-                   ~(C_RS_RTS | C_RS_DTR)));
-		retval = cyz_issue_cmd(&cy_card[info->card],
-			channel, C_CM_IOCTLM, 0L);
-		if (retval != 0){
-		    printk("cyc:shutdown retval on ttyC%d was %x\n",
-			   info->line, retval);
+		if (info->xmit_buf) {
+			unsigned char *temp;
+			temp = info->xmit_buf;
+			info->xmit_buf = NULL;
+			free_page((unsigned long)temp);
 		}
+
+		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+			cy_writel(&ch_ctrl[channel].rs_control,
+				(uclong)(cy_readl(&ch_ctrl[channel].rs_control)&
+					~(C_RS_RTS | C_RS_DTR)));
+			retval = cyz_issue_cmd(&cy_card[info->card], channel,
+					C_CM_IOCTLM, 0L);
+			if (retval != 0) {
+				printk("cyc:shutdown retval on ttyC%d was %x\n",
+					info->line, retval);
+			}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:shutdown dropping Z DTR\n");
+			printk("cyc:shutdown dropping Z DTR\n");
 #endif
-	    }
-	    
-	    if (info->tty){
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
-	    }
-	    info->flags &= ~ASYNC_INITIALIZED;
+		}
 
-	CY_UNLOCK(info, flags);
-    }
+		if (info->tty) {
+			set_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		info->flags &= ~ASYNC_INITIALIZED;
+
+		CY_UNLOCK(info, flags);
+	}
 
 #ifdef CY_DEBUG_OPEN
-    printk(" cyc shutdown done\n");
+	printk(" cyc shutdown done\n");
 #endif
-    return;
-} /* shutdown */
-
+	return;
+}				/* shutdown */
 
 /*
  * ------------------------------------------------------------
@@ -2266,527 +2328,549 @@ shutdown(struct cyclades_port * info)
  */
 
 static int
-block_til_ready(struct tty_struct *tty, struct file * filp,
-                           struct cyclades_port *info)
+block_til_ready(struct tty_struct *tty, struct file *filp,
+		struct cyclades_port *info)
 {
-  DECLARE_WAITQUEUE(wait, current);
-  struct cyclades_card *cinfo;
-  unsigned long flags;
-  int chip, channel,index;
-  int retval;
-  void __iomem *base_addr;
-
-    cinfo = &cy_card[info->card];
-    channel = info->line - cinfo->first_line;
-
-    /*
-     * If the device is in the middle of being closed, then block
-     * until it's done, and then try again.
-     */
-    if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-	if (info->flags & ASYNC_CLOSING) {
-            interruptible_sleep_on(&info->close_wait);
-	}
-        return ((info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
-    }
-
-    /*
-     * If non-blocking mode is set, then make the check up front
-     * and then exit.
-     */
-    if ((filp->f_flags & O_NONBLOCK) ||
-	(tty->flags & (1 << TTY_IO_ERROR))) {
-        info->flags |= ASYNC_NORMAL_ACTIVE;
-        return 0;
-    }
-
-    /*
-     * Block waiting for the carrier detect and the line to become
-     * free (i.e., not in use by the callout).  While we are in
-     * this loop, info->count is dropped by one, so that
-     * cy_close() knows when to free things.  We restore it upon
-     * exit, either normal or abnormal.
-     */
-    retval = 0;
-    add_wait_queue(&info->open_wait, &wait);
+	DECLARE_WAITQUEUE(wait, current);
+	struct cyclades_card *cinfo;
+	unsigned long flags;
+	int chip, channel, index;
+	int retval;
+	void __iomem *base_addr;
+
+	cinfo = &cy_card[info->card];
+	channel = info->line - cinfo->first_line;
+
+	/*
+	 * If the device is in the middle of being closed, then block
+	 * until it's done, and then try again.
+	 */
+	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING) {
+			interruptible_sleep_on(&info->close_wait);
+		}
+		return ((info->
+			 flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
+	}
+
+	/*
+	 * If non-blocking mode is set, then make the check up front
+	 * and then exit.
+	 */
+	if ((filp->f_flags & O_NONBLOCK) || (tty->flags & (1 << TTY_IO_ERROR))) {
+		info->flags |= ASYNC_NORMAL_ACTIVE;
+		return 0;
+	}
+
+	/*
+	 * Block waiting for the carrier detect and the line to become
+	 * free (i.e., not in use by the callout).  While we are in
+	 * this loop, info->count is dropped by one, so that
+	 * cy_close() knows when to free things.  We restore it upon
+	 * exit, either normal or abnormal.
+	 */
+	retval = 0;
+	add_wait_queue(&info->open_wait, &wait);
 #ifdef CY_DEBUG_OPEN
-    printk("cyc block_til_ready before block: ttyC%d, count = %d\n",
-           info->line, info->count);/**/
+	printk("cyc block_til_ready before block: ttyC%d, count = %d\n",
+		info->line, info->count);
+	/**/
 #endif
-    CY_LOCK(info, flags);
-    if (!tty_hung_up_p(filp))
-	info->count--;
-    CY_UNLOCK(info, flags);
+	CY_LOCK(info, flags);
+	if (!tty_hung_up_p(filp))
+		info->count--;
+	CY_UNLOCK(info, flags);
 #ifdef CY_DEBUG_COUNT
-    printk("cyc block_til_ready: (%d): decrementing count to %d\n",
-        current->pid, info->count);
+	printk("cyc block_til_ready: (%d): decrementing count to %d\n",
+		current->pid, info->count);
 #endif
-    info->blocked_open++;
-
-    if (!IS_CYC_Z(*cinfo)) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cinfo->bus_index;
-	base_addr = cinfo->base_addr + (cy_chip_offset[chip]<<index);
+	info->blocked_open++;
 
-	while (1) {
-	    CY_LOCK(info, flags);
-		if ((tty->termios->c_cflag & CBAUD)){
-		    cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-		    cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-		    cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
+	if (!IS_CYC_Z(*cinfo)) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cinfo->bus_index;
+		base_addr = cinfo->base_addr + (cy_chip_offset[chip] << index);
+
+		while (1) {
+			CY_LOCK(info, flags);
+			if ((tty->termios->c_cflag & CBAUD)) {
+				cy_writeb(base_addr + (CyCAR << index),
+					  (u_char) channel);
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  CyRTS);
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  CyDTR);
 #ifdef CY_DEBUG_DTR
-		    printk("cyc:block_til_ready raising DTR\n");
-		    printk("     status: 0x%x, 0x%x\n",
-			cy_readb(base_addr+(CyMSVR1<<index)), 
-                        cy_readb(base_addr+(CyMSVR2<<index)));
+				printk("cyc:block_til_ready raising DTR\n");
+				printk("     status: 0x%x, 0x%x\n",
+					cy_readb(base_addr +
+						(CyMSVR1 << index)),
+					cy_readb(base_addr +
+						(CyMSVR2 << index)));
 #endif
-		}
-	    CY_UNLOCK(info, flags);
-
-	    set_current_state(TASK_INTERRUPTIBLE);
-	    if (tty_hung_up_p(filp)
-	    || !(info->flags & ASYNC_INITIALIZED) ){
-		retval = ((info->flags & ASYNC_HUP_NOTIFY) ? 
-		    -EAGAIN : -ERESTARTSYS);
-		break;
-	    }
+			}
+			CY_UNLOCK(info, flags);
+
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (tty_hung_up_p(filp) ||
+					!(info->flags & ASYNC_INITIALIZED)) {
+				retval = ((info->flags & ASYNC_HUP_NOTIFY) ?
+					  -EAGAIN : -ERESTARTSYS);
+				break;
+			}
 
-	    CY_LOCK(info, flags);
-		cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-		if (!(info->flags & ASYNC_CLOSING)
-		&& (C_CLOCAL(tty)
-		    || (cy_readb(base_addr+(CyMSVR1<<index)) & CyDCD))) {
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (!(info->flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
+					(cy_readb(base_addr +
+						(CyMSVR1 << index)) & CyDCD))) {
+				CY_UNLOCK(info, flags);
+				break;
+			}
 			CY_UNLOCK(info, flags);
-			break;
-		}
-	    CY_UNLOCK(info, flags);
 
-	    if (signal_pending(current)) {
-		retval = -ERESTARTSYS;
-		break;
-	    }
+			if (signal_pending(current)) {
+				retval = -ERESTARTSYS;
+				break;
+			}
 #ifdef CY_DEBUG_OPEN
-	    printk("cyc block_til_ready blocking: ttyC%d, count = %d\n",
-		   info->line, info->count);/**/
+			printk("cyc block_til_ready blocking: ttyC%d, "
+					"count = %d\n",
+					info->line, info->count);
+			/**/
 #endif
-	    schedule();
-	}
-    } else {
-      struct FIRM_ID __iomem *firm_id;
-      struct ZFW_CTRL __iomem *zfw_ctrl;
-      struct BOARD_CTRL __iomem *board_ctrl;
-      struct CH_CTRL __iomem *ch_ctrl;
-      int retval;
-
-	base_addr = cinfo->base_addr;
-	firm_id = base_addr + ID_ADDRESS;
-        if (!ISZLOADED(*cinfo)){
-            current->state = TASK_RUNNING;
-	    remove_wait_queue(&info->open_wait, &wait);
-	    return -EINVAL;
-	}
-
-	zfw_ctrl = base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	board_ctrl = &zfw_ctrl->board_ctrl;
-	ch_ctrl = zfw_ctrl->ch_ctrl;
+			schedule();
+		}
+	} else {
+		struct FIRM_ID __iomem *firm_id;
+		struct ZFW_CTRL __iomem *zfw_ctrl;
+		struct BOARD_CTRL __iomem *board_ctrl;
+		struct CH_CTRL __iomem *ch_ctrl;
+		int retval;
 
-	while (1) {
-	    if ((tty->termios->c_cflag & CBAUD)){
-		cy_writel(&ch_ctrl[channel].rs_control,
-			cy_readl(&ch_ctrl[channel].rs_control) |
-			(C_RS_RTS | C_RS_DTR));
-		retval = cyz_issue_cmd(&cy_card[info->card],
-				       channel, C_CM_IOCTLM, 0L);
-		if (retval != 0){
-		    printk("cyc:block_til_ready retval on ttyC%d was %x\n",
-			   info->line, retval);
+		base_addr = cinfo->base_addr;
+		firm_id = base_addr + ID_ADDRESS;
+		if (!ISZLOADED(*cinfo)) {
+			current->state = TASK_RUNNING;
+			remove_wait_queue(&info->open_wait, &wait);
+			return -EINVAL;
 		}
+
+		zfw_ctrl = base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
+				0xfffff);
+		board_ctrl = &zfw_ctrl->board_ctrl;
+		ch_ctrl = zfw_ctrl->ch_ctrl;
+
+		while (1) {
+			if ((tty->termios->c_cflag & CBAUD)) {
+				cy_writel(&ch_ctrl[channel].rs_control,
+					  cy_readl(&ch_ctrl[channel].
+						   rs_control) | (C_RS_RTS |
+								  C_RS_DTR));
+				retval = cyz_issue_cmd(&cy_card[info->card],
+						channel, C_CM_IOCTLM, 0L);
+				if (retval != 0) {
+					printk("cyc:block_til_ready retval on "
+						"ttyC%d was %x\n",
+						info->line, retval);
+				}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:block_til_ready raising Z DTR\n");
+				printk("cyc:block_til_ready raising Z DTR\n");
 #endif
-	    }
+			}
 
-	    set_current_state(TASK_INTERRUPTIBLE);
-	    if (tty_hung_up_p(filp)
-	    || !(info->flags & ASYNC_INITIALIZED) ){
-		retval = ((info->flags & ASYNC_HUP_NOTIFY) ?
-		    -EAGAIN : -ERESTARTSYS);
-		break;
-	    }
-	    if (!(info->flags & ASYNC_CLOSING)
-	    && (C_CLOCAL(tty)
-	      || (cy_readl(&ch_ctrl[channel].rs_status) & C_RS_DCD))) {
-		break;
-	    }
-	    if (signal_pending(current)) {
-		retval = -ERESTARTSYS;
-		break;
-	    }
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (tty_hung_up_p(filp) ||
+					!(info->flags & ASYNC_INITIALIZED)) {
+				retval = ((info->flags & ASYNC_HUP_NOTIFY) ?
+					  -EAGAIN : -ERESTARTSYS);
+				break;
+			}
+			if (!(info->flags & ASYNC_CLOSING) && (C_CLOCAL(tty) ||
+					(cy_readl(&ch_ctrl[channel].rs_status) &
+						C_RS_DCD))) {
+				break;
+			}
+			if (signal_pending(current)) {
+				retval = -ERESTARTSYS;
+				break;
+			}
 #ifdef CY_DEBUG_OPEN
-	    printk("cyc block_til_ready blocking: ttyC%d, count = %d\n",
-		   info->line, info->count);/**/
+			printk("cyc block_til_ready blocking: ttyC%d, "
+					"count = %d\n",
+					info->line, info->count);
+			/**/
 #endif
-	    schedule();
+			schedule();
+		}
 	}
-    }
-    current->state = TASK_RUNNING;
-    remove_wait_queue(&info->open_wait, &wait);
-    if (!tty_hung_up_p(filp)){
-	info->count++;
+	current->state = TASK_RUNNING;
+	remove_wait_queue(&info->open_wait, &wait);
+	if (!tty_hung_up_p(filp)) {
+		info->count++;
 #ifdef CY_DEBUG_COUNT
-	printk("cyc:block_til_ready (%d): incrementing count to %d\n",
-	    current->pid, info->count);
+		printk("cyc:block_til_ready (%d): incrementing count to %d\n",
+			current->pid, info->count);
 #endif
-    }
-    info->blocked_open--;
+	}
+	info->blocked_open--;
 #ifdef CY_DEBUG_OPEN
-    printk("cyc:block_til_ready after blocking: ttyC%d, count = %d\n",
-	   info->line, info->count);/**/
-#endif
-    if (retval)
-	return retval;
-    info->flags |= ASYNC_NORMAL_ACTIVE;
-    return 0;
-} /* block_til_ready */
-
+	printk("cyc:block_til_ready after blocking: ttyC%d, count = %d\n",
+		info->line, info->count);
+	/**/
+#endif
+	if (retval)
+		return retval;
+	info->flags |= ASYNC_NORMAL_ACTIVE;
+	return 0;
+}				/* block_til_ready */
 
 /*
  * This routine is called whenever a serial port is opened.  It
  * performs the serial-specific initialization for the tty structure.
  */
-static int
-cy_open(struct tty_struct *tty, struct file * filp)
+static int cy_open(struct tty_struct *tty, struct file *filp)
 {
-  struct cyclades_port  *info;
-  int retval, line;
-
-    line = tty->index;
-    if ((line < 0) || (NR_PORTS <= line)){
-        return -ENODEV;
-    }
-    info = &cy_port[line];
-    if (info->line < 0){
-        return -ENODEV;
-    }
-    
-    /* If the card's firmware hasn't been loaded,
-       treat it as absent from the system.  This
-       will make the user pay attention.
-    */
-    if (IS_CYC_Z(cy_card[info->card])) {
-	struct cyclades_card *cinfo = &cy_card[info->card];
-	struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
+	struct cyclades_port *info;
+	int retval, line;
 
-        if (!ISZLOADED(*cinfo)) {
-	    if (((ZE_V1 ==cy_readl(&((struct RUNTIME_9060 __iomem *)
-		(cinfo->ctl_addr))->mail_box_0)) &&
-		Z_FPGA_CHECK (*cinfo)) &&
-		(ZFIRM_HLT == cy_readl (&firm_id->signature)))
-	    {
-		printk ("cyc:Cyclades-Z Error: you need an external power supply for this number of ports.\n\rFirmware halted.\r\n");
-	    } else {
-		printk("cyc:Cyclades-Z firmware not yet loaded\n");
-	    }
-	    return -ENODEV;
+	line = tty->index;
+	if ((line < 0) || (NR_PORTS <= line)) {
+		return -ENODEV;
+	}
+	info = &cy_port[line];
+	if (info->line < 0) {
+		return -ENODEV;
 	}
-#ifdef CONFIG_CYZ_INTR
-	else {
-	    /* In case this Z board is operating in interrupt mode, its 
-	       interrupts should be enabled as soon as the first open happens 
-	       to one of its ports. */
-            if (!cinfo->intr_enabled) {
-		struct ZFW_CTRL __iomem *zfw_ctrl;
-		struct BOARD_CTRL __iomem *board_ctrl;
-
-		zfw_ctrl = cinfo->base_addr + (cy_readl (&firm_id->zfwctrl_addr) & 0xfffff);
-
-		board_ctrl = &zfw_ctrl->board_ctrl;
 
-		/* Enable interrupts on the PLX chip */
-		cy_writew(cinfo->ctl_addr+0x68,
-			cy_readw(cinfo->ctl_addr+0x68)|0x0900);
-		/* Enable interrupts on the FW */
-		retval = cyz_issue_cmd(cinfo,
-					0, C_CM_IRQ_ENBL, 0L);
-		if (retval != 0){
-		    printk("cyc:IRQ enable retval was %x\n", retval);
-		}
-		cinfo->nports = (int) cy_readl (&board_ctrl->n_channel);
-		cinfo->intr_enabled = 1;
-	    }
+	/* If the card's firmware hasn't been loaded,
+	   treat it as absent from the system.  This
+	   will make the user pay attention.
+	 */
+	if (IS_CYC_Z(cy_card[info->card])) {
+		struct cyclades_card *cinfo = &cy_card[info->card];
+		struct FIRM_ID __iomem *firm_id = cinfo->base_addr + ID_ADDRESS;
+
+		if (!ISZLOADED(*cinfo)) {
+			if (((ZE_V1 == cy_readl(
+					&((struct RUNTIME_9060 __iomem *)
+					 (cinfo->ctl_addr))->mail_box_0)) &&
+					Z_FPGA_CHECK(*cinfo)) &&
+					(ZFIRM_HLT == cy_readl(
+						&firm_id->signature))) {
+				printk("cyc:Cyclades-Z Error: you need an "
+					"external power supply for this number "
+					"of ports.\n\rFirmware halted.\r\n");
+			} else {
+				printk("cyc:Cyclades-Z firmware not yet "
+					"loaded\n");
+			}
+			return -ENODEV;
+		}
+#ifdef CONFIG_CYZ_INTR
+		else {
+		/* In case this Z board is operating in interrupt mode, its
+		   interrupts should be enabled as soon as the first open
+		   happens to one of its ports. */
+			if (!cinfo->intr_enabled) {
+				struct ZFW_CTRL __iomem *zfw_ctrl;
+				struct BOARD_CTRL __iomem *board_ctrl;
+
+				zfw_ctrl = cinfo->base_addr +
+					(cy_readl(&firm_id->zfwctrl_addr) &
+						0xfffff);
+
+				board_ctrl = &zfw_ctrl->board_ctrl;
+
+				/* Enable interrupts on the PLX chip */
+				cy_writew(cinfo->ctl_addr + 0x68,
+					  cy_readw(cinfo->ctl_addr +
+						   0x68) | 0x0900);
+				/* Enable interrupts on the FW */
+				retval = cyz_issue_cmd(cinfo, 0,
+						C_CM_IRQ_ENBL, 0L);
+				if (retval != 0) {
+					printk("cyc:IRQ enable retval was %x\n",
+						retval);
+				}
+				cinfo->nports =
+					(int)cy_readl(&board_ctrl->n_channel);
+				cinfo->intr_enabled = 1;
+			}
+		}
+#endif				/* CONFIG_CYZ_INTR */
+		/* Make sure this Z port really exists in hardware */
+		if (info->line > (cinfo->first_line + cinfo->nports - 1))
+			return -ENODEV;
 	}
-#endif /* CONFIG_CYZ_INTR */
-	/* Make sure this Z port really exists in hardware */
-	if (info->line > (cinfo->first_line + cinfo->nports - 1))
-		return -ENODEV;
-    }
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_open ttyC%d\n", info->line); /* */
+	printk("cyc:cy_open ttyC%d\n", info->line);	/* */
 #endif
-    tty->driver_data = info;
-    info->tty = tty;
-    if (serial_paranoia_check(info, tty->name, "cy_open")){
-        return -ENODEV;
-    }
+	tty->driver_data = info;
+	info->tty = tty;
+	if (serial_paranoia_check(info, tty->name, "cy_open")) {
+		return -ENODEV;
+	}
 #ifdef CY_DEBUG_OPEN
-    printk("cyc:cy_open ttyC%d, count = %d\n",
-        info->line, info->count);/**/
+	printk("cyc:cy_open ttyC%d, count = %d\n", info->line, info->count);
+	/**/
 #endif
-    info->count++;
+	info->count++;
 #ifdef CY_DEBUG_COUNT
-    printk("cyc:cy_open (%d): incrementing count to %d\n",
-        current->pid, info->count);
+	printk("cyc:cy_open (%d): incrementing count to %d\n",
+		current->pid, info->count);
 #endif
 
-    /*
-     * If the port is the middle of closing, bail out now
-     */
-    if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
-	if (info->flags & ASYNC_CLOSING)
-	    interruptible_sleep_on(&info->close_wait);
-	return ((info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
-    }
-
-    /*
-     * Start up serial port
-     */
-    retval = startup(info);
-    if (retval){
-        return retval;
-    }
+	/*
+	 * If the port is the middle of closing, bail out now
+	 */
+	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
+		if (info->flags & ASYNC_CLOSING)
+			interruptible_sleep_on(&info->close_wait);
+		return ((info->
+			 flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
+	}
+
+	/*
+	 * Start up serial port
+	 */
+	retval = startup(info);
+	if (retval) {
+		return retval;
+	}
 
-    retval = block_til_ready(tty, filp, info);
-    if (retval) {
+	retval = block_til_ready(tty, filp, info);
+	if (retval) {
 #ifdef CY_DEBUG_OPEN
-        printk("cyc:cy_open returning after block_til_ready with %d\n",
-               retval);
+		printk("cyc:cy_open returning after block_til_ready with %d\n",
+			retval);
 #endif
-        return retval;
-    }
+		return retval;
+	}
 
-    info->throttle = 0;
+	info->throttle = 0;
 
 #ifdef CY_DEBUG_OPEN
-    printk(" cyc:cy_open done\n");/**/
+	printk(" cyc:cy_open done\n");
+	/**/
 #endif
-
-    return 0;
-} /* cy_open */
-
+	return 0;
+}				/* cy_open */
 
 /*
  * cy_wait_until_sent() --- wait until the transmitter is empty
  */
-static void 
-cy_wait_until_sent(struct tty_struct *tty, int timeout)
+static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 {
-  struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
-  unsigned long orig_jiffies;
-  int char_time;
-	
-    if (serial_paranoia_check(info, tty->name, "cy_wait_until_sent"))
-	return;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
+	unsigned long orig_jiffies;
+	int char_time;
 
-    if (info->xmit_fifo_size == 0)
-	return; /* Just in case.... */
+	if (serial_paranoia_check(info, tty->name, "cy_wait_until_sent"))
+		return;
 
+	if (info->xmit_fifo_size == 0)
+		return;		/* Just in case.... */
 
-    orig_jiffies = jiffies;
-    /*
-     * Set the check interval to be 1/5 of the estimated time to
-     * send a single character, and make it at least 1.  The check
-     * interval should also be less than the timeout.
-     * 
-     * Note: we have to use pretty tight timings here to satisfy
-     * the NIST-PCTS.
-     */
-    char_time = (info->timeout - HZ/50) / info->xmit_fifo_size;
-    char_time = char_time / 5;
-    if (char_time <= 0)
-	char_time = 1;
-    if (timeout < 0)
-	timeout = 0;
-    if (timeout)
-	char_time = min(char_time, timeout);
-    /*
-     * If the transmitter hasn't cleared in twice the approximate
-     * amount of time to send the entire FIFO, it probably won't
-     * ever clear.  This assumes the UART isn't doing flow
-     * control, which is currently the case.  Hence, if it ever
-     * takes longer than info->timeout, this is probably due to a
-     * UART bug of some kind.  So, we clamp the timeout parameter at
-     * 2*info->timeout.
-     */
-    if (!timeout || timeout > 2*info->timeout)
-	timeout = 2*info->timeout;
+	orig_jiffies = jiffies;
+	/*
+	 * Set the check interval to be 1/5 of the estimated time to
+	 * send a single character, and make it at least 1.  The check
+	 * interval should also be less than the timeout.
+	 *
+	 * Note: we have to use pretty tight timings here to satisfy
+	 * the NIST-PCTS.
+	 */
+	char_time = (info->timeout - HZ / 50) / info->xmit_fifo_size;
+	char_time = char_time / 5;
+	if (char_time <= 0)
+		char_time = 1;
+	if (timeout < 0)
+		timeout = 0;
+	if (timeout)
+		char_time = min(char_time, timeout);
+	/*
+	 * If the transmitter hasn't cleared in twice the approximate
+	 * amount of time to send the entire FIFO, it probably won't
+	 * ever clear.  This assumes the UART isn't doing flow
+	 * control, which is currently the case.  Hence, if it ever
+	 * takes longer than info->timeout, this is probably due to a
+	 * UART bug of some kind.  So, we clamp the timeout parameter at
+	 * 2*info->timeout.
+	 */
+	if (!timeout || timeout > 2 * info->timeout)
+		timeout = 2 * info->timeout;
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-    printk("In cy_wait_until_sent(%d) check=%lu...", timeout, char_time);
-    printk("jiff=%lu...", jiffies);
+	printk("In cy_wait_until_sent(%d) check=%lu...", timeout, char_time);
+	printk("jiff=%lu...", jiffies);
 #endif
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
-	while (cy_readb(base_addr+(CySRER<<index)) & CyTxRdy) {
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+		while (cy_readb(base_addr + (CySRER << index)) & CyTxRdy) {
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-	    printk("Not clean (jiff=%lu)...", jiffies);
+			printk("Not clean (jiff=%lu)...", jiffies);
 #endif
-	    if (msleep_interruptible(jiffies_to_msecs(char_time)))
-		break;
-	    if (timeout && time_after(jiffies, orig_jiffies + timeout))
-		break;
+			if (msleep_interruptible(jiffies_to_msecs(char_time)))
+				break;
+			if (timeout && time_after(jiffies, orig_jiffies +
+					timeout))
+				break;
+		}
+	} else {
+		// Nothing to do!
 	}
-    } else {
-	// Nothing to do!
-    }
-    /* Run one more char cycle */
-    msleep_interruptible(jiffies_to_msecs(char_time * 5));
+	/* Run one more char cycle */
+	msleep_interruptible(jiffies_to_msecs(char_time * 5));
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
-    printk("Clean (jiff=%lu)...done\n", jiffies);
+	printk("Clean (jiff=%lu)...done\n", jiffies);
 #endif
 }
 
 /*
  * This routine is called when a particular tty device is closed.
  */
-static void
-cy_close(struct tty_struct *tty, struct file *filp)
+static void cy_close(struct tty_struct *tty, struct file *filp)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  unsigned long flags;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_close ttyC%d\n", info->line);
+	printk("cyc:cy_close ttyC%d\n", info->line);
 #endif
 
-    if (!info || serial_paranoia_check(info, tty->name, "cy_close")){
-        return;
-    }
+	if (!info || serial_paranoia_check(info, tty->name, "cy_close")) {
+		return;
+	}
 
-    CY_LOCK(info, flags);
-    /* If the TTY is being hung up, nothing to do */
-    if (tty_hung_up_p(filp)) {
-	CY_UNLOCK(info, flags);
-        return;
-    }
-        
+	CY_LOCK(info, flags);
+	/* If the TTY is being hung up, nothing to do */
+	if (tty_hung_up_p(filp)) {
+		CY_UNLOCK(info, flags);
+		return;
+	}
 #ifdef CY_DEBUG_OPEN
-    printk("cyc:cy_close ttyC%d, count = %d\n", info->line, info->count);
+	printk("cyc:cy_close ttyC%d, count = %d\n", info->line, info->count);
 #endif
-    if ((tty->count == 1) && (info->count != 1)) {
-        /*
-         * Uh, oh.  tty->count is 1, which means that the tty
-         * structure will be freed.  Info->count should always
-         * be one in these conditions.  If it's greater than
-         * one, we've got real problems, since it means the
-         * serial port won't be shutdown.
-         */
-        printk("cyc:cy_close: bad serial port count; tty->count is 1, "
-           "info->count is %d\n", info->count);
-        info->count = 1;
-    }
+	if ((tty->count == 1) && (info->count != 1)) {
+		/*
+		 * Uh, oh.  tty->count is 1, which means that the tty
+		 * structure will be freed.  Info->count should always
+		 * be one in these conditions.  If it's greater than
+		 * one, we've got real problems, since it means the
+		 * serial port won't be shutdown.
+		 */
+		printk("cyc:cy_close: bad serial port count; tty->count is 1, "
+			"info->count is %d\n", info->count);
+		info->count = 1;
+	}
 #ifdef CY_DEBUG_COUNT
-    printk("cyc:cy_close at (%d): decrementing count to %d\n",
-        current->pid, info->count - 1);
+	printk("cyc:cy_close at (%d): decrementing count to %d\n",
+		current->pid, info->count - 1);
 #endif
-    if (--info->count < 0) {
+	if (--info->count < 0) {
 #ifdef CY_DEBUG_COUNT
-    printk("cyc:cyc_close setting count to 0\n");
+		printk("cyc:cyc_close setting count to 0\n");
 #endif
-        info->count = 0;
-    }
-    if (info->count) {
+		info->count = 0;
+	}
+	if (info->count) {
+		CY_UNLOCK(info, flags);
+		return;
+	}
+	info->flags |= ASYNC_CLOSING;
+
+	/*
+	 * Now we wait for the transmit buffer to clear; and we notify
+	 * the line discipline to only process XON/XOFF characters.
+	 */
+	tty->closing = 1;
 	CY_UNLOCK(info, flags);
-        return;
-    }
-    info->flags |= ASYNC_CLOSING;
-
-    /*
-    * Now we wait for the transmit buffer to clear; and we notify
-    * the line discipline to only process XON/XOFF characters.
-    */
-    tty->closing = 1;
-    CY_UNLOCK(info, flags);
-    if (info->closing_wait != CY_CLOSING_WAIT_NONE) {
-	tty_wait_until_sent(tty, info->closing_wait);
-    }
-    CY_LOCK(info, flags);
-
-    if (!IS_CYC_Z(cy_card[info->card])) {
-	int channel = info->line - cy_card[info->card].first_line;
-	int index = cy_card[info->card].bus_index;
-	void __iomem *base_addr = cy_card[info->card].base_addr + (cy_chip_offset[channel>>2] << index);
-	/* Stop accepting input */
-	channel &= 0x03;
-	cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-	cy_writeb(base_addr+(CySRER<<index),
-			cy_readb(base_addr+(CySRER<<index)) & ~CyRxData);
-	if (info->flags & ASYNC_INITIALIZED) {
-	    /* Waiting for on-board buffers to be empty before closing 
-	       the port */
-	    CY_UNLOCK(info, flags);
-	    cy_wait_until_sent(tty, info->timeout);
-	    CY_LOCK(info, flags);
+	if (info->closing_wait != CY_CLOSING_WAIT_NONE) {
+		tty_wait_until_sent(tty, info->closing_wait);
 	}
-    } else {
+	CY_LOCK(info, flags);
+
+	if (!IS_CYC_Z(cy_card[info->card])) {
+		int channel = info->line - cy_card[info->card].first_line;
+		int index = cy_card[info->card].bus_index;
+		void __iomem *base_addr = cy_card[info->card].base_addr +
+			(cy_chip_offset[channel >> 2] << index);
+		/* Stop accepting input */
+		channel &= 0x03;
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		cy_writeb(base_addr + (CySRER << index),
+			  cy_readb(base_addr + (CySRER << index)) & ~CyRxData);
+		if (info->flags & ASYNC_INITIALIZED) {
+			/* Waiting for on-board buffers to be empty before closing
+			   the port */
+			CY_UNLOCK(info, flags);
+			cy_wait_until_sent(tty, info->timeout);
+			CY_LOCK(info, flags);
+		}
+	} else {
 #ifdef Z_WAKE
-	/* Waiting for on-board buffers to be empty before closing the port */
-	void __iomem *base_addr = cy_card[info->card].base_addr;
-	struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
-	struct ZFW_CTRL __iomem *zfw_ctrl = base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	struct CH_CTRL __iomem *ch_ctrl = zfw_ctrl->ch_ctrl;
-	int channel = info->line - cy_card[info->card].first_line;
-	int retval;
+		/* Waiting for on-board buffers to be empty before closing the port */
+		void __iomem *base_addr = cy_card[info->card].base_addr;
+		struct FIRM_ID __iomem *firm_id = base_addr + ID_ADDRESS;
+		struct ZFW_CTRL __iomem *zfw_ctrl =
+		    base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		struct CH_CTRL __iomem *ch_ctrl = zfw_ctrl->ch_ctrl;
+		int channel = info->line - cy_card[info->card].first_line;
+		int retval;
+
+		if (cy_readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
+			retval = cyz_issue_cmd(&cy_card[info->card], channel,
+						C_CM_IOCTLW, 0L);
+			if (retval != 0) {
+				printk("cyc:cy_close retval on ttyC%d was %x\n",
+					info->line, retval);
+			}
+			CY_UNLOCK(info, flags);
+			interruptible_sleep_on(&info->shutdown_wait);
+			CY_LOCK(info, flags);
+		}
+#endif
+	}
 
-	if (cy_readl(&ch_ctrl[channel].flow_status) != C_FS_TXIDLE) {
-	    retval = cyz_issue_cmd(&cy_card[info->card], channel, 
-				   C_CM_IOCTLW, 0L);
-	    if (retval != 0){
-		printk("cyc:cy_close retval on ttyC%d was %x\n",
-		       info->line, retval);
-	    }
-	    CY_UNLOCK(info, flags);
-	    interruptible_sleep_on(&info->shutdown_wait);
-	    CY_LOCK(info, flags);
-	}
-#endif
-    }
-
-    CY_UNLOCK(info, flags);
-    shutdown(info);
-    if (tty->driver->flush_buffer)
-        tty->driver->flush_buffer(tty);
-    tty_ldisc_flush(tty);        
-    CY_LOCK(info, flags);
-
-    tty->closing = 0;
-    info->event = 0;
-    info->tty = NULL;
-    if (info->blocked_open) {
 	CY_UNLOCK(info, flags);
-        if (info->close_delay) {
-            msleep_interruptible(jiffies_to_msecs(info->close_delay));
-        }
-        wake_up_interruptible(&info->open_wait);
+	shutdown(info);
+	if (tty->driver->flush_buffer)
+		tty->driver->flush_buffer(tty);
+	tty_ldisc_flush(tty);
 	CY_LOCK(info, flags);
-    }
-    info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-    wake_up_interruptible(&info->close_wait);
+
+	tty->closing = 0;
+	info->event = 0;
+	info->tty = NULL;
+	if (info->blocked_open) {
+		CY_UNLOCK(info, flags);
+		if (info->close_delay) {
+			msleep_interruptible(jiffies_to_msecs
+						(info->close_delay));
+		}
+		wake_up_interruptible(&info->open_wait);
+		CY_LOCK(info, flags);
+	}
+	info->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+	wake_up_interruptible(&info->close_wait);
 
 #ifdef CY_DEBUG_OTHER
-    printk(" cyc:cy_close done\n");
+	printk(" cyc:cy_close done\n");
 #endif
 
-    CY_UNLOCK(info, flags);
-    return;
-} /* cy_close */
-
+	CY_UNLOCK(info, flags);
+	return;
+}				/* cy_close */
 
 /* This routine gets called when tty_write has put something into
  * the write_queue.  The characters may come from user space or
@@ -2801,50 +2885,49 @@ cy_close(struct tty_struct *tty, struct 
  * If the port is already active, there is no need to kick it.
  *
  */
-static int
-cy_write(struct tty_struct * tty, const unsigned char *buf, int count)
+static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  unsigned long flags;
-  int c, ret = 0;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
+	int c, ret = 0;
 
 #ifdef CY_DEBUG_IO
-    printk("cyc:cy_write ttyC%d\n", info->line); /* */
+	printk("cyc:cy_write ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_write")){
-        return 0;
-    }
-        
-    if (!info->xmit_buf)
-	return 0;
+	if (serial_paranoia_check(info, tty->name, "cy_write")) {
+		return 0;
+	}
+
+	if (!info->xmit_buf)
+		return 0;
+
+	CY_LOCK(info, flags);
+	while (1) {
+		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
+				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
 
-    CY_LOCK(info, flags);
-    while (1) {
-	c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
-			(int)(SERIAL_XMIT_SIZE - info->xmit_head)));
-	        
-	if (c <= 0)
-	    break;
-
-	memcpy(info->xmit_buf + info->xmit_head, buf, c);
-	info->xmit_head = (info->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
-	info->xmit_cnt += c;
-	buf += c;
-	count -= c;
-	ret += c;
-    }
-    CY_UNLOCK(info, flags);
-
-    info->idle_stats.xmit_bytes += ret;
-    info->idle_stats.xmit_idle   = jiffies;
-
-    if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped) {
-        start_xmit(info);
-    }
-    return ret;
-} /* cy_write */
+		if (c <= 0)
+			break;
 
+		memcpy(info->xmit_buf + info->xmit_head, buf, c);
+		info->xmit_head = (info->xmit_head + c) &
+			(SERIAL_XMIT_SIZE - 1);
+		info->xmit_cnt += c;
+		buf += c;
+		count -= c;
+		ret += c;
+	}
+	CY_UNLOCK(info, flags);
+
+	info->idle_stats.xmit_bytes += ret;
+	info->idle_stats.xmit_idle = jiffies;
+
+	if (info->xmit_cnt && !tty->stopped && !tty->hw_stopped) {
+		start_xmit(info);
+	}
+	return ret;
+}				/* cy_write */
 
 /*
  * This routine is called by the kernel to write a single
@@ -2853,60 +2936,56 @@ cy_write(struct tty_struct * tty, const 
  * done stuffing characters into the driver.  If there is no room
  * in the queue, the character is ignored.
  */
-static void
-cy_put_char(struct tty_struct *tty, unsigned char ch)
+static void cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  unsigned long flags;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
 
 #ifdef CY_DEBUG_IO
-    printk("cyc:cy_put_char ttyC%d\n", info->line);
+	printk("cyc:cy_put_char ttyC%d\n", info->line);
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-        return;
+	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
+		return;
 
-    if (!info->xmit_buf)
-        return;
+	if (!info->xmit_buf)
+		return;
 
-    CY_LOCK(info, flags);
-        if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
-	    CY_UNLOCK(info, flags);
-            return;
-        }
+	CY_LOCK(info, flags);
+	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
+		CY_UNLOCK(info, flags);
+		return;
+	}
 
-        info->xmit_buf[info->xmit_head++] = ch;
-        info->xmit_head &= SERIAL_XMIT_SIZE - 1;
-        info->xmit_cnt++;
+	info->xmit_buf[info->xmit_head++] = ch;
+	info->xmit_head &= SERIAL_XMIT_SIZE - 1;
+	info->xmit_cnt++;
 	info->idle_stats.xmit_bytes++;
 	info->idle_stats.xmit_idle = jiffies;
-    CY_UNLOCK(info, flags);
-} /* cy_put_char */
-
+	CY_UNLOCK(info, flags);
+}				/* cy_put_char */
 
 /*
  * This routine is called by the kernel after it has written a
  * series of characters to the tty device using put_char().  
  */
-static void
-cy_flush_chars(struct tty_struct *tty)
+static void cy_flush_chars(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-                                
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+
 #ifdef CY_DEBUG_IO
-    printk("cyc:cy_flush_chars ttyC%d\n", info->line); /* */
+	printk("cyc:cy_flush_chars ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_flush_chars"))
-        return;
-
-    if (info->xmit_cnt <= 0 || tty->stopped
-    || tty->hw_stopped || !info->xmit_buf)
-        return;
+	if (serial_paranoia_check(info, tty->name, "cy_flush_chars"))
+		return;
 
-    start_xmit(info);
-} /* cy_flush_chars */
+	if (info->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
+			!info->xmit_buf)
+		return;
 
+	start_xmit(info);
+}				/* cy_flush_chars */
 
 /*
  * This routine returns the numbers of characters the tty driver
@@ -2914,75 +2993,70 @@ cy_flush_chars(struct tty_struct *tty)
  * to change as output buffers get emptied, or if the output flow
  * control is activated.
  */
-static int
-cy_write_room(struct tty_struct *tty)
+static int cy_write_room(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  int   ret;
-                                
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	int ret;
+
 #ifdef CY_DEBUG_IO
-    printk("cyc:cy_write_room ttyC%d\n", info->line); /* */
+	printk("cyc:cy_write_room ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_write_room"))
-        return 0;
-    ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
-    if (ret < 0)
-        ret = 0;
-    return ret;
-} /* cy_write_room */
-
+	if (serial_paranoia_check(info, tty->name, "cy_write_room"))
+		return 0;
+	ret = SERIAL_XMIT_SIZE - info->xmit_cnt - 1;
+	if (ret < 0)
+		ret = 0;
+	return ret;
+}				/* cy_write_room */
 
-static int
-cy_chars_in_buffer(struct tty_struct *tty)
+static int cy_chars_in_buffer(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  int card, channel;
-                                
-    if (serial_paranoia_check(info, tty->name, "cy_chars_in_buffer"))
-        return 0;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	int card, channel;
+
+	if (serial_paranoia_check(info, tty->name, "cy_chars_in_buffer"))
+		return 0;
 
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
 
 #ifdef Z_EXT_CHARS_IN_BUFFER
-    if (!IS_CYC_Z(cy_card[card])) {
-#endif /* Z_EXT_CHARS_IN_BUFFER */
+	if (!IS_CYC_Z(cy_card[card])) {
+#endif				/* Z_EXT_CHARS_IN_BUFFER */
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_chars_in_buffer ttyC%d %d\n",
-		info->line, info->xmit_cnt); /* */
+		printk("cyc:cy_chars_in_buffer ttyC%d %d\n", info->line, info->xmit_cnt);	/* */
 #endif
-	return info->xmit_cnt;
+		return info->xmit_cnt;
 #ifdef Z_EXT_CHARS_IN_BUFFER
-    } else {
-	static volatile struct FIRM_ID *firm_id;
-	static volatile struct ZFW_CTRL *zfw_ctrl;
-	static volatile struct CH_CTRL *ch_ctrl;
-	static volatile struct BUF_CTRL *buf_ctrl;
-	int char_count;
-	volatile uclong tx_put, tx_get, tx_bufsize;
-
-	firm_id = cy_card[card].base_addr + ID_ADDRESS;
-	zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
-	buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
-
-	tx_get = cy_readl(&buf_ctrl->tx_get);
-	tx_put = cy_readl(&buf_ctrl->tx_put);
-	tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
-	if (tx_put >= tx_get)
-	    char_count = tx_put - tx_get;
-	else
-	    char_count = tx_put - tx_get + tx_bufsize;
+	} else {
+		static volatile struct FIRM_ID *firm_id;
+		static volatile struct ZFW_CTRL *zfw_ctrl;
+		static volatile struct CH_CTRL *ch_ctrl;
+		static volatile struct BUF_CTRL *buf_ctrl;
+		int char_count;
+		volatile uclong tx_put, tx_get, tx_bufsize;
+
+		firm_id = cy_card[card].base_addr + ID_ADDRESS;
+		zfw_ctrl = cy_card[card].base_addr +
+			(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
+		buf_ctrl = &(zfw_ctrl->buf_ctrl[channel]);
+
+		tx_get = cy_readl(&buf_ctrl->tx_get);
+		tx_put = cy_readl(&buf_ctrl->tx_put);
+		tx_bufsize = cy_readl(&buf_ctrl->tx_bufsize);
+		if (tx_put >= tx_get)
+			char_count = tx_put - tx_get;
+		else
+			char_count = tx_put - tx_get + tx_bufsize;
 #ifdef CY_DEBUG_IO
-	printk("cyc:cy_chars_in_buffer ttyC%d %d\n",
-		info->line, info->xmit_cnt + char_count); /* */
+		printk("cyc:cy_chars_in_buffer ttyC%d %d\n", info->line, info->xmit_cnt + char_count);	/* */
 #endif
-	return (info->xmit_cnt + char_count);
-    }
-#endif /* Z_EXT_CHARS_IN_BUFFER */
-} /* cy_chars_in_buffer */
-
+		return (info->xmit_cnt + char_count);
+	}
+#endif				/* Z_EXT_CHARS_IN_BUFFER */
+}				/* cy_chars_in_buffer */
 
 /*
  * ------------------------------------------------------------
@@ -2990,178 +3064,179 @@ cy_chars_in_buffer(struct tty_struct *tt
  * ------------------------------------------------------------
  */
 
-static void
-cyy_baud_calc(struct cyclades_port *info, uclong baud)
+static void cyy_baud_calc(struct cyclades_port *info, uclong baud)
 {
-    int co, co_val, bpr;
-    uclong cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 : 25000000);
+	int co, co_val, bpr;
+	uclong cy_clock = ((info->chip_rev >= CD1400_REV_J) ? 60000000 :
+			25000000);
 
-    if (baud == 0) {
-	info->tbpr = info->tco = info->rbpr = info->rco = 0;
-	return;
-    }
+	if (baud == 0) {
+		info->tbpr = info->tco = info->rbpr = info->rco = 0;
+		return;
+	}
 
-    /* determine which prescaler to use */
-    for (co = 4, co_val = 2048; co; co--, co_val >>= 2) {
-	if (cy_clock / co_val / baud > 63)
-	    break;
-    }
-
-    bpr = (cy_clock / co_val * 2 / baud + 1) / 2;
-    if (bpr > 255)
-	bpr = 255;
+	/* determine which prescaler to use */
+	for (co = 4, co_val = 2048; co; co--, co_val >>= 2) {
+		if (cy_clock / co_val / baud > 63)
+			break;
+	}
+
+	bpr = (cy_clock / co_val * 2 / baud + 1) / 2;
+	if (bpr > 255)
+		bpr = 255;
 
-    info->tbpr = info->rbpr = bpr;
-    info->tco = info->rco = co;
+	info->tbpr = info->rbpr = bpr;
+	info->tco = info->rco = co;
 }
 
 /*
  * This routine finds or computes the various line characteristics.
  * It used to be called config_setup
  */
-static void
-set_line_char(struct cyclades_port * info)
+static void set_line_char(struct cyclades_port *info)
 {
-  unsigned long flags;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
-  unsigned cflag, iflag;
-  unsigned short chip_number;
-  int baud, baud_rate = 0;
-  int   i;
-
-
-    if (!info->tty || !info->tty->termios){
-        return;
-    }
-    if (info->line == -1){
-        return;
-    }
-    cflag = info->tty->termios->c_cflag;
-    iflag = info->tty->termios->c_iflag;
-
-    /*
-     * Set up the tty->alt_speed kludge
-     */
-    if (info->tty) {
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
-	    info->tty->alt_speed = 57600;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
-	    info->tty->alt_speed = 115200;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
-	    info->tty->alt_speed = 230400;
-	if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
-	    info->tty->alt_speed = 460800;
-    }
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    chip_number = channel / 4;
-
-    if (!IS_CYC_Z(cy_card[card])) {
-
-	index = cy_card[card].bus_index;
-
-	/* baud rate */
-	baud = tty_get_baud_rate(info->tty);
-	if ((baud == 38400) &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)) {
-	    if (info->custom_divisor)
-		baud_rate = info->baud / info->custom_divisor;
-	    else
-		baud_rate = info->baud;
-	} else if (baud > CD1400_MAX_SPEED) {
-	    baud = CD1400_MAX_SPEED;
-	}
-	/* find the baud index */
-	for (i = 0; i < 20; i++) {
-	    if (baud == baud_table[i]) {
-		break;
-	    }
+	unsigned long flags;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
+	unsigned cflag, iflag;
+	unsigned short chip_number;
+	int baud, baud_rate = 0;
+	int i;
+
+	if (!info->tty || !info->tty->termios) {
+		return;
 	}
-	if (i == 20) {
-	    i = 19; /* CD1400_MAX_SPEED */
-	} 
-
-	if ((baud == 38400) &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)) {
-	    cyy_baud_calc(info, baud_rate);
-	} else {
-	    if(info->chip_rev >= CD1400_REV_J) {
-		/* It is a CD1400 rev. J or later */
-		info->tbpr = baud_bpr_60[i]; /* Tx BPR */
-		info->tco = baud_co_60[i]; /* Tx CO */
-		info->rbpr = baud_bpr_60[i]; /* Rx BPR */
-		info->rco = baud_co_60[i]; /* Rx CO */
-	    } else {
-		info->tbpr = baud_bpr_25[i]; /* Tx BPR */
-		info->tco = baud_co_25[i]; /* Tx CO */
-		info->rbpr = baud_bpr_25[i]; /* Rx BPR */
-		info->rco = baud_co_25[i]; /* Rx CO */
-	    }
-	}
-	if (baud_table[i] == 134) {
-	    /* get it right for 134.5 baud */
-	    info->timeout = (info->xmit_fifo_size*HZ*30/269) + 2;
-	} else if ((baud == 38400) &&
-		   ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)) {
-	    info->timeout = (info->xmit_fifo_size*HZ*15/baud_rate) + 2;
-	} else if (baud_table[i]) {
-	    info->timeout = (info->xmit_fifo_size*HZ*15/baud_table[i]) + 2;
-	    /* this needs to be propagated into the card info */
-	} else {
-	    info->timeout = 0;
+	if (info->line == -1) {
+		return;
 	}
-	/* By tradition (is it a standard?) a baud rate of zero
-	   implies the line should be/has been closed.  A bit
-	   later in this routine such a test is performed. */
-
-	/* byte size and parity */
-	info->cor5 = 0;
-	info->cor4 = 0;
-	info->cor3 = (info->default_threshold
-		      ? info->default_threshold
-		      : baud_cor3[i]); /* receive threshold */
-	info->cor2 = CyETC;
-	switch(cflag & CSIZE){
-	case CS5:
-	    info->cor1 = Cy_5_BITS;
-	    break;
-	case CS6:
-	    info->cor1 = Cy_6_BITS;
-	    break;
-	case CS7:
-	    info->cor1 = Cy_7_BITS;
-	    break;
-	case CS8:
-	    info->cor1 = Cy_8_BITS;
-	    break;
-	}
-	if(cflag & CSTOPB){
-	    info->cor1 |= Cy_2_STOP;
-	}
-	if (cflag & PARENB){
-	    if (cflag & PARODD){
-		info->cor1 |= CyPARITY_O;
-	    }else{
-		info->cor1 |= CyPARITY_E;
-	    }
-	}else{
-	    info->cor1 |= CyPARITY_NONE;
-	}
-	    
-	/* CTS flow control flag */
-	if (cflag & CRTSCTS){
-	    info->flags |= ASYNC_CTS_FLOW;
-	    info->cor2 |= CyCtsAE;
-	}else{
-	    info->flags &= ~ASYNC_CTS_FLOW;
-	    info->cor2 &= ~CyCtsAE;
+	cflag = info->tty->termios->c_cflag;
+	iflag = info->tty->termios->c_iflag;
+
+	/*
+	 * Set up the tty->alt_speed kludge
+	 */
+	if (info->tty) {
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+			info->tty->alt_speed = 57600;
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+			info->tty->alt_speed = 115200;
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+			info->tty->alt_speed = 230400;
+		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+			info->tty->alt_speed = 460800;
 	}
-	if (cflag & CLOCAL)
-	    info->flags &= ~ASYNC_CHECK_CD;
-	else
-	    info->flags |= ASYNC_CHECK_CD;
+
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	chip_number = channel / 4;
+
+	if (!IS_CYC_Z(cy_card[card])) {
+
+		index = cy_card[card].bus_index;
+
+		/* baud rate */
+		baud = tty_get_baud_rate(info->tty);
+		if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
+				ASYNC_SPD_CUST) {
+			if (info->custom_divisor)
+				baud_rate = info->baud / info->custom_divisor;
+			else
+				baud_rate = info->baud;
+		} else if (baud > CD1400_MAX_SPEED) {
+			baud = CD1400_MAX_SPEED;
+		}
+		/* find the baud index */
+		for (i = 0; i < 20; i++) {
+			if (baud == baud_table[i]) {
+				break;
+			}
+		}
+		if (i == 20) {
+			i = 19;	/* CD1400_MAX_SPEED */
+		}
+
+		if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
+				ASYNC_SPD_CUST) {
+			cyy_baud_calc(info, baud_rate);
+		} else {
+			if (info->chip_rev >= CD1400_REV_J) {
+				/* It is a CD1400 rev. J or later */
+				info->tbpr = baud_bpr_60[i];	/* Tx BPR */
+				info->tco = baud_co_60[i];	/* Tx CO */
+				info->rbpr = baud_bpr_60[i];	/* Rx BPR */
+				info->rco = baud_co_60[i];	/* Rx CO */
+			} else {
+				info->tbpr = baud_bpr_25[i];	/* Tx BPR */
+				info->tco = baud_co_25[i];	/* Tx CO */
+				info->rbpr = baud_bpr_25[i];	/* Rx BPR */
+				info->rco = baud_co_25[i];	/* Rx CO */
+			}
+		}
+		if (baud_table[i] == 134) {
+			/* get it right for 134.5 baud */
+			info->timeout = (info->xmit_fifo_size * HZ * 30 / 269) +
+					2;
+		} else if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
+				ASYNC_SPD_CUST) {
+			info->timeout = (info->xmit_fifo_size * HZ * 15 /
+					baud_rate) + 2;
+		} else if (baud_table[i]) {
+			info->timeout = (info->xmit_fifo_size * HZ * 15 /
+					baud_table[i]) + 2;
+			/* this needs to be propagated into the card info */
+		} else {
+			info->timeout = 0;
+		}
+		/* By tradition (is it a standard?) a baud rate of zero
+		   implies the line should be/has been closed.  A bit
+		   later in this routine such a test is performed. */
+
+		/* byte size and parity */
+		info->cor5 = 0;
+		info->cor4 = 0;
+		/* receive threshold */
+		info->cor3 = (info->default_threshold ?
+				info->default_threshold : baud_cor3[i]);
+		info->cor2 = CyETC;
+		switch (cflag & CSIZE) {
+		case CS5:
+			info->cor1 = Cy_5_BITS;
+			break;
+		case CS6:
+			info->cor1 = Cy_6_BITS;
+			break;
+		case CS7:
+			info->cor1 = Cy_7_BITS;
+			break;
+		case CS8:
+			info->cor1 = Cy_8_BITS;
+			break;
+		}
+		if (cflag & CSTOPB) {
+			info->cor1 |= Cy_2_STOP;
+		}
+		if (cflag & PARENB) {
+			if (cflag & PARODD) {
+				info->cor1 |= CyPARITY_O;
+			} else {
+				info->cor1 |= CyPARITY_E;
+			}
+		} else {
+			info->cor1 |= CyPARITY_NONE;
+		}
+
+		/* CTS flow control flag */
+		if (cflag & CRTSCTS) {
+			info->flags |= ASYNC_CTS_FLOW;
+			info->cor2 |= CyCtsAE;
+		} else {
+			info->flags &= ~ASYNC_CTS_FLOW;
+			info->cor2 &= ~CyCtsAE;
+		}
+		if (cflag & CLOCAL)
+			info->flags &= ~ASYNC_CHECK_CD;
+		else
+			info->flags |= ASYNC_CHECK_CD;
 
 	 /***********************************************
 	    The hardware option, CyRtsAO, presents RTS when
@@ -3173,300 +3248,319 @@ set_line_char(struct cyclades_port * inf
 	    cable.  Contact Marcio Saito for details.
 	 ***********************************************/
 
-	chip = channel>>2;
-	channel &= 0x03;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+		chip = channel >> 2;
+		channel &= 0x03;
+		base_addr = cy_card[card].base_addr +
+			(cy_chip_offset[chip] << index);
 
-	CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
 
-	   /* tx and rx baud rate */
+		/* tx and rx baud rate */
 
-	    cy_writeb(base_addr+(CyTCOR<<index), info->tco);
-	    cy_writeb(base_addr+(CyTBPR<<index), info->tbpr);
-	    cy_writeb(base_addr+(CyRCOR<<index), info->rco);
-	    cy_writeb(base_addr+(CyRBPR<<index), info->rbpr);
-
-	    /* set line characteristics  according configuration */
-
-	    cy_writeb(base_addr+(CySCHR1<<index), 
-		      START_CHAR(info->tty));
-	    cy_writeb(base_addr+(CySCHR2<<index), 
-		      STOP_CHAR(info->tty));
-	    cy_writeb(base_addr+(CyCOR1<<index), info->cor1);
-	    cy_writeb(base_addr+(CyCOR2<<index), info->cor2);
-	    cy_writeb(base_addr+(CyCOR3<<index), info->cor3);
-	    cy_writeb(base_addr+(CyCOR4<<index), info->cor4);
-	    cy_writeb(base_addr+(CyCOR5<<index), info->cor5);
-
-	    cyy_issue_cmd(base_addr,
-		     CyCOR_CHANGE|CyCOR1ch|CyCOR2ch|CyCOR3ch,index);
-
-	    cy_writeb(base_addr+(CyCAR<<index), 
-		      (u_char)channel); /* !!! Is this needed? */
-	    cy_writeb(base_addr+(CyRTPR<<index), (info->default_timeout
-					         ? info->default_timeout
-					         : 0x02)); /* 10ms rx timeout */
-
-	    if (C_CLOCAL(info->tty)) {
-		/* without modem intr */
-		cy_writeb(base_addr+(CySRER<<index),
-                   cy_readb(base_addr+(CySRER<<index)) | CyMdmCh); 
-					/* act on 1->0 modem transitions */
-                if ((cflag & CRTSCTS) && info->rflow) {
-                        cy_writeb(base_addr+(CyMCOR1<<index), 
-                                  (CyCTS|rflow_thr[i]));
-                } else {
-                        cy_writeb(base_addr+(CyMCOR1<<index), CyCTS);
-                }
-					/* act on 0->1 modem transitions */
-		cy_writeb(base_addr+(CyMCOR2<<index), CyCTS);
-	    } else {
-		/* without modem intr */
-		cy_writeb(base_addr+(CySRER<<index),
-                   cy_readb(base_addr+(CySRER<<index)) | CyMdmCh); 
-					/* act on 1->0 modem transitions */
-                if ((cflag & CRTSCTS) && info->rflow) {
-			cy_writeb(base_addr+(CyMCOR1<<index), 
-        	                  (CyDSR|CyCTS|CyRI|CyDCD|rflow_thr[i]));
-                } else {
-			cy_writeb(base_addr+(CyMCOR1<<index), 
-                                  CyDSR|CyCTS|CyRI|CyDCD);
-                }
-					/* act on 0->1 modem transitions */
-		cy_writeb(base_addr+(CyMCOR2<<index), 
-			  CyDSR|CyCTS|CyRI|CyDCD);
-	    }
-
-	    if(i == 0){ /* baud rate is zero, turn off line */
-	        if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR1<<index), ~CyRTS);
+		cy_writeb(base_addr + (CyTCOR << index), info->tco);
+		cy_writeb(base_addr + (CyTBPR << index), info->tbpr);
+		cy_writeb(base_addr + (CyRCOR << index), info->rco);
+		cy_writeb(base_addr + (CyRBPR << index), info->rbpr);
+
+		/* set line characteristics  according configuration */
+
+		cy_writeb(base_addr + (CySCHR1 << index),
+			  START_CHAR(info->tty));
+		cy_writeb(base_addr + (CySCHR2 << index), STOP_CHAR(info->tty));
+		cy_writeb(base_addr + (CyCOR1 << index), info->cor1);
+		cy_writeb(base_addr + (CyCOR2 << index), info->cor2);
+		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
+		cy_writeb(base_addr + (CyCOR4 << index), info->cor4);
+		cy_writeb(base_addr + (CyCOR5 << index), info->cor5);
+
+		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR1ch | CyCOR2ch |
+				CyCOR3ch, index);
+
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);	/* !!! Is this needed? */
+		cy_writeb(base_addr + (CyRTPR << index),
+			(info->default_timeout ? info->default_timeout : 0x02));
+		/* 10ms rx timeout */
+
+		if (C_CLOCAL(info->tty)) {
+			/* without modem intr */
+			cy_writeb(base_addr + (CySRER << index),
+				  cy_readb(base_addr +
+					   (CySRER << index)) | CyMdmCh);
+			/* act on 1->0 modem transitions */
+			if ((cflag & CRTSCTS) && info->rflow) {
+				cy_writeb(base_addr + (CyMCOR1 << index),
+					  (CyCTS | rflow_thr[i]));
+			} else {
+				cy_writeb(base_addr + (CyMCOR1 << index),
+					  CyCTS);
+			}
+			/* act on 0->1 modem transitions */
+			cy_writeb(base_addr + (CyMCOR2 << index), CyCTS);
 		} else {
-                        cy_writeb(base_addr+(CyMSVR2<<index), ~CyDTR);
+			/* without modem intr */
+			cy_writeb(base_addr + (CySRER << index),
+				  cy_readb(base_addr +
+					   (CySRER << index)) | CyMdmCh);
+			/* act on 1->0 modem transitions */
+			if ((cflag & CRTSCTS) && info->rflow) {
+				cy_writeb(base_addr + (CyMCOR1 << index),
+					  (CyDSR | CyCTS | CyRI | CyDCD |
+					   rflow_thr[i]));
+			} else {
+				cy_writeb(base_addr + (CyMCOR1 << index),
+					  CyDSR | CyCTS | CyRI | CyDCD);
+			}
+			/* act on 0->1 modem transitions */
+			cy_writeb(base_addr + (CyMCOR2 << index),
+				  CyDSR | CyCTS | CyRI | CyDCD);
 		}
+
+		if (i == 0) {	/* baud rate is zero, turn off line */
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  ~CyRTS);
+			} else {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  ~CyDTR);
+			}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:set_line_char dropping DTR\n");
-		printk("     status: 0x%x, 0x%x\n", 
-		    cy_readb(base_addr+(CyMSVR1<<index)),
-		    cy_readb(base_addr+(CyMSVR2<<index)));
-#endif
-	    }else{
-                if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-                } else {
-			cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
-                }
+			printk("cyc:set_line_char dropping DTR\n");
+			printk("     status: 0x%x, 0x%x\n",
+				cy_readb(base_addr + (CyMSVR1 << index)),
+				cy_readb(base_addr + (CyMSVR2 << index)));
+#endif
+		} else {
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  CyRTS);
+			} else {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  CyDTR);
+			}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:set_line_char raising DTR\n");
-		printk("     status: 0x%x, 0x%x\n",
-		    cy_readb(base_addr+(CyMSVR1<<index)),
-		    cy_readb(base_addr+(CyMSVR2<<index)));
+			printk("cyc:set_line_char raising DTR\n");
+			printk("     status: 0x%x, 0x%x\n",
+				cy_readb(base_addr + (CyMSVR1 << index)),
+				cy_readb(base_addr + (CyMSVR2 << index)));
 #endif
-	    }
+		}
 
-	    if (info->tty){
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
-	    }
-	CY_UNLOCK(info, flags);
+		if (info->tty) {
+			clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
+		CY_UNLOCK(info, flags);
 
-    } else {
-      struct FIRM_ID __iomem *firm_id;
-      struct ZFW_CTRL __iomem *zfw_ctrl;
-      struct BOARD_CTRL __iomem *board_ctrl;
-      struct CH_CTRL __iomem *ch_ctrl;
-      struct BUF_CTRL __iomem *buf_ctrl;
-      uclong sw_flow;
-      int retval;
-
-        firm_id = cy_card[card].base_addr + ID_ADDRESS;
-        if (!ISZLOADED(cy_card[card])) {
-	    return;
-	}
+	} else {
+		struct FIRM_ID __iomem *firm_id;
+		struct ZFW_CTRL __iomem *zfw_ctrl;
+		struct BOARD_CTRL __iomem *board_ctrl;
+		struct CH_CTRL __iomem *ch_ctrl;
+		struct BUF_CTRL __iomem *buf_ctrl;
+		uclong sw_flow;
+		int retval;
 
-	zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	board_ctrl = &zfw_ctrl->board_ctrl;
-	ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
-	buf_ctrl = &zfw_ctrl->buf_ctrl[channel];
+		firm_id = cy_card[card].base_addr + ID_ADDRESS;
+		if (!ISZLOADED(cy_card[card])) {
+			return;
+		}
 
-	/* baud rate */
-	baud = tty_get_baud_rate(info->tty);
-	if ((baud == 38400) &&
-	    ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)) {
-	    if (info->custom_divisor)
-		baud_rate = info->baud / info->custom_divisor;
-	    else
-		baud_rate = info->baud;
-	} else if (baud > CYZ_MAX_SPEED) {
-	    baud = CYZ_MAX_SPEED;
-	}
-	cy_writel(&ch_ctrl->comm_baud , baud);
-
-	if (baud == 134) {
-	    /* get it right for 134.5 baud */
-	    info->timeout = (info->xmit_fifo_size*HZ*30/269) + 2;
-	} else if ((baud == 38400) &&
-		   ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)) {
-	    info->timeout = (info->xmit_fifo_size*HZ*15/baud_rate) + 2;
-	} else if (baud) {
-	    info->timeout = (info->xmit_fifo_size*HZ*15/baud) + 2;
-	    /* this needs to be propagated into the card info */
-	} else {
-	    info->timeout = 0;
-	}
+		zfw_ctrl = cy_card[card].base_addr +
+			(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+		board_ctrl = &zfw_ctrl->board_ctrl;
+		ch_ctrl = &(zfw_ctrl->ch_ctrl[channel]);
+		buf_ctrl = &zfw_ctrl->buf_ctrl[channel];
+
+		/* baud rate */
+		baud = tty_get_baud_rate(info->tty);
+		if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
+				ASYNC_SPD_CUST) {
+			if (info->custom_divisor)
+				baud_rate = info->baud / info->custom_divisor;
+			else
+				baud_rate = info->baud;
+		} else if (baud > CYZ_MAX_SPEED) {
+			baud = CYZ_MAX_SPEED;
+		}
+		cy_writel(&ch_ctrl->comm_baud, baud);
 
-	/* byte size and parity */
-	switch(cflag & CSIZE){
-	case CS5: cy_writel(&ch_ctrl->comm_data_l , C_DL_CS5); break;
-	case CS6: cy_writel(&ch_ctrl->comm_data_l , C_DL_CS6); break;
-	case CS7: cy_writel(&ch_ctrl->comm_data_l , C_DL_CS7); break;
-	case CS8: cy_writel(&ch_ctrl->comm_data_l , C_DL_CS8); break;
-	}
-	if(cflag & CSTOPB){
-	    cy_writel(&ch_ctrl->comm_data_l,
-               cy_readl(&ch_ctrl->comm_data_l) | C_DL_2STOP);
-	}else{
-	    cy_writel(&ch_ctrl->comm_data_l,
-               cy_readl(&ch_ctrl->comm_data_l) | C_DL_1STOP);
-	}
-	if (cflag & PARENB){
-	    if (cflag & PARODD){
-		cy_writel(&ch_ctrl->comm_parity , C_PR_ODD);
-	    }else{
-		cy_writel(&ch_ctrl->comm_parity , C_PR_EVEN);
-	    }
-	}else{
-	    cy_writel(&ch_ctrl->comm_parity , C_PR_NONE);
-	}
-
-	/* CTS flow control flag */
-	if (cflag & CRTSCTS){
-	    cy_writel(&ch_ctrl->hw_flow,
-               cy_readl(&ch_ctrl->hw_flow) | C_RS_CTS | C_RS_RTS);
-	}else{
-	    cy_writel(&ch_ctrl->hw_flow,
-               cy_readl(&ch_ctrl->hw_flow) & ~(C_RS_CTS | C_RS_RTS));
-	}
-	/* As the HW flow control is done in firmware, the driver doesn't
-	   need to care about it */
-	info->flags &= ~ASYNC_CTS_FLOW;
-
-	/* XON/XOFF/XANY flow control flags */
-	sw_flow = 0;
-	if (iflag & IXON){
-	    sw_flow |= C_FL_OXX;
-	    if (iflag & IXANY)
-		sw_flow |= C_FL_OIXANY;
-	}
-	cy_writel(&ch_ctrl->sw_flow, sw_flow);
-
-	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
-	if (retval != 0){
-	    printk("cyc:set_line_char retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
-
-	/* CD sensitivity */
-	if (cflag & CLOCAL){
-	    info->flags &= ~ASYNC_CHECK_CD;
-	}else{
-	    info->flags |= ASYNC_CHECK_CD;
-	}
-
-	if(baud == 0){ /* baud rate is zero, turn off line */
-	    cy_writel(&ch_ctrl->rs_control,
-               cy_readl(&ch_ctrl->rs_control) & ~C_RS_DTR);
+		if (baud == 134) {
+			/* get it right for 134.5 baud */
+			info->timeout = (info->xmit_fifo_size * HZ * 30 / 269) +
+					2;
+		} else if (baud == 38400 && (info->flags & ASYNC_SPD_MASK) ==
+				ASYNC_SPD_CUST) {
+			info->timeout = (info->xmit_fifo_size * HZ * 15 /
+					baud_rate) + 2;
+		} else if (baud) {
+			info->timeout = (info->xmit_fifo_size * HZ * 15 /
+					baud) + 2;
+			/* this needs to be propagated into the card info */
+		} else {
+			info->timeout = 0;
+		}
+
+		/* byte size and parity */
+		switch (cflag & CSIZE) {
+		case CS5:
+			cy_writel(&ch_ctrl->comm_data_l, C_DL_CS5);
+			break;
+		case CS6:
+			cy_writel(&ch_ctrl->comm_data_l, C_DL_CS6);
+			break;
+		case CS7:
+			cy_writel(&ch_ctrl->comm_data_l, C_DL_CS7);
+			break;
+		case CS8:
+			cy_writel(&ch_ctrl->comm_data_l, C_DL_CS8);
+			break;
+		}
+		if (cflag & CSTOPB) {
+			cy_writel(&ch_ctrl->comm_data_l,
+				  cy_readl(&ch_ctrl->comm_data_l) | C_DL_2STOP);
+		} else {
+			cy_writel(&ch_ctrl->comm_data_l,
+				  cy_readl(&ch_ctrl->comm_data_l) | C_DL_1STOP);
+		}
+		if (cflag & PARENB) {
+			if (cflag & PARODD) {
+				cy_writel(&ch_ctrl->comm_parity, C_PR_ODD);
+			} else {
+				cy_writel(&ch_ctrl->comm_parity, C_PR_EVEN);
+			}
+		} else {
+			cy_writel(&ch_ctrl->comm_parity, C_PR_NONE);
+		}
+
+		/* CTS flow control flag */
+		if (cflag & CRTSCTS) {
+			cy_writel(&ch_ctrl->hw_flow,
+				  cy_readl(&ch_ctrl->
+					   hw_flow) | C_RS_CTS | C_RS_RTS);
+		} else {
+			cy_writel(&ch_ctrl->hw_flow,
+				  cy_readl(&ch_ctrl->
+					   hw_flow) & ~(C_RS_CTS | C_RS_RTS));
+		}
+		/* As the HW flow control is done in firmware, the driver
+		   doesn't need to care about it */
+		info->flags &= ~ASYNC_CTS_FLOW;
+
+		/* XON/XOFF/XANY flow control flags */
+		sw_flow = 0;
+		if (iflag & IXON) {
+			sw_flow |= C_FL_OXX;
+			if (iflag & IXANY)
+				sw_flow |= C_FL_OIXANY;
+		}
+		cy_writel(&ch_ctrl->sw_flow, sw_flow);
+
+		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTL, 0L);
+		if (retval != 0) {
+			printk("cyc:set_line_char retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
+
+		/* CD sensitivity */
+		if (cflag & CLOCAL) {
+			info->flags &= ~ASYNC_CHECK_CD;
+		} else {
+			info->flags |= ASYNC_CHECK_CD;
+		}
+
+		if (baud == 0) {	/* baud rate is zero, turn off line */
+			cy_writel(&ch_ctrl->rs_control,
+				  cy_readl(&ch_ctrl->rs_control) & ~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-	    printk("cyc:set_line_char dropping Z DTR\n");
+			printk("cyc:set_line_char dropping Z DTR\n");
 #endif
-	}else{
-	    cy_writel(&ch_ctrl->rs_control,
-               cy_readl(&ch_ctrl->rs_control) | C_RS_DTR);
+		} else {
+			cy_writel(&ch_ctrl->rs_control,
+				  cy_readl(&ch_ctrl->rs_control) | C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-	    printk("cyc:set_line_char raising Z DTR\n");
+			printk("cyc:set_line_char raising Z DTR\n");
 #endif
-	}
+		}
 
-	retval = cyz_issue_cmd( &cy_card[card], channel, C_CM_IOCTLM, 0L);
-	if (retval != 0){
-	    printk("cyc:set_line_char(2) retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
+		retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_IOCTLM,0L);
+		if (retval != 0) {
+			printk("cyc:set_line_char(2) retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
 
-	if (info->tty){
-	    clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		if (info->tty) {
+			clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		}
 	}
-    }
-} /* set_line_char */
-
+}				/* set_line_char */
 
 static int
-get_serial_info(struct cyclades_port * info,
-                           struct serial_struct __user * retinfo)
+get_serial_info(struct cyclades_port *info,
+		struct serial_struct __user * retinfo)
 {
-  struct serial_struct tmp;
-  struct cyclades_card *cinfo = &cy_card[info->card];
-
-    if (!retinfo)
-            return -EFAULT;
-    memset(&tmp, 0, sizeof(tmp));
-    tmp.type = info->type;
-    tmp.line = info->line;
-    tmp.port = info->card * 0x100 + info->line - cinfo->first_line;
-    tmp.irq = cinfo->irq;
-    tmp.flags = info->flags;
-    tmp.close_delay = info->close_delay;
-    tmp.baud_base = info->baud;
-    tmp.custom_divisor = info->custom_divisor;
-    tmp.hub6 = 0;               /*!!!*/
-    return copy_to_user(retinfo,&tmp,sizeof(*retinfo))?-EFAULT:0;
-} /* get_serial_info */
+	struct serial_struct tmp;
+	struct cyclades_card *cinfo = &cy_card[info->card];
 
+	if (!retinfo)
+		return -EFAULT;
+	memset(&tmp, 0, sizeof(tmp));
+	tmp.type = info->type;
+	tmp.line = info->line;
+	tmp.port = info->card * 0x100 + info->line - cinfo->first_line;
+	tmp.irq = cinfo->irq;
+	tmp.flags = info->flags;
+	tmp.close_delay = info->close_delay;
+	tmp.baud_base = info->baud;
+	tmp.custom_divisor = info->custom_divisor;
+	tmp.hub6 = 0;		/*!!! */
+	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
+}				/* get_serial_info */
 
 static int
-set_serial_info(struct cyclades_port * info,
-                           struct serial_struct __user * new_info)
+set_serial_info(struct cyclades_port *info,
+		struct serial_struct __user * new_info)
 {
-  struct serial_struct new_serial;
-  struct cyclades_port old_info;
+	struct serial_struct new_serial;
+	struct cyclades_port old_info;
+
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+		return -EFAULT;
+	old_info = *info;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (new_serial.close_delay != info->close_delay ||
+				new_serial.baud_base != info->baud ||
+				(new_serial.flags & ASYNC_FLAGS &
+					~ASYNC_USR_MASK) !=
+				(info->flags & ASYNC_FLAGS & ~ASYNC_USR_MASK))
+			return -EPERM;
+		info->flags = (info->flags & ~ASYNC_USR_MASK) |
+				(new_serial.flags & ASYNC_USR_MASK);
+		info->baud = new_serial.baud_base;
+		info->custom_divisor = new_serial.custom_divisor;
+		goto check_and_exit;
+	}
 
-    if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
-	return -EFAULT;
-    old_info = *info;
-
-    if (!capable(CAP_SYS_ADMIN)) {
-            if ((new_serial.close_delay != info->close_delay) ||
-		(new_serial.baud_base != info->baud) ||
-		((new_serial.flags & ASYNC_FLAGS & ~ASYNC_USR_MASK) !=
-		 (info->flags & ASYNC_FLAGS & ~ASYNC_USR_MASK)))
-                    return -EPERM;
-            info->flags = ((info->flags & ~ASYNC_USR_MASK) |
-                           (new_serial.flags & ASYNC_USR_MASK));
-            info->baud = new_serial.baud_base;
-	    info->custom_divisor = new_serial.custom_divisor;
-            goto check_and_exit;
-    }
-
-
-    /*
-     * OK, past this point, all the error checking has been done.
-     * At this point, we start making changes.....
-     */
-
-    info->baud = new_serial.baud_base;
-    info->custom_divisor = new_serial.custom_divisor;
-    info->flags = ((info->flags & ~ASYNC_FLAGS) |
-                    (new_serial.flags & ASYNC_FLAGS));
-    info->close_delay = new_serial.close_delay * HZ/100;
-    info->closing_wait = new_serial.closing_wait * HZ/100;
+	/*
+	 * OK, past this point, all the error checking has been done.
+	 * At this point, we start making changes.....
+	 */
+
+	info->baud = new_serial.baud_base;
+	info->custom_divisor = new_serial.custom_divisor;
+	info->flags = (info->flags & ~ASYNC_FLAGS) |
+			(new_serial.flags & ASYNC_FLAGS);
+	info->close_delay = new_serial.close_delay * HZ / 100;
+	info->closing_wait = new_serial.closing_wait * HZ / 100;
 
 check_and_exit:
-    if (info->flags & ASYNC_INITIALIZED){
-        set_line_char(info);
-        return 0;
-    }else{
-        return startup(info);
-    }
-} /* set_serial_info */
+	if (info->flags & ASYNC_INITIALIZED) {
+		set_line_char(info);
+		return 0;
+	} else {
+		return startup(info);
+	}
+}				/* set_serial_info */
 
 /*
  * get_lsr_info - get line status register info
@@ -3478,441 +3572,452 @@ check_and_exit:
  *	    transmit holding register is empty.  This functionality
  *	    allows an RS485 driver to be written in user space.
  */
-static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
+static int get_lsr_info(struct cyclades_port *info, unsigned int __user * value)
 {
-    int card, chip, channel, index;
-    unsigned char status;
-    unsigned int result;
-    unsigned long flags;
-    void __iomem *base_addr;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	int card, chip, channel, index;
+	unsigned char status;
+	unsigned int result;
+	unsigned long flags;
+	void __iomem *base_addr;
 
-	CY_LOCK(info, flags);
-	status = cy_readb(base_addr+(CySRER<<index)) & (CyTxRdy|CyTxMpty);
-	CY_UNLOCK(info, flags);
-	result = (status ? 0 : TIOCSER_TEMT);
-    } else {
-	/* Not supported yet */
-	return -EINVAL;
-    }
-    return put_user(result, (unsigned long __user *) value);
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+
+		CY_LOCK(info, flags);
+		status = cy_readb(base_addr + (CySRER << index)) &
+				(CyTxRdy | CyTxMpty);
+		CY_UNLOCK(info, flags);
+		result = (status ? 0 : TIOCSER_TEMT);
+	} else {
+		/* Not supported yet */
+		return -EINVAL;
+	}
+	return put_user(result, (unsigned long __user *)value);
 }
 
-static int
-cy_tiocmget(struct tty_struct *tty, struct file *file)
+static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 {
-  struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-  int card,chip,channel,index;
-  void __iomem *base_addr;
-  unsigned long flags;
-  unsigned char status;
-  unsigned long lstatus;
-  unsigned int result;
-  struct FIRM_ID __iomem *firm_id;
-  struct ZFW_CTRL __iomem *zfw_ctrl;
-  struct BOARD_CTRL __iomem *board_ctrl;
-  struct CH_CTRL __iomem *ch_ctrl;
-
-    if (serial_paranoia_check(info, tty->name, __FUNCTION__))
-	return -ENODEV;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	int card, chip, channel, index;
+	void __iomem *base_addr;
+	unsigned long flags;
+	unsigned char status;
+	unsigned long lstatus;
+	unsigned int result;
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
 
-	CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-	    status = cy_readb(base_addr+(CyMSVR1<<index));
-	    status |= cy_readb(base_addr+(CyMSVR2<<index));
-	CY_UNLOCK(info, flags);
+	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+		return -ENODEV;
 
-        if (info->rtsdtr_inv) {
-	    result =  ((status  & CyRTS) ? TIOCM_DTR : 0)
-		    | ((status  & CyDTR) ? TIOCM_RTS : 0);
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCAR << index), (u_char) channel);
+		status = cy_readb(base_addr + (CyMSVR1 << index));
+		status |= cy_readb(base_addr + (CyMSVR2 << index));
+		CY_UNLOCK(info, flags);
+
+		if (info->rtsdtr_inv) {
+			result = ((status & CyRTS) ? TIOCM_DTR : 0) |
+				((status & CyDTR) ? TIOCM_RTS : 0);
+		} else {
+			result = ((status & CyRTS) ? TIOCM_RTS : 0) |
+				((status & CyDTR) ? TIOCM_DTR : 0);
+		}
+		result |= ((status & CyDCD) ? TIOCM_CAR : 0) |
+			((status & CyRI) ? TIOCM_RNG : 0) |
+			((status & CyDSR) ? TIOCM_DSR : 0) |
+			((status & CyCTS) ? TIOCM_CTS : 0);
 	} else {
-	    result =  ((status  & CyRTS) ? TIOCM_RTS : 0)
-		    | ((status  & CyDTR) ? TIOCM_DTR : 0);
-	}
-	result |=  ((status  & CyDCD) ? TIOCM_CAR : 0)
-		 | ((status  & CyRI) ? TIOCM_RNG : 0)
-		 | ((status  & CyDSR) ? TIOCM_DSR : 0)
-		 | ((status  & CyCTS) ? TIOCM_CTS : 0);
-    } else {
-	base_addr = cy_card[card].base_addr;
-
-        if (cy_card[card].num_chips != -1){
-	    return -EINVAL;
-	}
-
-	firm_id = cy_card[card].base_addr + ID_ADDRESS;
-        if (ISZLOADED(cy_card[card])) {
-	    zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	    board_ctrl = &zfw_ctrl->board_ctrl;
-	    ch_ctrl = zfw_ctrl->ch_ctrl;
-	    lstatus = cy_readl(&ch_ctrl[channel].rs_status);
-	    result =  ((lstatus  & C_RS_RTS) ? TIOCM_RTS : 0)
-		    | ((lstatus  & C_RS_DTR) ? TIOCM_DTR : 0)
-	            | ((lstatus  & C_RS_DCD) ? TIOCM_CAR : 0)
-		    | ((lstatus  & C_RS_RI) ? TIOCM_RNG : 0)
-		    | ((lstatus  & C_RS_DSR) ? TIOCM_DSR : 0)
-		    | ((lstatus  & C_RS_CTS) ? TIOCM_CTS : 0);
-	}else{
-	    result = 0;
-	    return -ENODEV;
-	}
-
-    }
-    return result;
-} /* cy_tiomget */
+		base_addr = cy_card[card].base_addr;
 
+		if (cy_card[card].num_chips != -1) {
+			return -EINVAL;
+		}
+
+		firm_id = cy_card[card].base_addr + ID_ADDRESS;
+		if (ISZLOADED(cy_card[card])) {
+			zfw_ctrl = cy_card[card].base_addr +
+				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+			board_ctrl = &zfw_ctrl->board_ctrl;
+			ch_ctrl = zfw_ctrl->ch_ctrl;
+			lstatus = cy_readl(&ch_ctrl[channel].rs_status);
+			result = ((lstatus & C_RS_RTS) ? TIOCM_RTS : 0) |
+				((lstatus & C_RS_DTR) ? TIOCM_DTR : 0) |
+				((lstatus & C_RS_DCD) ? TIOCM_CAR : 0) |
+				((lstatus & C_RS_RI) ? TIOCM_RNG : 0) |
+				((lstatus & C_RS_DSR) ? TIOCM_DSR : 0) |
+				((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
+		} else {
+			result = 0;
+			return -ENODEV;
+		}
+
+	}
+	return result;
+}				/* cy_tiomget */
 
 static int
 cy_tiocmset(struct tty_struct *tty, struct file *file,
-            unsigned int set, unsigned int clear)
+		unsigned int set, unsigned int clear)
 {
-  struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-  int card,chip,channel,index;
-  void __iomem *base_addr;
-  unsigned long flags;
-  struct FIRM_ID __iomem *firm_id;
-  struct ZFW_CTRL __iomem *zfw_ctrl;
-  struct BOARD_CTRL __iomem *board_ctrl;
-  struct CH_CTRL __iomem *ch_ctrl;
-  int retval;
-
-    if (serial_paranoia_check(info, tty->name, __FUNCTION__))
-	return -ENODEV;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	int card, chip, channel, index;
+	void __iomem *base_addr;
+	unsigned long flags;
+	struct FIRM_ID __iomem *firm_id;
+	struct ZFW_CTRL __iomem *zfw_ctrl;
+	struct BOARD_CTRL __iomem *board_ctrl;
+	struct CH_CTRL __iomem *ch_ctrl;
+	int retval;
 
-	if (set & TIOCM_RTS){
-		CY_LOCK(info, flags);
-	        cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-                if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
-                } else {
-			cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-                }
-		CY_UNLOCK(info, flags);
-	}
-	if (clear & TIOCM_RTS) {
-		CY_LOCK(info, flags);
-		cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-                if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR2<<index), ~CyDTR);
-                } else {
-			cy_writeb(base_addr+(CyMSVR1<<index), ~CyRTS);
-                }
-		CY_UNLOCK(info, flags);
-	}
-	if (set & TIOCM_DTR){
-		CY_LOCK(info, flags);
-		cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-                if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-                } else {
-			cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
-                }
+	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+		return -ENODEV;
+
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+
+		if (set & TIOCM_RTS) {
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  CyDTR);
+			} else {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  CyRTS);
+			}
+			CY_UNLOCK(info, flags);
+		}
+		if (clear & TIOCM_RTS) {
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  ~CyDTR);
+			} else {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  ~CyRTS);
+			}
+			CY_UNLOCK(info, flags);
+		}
+		if (set & TIOCM_DTR) {
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  CyRTS);
+			} else {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  CyDTR);
+			}
 #ifdef CY_DEBUG_DTR
-		printk("cyc:set_modem_info raising DTR\n");
-		printk("     status: 0x%x, 0x%x\n",
-		    cy_readb(base_addr+(CyMSVR1<<index)), 
-                    cy_readb(base_addr+(CyMSVR2<<index)));
+			printk("cyc:set_modem_info raising DTR\n");
+			printk("     status: 0x%x, 0x%x\n",
+				cy_readb(base_addr + (CyMSVR1 << index)),
+				cy_readb(base_addr + (CyMSVR2 << index)));
 #endif
-		CY_UNLOCK(info, flags);
-	}
-	if (clear & TIOCM_DTR) {
-		CY_LOCK(info, flags);
-		cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-                if (info->rtsdtr_inv) {
-			cy_writeb(base_addr+(CyMSVR1<<index), ~CyRTS);
-                } else {
-			cy_writeb(base_addr+(CyMSVR2<<index), ~CyDTR);
-                }
+			CY_UNLOCK(info, flags);
+		}
+		if (clear & TIOCM_DTR) {
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  ~CyRTS);
+			} else {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  ~CyDTR);
+			}
 
 #ifdef CY_DEBUG_DTR
-		printk("cyc:set_modem_info dropping DTR\n");
-		printk("     status: 0x%x, 0x%x\n",
-		    cy_readb(base_addr+(CyMSVR1<<index)), 
-                    cy_readb(base_addr+(CyMSVR2<<index)));
+			printk("cyc:set_modem_info dropping DTR\n");
+			printk("     status: 0x%x, 0x%x\n",
+				cy_readb(base_addr + (CyMSVR1 << index)),
+				cy_readb(base_addr + (CyMSVR2 << index)));
 #endif
-		CY_UNLOCK(info, flags);
-	}
-    } else {
-	base_addr = cy_card[card].base_addr;
+			CY_UNLOCK(info, flags);
+		}
+	} else {
+		base_addr = cy_card[card].base_addr;
 
-	firm_id = cy_card[card].base_addr + ID_ADDRESS;
-        if (ISZLOADED(cy_card[card])) {
-	    zfw_ctrl = cy_card[card].base_addr + (cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
-	    board_ctrl = &zfw_ctrl->board_ctrl;
-	    ch_ctrl = zfw_ctrl->ch_ctrl;
-
-	    if (set & TIOCM_RTS){
-		    CY_LOCK(info, flags);
-		    cy_writel(&ch_ctrl[channel].rs_control,
-                       cy_readl(&ch_ctrl[channel].rs_control) | C_RS_RTS);
-		    CY_UNLOCK(info, flags);
-	    }
-	    if (clear & TIOCM_RTS) {
-		    CY_LOCK(info, flags);
-		    cy_writel(&ch_ctrl[channel].rs_control,
-                       cy_readl(&ch_ctrl[channel].rs_control) & ~C_RS_RTS);
-		    CY_UNLOCK(info, flags);
-	    }
-	    if (set & TIOCM_DTR){
-		    CY_LOCK(info, flags);
-		    cy_writel(&ch_ctrl[channel].rs_control,
-                       cy_readl(&ch_ctrl[channel].rs_control) | C_RS_DTR);
+		firm_id = cy_card[card].base_addr + ID_ADDRESS;
+		if (ISZLOADED(cy_card[card])) {
+			zfw_ctrl = cy_card[card].base_addr +
+				(cy_readl(&firm_id->zfwctrl_addr) & 0xfffff);
+			board_ctrl = &zfw_ctrl->board_ctrl;
+			ch_ctrl = zfw_ctrl->ch_ctrl;
+
+			if (set & TIOCM_RTS) {
+				CY_LOCK(info, flags);
+				cy_writel(&ch_ctrl[channel].rs_control,
+					  cy_readl(&ch_ctrl[channel].
+						   rs_control) | C_RS_RTS);
+				CY_UNLOCK(info, flags);
+			}
+			if (clear & TIOCM_RTS) {
+				CY_LOCK(info, flags);
+				cy_writel(&ch_ctrl[channel].rs_control,
+					  cy_readl(&ch_ctrl[channel].
+						   rs_control) & ~C_RS_RTS);
+				CY_UNLOCK(info, flags);
+			}
+			if (set & TIOCM_DTR) {
+				CY_LOCK(info, flags);
+				cy_writel(&ch_ctrl[channel].rs_control,
+					  cy_readl(&ch_ctrl[channel].
+						   rs_control) | C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-		    printk("cyc:set_modem_info raising Z DTR\n");
+				printk("cyc:set_modem_info raising Z DTR\n");
 #endif
-		    CY_UNLOCK(info, flags);
-	    }
-	    if (clear & TIOCM_DTR) {
-		    CY_LOCK(info, flags);
-		    cy_writel(&ch_ctrl[channel].rs_control,
-                       cy_readl(&ch_ctrl[channel].rs_control) & ~C_RS_DTR);
+				CY_UNLOCK(info, flags);
+			}
+			if (clear & TIOCM_DTR) {
+				CY_LOCK(info, flags);
+				cy_writel(&ch_ctrl[channel].rs_control,
+					  cy_readl(&ch_ctrl[channel].
+						   rs_control) & ~C_RS_DTR);
 #ifdef CY_DEBUG_DTR
-		    printk("cyc:set_modem_info clearing Z DTR\n");
+				printk("cyc:set_modem_info clearing Z DTR\n");
 #endif
-		    CY_UNLOCK(info, flags);
-	    }
-	}else{
-	    return -ENODEV;
-	}
-	CY_LOCK(info, flags);
-        retval = cyz_issue_cmd(&cy_card[info->card],
-				    channel, C_CM_IOCTLM,0L);
-	if (retval != 0){
-	    printk("cyc:set_modem_info retval on ttyC%d was %x\n",
-		   info->line, retval);
+				CY_UNLOCK(info, flags);
+			}
+		} else {
+			return -ENODEV;
+		}
+		CY_LOCK(info, flags);
+		retval = cyz_issue_cmd(&cy_card[info->card],
+					channel, C_CM_IOCTLM, 0L);
+		if (retval != 0) {
+			printk("cyc:set_modem_info retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
+		CY_UNLOCK(info, flags);
 	}
-	CY_UNLOCK(info, flags);
-    }
-    return 0;
-} /* cy_tiocmset */
+	return 0;
+}				/* cy_tiocmset */
 
 /*
  * cy_break() --- routine which turns the break handling on or off
  */
-static void
-cy_break(struct tty_struct *tty, int break_state)
+static void cy_break(struct tty_struct *tty, int break_state)
 {
-    struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-    unsigned long flags;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
 
-    if (serial_paranoia_check(info, tty->name, "cy_break"))
-	return;
+	if (serial_paranoia_check(info, tty->name, "cy_break"))
+		return;
 
-    CY_LOCK(info, flags);
-    if (!IS_CYC_Z(cy_card[info->card])) {
-        /* Let the transmit ISR take care of this (since it
-	   requires stuffing characters into the output stream).
-        */
-	if (break_state == -1) {
-	    if (!info->breakon) {
-		info->breakon = 1;
-		if (!info->xmit_cnt) {
-		    CY_UNLOCK(info, flags);
-		    start_xmit(info);
-		    CY_LOCK(info, flags);
+	CY_LOCK(info, flags);
+	if (!IS_CYC_Z(cy_card[info->card])) {
+		/* Let the transmit ISR take care of this (since it
+		   requires stuffing characters into the output stream).
+		 */
+		if (break_state == -1) {
+			if (!info->breakon) {
+				info->breakon = 1;
+				if (!info->xmit_cnt) {
+					CY_UNLOCK(info, flags);
+					start_xmit(info);
+					CY_LOCK(info, flags);
+				}
+			}
+		} else {
+			if (!info->breakoff) {
+				info->breakoff = 1;
+				if (!info->xmit_cnt) {
+					CY_UNLOCK(info, flags);
+					start_xmit(info);
+					CY_LOCK(info, flags);
+				}
+			}
 		}
-	    }
 	} else {
-	    if (!info->breakoff) {
-		info->breakoff = 1;
-		if (!info->xmit_cnt) {
-		    CY_UNLOCK(info, flags);
-		    start_xmit(info);
-		    CY_LOCK(info, flags);
+		int retval;
+
+		if (break_state == -1) {
+			retval = cyz_issue_cmd(&cy_card[info->card],
+				info->line - cy_card[info->card].first_line,
+				C_CM_SET_BREAK, 0L);
+			if (retval != 0) {
+				printk("cyc:cy_break (set) retval on ttyC%d "
+					"was %x\n", info->line, retval);
+			}
+		} else {
+			retval = cyz_issue_cmd(&cy_card[info->card],
+				info->line - cy_card[info->card].first_line,
+				C_CM_CLR_BREAK, 0L);
+			if (retval != 0) {
+				printk("cyc:cy_break (clr) retval on ttyC%d "
+					"was %x\n", info->line, retval);
+			}
 		}
-	    }
 	}
-    } else {
-	int retval;
-
-	if (break_state == -1) {
-	    retval = cyz_issue_cmd(&cy_card[info->card],
-		(info->line) - (cy_card[info->card].first_line),
-		C_CM_SET_BREAK, 0L);
-	    if (retval != 0) {
-		printk("cyc:cy_break (set) retval on ttyC%d was %x\n",
-		       info->line, retval);
-	    }
-	} else {
-	    retval = cyz_issue_cmd(&cy_card[info->card],
-		(info->line) - (cy_card[info->card].first_line),
-		C_CM_CLR_BREAK, 0L);
-	    if (retval != 0) {
-		printk("cyc:cy_break (clr) retval on ttyC%d was %x\n",
-		       info->line, retval);
-	    }
-	}
-    }
-    CY_UNLOCK(info, flags);
-} /* cy_break */
+	CY_UNLOCK(info, flags);
+}				/* cy_break */
 
 static int
-get_mon_info(struct cyclades_port * info, struct cyclades_monitor __user * mon)
+get_mon_info(struct cyclades_port *info, struct cyclades_monitor __user * mon)
 {
 
-    if(copy_to_user(mon, &info->mon, sizeof(struct cyclades_monitor)))
-    	return -EFAULT;
-    info->mon.int_count  = 0;
-    info->mon.char_count = 0;
-    info->mon.char_max   = 0;
-    info->mon.char_last  = 0;
-    return 0;
-}/* get_mon_info */
-
+	if (copy_to_user(mon, &info->mon, sizeof(struct cyclades_monitor)))
+		return -EFAULT;
+	info->mon.int_count = 0;
+	info->mon.char_count = 0;
+	info->mon.char_max = 0;
+	info->mon.char_last = 0;
+	return 0;
+}				/* get_mon_info */
 
-static int
-set_threshold(struct cyclades_port * info, unsigned long value)
+static int set_threshold(struct cyclades_port *info, unsigned long value)
 {
-  void __iomem *base_addr;
-  int card,channel,chip,index;
-  unsigned long flags;
-   
-    card = info->card;
-    channel = info->line - cy_card[card].first_line;
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	void __iomem *base_addr;
+	int card, channel, chip, index;
+	unsigned long flags;
 
-	info->cor3 &= ~CyREC_FIFO;
-	info->cor3 |= value & CyREC_FIFO;
+	card = info->card;
+	channel = info->line - cy_card[card].first_line;
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
-	CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyCOR3<<index), info->cor3);
-	    cyy_issue_cmd(base_addr,CyCOR_CHANGE|CyCOR3ch,index);
-	CY_UNLOCK(info, flags);
-    } else {
-	// Nothing to do!
-    }
-    return 0;
-}/* set_threshold */
+		info->cor3 &= ~CyREC_FIFO;
+		info->cor3 |= value & CyREC_FIFO;
 
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCOR3 << index), info->cor3);
+		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR3ch, index);
+		CY_UNLOCK(info, flags);
+	} else {
+		// Nothing to do!
+	}
+	return 0;
+}				/* set_threshold */
 
 static int
-get_threshold(struct cyclades_port * info, unsigned long __user *value)
+get_threshold(struct cyclades_port *info, unsigned long __user * value)
 {
-  void __iomem *base_addr;
-  int card,channel,chip,index;
-  unsigned long tmp;
-   
-    card = info->card;
-    channel = info->line - cy_card[card].first_line;
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
-
-	tmp = cy_readb(base_addr+(CyCOR3<<index)) & CyREC_FIFO;
-	return put_user(tmp,value);
-    } else {
-	// Nothing to do!
-	return 0;
-    }
-}/* get_threshold */
+	void __iomem *base_addr;
+	int card, channel, chip, index;
+	unsigned long tmp;
 
+	card = info->card;
+	channel = info->line - cy_card[card].first_line;
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
+
+		tmp = cy_readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
+		return put_user(tmp, value);
+	} else {
+		// Nothing to do!
+		return 0;
+	}
+}				/* get_threshold */
 
 static int
-set_default_threshold(struct cyclades_port * info, unsigned long value)
+set_default_threshold(struct cyclades_port *info, unsigned long value)
 {
-    info->default_threshold = value & 0x0f;
-    return 0;
-}/* set_default_threshold */
-
+	info->default_threshold = value & 0x0f;
+	return 0;
+}				/* set_default_threshold */
 
 static int
-get_default_threshold(struct cyclades_port * info, unsigned long __user *value)
+get_default_threshold(struct cyclades_port *info, unsigned long __user * value)
 {
-    return put_user(info->default_threshold,value);
-}/* get_default_threshold */
+	return put_user(info->default_threshold, value);
+}				/* get_default_threshold */
 
-
-static int
-set_timeout(struct cyclades_port * info, unsigned long value)
+static int set_timeout(struct cyclades_port *info, unsigned long value)
 {
-  void __iomem *base_addr;
-  int card,channel,chip,index;
-  unsigned long flags;
-   
-    card = info->card;
-    channel = info->line - cy_card[card].first_line;
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
+	void __iomem *base_addr;
+	int card, channel, chip, index;
+	unsigned long flags;
 
-	CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyRTPR<<index), value & 0xff);
-	CY_UNLOCK(info, flags);
-    } else {
-	// Nothing to do!
-    }
-    return 0;
-}/* set_timeout */
+	card = info->card;
+	channel = info->line - cy_card[card].first_line;
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
+		CY_UNLOCK(info, flags);
+	} else {
+		// Nothing to do!
+	}
+	return 0;
+}				/* set_timeout */
 
-static int
-get_timeout(struct cyclades_port * info, unsigned long __user *value)
+static int get_timeout(struct cyclades_port *info, unsigned long __user * value)
 {
-  void __iomem *base_addr;
-  int card,channel,chip,index;
-  unsigned long tmp;
-   
-    card = info->card;
-    channel = info->line - cy_card[card].first_line;
-    if (!IS_CYC_Z(cy_card[card])) {
-	chip = channel>>2;
-	channel &= 0x03;
-	index = cy_card[card].bus_index;
-	base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
-
-	tmp = cy_readb(base_addr+(CyRTPR<<index));
-	return put_user(tmp,value);
-    } else {
-	// Nothing to do!
-	return 0;
-    }
-}/* get_timeout */
+	void __iomem *base_addr;
+	int card, channel, chip, index;
+	unsigned long tmp;
 
+	card = info->card;
+	channel = info->line - cy_card[card].first_line;
+	if (!IS_CYC_Z(cy_card[card])) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		index = cy_card[card].bus_index;
+		base_addr =
+		    cy_card[card].base_addr + (cy_chip_offset[chip] << index);
 
-static int
-set_default_timeout(struct cyclades_port * info, unsigned long value)
-{
-    info->default_timeout = value & 0xff;
-    return 0;
-}/* set_default_timeout */
+		tmp = cy_readb(base_addr + (CyRTPR << index));
+		return put_user(tmp, value);
+	} else {
+		// Nothing to do!
+		return 0;
+	}
+}				/* get_timeout */
 
+static int set_default_timeout(struct cyclades_port *info, unsigned long value)
+{
+	info->default_timeout = value & 0xff;
+	return 0;
+}				/* set_default_timeout */
 
 static int
-get_default_timeout(struct cyclades_port * info, unsigned long __user *value)
+get_default_timeout(struct cyclades_port *info, unsigned long __user * value)
 {
-    return put_user(info->default_timeout,value);
-}/* get_default_timeout */
+	return put_user(info->default_timeout, value);
+}				/* get_default_timeout */
 
 /*
  * This routine allows the tty driver to implement device-
@@ -3920,184 +4025,193 @@ get_default_timeout(struct cyclades_port
  * not recognized by the driver, it should return ENOIOCTLCMD.
  */
 static int
-cy_ioctl(struct tty_struct *tty, struct file * file,
-            unsigned int cmd, unsigned long arg)
+cy_ioctl(struct tty_struct *tty, struct file *file,
+	 unsigned int cmd, unsigned long arg)
 {
-  struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-  struct cyclades_icount cprev, cnow;		/* kernel counter temps */
-  struct serial_icounter_struct __user *p_cuser;	/* user space */
-  int ret_val = 0;
-  unsigned long flags;
-  void __user *argp = (void __user *)arg;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_icount cprev, cnow;	/* kernel counter temps */
+	struct serial_icounter_struct __user *p_cuser;	/* user space */
+	int ret_val = 0;
+	unsigned long flags;
+	void __user *argp = (void __user *)arg;
 
-    if (serial_paranoia_check(info, tty->name, "cy_ioctl"))
-	return -ENODEV;
+	if (serial_paranoia_check(info, tty->name, "cy_ioctl"))
+		return -ENODEV;
 
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
-        info->line, cmd, arg); /* */
+	printk("cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n", info->line, cmd, arg);	/* */
 #endif
 
-    switch (cmd) {
-        case CYGETMON:
-            ret_val = get_mon_info(info, argp);
-            break;
-        case CYGETTHRESH:
-            ret_val = get_threshold(info, argp);
-            break;
-        case CYSETTHRESH:
-            ret_val = set_threshold(info, arg);
-            break;
-        case CYGETDEFTHRESH:
-            ret_val = get_default_threshold(info, argp);
-            break;
-        case CYSETDEFTHRESH:
-            ret_val = set_default_threshold(info, arg);
-            break;
-        case CYGETTIMEOUT:
-            ret_val = get_timeout(info, argp);
-            break;
-        case CYSETTIMEOUT:
-            ret_val = set_timeout(info, arg);
-            break;
-        case CYGETDEFTIMEOUT:
-            ret_val = get_default_timeout(info, argp);
-            break;
-        case CYSETDEFTIMEOUT:
-            ret_val = set_default_timeout(info, arg);
-            break;
+	switch (cmd) {
+	case CYGETMON:
+		ret_val = get_mon_info(info, argp);
+		break;
+	case CYGETTHRESH:
+		ret_val = get_threshold(info, argp);
+		break;
+	case CYSETTHRESH:
+		ret_val = set_threshold(info, arg);
+		break;
+	case CYGETDEFTHRESH:
+		ret_val = get_default_threshold(info, argp);
+		break;
+	case CYSETDEFTHRESH:
+		ret_val = set_default_threshold(info, arg);
+		break;
+	case CYGETTIMEOUT:
+		ret_val = get_timeout(info, argp);
+		break;
+	case CYSETTIMEOUT:
+		ret_val = set_timeout(info, arg);
+		break;
+	case CYGETDEFTIMEOUT:
+		ret_val = get_default_timeout(info, argp);
+		break;
+	case CYSETDEFTIMEOUT:
+		ret_val = set_default_timeout(info, arg);
+		break;
 	case CYSETRFLOW:
-    	    info->rflow = (int)arg;
-	    ret_val = 0;
-	    break;
+		info->rflow = (int)arg;
+		ret_val = 0;
+		break;
 	case CYGETRFLOW:
-	    ret_val = info->rflow;
-	    break;
+		ret_val = info->rflow;
+		break;
 	case CYSETRTSDTR_INV:
-    	    info->rtsdtr_inv = (int)arg;
-	    ret_val = 0;
-	    break;
+		info->rtsdtr_inv = (int)arg;
+		ret_val = 0;
+		break;
 	case CYGETRTSDTR_INV:
-	    ret_val = info->rtsdtr_inv;
-	    break;
+		ret_val = info->rtsdtr_inv;
+		break;
 	case CYGETCARDINFO:
-            if (copy_to_user(argp, &cy_card[info->card], 
-			sizeof (struct cyclades_card))) {
-		ret_val = -EFAULT;
+		if (copy_to_user(argp, &cy_card[info->card],
+				 sizeof(struct cyclades_card))) {
+			ret_val = -EFAULT;
+			break;
+		}
+		ret_val = 0;
 		break;
-	    }
-	    ret_val = 0;
-            break;
 	case CYGETCD1400VER:
-	    ret_val = info->chip_rev;
-	    break;
+		ret_val = info->chip_rev;
+		break;
 #ifndef CONFIG_CYZ_INTR
 	case CYZSETPOLLCYCLE:
-            cyz_polling_cycle = (arg * HZ) / 1000;
-	    ret_val = 0;
-	    break;
+		cyz_polling_cycle = (arg * HZ) / 1000;
+		ret_val = 0;
+		break;
 	case CYZGETPOLLCYCLE:
-            ret_val = (cyz_polling_cycle * 1000) / HZ;
-	    break;
-#endif /* CONFIG_CYZ_INTR */
+		ret_val = (cyz_polling_cycle * 1000) / HZ;
+		break;
+#endif				/* CONFIG_CYZ_INTR */
 	case CYSETWAIT:
-    	    info->closing_wait = (unsigned short)arg * HZ/100;
-	    ret_val = 0;
-	    break;
+		info->closing_wait = (unsigned short)arg *HZ / 100;
+		ret_val = 0;
+		break;
 	case CYGETWAIT:
-	    ret_val = info->closing_wait / (HZ/100);
-	    break;
-        case TIOCGSERIAL:
-            ret_val = get_serial_info(info, argp);
-            break;
-        case TIOCSSERIAL:
-            ret_val = set_serial_info(info, argp);
-            break;
-	case TIOCSERGETLSR: /* Get line status register */
-	    ret_val = get_lsr_info(info, argp);
-	    break;
-	/*
-	 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change 
-	 * - mask passed in arg for lines of interest
-	 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
-	 * Caller should use TIOCGICOUNT to see which one it was
-	 */
+		ret_val = info->closing_wait / (HZ / 100);
+		break;
+	case TIOCGSERIAL:
+		ret_val = get_serial_info(info, argp);
+		break;
+	case TIOCSSERIAL:
+		ret_val = set_serial_info(info, argp);
+		break;
+	case TIOCSERGETLSR:	/* Get line status register */
+		ret_val = get_lsr_info(info, argp);
+		break;
+		/*
+		 * Wait for any of the 4 modem inputs (DCD,RI,DSR,CTS) to change
+		 * - mask passed in arg for lines of interest
+		 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
+		 * Caller should use TIOCGICOUNT to see which one it was
+		 */
 	case TIOCMIWAIT:
-	    CY_LOCK(info, flags);
-	    /* note the counters on entry */
-	    cprev = info->icount;
-	    CY_UNLOCK(info, flags);
-	    while (1) {
-		interruptible_sleep_on(&info->delta_msr_wait);
-		/* see if a signal did it */
-		if (signal_pending(current)) {
-		    return -ERESTARTSYS;
-		}
-
 		CY_LOCK(info, flags);
-		cnow = info->icount; /* atomic copy */
+		/* note the counters on entry */
+		cprev = info->icount;
 		CY_UNLOCK(info, flags);
+		while (1) {
+			interruptible_sleep_on(&info->delta_msr_wait);
+			/* see if a signal did it */
+			if (signal_pending(current)) {
+				return -ERESTARTSYS;
+			}
 
-		if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
-		    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-		    return -EIO; /* no change => error */
-		}
-		if ( ((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) || 
-		     ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) || 
-		     ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) || 
-		     ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
-		    return 0;
-		}
-		cprev = cnow;
-	    }
-	    /* NOTREACHED */
+			CY_LOCK(info, flags);
+			cnow = info->icount;	/* atomic copy */
+			CY_UNLOCK(info, flags);
 
-	/*
-	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-	 * Return: write counters to the user passed counter struct
-	 * NB: both 1->0 and 0->1 transitions are counted except for
-	 *     RI where only 0->1 is counted.
-	 */
+			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
+				return -EIO;	/* no change => error */
+			}
+			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			    ((arg & TIOCM_CD) && (cnow.dcd != cprev.dcd)) ||
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
+				return 0;
+			}
+			cprev = cnow;
+		}
+		/* NOTREACHED */
+
+		/*
+		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+		 * Return: write counters to the user passed counter struct
+		 * NB: both 1->0 and 0->1 transitions are counted except for
+		 *     RI where only 0->1 is counted.
+		 */
 	case TIOCGICOUNT:
-	    CY_LOCK(info, flags);
-	    cnow = info->icount;
-	    CY_UNLOCK(info, flags);
-	    p_cuser = argp;
-	    ret_val = put_user(cnow.cts, &p_cuser->cts);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.dsr, &p_cuser->dsr);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.rng, &p_cuser->rng);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.dcd, &p_cuser->dcd);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.rx, &p_cuser->rx);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.tx, &p_cuser->tx);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.frame, &p_cuser->frame);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.overrun, &p_cuser->overrun);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.parity, &p_cuser->parity);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.brk, &p_cuser->brk);
-	    if (ret_val) return ret_val;
-	    ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
-	    if (ret_val) return ret_val;
-	    ret_val = 0;
-	    break;
-        default:
-            ret_val = -ENOIOCTLCMD;
-    }
+		CY_LOCK(info, flags);
+		cnow = info->icount;
+		CY_UNLOCK(info, flags);
+		p_cuser = argp;
+		ret_val = put_user(cnow.cts, &p_cuser->cts);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.rng, &p_cuser->rng);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.rx, &p_cuser->rx);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.tx, &p_cuser->tx);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.frame, &p_cuser->frame);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.parity, &p_cuser->parity);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.brk, &p_cuser->brk);
+		if (ret_val)
+			return ret_val;
+		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
+		if (ret_val)
+			return ret_val;
+		ret_val = 0;
+		break;
+	default:
+		ret_val = -ENOIOCTLCMD;
+	}
 
 #ifdef CY_DEBUG_OTHER
-    printk(" cyc:cy_ioctl done\n");
+	printk(" cyc:cy_ioctl done\n");
 #endif
 
-    return ret_val;
-} /* cy_ioctl */
-
+	return ret_val;
+}				/* cy_ioctl */
 
 /*
  * This routine allows the tty driver to be notified when
@@ -4105,66 +4219,66 @@ cy_ioctl(struct tty_struct *tty, struct 
  * well-designed tty driver should be prepared to accept the case
  * where old == NULL, and try to do something rational.
  */
-static void
-cy_set_termios(struct tty_struct *tty, struct ktermios * old_termios)
+static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_set_termios ttyC%d\n", info->line);
+	printk("cyc:cy_set_termios ttyC%d\n", info->line);
 #endif
 
-    if ((tty->termios->c_cflag == old_termios->c_cflag) &&
-	((tty->termios->c_iflag & (IXON|IXANY)) == 
-	 (old_termios->c_iflag & (IXON|IXANY))))
-        return;
-    set_line_char(info);
-
-    if ((old_termios->c_cflag & CRTSCTS) &&
-        !(tty->termios->c_cflag & CRTSCTS)) {
-            tty->hw_stopped = 0;
-            cy_start(tty);
-    }
+	if (tty->termios->c_cflag == old_termios->c_cflag &&
+			(tty->termios->c_iflag & (IXON | IXANY)) ==
+			(old_termios->c_iflag & (IXON | IXANY)))
+		return;
+	set_line_char(info);
+
+	if ((old_termios->c_cflag & CRTSCTS) &&
+			!(tty->termios->c_cflag & CRTSCTS)) {
+		tty->hw_stopped = 0;
+		cy_start(tty);
+	}
 #if 0
-    /*
-     * No need to wake up processes in open wait, since they
-     * sample the CLOCAL flag once, and don't recheck it.
-     * XXX  It's not clear whether the current behavior is correct
-     * or not.  Hence, this may change.....
-     */
-    if (!(old_termios->c_cflag & CLOCAL) &&
-        (tty->termios->c_cflag & CLOCAL))
-            wake_up_interruptible(&info->open_wait);
+	/*
+	 * No need to wake up processes in open wait, since they
+	 * sample the CLOCAL flag once, and don't recheck it.
+	 * XXX  It's not clear whether the current behavior is correct
+	 * or not.  Hence, this may change.....
+	 */
+	if (!(old_termios->c_cflag & CLOCAL) &&
+	    (tty->termios->c_cflag & CLOCAL))
+		wake_up_interruptible(&info->open_wait);
 #endif
 
-    return;
-} /* cy_set_termios */
+	return;
+}				/* cy_set_termios */
 
 /* This function is used to send a high-priority XON/XOFF character to
    the device.
 */
-static void
-cy_send_xchar (struct tty_struct *tty, char ch)
+static void cy_send_xchar(struct tty_struct *tty, char ch)
 {
-	struct cyclades_port *info = (struct cyclades_port *) tty->driver_data;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 	int card, channel;
 
-	if (serial_paranoia_check (info, tty->name, "cy_send_xchar"))
+	if (serial_paranoia_check(info, tty->name, "cy_send_xchar"))
 		return;
 
-  	info->x_char = ch;
+	info->x_char = ch;
 
 	if (ch)
-		cy_start (tty);
+		cy_start(tty);
 
 	card = info->card;
 	channel = info->line - cy_card[card].first_line;
 
-	if (IS_CYC_Z (cy_card[card])) {
-		if (ch == STOP_CHAR (tty))
-	  		cyz_issue_cmd (&cy_card[card], channel, C_CM_SENDXOFF, 0L);
-		else if (ch == START_CHAR (tty))
-			cyz_issue_cmd (&cy_card[card], channel, C_CM_SENDXON, 0L);
+	if (IS_CYC_Z(cy_card[card])) {
+		if (ch == STOP_CHAR(tty))
+			cyz_issue_cmd(&cy_card[card], channel, C_CM_SENDXOFF,
+					0L);
+		else if (ch == START_CHAR(tty))
+			cyz_issue_cmd(&cy_card[card], channel, C_CM_SENDXON,
+					0L);
 	}
 }
 
@@ -4172,260 +4286,256 @@ cy_send_xchar (struct tty_struct *tty, c
    that incoming characters should be throttled because the input
    buffers are close to full.
  */
-static void
-cy_throttle(struct tty_struct * tty)
+static void cy_throttle(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  unsigned long flags;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
-  char buf[64];
+	char buf[64];
 
-    printk("cyc:throttle %s: %d....ttyC%d\n", 
-	   tty_name(tty, buf),
-           tty->ldisc.chars_in_buffer(tty), info->line);
-#endif
-
-    if (serial_paranoia_check(info, tty->name, "cy_throttle")){
-            return;
-    }
-
-    card = info->card;
-
-    if (I_IXOFF(tty)) {
-        if (!IS_CYC_Z (cy_card[card]))
-            cy_send_xchar (tty, STOP_CHAR (tty));
-        else
-            info->throttle = 1;
-    }
-
-    if (tty->termios->c_cflag & CRTSCTS) {
-        channel = info->line - cy_card[card].first_line;
-        if (!IS_CYC_Z(cy_card[card])) {
-            chip = channel>>2;
-            channel &= 0x03;
-            index = cy_card[card].bus_index;
-            base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
-
-            CY_LOCK(info, flags);
-            cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-            if (info->rtsdtr_inv) {
-                cy_writeb(base_addr+(CyMSVR2<<index), ~CyDTR);
-             } else {
-                cy_writeb(base_addr+(CyMSVR1<<index), ~CyRTS);
-	     }
-	    CY_UNLOCK(info, flags);
-	} else {
-	    info->throttle = 1;
-        }
-    }
+	printk("cyc:throttle %s: %d....ttyC%d\n", tty_name(tty, buf),
+			tty->ldisc.chars_in_buffer(tty), info->line);
+#endif
+
+	if (serial_paranoia_check(info, tty->name, "cy_throttle")) {
+		return;
+	}
+
+	card = info->card;
+
+	if (I_IXOFF(tty)) {
+		if (!IS_CYC_Z(cy_card[card]))
+			cy_send_xchar(tty, STOP_CHAR(tty));
+		else
+			info->throttle = 1;
+	}
 
-    return;
-} /* cy_throttle */
+	if (tty->termios->c_cflag & CRTSCTS) {
+		channel = info->line - cy_card[card].first_line;
+		if (!IS_CYC_Z(cy_card[card])) {
+			chip = channel >> 2;
+			channel &= 0x03;
+			index = cy_card[card].bus_index;
+			base_addr = cy_card[card].base_addr +
+				(cy_chip_offset[chip] << index);
+
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  ~CyDTR);
+			} else {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  ~CyRTS);
+			}
+			CY_UNLOCK(info, flags);
+		} else {
+			info->throttle = 1;
+		}
+	}
 
+	return;
+}				/* cy_throttle */
 
 /*
  * This routine notifies the tty driver that it should signal
  * that characters can now be sent to the tty without fear of
  * overrunning the input buffers of the line disciplines.
  */
-static void
-cy_unthrottle(struct tty_struct * tty)
+static void cy_unthrottle(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  unsigned long flags;
-  void __iomem *base_addr;
-  int card,chip,channel,index;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	unsigned long flags;
+	void __iomem *base_addr;
+	int card, chip, channel, index;
 
 #ifdef CY_DEBUG_THROTTLE
-  char buf[64];
-        
-    printk("cyc:unthrottle %s: %d....ttyC%d\n", 
-	   tty_name(tty, buf),
-           tty->ldisc.chars_in_buffer(tty), info->line);
+	char buf[64];
+
+	printk("cyc:unthrottle %s: %d....ttyC%d\n", tty_name(tty, buf),
+		tty->ldisc.chars_in_buffer(tty), info->line);
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_unthrottle")){
-            return;
-    }
-
-    if (I_IXOFF(tty)) {
-	if (info->x_char)
-	    info->x_char = 0;
-	else
-	    cy_send_xchar (tty, START_CHAR (tty));
-    }
+	if (serial_paranoia_check(info, tty->name, "cy_unthrottle")) {
+		return;
+	}
 
-    if (tty->termios->c_cflag & CRTSCTS) {
-        card = info->card;
-        channel = info->line - cy_card[card].first_line;
-        if (!IS_CYC_Z(cy_card[card])) {
-	    chip = channel>>2;
-	    channel &= 0x03;
-	    index = cy_card[card].bus_index;
-	    base_addr = cy_card[card].base_addr + (cy_chip_offset[chip]<<index);
-
-	    CY_LOCK(info, flags);
-	    cy_writeb(base_addr+(CyCAR<<index), (u_char)channel);
-	    if (info->rtsdtr_inv) {
-		    cy_writeb(base_addr+(CyMSVR2<<index), CyDTR);
-	    } else {
-		    cy_writeb(base_addr+(CyMSVR1<<index), CyRTS);
-	    }
-	    CY_UNLOCK(info, flags);
-        } else {
-	    info->throttle = 0;
+	if (I_IXOFF(tty)) {
+		if (info->x_char)
+			info->x_char = 0;
+		else
+			cy_send_xchar(tty, START_CHAR(tty));
 	}
-    }
 
-    return;
-} /* cy_unthrottle */
+	if (tty->termios->c_cflag & CRTSCTS) {
+		card = info->card;
+		channel = info->line - cy_card[card].first_line;
+		if (!IS_CYC_Z(cy_card[card])) {
+			chip = channel >> 2;
+			channel &= 0x03;
+			index = cy_card[card].bus_index;
+			base_addr = cy_card[card].base_addr +
+				(cy_chip_offset[chip] << index);
+
+			CY_LOCK(info, flags);
+			cy_writeb(base_addr + (CyCAR << index),
+				  (u_char) channel);
+			if (info->rtsdtr_inv) {
+				cy_writeb(base_addr + (CyMSVR2 << index),
+					  CyDTR);
+			} else {
+				cy_writeb(base_addr + (CyMSVR1 << index),
+					  CyRTS);
+			}
+			CY_UNLOCK(info, flags);
+		} else {
+			info->throttle = 0;
+		}
+	}
 
+	return;
+}				/* cy_unthrottle */
 
 /* cy_start and cy_stop provide software output flow control as a
    function of XON/XOFF, software CTS, and other such stuff.
 */
-static void
-cy_stop(struct tty_struct *tty)
+static void cy_stop(struct tty_struct *tty)
 {
-  struct cyclades_card *cinfo;
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  void __iomem *base_addr;
-  int chip,channel,index;
-  unsigned long flags;
+	struct cyclades_card *cinfo;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	void __iomem *base_addr;
+	int chip, channel, index;
+	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_stop ttyC%d\n", info->line); /* */
+	printk("cyc:cy_stop ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_stop"))
-        return;
-        
-    cinfo = &cy_card[info->card];
-    channel = info->line - cinfo->first_line;
-    if (!IS_CYC_Z(*cinfo)) {
-        index = cinfo->bus_index;
-        chip = channel>>2;
-        channel &= 0x03;
-        base_addr = cy_card[info->card].base_addr + (cy_chip_offset[chip]<<index);
+	if (serial_paranoia_check(info, tty->name, "cy_stop"))
+		return;
 
-	CY_LOCK(info, flags);
-            cy_writeb(base_addr+(CyCAR<<index),
-	       (u_char)(channel & 0x0003)); /* index channel */
-            cy_writeb(base_addr+(CySRER<<index), 
-               cy_readb(base_addr+(CySRER<<index)) & ~CyTxRdy);
-	CY_UNLOCK(info, flags);
-    } else {
-	// Nothing to do!
-    }
+	cinfo = &cy_card[info->card];
+	channel = info->line - cinfo->first_line;
+	if (!IS_CYC_Z(*cinfo)) {
+		index = cinfo->bus_index;
+		chip = channel >> 2;
+		channel &= 0x03;
+		base_addr = cy_card[info->card].base_addr +
+			(cy_chip_offset[chip] << index);
 
-    return;
-} /* cy_stop */
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCAR << index),
+			(u_char)(channel & 0x0003)); /* index channel */
+		cy_writeb(base_addr + (CySRER << index),
+			  cy_readb(base_addr + (CySRER << index)) & ~CyTxRdy);
+		CY_UNLOCK(info, flags);
+	} else {
+		// Nothing to do!
+	}
 
+	return;
+}				/* cy_stop */
 
-static void
-cy_start(struct tty_struct *tty)
+static void cy_start(struct tty_struct *tty)
 {
-  struct cyclades_card *cinfo;
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  void __iomem *base_addr;
-  int chip,channel,index;
-  unsigned long flags;
+	struct cyclades_card *cinfo;
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	void __iomem *base_addr;
+	int chip, channel, index;
+	unsigned long flags;
 
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_start ttyC%d\n", info->line); /* */
+	printk("cyc:cy_start ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_start"))
-        return;
-        
-    cinfo = &cy_card[info->card];
-    channel = info->line - cinfo->first_line;
-    index = cinfo->bus_index;
-    if (!IS_CYC_Z(*cinfo)) {
-        chip = channel>>2;
-        channel &= 0x03;
-        base_addr = cy_card[info->card].base_addr + (cy_chip_offset[chip]<<index);
+	if (serial_paranoia_check(info, tty->name, "cy_start"))
+		return;
 
-	CY_LOCK(info, flags);
-            cy_writeb(base_addr+(CyCAR<<index),
-	       (u_char)(channel & 0x0003)); /* index channel */
-            cy_writeb(base_addr+(CySRER<<index), 
-               cy_readb(base_addr+(CySRER<<index)) | CyTxRdy);
-	CY_UNLOCK(info, flags);
-    } else {
-	// Nothing to do!
-    }
+	cinfo = &cy_card[info->card];
+	channel = info->line - cinfo->first_line;
+	index = cinfo->bus_index;
+	if (!IS_CYC_Z(*cinfo)) {
+		chip = channel >> 2;
+		channel &= 0x03;
+		base_addr = cy_card[info->card].base_addr +
+			(cy_chip_offset[chip] << index);
 
-    return;
-} /* cy_start */
+		CY_LOCK(info, flags);
+		cy_writeb(base_addr + (CyCAR << index), (u_char) (channel & 0x0003));	/* index channel */
+		cy_writeb(base_addr + (CySRER << index),
+			  cy_readb(base_addr + (CySRER << index)) | CyTxRdy);
+		CY_UNLOCK(info, flags);
+	} else {
+		// Nothing to do!
+	}
 
+	return;
+}				/* cy_start */
 
-static void
-cy_flush_buffer(struct tty_struct *tty)
+static void cy_flush_buffer(struct tty_struct *tty)
 {
-  struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
-  int card, channel, retval;
-  unsigned long flags;
-                                
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+	int card, channel, retval;
+	unsigned long flags;
+
 #ifdef CY_DEBUG_IO
-    printk("cyc:cy_flush_buffer ttyC%d\n", info->line); /* */
+	printk("cyc:cy_flush_buffer ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
-        return;
-
-    card = info->card;
-    channel = (info->line) - (cy_card[card].first_line);
+	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
+		return;
 
-    CY_LOCK(info, flags);
-    info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-    CY_UNLOCK(info, flags);
+	card = info->card;
+	channel = (info->line) - (cy_card[card].first_line);
 
-    if (IS_CYC_Z(cy_card[card])) { /* If it is a Z card, flush the on-board 
-				      buffers as well */
 	CY_LOCK(info, flags);
-	retval = cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_TX, 0L);
-	if (retval != 0) {
-	    printk("cyc: flush_buffer retval on ttyC%d was %x\n",
-		   info->line, retval);
-	}
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 	CY_UNLOCK(info, flags);
-    }
-    tty_wakeup(tty);
-    wake_up_interruptible(&tty->write_wait);
-} /* cy_flush_buffer */
 
+	if (IS_CYC_Z(cy_card[card])) {	/* If it is a Z card, flush the on-board
+					   buffers as well */
+		CY_LOCK(info, flags);
+		retval =
+		    cyz_issue_cmd(&cy_card[card], channel, C_CM_FLUSH_TX, 0L);
+		if (retval != 0) {
+			printk("cyc: flush_buffer retval on ttyC%d was %x\n",
+				info->line, retval);
+		}
+		CY_UNLOCK(info, flags);
+	}
+	tty_wakeup(tty);
+	wake_up_interruptible(&tty->write_wait);
+}				/* cy_flush_buffer */
 
 /*
  * cy_hangup() --- called by tty_hangup() when a hangup is signaled.
  */
-static void
-cy_hangup(struct tty_struct *tty)
+static void cy_hangup(struct tty_struct *tty)
 {
-  struct cyclades_port * info = (struct cyclades_port *)tty->driver_data;
-        
+	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
+
 #ifdef CY_DEBUG_OTHER
-    printk("cyc:cy_hangup ttyC%d\n", info->line); /* */
+	printk("cyc:cy_hangup ttyC%d\n", info->line);	/* */
 #endif
 
-    if (serial_paranoia_check(info, tty->name, "cy_hangup"))
-        return;
+	if (serial_paranoia_check(info, tty->name, "cy_hangup"))
+		return;
 
-    cy_flush_buffer(tty);
-    shutdown(info);
-    info->event = 0;
-    info->count = 0;
+	cy_flush_buffer(tty);
+	shutdown(info);
+	info->event = 0;
+	info->count = 0;
 #ifdef CY_DEBUG_COUNT
-    printk("cyc:cy_hangup (%d): setting count to 0\n", current->pid);
+	printk("cyc:cy_hangup (%d): setting count to 0\n", current->pid);
 #endif
-    info->tty = NULL;
-    info->flags &= ~ASYNC_NORMAL_ACTIVE;
-    wake_up_interruptible(&info->open_wait);
-} /* cy_hangup */
-
+	info->tty = NULL;
+	info->flags &= ~ASYNC_NORMAL_ACTIVE;
+	wake_up_interruptible(&info->open_wait);
+}				/* cy_hangup */
 
 /*
  * ---------------------------------------------------------------------
@@ -4438,82 +4548,84 @@ cy_hangup(struct tty_struct *tty)
 /* initialize chips on Cyclom-Y card -- return number of valid
    chips (which is number of ports/4) */
 static unsigned short __init
-cyy_init_card(void __iomem *true_base_addr,int index)
+cyy_init_card(void __iomem * true_base_addr, int index)
 {
-  unsigned int chip_number;
-  void __iomem *base_addr;
+	unsigned int chip_number;
+	void __iomem *base_addr;
 
-    cy_writeb(true_base_addr+(Cy_HwReset<<index), 0); 
-						/* Cy_HwReset is 0x1400 */
-    cy_writeb(true_base_addr+(Cy_ClrIntr<<index), 0); 
-						/* Cy_ClrIntr is 0x1800 */
-    udelay(500L);
-
-    for(chip_number=0; chip_number<CyMAX_CHIPS_PER_CARD; chip_number++){
-        base_addr = true_base_addr + (cy_chip_offset[chip_number]<<index);
-        mdelay(1);
-        if(cy_readb(base_addr+(CyCCR<<index)) != 0x00){
-            /*************
-            printk(" chip #%d at %#6lx is never idle (CCR != 0)\n",
-               chip_number, (unsigned long)base_addr);
-            *************/
-            return chip_number;
-        }
-
-        cy_writeb(base_addr+(CyGFRCR<<index), 0);
-        udelay(10L);
-
-        /* The Cyclom-16Y does not decode address bit 9 and therefore
-           cannot distinguish between references to chip 0 and a non-
-           existent chip 4.  If the preceding clearing of the supposed
-           chip 4 GFRCR register appears at chip 0, there is no chip 4
-           and this must be a Cyclom-16Y, not a Cyclom-32Ye.
-        */
-        if (chip_number == 4
-        && cy_readb(true_base_addr
-	    + (cy_chip_offset[0]<<index)
-	    + (CyGFRCR<<index)) == 0){
-            return chip_number;
-        }
-
-        cy_writeb(base_addr+(CyCCR<<index), CyCHIP_RESET);
-        mdelay(1);
-
-        if(cy_readb(base_addr+(CyGFRCR<<index)) == 0x00){
-            /*
-            printk(" chip #%d at %#6lx is not responding ",
-               chip_number, (unsigned long)base_addr);
-            printk("(GFRCR stayed 0)\n",
-            */
-            return chip_number;
-        }
-        if((0xf0 & (cy_readb(base_addr+(CyGFRCR<<index)))) != 0x40){
-            /*
-            printk(" chip #%d at %#6lx is not valid (GFRCR == %#2x)\n",
-               chip_number, (unsigned long)base_addr,
-	       base_addr[CyGFRCR<<index]);
-            */
-            return chip_number;
-        }
-        cy_writeb(base_addr+(CyGCR<<index), CyCH0_SERIAL);
-        if (cy_readb(base_addr+(CyGFRCR<<index)) >= CD1400_REV_J){
-	    /* It is a CD1400 rev. J or later */
-	    /* Impossible to reach 5ms with this chip. 
-	       Changed to 2ms instead (f = 500 Hz). */
-	    cy_writeb(base_addr+(CyPPR<<index), CyCLOCK_60_2MS);
-	} else {
-	    /* f = 200 Hz */
-	    cy_writeb(base_addr+(CyPPR<<index), CyCLOCK_25_5MS);
-	}
+	cy_writeb(true_base_addr + (Cy_HwReset << index), 0);
+	/* Cy_HwReset is 0x1400 */
+	cy_writeb(true_base_addr + (Cy_ClrIntr << index), 0);
+	/* Cy_ClrIntr is 0x1800 */
+	udelay(500L);
+
+	for (chip_number = 0; chip_number < CyMAX_CHIPS_PER_CARD; chip_number++) {
+		base_addr =
+		    true_base_addr + (cy_chip_offset[chip_number] << index);
+		mdelay(1);
+		if (cy_readb(base_addr + (CyCCR << index)) != 0x00) {
+			/*************
+			printk(" chip #%d at %#6lx is never idle (CCR != 0)\n",
+			chip_number, (unsigned long)base_addr);
+			*************/
+			return chip_number;
+		}
+
+		cy_writeb(base_addr + (CyGFRCR << index), 0);
+		udelay(10L);
+
+		/* The Cyclom-16Y does not decode address bit 9 and therefore
+		   cannot distinguish between references to chip 0 and a non-
+		   existent chip 4.  If the preceding clearing of the supposed
+		   chip 4 GFRCR register appears at chip 0, there is no chip 4
+		   and this must be a Cyclom-16Y, not a Cyclom-32Ye.
+		 */
+		if (chip_number == 4 && cy_readb(true_base_addr +
+				(cy_chip_offset[0] << index) +
+				(CyGFRCR << index)) == 0) {
+			return chip_number;
+		}
 
-    /*
-        printk(" chip #%d at %#6lx is rev 0x%2x\n",
-               chip_number, (unsigned long)base_addr,
-	       cy_readb(base_addr+(CyGFRCR<<index)));
-    */
-    }
-    return chip_number;
-} /* cyy_init_card */
+		cy_writeb(base_addr + (CyCCR << index), CyCHIP_RESET);
+		mdelay(1);
+
+		if (cy_readb(base_addr + (CyGFRCR << index)) == 0x00) {
+			/*
+			   printk(" chip #%d at %#6lx is not responding ",
+			   chip_number, (unsigned long)base_addr);
+			   printk("(GFRCR stayed 0)\n",
+			 */
+			return chip_number;
+		}
+		if ((0xf0 & (cy_readb(base_addr + (CyGFRCR << index)))) !=
+				0x40) {
+			/*
+			printk(" chip #%d at %#6lx is not valid (GFRCR == "
+					"%#2x)\n",
+					chip_number, (unsigned long)base_addr,
+					base_addr[CyGFRCR<<index]);
+			 */
+			return chip_number;
+		}
+		cy_writeb(base_addr + (CyGCR << index), CyCH0_SERIAL);
+		if (cy_readb(base_addr + (CyGFRCR << index)) >= CD1400_REV_J) {
+			/* It is a CD1400 rev. J or later */
+			/* Impossible to reach 5ms with this chip.
+			   Changed to 2ms instead (f = 500 Hz). */
+			cy_writeb(base_addr + (CyPPR << index), CyCLOCK_60_2MS);
+		} else {
+			/* f = 200 Hz */
+			cy_writeb(base_addr + (CyPPR << index), CyCLOCK_25_5MS);
+		}
+
+		/*
+		   printk(" chip #%d at %#6lx is rev 0x%2x\n",
+		   chip_number, (unsigned long)base_addr,
+		   cy_readb(base_addr+(CyGFRCR<<index)));
+		 */
+	}
+	return chip_number;
+}				/* cyy_init_card */
 
 /*
  * ---------------------------------------------------------------------
@@ -4521,126 +4633,124 @@ cyy_init_card(void __iomem *true_base_ad
  * sets global variables and return the number of ISA boards found.
  * ---------------------------------------------------------------------
  */
-static int __init
-cy_detect_isa(void)
+static int __init cy_detect_isa(void)
 {
 #ifdef CONFIG_ISA
-  unsigned short	cy_isa_irq,nboard;
-  void __iomem		*cy_isa_address;
-  unsigned short	i,j,cy_isa_nchan;
+	unsigned short cy_isa_irq, nboard;
+	void __iomem *cy_isa_address;
+	unsigned short i, j, cy_isa_nchan;
 #ifdef MODULE
-  int isparam = 0;
+	int isparam = 0;
 #endif
 
-        nboard = 0;
+	nboard = 0;
 
 #ifdef MODULE
 	/* Check for module parameters */
-	for(i = 0 ; i < NR_CARDS; i++) {
-	    if (maddr[i] || i) {
-		isparam = 1;
-		cy_isa_addresses[i] = maddr[i];
-	    }
-	    if (!maddr[i])
-		break;
+	for (i = 0; i < NR_CARDS; i++) {
+		if (maddr[i] || i) {
+			isparam = 1;
+			cy_isa_addresses[i] = maddr[i];
+		}
+		if (!maddr[i])
+			break;
 	}
 #endif
 
-        /* scan the address table probing for Cyclom-Y/ISA boards */
-        for (i = 0 ; i < NR_ISA_ADDRS ; i++) {
-        	unsigned int isa_address = cy_isa_addresses[i];
-                if (isa_address  == 0x0000) {
-                        return(nboard);
-                }
+	/* scan the address table probing for Cyclom-Y/ISA boards */
+	for (i = 0; i < NR_ISA_ADDRS; i++) {
+		unsigned int isa_address = cy_isa_addresses[i];
+		if (isa_address == 0x0000) {
+			return (nboard);
+		}
 
-                /* probe for CD1400... */
+		/* probe for CD1400... */
 		cy_isa_address = ioremap(isa_address, CyISA_Ywin);
-                cy_isa_nchan = CyPORTS_PER_CHIP * 
-                     cyy_init_card(cy_isa_address,0);
-                if (cy_isa_nchan == 0) {
-                        continue;
-                }
-
+		cy_isa_nchan = CyPORTS_PER_CHIP *
+			cyy_init_card(cy_isa_address, 0);
+		if (cy_isa_nchan == 0) {
+			continue;
+		}
 #ifdef MODULE
 		if (isparam && irq[i])
-		    cy_isa_irq = irq[i];
+			cy_isa_irq = irq[i];
 		else
 #endif
-                /* find out the board's irq by probing */
-                cy_isa_irq = detect_isa_irq(cy_isa_address);
-                if (cy_isa_irq == 0) {
-                        printk("Cyclom-Y/ISA found at 0x%lx ",
-                                (unsigned long) cy_isa_address);
-                        printk("but the IRQ could not be detected.\n");
-                        continue;
-                }
-
-                if((cy_next_channel+cy_isa_nchan) > NR_PORTS) {
-                        printk("Cyclom-Y/ISA found at 0x%lx ",
-                                (unsigned long) cy_isa_address);
-                        printk("but no more channels are available.\n");
-                        printk("Change NR_PORTS in cyclades.c and recompile kernel.\n");
-                        return(nboard);
-                }
-                /* fill the next cy_card structure available */
-                for (j = 0 ; j < NR_CARDS ; j++) {
-                        if (cy_card[j].base_addr == 0)  break;
-                }
-                if (j == NR_CARDS) {    /* no more cy_cards available */
-                        printk("Cyclom-Y/ISA found at 0x%lx ",
-                                (unsigned long) cy_isa_address);
-                        printk("but no more cards can be used .\n");
-                        printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
-                        return(nboard);
-                }
-
-                /* allocate IRQ */
-                if(request_irq(cy_isa_irq, cyy_interrupt,
-				   IRQF_DISABLED, "Cyclom-Y", &cy_card[j]))
-                {
-                        printk("Cyclom-Y/ISA found at 0x%lx ",
-                                (unsigned long) cy_isa_address);
-                        printk("but could not allocate IRQ#%d.\n",
-                                cy_isa_irq);
-                        return(nboard);
-                }
-
-                /* set cy_card */
-                cy_card[j].base_addr = cy_isa_address;
-                cy_card[j].ctl_addr = NULL;
-                cy_card[j].irq = (int) cy_isa_irq;
-                cy_card[j].bus_index = 0;
-                cy_card[j].first_line = cy_next_channel;
-                cy_card[j].num_chips = cy_isa_nchan/4;
-                nboard++;
-                        
-                /* print message */
-                printk("Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d, ",
-                    j+1, (unsigned long) cy_isa_address,
-                    (unsigned long)(cy_isa_address + (CyISA_Ywin - 1)),
-		    cy_isa_irq);
-                printk("%d channels starting from port %d.\n",
-                        cy_isa_nchan, cy_next_channel);
-                cy_next_channel += cy_isa_nchan;
-        }
-        return(nboard);
+			/* find out the board's irq by probing */
+			cy_isa_irq = detect_isa_irq(cy_isa_address);
+		if (cy_isa_irq == 0) {
+			printk("Cyclom-Y/ISA found at 0x%lx ",
+				(unsigned long)cy_isa_address);
+			printk("but the IRQ could not be detected.\n");
+			continue;
+		}
+
+		if ((cy_next_channel + cy_isa_nchan) > NR_PORTS) {
+			printk("Cyclom-Y/ISA found at 0x%lx ",
+				(unsigned long)cy_isa_address);
+			printk("but no more channels are available.\n");
+			printk("Change NR_PORTS in cyclades.c and recompile "
+					"kernel.\n");
+			return (nboard);
+		}
+		/* fill the next cy_card structure available */
+		for (j = 0; j < NR_CARDS; j++) {
+			if (cy_card[j].base_addr == 0)
+				break;
+		}
+		if (j == NR_CARDS) {	/* no more cy_cards available */
+			printk("Cyclom-Y/ISA found at 0x%lx ",
+				(unsigned long)cy_isa_address);
+			printk("but no more cards can be used .\n");
+			printk("Change NR_CARDS in cyclades.c and recompile "
+					"kernel.\n");
+			return (nboard);
+		}
+
+		/* allocate IRQ */
+		if (request_irq(cy_isa_irq, cyy_interrupt,
+				IRQF_DISABLED, "Cyclom-Y", &cy_card[j])) {
+			printk("Cyclom-Y/ISA found at 0x%lx ",
+				(unsigned long)cy_isa_address);
+			printk("but could not allocate IRQ#%d.\n", cy_isa_irq);
+			return (nboard);
+		}
+
+		/* set cy_card */
+		cy_card[j].base_addr = cy_isa_address;
+		cy_card[j].ctl_addr = NULL;
+		cy_card[j].irq = (int)cy_isa_irq;
+		cy_card[j].bus_index = 0;
+		cy_card[j].first_line = cy_next_channel;
+		cy_card[j].num_chips = cy_isa_nchan / 4;
+		nboard++;
+
+		/* print message */
+		printk("Cyclom-Y/ISA #%d: 0x%lx-0x%lx, IRQ%d, ",
+			j + 1, (unsigned long)cy_isa_address,
+			(unsigned long)(cy_isa_address + (CyISA_Ywin - 1)),
+			cy_isa_irq);
+		printk("%d channels starting from port %d.\n",
+			cy_isa_nchan, cy_next_channel);
+		cy_next_channel += cy_isa_nchan;
+	}
+	return (nboard);
 #else
-        return(0);
-#endif /* CONFIG_ISA */
-} /* cy_detect_isa */
-
-static void 
-plx_init(void __iomem *addr, uclong initctl)
-{
-    /* Reset PLX */
-    cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x40000000);
-    udelay(100L);
-    cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x40000000);
-
-    /* Reload Config. Registers from EEPROM */
-    cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x20000000);
-    udelay(100L);
-    cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x20000000);
+	return (0);
+#endif				/* CONFIG_ISA */
+}				/* cy_detect_isa */
+
+static void plx_init(void __iomem * addr, uclong initctl)
+{
+	/* Reset PLX */
+	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x40000000);
+	udelay(100L);
+	cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x40000000);
+
+	/* Reload Config. Registers from EEPROM */
+	cy_writel(addr + initctl, cy_readl(addr + initctl) | 0x20000000);
+	udelay(100L);
+	cy_writel(addr + initctl, cy_readl(addr + initctl) & ~0x20000000);
 }
 
 /*
@@ -4649,43 +4759,42 @@ plx_init(void __iomem *addr, uclong init
  * sets global variables and return the number of PCI boards found.
  * ---------------------------------------------------------------------
  */
-static int __init
-cy_detect_pci(void)
+static int __init cy_detect_pci(void)
 {
 #ifdef CONFIG_PCI
 
-  struct pci_dev	*pdev = NULL;
-  unsigned char		cyy_rev_id;
-  unsigned char		cy_pci_irq = 0;
-  uclong		cy_pci_phys0, cy_pci_phys2;
-  void __iomem		*cy_pci_addr0, *cy_pci_addr2;
-  unsigned short	i,j,cy_pci_nchan, plx_ver;
-  unsigned short	device_id,dev_index = 0;
-  uclong		mailbox;
-  uclong		ZeIndex = 0;
-  void __iomem		*Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
-  uclong		Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
-  unsigned char		Ze_irq[NR_CARDS];
-  struct pci_dev	*Ze_pdev[NR_CARDS];
-
-        for (i = 0; i < NR_CARDS; i++) {
-                /* look for a Cyclades card by vendor and device id */
-                while((device_id = cy_pci_dev_id[dev_index]) != 0) {
-                        if((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
-                                        device_id, pdev)) == NULL) {
-                                dev_index++;    /* try next device id */
-                        } else {
-                                break;          /* found a board */
-                        }
-                }
+	struct pci_dev *pdev = NULL;
+	unsigned char cyy_rev_id;
+	unsigned char cy_pci_irq = 0;
+	uclong cy_pci_phys0, cy_pci_phys2;
+	void __iomem *cy_pci_addr0, *cy_pci_addr2;
+	unsigned short i, j, cy_pci_nchan, plx_ver;
+	unsigned short device_id, dev_index = 0;
+	uclong mailbox;
+	uclong ZeIndex = 0;
+	void __iomem *Ze_addr0[NR_CARDS], *Ze_addr2[NR_CARDS];
+	uclong Ze_phys0[NR_CARDS], Ze_phys2[NR_CARDS];
+	unsigned char Ze_irq[NR_CARDS];
+	struct pci_dev *Ze_pdev[NR_CARDS];
+
+	for (i = 0; i < NR_CARDS; i++) {
+		/* look for a Cyclades card by vendor and device id */
+		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
+			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
+						   device_id, pdev)) == NULL) {
+				dev_index++;	/* try next device id */
+			} else {
+				break;	/* found a board */
+			}
+		}
 
 		if (device_id == 0)
-		    break;
+			break;
 
 		if (pci_enable_device(pdev))
-		    continue;
+			continue;
 
-                /* read PCI configuration area */
+		/* read PCI configuration area */
 		cy_pci_irq = pdev->irq;
 		cy_pci_phys0 = pci_resource_start(pdev, 0);
 		cy_pci_phys2 = pci_resource_start(pdev, 2);
@@ -4693,482 +4802,509 @@ cy_detect_pci(void)
 
 		device_id &= ~PCI_DEVICE_ID_MASK;
 
-    if ((device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo)
-	   || (device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi)){
+		if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo ||
+				device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
 #ifdef CY_PCI_DEBUG
-            printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
-		pdev->bus->number, pdev->devfn);
-            printk("rev_id=%d) IRQ%d\n",
-		cyy_rev_id, (int)cy_pci_irq);
-            printk("Cyclom-Y/PCI:found  winaddr=0x%lx ctladdr=0x%lx\n",
-		(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-#endif
-
-		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-		    printk("  Warning: PCI I/O bit incorrectly set. "
-			   "Ignoring it...\n");
-		    pdev->resource[2].flags &= ~IORESOURCE_IO;
-		}
-
-		/* Although we don't use this I/O region, we should
-		   request it from the kernel anyway, to avoid problems
-		   with other drivers accessing it. */
-		if (pci_request_regions(pdev, "Cyclom-Y") != 0) {
-			printk(KERN_ERR "cyclades: failed to reserve PCI resources\n");
-			continue;
-		}
+			printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
+				pdev->bus->number, pdev->devfn);
+			printk("rev_id=%d) IRQ%d\n",
+				cyy_rev_id, (int)cy_pci_irq);
+			printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
+				"ctladdr=0x%lx\n",
+				(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
+#endif
 
+			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
+				printk("  Warning: PCI I/O bit incorrectly "
+					"set. Ignoring it...\n");
+				pdev->resource[2].flags &= ~IORESOURCE_IO;
+			}
+
+			/* Although we don't use this I/O region, we should
+			   request it from the kernel anyway, to avoid problems
+			   with other drivers accessing it. */
+			if (pci_request_regions(pdev, "Cyclom-Y") != 0) {
+				printk(KERN_ERR "cyclades: failed to reserve "
+						"PCI resources\n");
+				continue;
+			}
 #if defined(__alpha__)
-                if (device_id  == PCI_DEVICE_ID_CYCLOM_Y_Lo) { /* below 1M? */
-		    printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
-			pdev->bus->number, pdev->devfn);
-		    printk("rev_id=%d) IRQ%d\n",
-		        cyy_rev_id, (int)cy_pci_irq);
-                    printk("Cyclom-Y/PCI:found  winaddr=0x%lx ctladdr=0x%lx\n",
-		        (ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-	            printk("Cyclom-Y/PCI not supported for low addresses in "
-                           "Alpha systems.\n");
-		    i--;
-	            continue;
-                }
+			if (device_id == PCI_DEVICE_ID_CYCLOM_Y_Lo) {	/* below 1M? */
+				printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
+					pdev->bus->number, pdev->devfn);
+				printk("rev_id=%d) IRQ%d\n",
+					cyy_rev_id, (int)cy_pci_irq);
+				printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
+					"ctladdr=0x%lx\n",
+					(ulong)cy_pci_phys2,
+					(ulong)cy_pci_phys0);
+				printk("Cyclom-Y/PCI not supported for low "
+					"addresses in Alpha systems.\n");
+				i--;
+				continue;
+			}
 #endif
-		cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Yctl);
-		cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Ywin);
+			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Yctl);
+			cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Ywin);
 
 #ifdef CY_PCI_DEBUG
-            printk("Cyclom-Y/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
-		(u_long)cy_pci_addr2, (u_long)cy_pci_addr0);
-#endif
-                cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP * 
-                       cyy_init_card(cy_pci_addr2, 1));
-                if(cy_pci_nchan == 0) {
-                        printk("Cyclom-Y PCI host card with ");
-                        printk("no Serial-Modules at 0x%lx.\n",
-			    (ulong) cy_pci_phys2);
-                        i--;
-                        continue;
-                }
-                if((cy_next_channel+cy_pci_nchan) > NR_PORTS) {
-                        printk("Cyclom-Y/PCI found at 0x%lx ",
-			    (ulong) cy_pci_phys2);
-                        printk("but no channels are available.\n");
-                        printk("Change NR_PORTS in cyclades.c and recompile kernel.\n");
-                        return(i);
-                }
-                /* fill the next cy_card structure available */
-                for (j = 0 ; j < NR_CARDS ; j++) {
-                        if (cy_card[j].base_addr == 0)  break;
-                }
-                if (j == NR_CARDS) {    /* no more cy_cards available */
-                        printk("Cyclom-Y/PCI found at 0x%lx ",
-			    (ulong) cy_pci_phys2);
-                        printk("but no more cards can be used.\n");
-                        printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
-                        return(i);
-                }
-
-                /* allocate IRQ */
-                if(request_irq(cy_pci_irq, cyy_interrupt,
-		        IRQF_SHARED, "Cyclom-Y", &cy_card[j]))
-                {
-                        printk("Cyclom-Y/PCI found at 0x%lx ",
-			    (ulong) cy_pci_phys2);
-                        printk("but could not allocate IRQ%d.\n",
-			    cy_pci_irq);
-                        return(i);
-                }
-
-                /* set cy_card */
-                cy_card[j].base_phys = (ulong)cy_pci_phys2;
-                cy_card[j].ctl_phys = (ulong)cy_pci_phys0;
-                cy_card[j].base_addr = cy_pci_addr2;
-                cy_card[j].ctl_addr = cy_pci_addr0;
-                cy_card[j].irq = (int) cy_pci_irq;
-                cy_card[j].bus_index = 1;
-                cy_card[j].first_line = cy_next_channel;
-                cy_card[j].num_chips = cy_pci_nchan/4;
-		cy_card[j].pdev = pdev;
-	
-                /* enable interrupts in the PCI interface */
-		plx_ver = cy_readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
-		switch (plx_ver) {
-		    case PLX_9050:
-
-		    cy_writeb(cy_pci_addr0+0x4c, 0x43);
-		    break;
-
-		    case PLX_9060:
-		    case PLX_9080:
-		    default: /* Old boards, use PLX_9060 */
-
-		    plx_init(cy_pci_addr0, 0x6c);
-		    /* For some yet unknown reason, once the PLX9060 reloads
-		       the EEPROM, the IRQ is lost and, thus, we have to
-		       re-write it to the PCI config. registers.
-		       This will remain here until we find a permanent fix. */
-		    pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, cy_pci_irq);
-
-		    cy_writew(cy_pci_addr0+0x68, 
-			cy_readw(cy_pci_addr0+0x68)|0x0900);
-		    break;
-		}
-
-                /* print message */
-                printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-		       j+1, 
-		       (ulong)cy_pci_phys2, 
-		       (ulong)(cy_pci_phys2 + CyPCI_Ywin - 1),
-		       (int)cy_pci_irq);
-                printk("%d channels starting from port %d.\n",
-		    cy_pci_nchan, cy_next_channel);
-
-                cy_next_channel += cy_pci_nchan;
-    }else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo){
-	    /* print message */
-		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-		    pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-		    cyy_rev_id, (int)cy_pci_irq);
-		printk("Cyclades-Z/PCI: found winaddr=0x%lx ctladdr=0x%lx\n",
-		    (ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-	    printk("Cyclades-Z/PCI not supported for low addresses\n");
-	    break;
-    }else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi){
-#ifdef CY_PCI_DEBUG
-            printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
-	        pdev->bus->number, pdev->devfn);
-            printk("rev_id=%d) IRQ%d\n",
-		cyy_rev_id, (int)cy_pci_irq);
-            printk("Cyclades-Z/PCI: found winaddr=0x%lx ctladdr=0x%lx\n",
-                (ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
-#endif
-		cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Zctl);
-
-		/* Disable interrupts on the PLX before resetting it */
-		cy_writew(cy_pci_addr0+0x68,
-			cy_readw(cy_pci_addr0+0x68) & ~0x0900);
-
-		plx_init(cy_pci_addr0, 0x6c);
-		/* For some yet unknown reason, once the PLX9060 reloads
-		   the EEPROM, the IRQ is lost and, thus, we have to
-		   re-write it to the PCI config. registers.
-		   This will remain here until we find a permanent fix. */
-		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, cy_pci_irq);
-
-		mailbox = (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *) 
-			   cy_pci_addr0)->mail_box_0);
-
-		if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
-		    printk("  Warning: PCI I/O bit incorrectly set. "
-			   "Ignoring it...\n");
-		    pdev->resource[2].flags &= ~IORESOURCE_IO;
-		}
-
-		/* Although we don't use this I/O region, we should
-		   request it from the kernel anyway, to avoid problems
-		   with other drivers accessing it. */
-		if (pci_request_regions(pdev, "Cyclades-Z") != 0) {
-			printk(KERN_ERR "cyclades: failed to reserve PCI resources\n");
-			continue;
-		}
-	
-		if (mailbox == ZE_V1) {
-		    cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Ze_win);
-		    if (ZeIndex == NR_CARDS) {
-			printk("Cyclades-Ze/PCI found at 0x%lx ",
-				(ulong)cy_pci_phys2);
-			printk("but no more cards can be used.\n");
-                        printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
-		    } else {
-			Ze_phys0[ZeIndex] = cy_pci_phys0;
-			Ze_phys2[ZeIndex] = cy_pci_phys2;
-			Ze_addr0[ZeIndex] = cy_pci_addr0;
-			Ze_addr2[ZeIndex] = cy_pci_addr2;
-			Ze_irq[ZeIndex] = cy_pci_irq;
-			Ze_pdev[ZeIndex] = pdev;
-			ZeIndex++;
-		    }
-		    i--;
-		    continue;
-		} else {
-		    cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Zwin);
-		}
+			printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
+				"ctladdr=0x%lx\n",
+				(u_long)cy_pci_addr2, (u_long)cy_pci_addr0);
+#endif
+			cy_pci_nchan = (unsigned short)(CyPORTS_PER_CHIP *
+					cyy_init_card(cy_pci_addr2, 1));
+			if (cy_pci_nchan == 0) {
+				printk("Cyclom-Y PCI host card with ");
+				printk("no Serial-Modules at 0x%lx.\n",
+					(ulong) cy_pci_phys2);
+				i--;
+				continue;
+			}
+			if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+				printk("Cyclom-Y/PCI found at 0x%lx ",
+					(ulong) cy_pci_phys2);
+				printk("but no channels are available.\n");
+				printk("Change NR_PORTS in cyclades.c and "
+						"recompile kernel.\n");
+				return (i);
+			}
+			/* fill the next cy_card structure available */
+			for (j = 0; j < NR_CARDS; j++) {
+				if (cy_card[j].base_addr == 0)
+					break;
+			}
+			if (j == NR_CARDS) {	/* no more cy_cards available */
+				printk("Cyclom-Y/PCI found at 0x%lx ",
+					(ulong) cy_pci_phys2);
+				printk("but no more cards can be used.\n");
+				printk("Change NR_CARDS in cyclades.c and "
+						"recompile kernel.\n");
+				return (i);
+			}
+
+			/* allocate IRQ */
+			if (request_irq(cy_pci_irq, cyy_interrupt,
+					IRQF_SHARED, "Cyclom-Y", &cy_card[j])) {
+				printk("Cyclom-Y/PCI found at 0x%lx ",
+					(ulong) cy_pci_phys2);
+				printk("but could not allocate IRQ%d.\n",
+					cy_pci_irq);
+				return (i);
+			}
+
+			/* set cy_card */
+			cy_card[j].base_phys = (ulong) cy_pci_phys2;
+			cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
+			cy_card[j].base_addr = cy_pci_addr2;
+			cy_card[j].ctl_addr = cy_pci_addr0;
+			cy_card[j].irq = (int)cy_pci_irq;
+			cy_card[j].bus_index = 1;
+			cy_card[j].first_line = cy_next_channel;
+			cy_card[j].num_chips = cy_pci_nchan / 4;
+			cy_card[j].pdev = pdev;
+
+			/* enable interrupts in the PCI interface */
+			plx_ver = cy_readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
+			switch (plx_ver) {
+			case PLX_9050:
+
+				cy_writeb(cy_pci_addr0 + 0x4c, 0x43);
+				break;
+
+			case PLX_9060:
+			case PLX_9080:
+			default:	/* Old boards, use PLX_9060 */
+
+				plx_init(cy_pci_addr0, 0x6c);
+			/* For some yet unknown reason, once the PLX9060 reloads
+			   the EEPROM, the IRQ is lost and, thus, we have to
+			   re-write it to the PCI config. registers.
+			   This will remain here until we find a permanent
+			   fix. */
+				pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
+						cy_pci_irq);
+
+				cy_writew(cy_pci_addr0 + 0x68,
+					  cy_readw(cy_pci_addr0 +
+						   0x68) | 0x0900);
+				break;
+			}
 
+			/* print message */
+			printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
+				j + 1, (ulong)cy_pci_phys2,
+				(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1),
+				(int)cy_pci_irq);
+			printk("%d channels starting from port %d.\n",
+				cy_pci_nchan, cy_next_channel);
+
+			cy_next_channel += cy_pci_nchan;
+		} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
+			/* print message */
+			printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
+				pdev->bus->number, pdev->devfn);
+			printk("rev_id=%d) IRQ%d\n",
+				cyy_rev_id, (int)cy_pci_irq);
+			printk("Cyclades-Z/PCI: found winaddr=0x%lx "
+				"ctladdr=0x%lx\n",
+				(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
+			printk("Cyclades-Z/PCI not supported for low "
+				"addresses\n");
+			break;
+		} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
 #ifdef CY_PCI_DEBUG
-            printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
-                (ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
-	    if (mailbox == ZO_V1) {
-		cy_writel(&((struct RUNTIME_9060 *)
-			  (cy_pci_addr0))->loc_addr_base, WIN_CREG);
-		PAUSE
-		printk("Cyclades-8Zo/PCI: FPGA id %lx, ver %lx\n",
-		       (ulong)(0xff & cy_readl(&((struct CUSTOM_REG *)
-		        (cy_pci_addr2))->fpga_id)),
-		       (ulong)(0xff & cy_readl(&((struct CUSTOM_REG *)
-		        (cy_pci_addr2))->fpga_version)));
-		cy_writel(&((struct RUNTIME_9060 *)
-			  (cy_pci_addr0))->loc_addr_base, WIN_RAM);
-	    } else {
-		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not loaded\n");
-	    }
-#endif
-	    /* The following clears the firmware id word.  This ensures
-	       that the driver will not attempt to talk to the board
-	       until it has been properly initialized.
-	     */
-		PAUSE
-		if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
-		    cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
+			printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
+				pdev->bus->number, pdev->devfn);
+			printk("rev_id=%d) IRQ%d\n",
+				cyy_rev_id, (int)cy_pci_irq);
+			printk("Cyclades-Z/PCI: found winaddr=0x%lx "
+				"ctladdr=0x%lx\n",
+				(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
+#endif
+			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Zctl);
+
+			/* Disable interrupts on the PLX before resetting it */
+			cy_writew(cy_pci_addr0 + 0x68,
+				cy_readw(cy_pci_addr0 + 0x68) & ~0x0900);
+
+			plx_init(cy_pci_addr0, 0x6c);
+			/* For some yet unknown reason, once the PLX9060 reloads
+			   the EEPROM, the IRQ is lost and, thus, we have to
+			   re-write it to the PCI config. registers.
+			   This will remain here until we find a permanent
+			   fix. */
+			pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
+						cy_pci_irq);
+
+			mailbox =
+			    (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+						cy_pci_addr0)->mail_box_0);
+
+			if (pci_resource_flags(pdev, 2) & IORESOURCE_IO) {
+				printk("  Warning: PCI I/O bit incorrectly "
+					"set. Ignoring it...\n");
+				pdev->resource[2].flags &= ~IORESOURCE_IO;
+			}
+
+			/* Although we don't use this I/O region, we should
+			   request it from the kernel anyway, to avoid problems
+			   with other drivers accessing it. */
+			if (pci_request_regions(pdev, "Cyclades-Z") != 0) {
+				printk(KERN_ERR "cyclades: failed to reserve "
+					"PCI resources\n");
+				continue;
+			}
 
-                /* This must be a Cyclades-8Zo/PCI.  The extendable
-                   version will have a different device_id and will
-                   be allocated its maximum number of ports. */
-                cy_pci_nchan = 8;
-
-                if((cy_next_channel+cy_pci_nchan) > NR_PORTS) {
-                        printk("Cyclades-8Zo/PCI found at 0x%lx ",
-			    (ulong)cy_pci_phys2);
-                        printk("but no channels are available.\n");
-                        printk("Change NR_PORTS in cyclades.c and recompile kernel.\n");
-                        return(i);
-                }
-
-                /* fill the next cy_card structure available */
-                for (j = 0 ; j < NR_CARDS ; j++) {
-                        if (cy_card[j].base_addr == 0)  break;
-                }
-                if (j == NR_CARDS) {    /* no more cy_cards available */
-		    printk("Cyclades-8Zo/PCI found at 0x%lx ",
-			(ulong)cy_pci_phys2);
-		    printk("but no more cards can be used.\n");
-                    printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
-		    return(i);
-                }
+			if (mailbox == ZE_V1) {
+				cy_pci_addr2 = ioremap(cy_pci_phys2,
+						CyPCI_Ze_win);
+				if (ZeIndex == NR_CARDS) {
+					printk("Cyclades-Ze/PCI found at "
+						"0x%lx but no more cards can "
+						"be used.\nChange NR_CARDS in "
+						"cyclades.c and recompile "
+						"kernel.\n",
+						(ulong)cy_pci_phys2);
+				} else {
+					Ze_phys0[ZeIndex] = cy_pci_phys0;
+					Ze_phys2[ZeIndex] = cy_pci_phys2;
+					Ze_addr0[ZeIndex] = cy_pci_addr0;
+					Ze_addr2[ZeIndex] = cy_pci_addr2;
+					Ze_irq[ZeIndex] = cy_pci_irq;
+					Ze_pdev[ZeIndex] = pdev;
+					ZeIndex++;
+				}
+				i--;
+				continue;
+			} else {
+				cy_pci_addr2 = ioremap(cy_pci_phys2,CyPCI_Zwin);
+			}
 
-#ifdef CONFIG_CYZ_INTR
-                /* allocate IRQ only if board has an IRQ */
-		if( (cy_pci_irq != 0) && (cy_pci_irq != 255) ) {
-		    if(request_irq(cy_pci_irq, cyz_interrupt,
-			IRQF_SHARED, "Cyclades-Z", &cy_card[j]))
-		    {
-                        printk("Cyclom-8Zo/PCI found at 0x%lx ",
-			    (ulong) cy_pci_phys2);
-                        printk("but could not allocate IRQ%d.\n",
-			    cy_pci_irq);
-			return(i);
-		    }
-		}
-#endif /* CONFIG_CYZ_INTR */
+#ifdef CY_PCI_DEBUG
+			printk("Cyclades-Z/PCI: relocate winaddr=0x%lx "
+				"ctladdr=0x%lx\n",
+				(ulong) cy_pci_addr2, (ulong) cy_pci_addr0);
+			if (mailbox == ZO_V1) {
+				cy_writel(&((struct RUNTIME_9060 *)
+					(cy_pci_addr0))->loc_addr_base,
+					WIN_CREG);
+				PAUSE
+				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
+					"%lx\n", (ulong) (0xff &
+					cy_readl(&((struct CUSTOM_REG *)
+						(cy_pci_addr2))->fpga_id)),
+					(ulong)(0xff &
+					cy_readl(&((struct CUSTOM_REG *)
+						(cy_pci_addr2))->
+							fpga_version)));
+				cy_writel(&((struct RUNTIME_9060 *)
+					(cy_pci_addr0))->loc_addr_base,
+					WIN_RAM);
+			} else {
+				printk("Cyclades-Z/PCI: New Cyclades-Z board.  "
+						"FPGA not loaded\n");
+			}
+#endif
+			/* The following clears the firmware id word.  This
+			   ensures that the driver will not attempt to talk to
+			   the board until it has been properly initialized.
+			 */
+			PAUSE
+			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
+				cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
+
+			/* This must be a Cyclades-8Zo/PCI.  The extendable
+			   version will have a different device_id and will
+			   be allocated its maximum number of ports. */
+			cy_pci_nchan = 8;
+
+			if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+				printk("Cyclades-8Zo/PCI found at 0x%lx but"
+					"no channels are available.\nChange "
+					"NR_PORTS in cyclades.c and recompile "
+					"kernel.\n", (ulong)cy_pci_phys2);
+				return (i);
+			}
 
+			/* fill the next cy_card structure available */
+			for (j = 0; j < NR_CARDS; j++) {
+				if (cy_card[j].base_addr == 0)
+					break;
+			}
+			if (j == NR_CARDS) {	/* no more cy_cards available */
+				printk("Cyclades-8Zo/PCI found at 0x%lx but"
+					"no more cards can be used.\nChange "
+					"NR_CARDS in cyclades.c and recompile "
+					"kernel.\n", (ulong)cy_pci_phys2);
+				return (i);
+			}
+#ifdef CONFIG_CYZ_INTR
+			/* allocate IRQ only if board has an IRQ */
+			if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
+				if (request_irq(cy_pci_irq, cyz_interrupt,
+						IRQF_SHARED, "Cyclades-Z",
+						&cy_card[j])) {
+					printk("Cyclom-8Zo/PCI found at 0x%lx "
+						"but could not allocate "
+						"IRQ%d.\n", (ulong)cy_pci_phys2,
+						cy_pci_irq);
+					return (i);
+				}
+			}
+#endif				/* CONFIG_CYZ_INTR */
 
-                /* set cy_card */
-                cy_card[j].base_phys = cy_pci_phys2;
-                cy_card[j].ctl_phys = cy_pci_phys0;
-                cy_card[j].base_addr = cy_pci_addr2;
-                cy_card[j].ctl_addr = cy_pci_addr0;
-                cy_card[j].irq = (int) cy_pci_irq;
-                cy_card[j].bus_index = 1;
-                cy_card[j].first_line = cy_next_channel;
-                cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
+			/* set cy_card */
+			cy_card[j].base_phys = cy_pci_phys2;
+			cy_card[j].ctl_phys = cy_pci_phys0;
+			cy_card[j].base_addr = cy_pci_addr2;
+			cy_card[j].ctl_addr = cy_pci_addr0;
+			cy_card[j].irq = (int)cy_pci_irq;
+			cy_card[j].bus_index = 1;
+			cy_card[j].first_line = cy_next_channel;
+			cy_card[j].num_chips = -1;
+			cy_card[j].pdev = pdev;
 
-                /* print message */
+			/* print message */
 #ifdef CONFIG_CYZ_INTR
-		/* don't report IRQ if board is no IRQ */
-		if( (cy_pci_irq != 0) && (cy_pci_irq != 255) )
-		    printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-			j+1,(ulong)cy_pci_phys2,
-			(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1),
-			(int)cy_pci_irq);
-		else
-#endif /* CONFIG_CYZ_INTR */
-		    printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
-			j+1,(ulong)cy_pci_phys2,
-			(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1));
-
-                printk("%d channels starting from port %d.\n",
-		    cy_pci_nchan,cy_next_channel);
-                cy_next_channel += cy_pci_nchan;
-	    }
-        }
-
-        for (; ZeIndex != 0 && i < NR_CARDS; i++) {
-	    cy_pci_phys0 = Ze_phys0[0];
-	    cy_pci_phys2 = Ze_phys2[0];
-	    cy_pci_addr0 = Ze_addr0[0];
-	    cy_pci_addr2 = Ze_addr2[0];
-	    cy_pci_irq = Ze_irq[0];
-	    pdev = Ze_pdev[0];
-	    for (j = 0 ; j < ZeIndex-1 ; j++) {
-		Ze_phys0[j] = Ze_phys0[j+1];
-		Ze_phys2[j] = Ze_phys2[j+1];
-		Ze_addr0[j] = Ze_addr0[j+1];
-		Ze_addr2[j] = Ze_addr2[j+1];
-		Ze_irq[j] = Ze_irq[j+1];
-		Ze_pdev[j] = Ze_pdev[j+1];
-	    }
-	    ZeIndex--;
-		mailbox = (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *) 
-					   cy_pci_addr0)->mail_box_0);
+			/* don't report IRQ if board is no IRQ */
+			if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
+				printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
+					"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
+					(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
+					(int)cy_pci_irq);
+			else
+#endif				/* CONFIG_CYZ_INTR */
+				printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
+					j + 1, (ulong)cy_pci_phys2,
+					(ulong)(cy_pci_phys2 + CyPCI_Zwin - 1));
+
+			printk("%d channels starting from port %d.\n",
+					cy_pci_nchan, cy_next_channel);
+			cy_next_channel += cy_pci_nchan;
+		}
+	}
+
+	for (; ZeIndex != 0 && i < NR_CARDS; i++) {
+		cy_pci_phys0 = Ze_phys0[0];
+		cy_pci_phys2 = Ze_phys2[0];
+		cy_pci_addr0 = Ze_addr0[0];
+		cy_pci_addr2 = Ze_addr2[0];
+		cy_pci_irq = Ze_irq[0];
+		pdev = Ze_pdev[0];
+		for (j = 0; j < ZeIndex - 1; j++) {
+			Ze_phys0[j] = Ze_phys0[j + 1];
+			Ze_phys2[j] = Ze_phys2[j + 1];
+			Ze_addr0[j] = Ze_addr0[j + 1];
+			Ze_addr2[j] = Ze_addr2[j + 1];
+			Ze_irq[j] = Ze_irq[j + 1];
+			Ze_pdev[j] = Ze_pdev[j + 1];
+		}
+		ZeIndex--;
+		mailbox = (uclong)cy_readl(&((struct RUNTIME_9060 __iomem *)
+						cy_pci_addr0)->mail_box_0);
 #ifdef CY_PCI_DEBUG
-            printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
-                (ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
-	    printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not loaded\n");
+		printk("Cyclades-Z/PCI: relocate winaddr=0x%lx ctladdr=0x%lx\n",
+			(ulong)cy_pci_addr2, (ulong)cy_pci_addr0);
+		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
+				"loaded\n");
 #endif
 		PAUSE
-                /* This must be the new Cyclades-Ze/PCI. */
-                cy_pci_nchan = ZE_V1_NPORTS;
+		/* This must be the new Cyclades-Ze/PCI. */
+		cy_pci_nchan = ZE_V1_NPORTS;
 
-                if((cy_next_channel+cy_pci_nchan) > NR_PORTS) {
-                        printk("Cyclades-Ze/PCI found at 0x%lx ",
-			    (ulong)cy_pci_phys2);
-                        printk("but no channels are available.\n");
-                        printk("Change NR_PORTS in cyclades.c and recompile kernel.\n");
-                        return(i);
-                }
-
-                /* fill the next cy_card structure available */
-                for (j = 0 ; j < NR_CARDS ; j++) {
-                        if (cy_card[j].base_addr == 0)  break;
-                }
-                if (j == NR_CARDS) {    /* no more cy_cards available */
-		    printk("Cyclades-Ze/PCI found at 0x%lx ",
-			(ulong)cy_pci_phys2);
-		    printk("but no more cards can be used.\n");
-                    printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
-		    return(i);
-                }
+		if ((cy_next_channel + cy_pci_nchan) > NR_PORTS) {
+			printk("Cyclades-Ze/PCI found at 0x%lx but no channels "
+				"are available.\nChange NR_PORTS in cyclades.c "
+				"and recompile kernel.\n",
+				(ulong) cy_pci_phys2);
+			return (i);
+		}
 
+		/* fill the next cy_card structure available */
+		for (j = 0; j < NR_CARDS; j++) {
+			if (cy_card[j].base_addr == 0)
+				break;
+		}
+		if (j == NR_CARDS) {	/* no more cy_cards available */
+			printk("Cyclades-Ze/PCI found at 0x%lx but no more "
+				"cards can be used.\nChange NR_CARDS in "
+				"cyclades.c and recompile kernel.\n",
+				(ulong) cy_pci_phys2);
+			return (i);
+		}
 #ifdef CONFIG_CYZ_INTR
-                /* allocate IRQ only if board has an IRQ */
-		if( (cy_pci_irq != 0) && (cy_pci_irq != 255) ) {
-		    if(request_irq(cy_pci_irq, cyz_interrupt,
-			IRQF_SHARED, "Cyclades-Z", &cy_card[j]))
-		    {
-                        printk("Cyclom-Ze/PCI found at 0x%lx ",
-			    (ulong) cy_pci_phys2);
-                        printk("but could not allocate IRQ%d.\n",
-			    cy_pci_irq);
-			return(i);
-		    }
+		/* allocate IRQ only if board has an IRQ */
+		if ((cy_pci_irq != 0) && (cy_pci_irq != 255)) {
+			if (request_irq(cy_pci_irq, cyz_interrupt,
+					IRQF_SHARED, "Cyclades-Z",
+					&cy_card[j])) {
+				printk("Cyclom-Ze/PCI found at 0x%lx ",
+					(ulong) cy_pci_phys2);
+				printk("but could not allocate IRQ%d.\n",
+					cy_pci_irq);
+				return (i);
+			}
 		}
-#endif /* CONFIG_CYZ_INTR */
+#endif				/* CONFIG_CYZ_INTR */
 
-                /* set cy_card */
-                cy_card[j].base_phys = cy_pci_phys2;
-                cy_card[j].ctl_phys = cy_pci_phys0;
-                cy_card[j].base_addr = cy_pci_addr2;
-                cy_card[j].ctl_addr = cy_pci_addr0;
-                cy_card[j].irq = (int) cy_pci_irq;
-                cy_card[j].bus_index = 1;
-                cy_card[j].first_line = cy_next_channel;
-                cy_card[j].num_chips = -1;
+		/* set cy_card */
+		cy_card[j].base_phys = cy_pci_phys2;
+		cy_card[j].ctl_phys = cy_pci_phys0;
+		cy_card[j].base_addr = cy_pci_addr2;
+		cy_card[j].ctl_addr = cy_pci_addr0;
+		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].bus_index = 1;
+		cy_card[j].first_line = cy_next_channel;
+		cy_card[j].num_chips = -1;
 		cy_card[j].pdev = pdev;
 
-                /* print message */
+		/* print message */
 #ifdef CONFIG_CYZ_INTR
 		/* don't report IRQ if board is no IRQ */
-		if( (cy_pci_irq != 0) && (cy_pci_irq != 255) )
-		    printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
-			j+1,(ulong)cy_pci_phys2,
-			(ulong)(cy_pci_phys2 + CyPCI_Ze_win - 1),
-			(int)cy_pci_irq);
+		if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
+			printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
+				j + 1, (ulong) cy_pci_phys2,
+				(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1),
+				(int)cy_pci_irq);
 		else
-#endif /* CONFIG_CYZ_INTR */
-		    printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
-			j+1,(ulong)cy_pci_phys2,
-			(ulong)(cy_pci_phys2 + CyPCI_Ze_win - 1));
-
-                printk("%d channels starting from port %d.\n",
-		    cy_pci_nchan,cy_next_channel);
-                cy_next_channel += cy_pci_nchan;
-        }
+#endif				/* CONFIG_CYZ_INTR */
+			printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
+				j + 1, (ulong) cy_pci_phys2,
+				(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1));
+
+		printk("%d channels starting from port %d.\n",
+			cy_pci_nchan, cy_next_channel);
+		cy_next_channel += cy_pci_nchan;
+	}
 	if (ZeIndex != 0) {
-	    printk("Cyclades-Ze/PCI found at 0x%x ",
-		(unsigned int) Ze_phys2[0]);
-	    printk("but no more cards can be used.\n");
-            printk("Change NR_CARDS in cyclades.c and recompile kernel.\n");
+		printk("Cyclades-Ze/PCI found at 0x%x but no more cards can be "
+			"used.\nChange NR_CARDS in cyclades.c and recompile "
+			"kernel.\n", (unsigned int)Ze_phys2[0]);
 	}
-        return(i);
+	return (i);
 #else
-        return(0);
-#endif /* ifdef CONFIG_PCI */
-} /* cy_detect_pci */
-
+	return (0);
+#endif				/* ifdef CONFIG_PCI */
+}				/* cy_detect_pci */
 
 /*
  * This routine prints out the appropriate serial driver version number
  * and identifies which options were configured into this driver.
  */
-static inline void
-show_version(void)
+static inline void show_version(void)
 {
-  char *rcsvers, *rcsdate, *tmp;
-    rcsvers = strchr(rcsid, ' '); rcsvers++;
-    tmp = strchr(rcsvers, ' '); *tmp++ = '\0';
-    rcsdate = strchr(tmp, ' '); rcsdate++;
-    tmp = strrchr(rcsdate, ' '); *tmp = '\0';
-    printk("Cyclades driver %s %s\n",
-        rcsvers, rcsdate);
-    printk("        built %s %s\n",
-	__DATE__, __TIME__);
-} /* show_version */
+	char *rcsvers, *rcsdate, *tmp;
+	rcsvers = strchr(rcsid, ' ');
+	rcsvers++;
+	tmp = strchr(rcsvers, ' ');
+	*tmp++ = '\0';
+	rcsdate = strchr(tmp, ' ');
+	rcsdate++;
+	tmp = strrchr(rcsdate, ' ');
+	*tmp = '\0';
+	printk("Cyclades driver %s %s\n", rcsvers, rcsdate);
+	printk("        built %s %s\n", __DATE__, __TIME__);
+}				/* show_version */
 
-static int 
+static int
 cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
-		       int *eof, void *data)
+		int *eof, void *data)
 {
-    struct cyclades_port  *info;
-    int i;
-    int len=0;
-    off_t begin=0;
-    off_t pos=0;
-    int size;
-    __u32 cur_jifs = jiffies;
-
-    size = sprintf(buf, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   IdleIn  Overruns  Ldisc\n");
-
-    pos += size;
-    len += size;
-
-    /* Output one line for each known port */
-    for (i = 0; i < NR_PORTS && cy_port[i].line >= 0; i++) {
-	info = &cy_port[i];
-
-	if (info->count)
-	    size = sprintf(buf+len,
-			"%3d %8lu %10lu %8lu %10lu %8lu %9lu %6ld\n",
-			info->line,
-			JIFFIES_DIFF(info->idle_stats.in_use, cur_jifs) / HZ,
-			info->idle_stats.xmit_bytes,
-			JIFFIES_DIFF(info->idle_stats.xmit_idle, cur_jifs) / HZ,
-			info->idle_stats.recv_bytes,
-			JIFFIES_DIFF(info->idle_stats.recv_idle, cur_jifs) / HZ,
-			info->idle_stats.overruns,
-			(long) info->tty->ldisc.num);
-	else
-	    size = sprintf(buf+len,
-			"%3d %8lu %10lu %8lu %10lu %8lu %9lu %6ld\n",
-			info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
+	struct cyclades_port *info;
+	int i;
+	int len = 0;
+	off_t begin = 0;
+	off_t pos = 0;
+	int size;
+	__u32 cur_jifs = jiffies;
+
+	size = sprintf(buf, "Dev TimeOpen   BytesOut  IdleOut    BytesIn   "
+			"IdleIn  Overruns  Ldisc\n");
+
+	pos += size;
 	len += size;
-	pos = begin + len;
 
-	if (pos < offset) {
-	    len   = 0;
-	    begin = pos;
-	}
-	if (pos > offset + length)
-	    goto done;
-    }
-    *eof = 1;
+	/* Output one line for each known port */
+	for (i = 0; i < NR_PORTS && cy_port[i].line >= 0; i++) {
+		info = &cy_port[i];
+
+		if (info->count)
+			size = sprintf(buf + len, "%3d %8lu %10lu %8lu %10lu "
+				"%8lu %9lu %6ld\n", info->line,
+				JIFFIES_DIFF(info->idle_stats.in_use,
+					cur_jifs) / HZ,
+				info->idle_stats.xmit_bytes,
+				JIFFIES_DIFF(info->idle_stats.xmit_idle,
+					cur_jifs) / HZ,
+				info->idle_stats.recv_bytes,
+				JIFFIES_DIFF(info->idle_stats.recv_idle,
+					cur_jifs) / HZ,
+				info->idle_stats.overruns,
+				(long)info->tty->ldisc.num);
+		else
+			size = sprintf(buf + len, "%3d %8lu %10lu %8lu %10lu "
+				"%8lu %9lu %6ld\n",
+				info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
+		len += size;
+		pos = begin + len;
+
+		if (pos < offset) {
+			len = 0;
+			begin = pos;
+		}
+		if (pos > offset + length)
+			goto done;
+	}
+	*eof = 1;
 done:
-    *start = buf + (offset - begin);	/* Start of wanted data */
-    len -= (offset - begin);		/* Start slop */
-    if (len > length)
-	len = length;			/* Ending slop */
-    if (len < 0)
-	len = 0;
-    return len;
+	*start = buf + (offset - begin);	/* Start of wanted data */
+	len -= (offset - begin);	/* Start slop */
+	if (len > length)
+		len = length;	/* Ending slop */
+	if (len < 0)
+		len = 0;
+	return len;
 }
 
 /* The serial driver boot-time initialization code!
@@ -5190,290 +5326,288 @@ done:
  */
 
 static const struct tty_operations cy_ops = {
-    .open = cy_open,
-    .close = cy_close,
-    .write = cy_write,
-    .put_char = cy_put_char,
-    .flush_chars = cy_flush_chars,
-    .write_room = cy_write_room,
-    .chars_in_buffer = cy_chars_in_buffer,
-    .flush_buffer = cy_flush_buffer,
-    .ioctl = cy_ioctl,
-    .throttle = cy_throttle,
-    .unthrottle = cy_unthrottle,
-    .set_termios = cy_set_termios,
-    .stop = cy_stop,
-    .start = cy_start,
-    .hangup = cy_hangup,
-    .break_ctl = cy_break,
-    .wait_until_sent = cy_wait_until_sent,
-    .read_proc = cyclades_get_proc_info,
-    .tiocmget = cy_tiocmget,
-    .tiocmset = cy_tiocmset,
+	.open = cy_open,
+	.close = cy_close,
+	.write = cy_write,
+	.put_char = cy_put_char,
+	.flush_chars = cy_flush_chars,
+	.write_room = cy_write_room,
+	.chars_in_buffer = cy_chars_in_buffer,
+	.flush_buffer = cy_flush_buffer,
+	.ioctl = cy_ioctl,
+	.throttle = cy_throttle,
+	.unthrottle = cy_unthrottle,
+	.set_termios = cy_set_termios,
+	.stop = cy_stop,
+	.start = cy_start,
+	.hangup = cy_hangup,
+	.break_ctl = cy_break,
+	.wait_until_sent = cy_wait_until_sent,
+	.read_proc = cyclades_get_proc_info,
+	.tiocmget = cy_tiocmget,
+	.tiocmset = cy_tiocmset,
 };
 
-static int __init
-cy_init(void)
+static int __init cy_init(void)
 {
-  struct cyclades_port  *info;
-  struct cyclades_card *cinfo;
-  int number_z_boards = 0;
-  int board,port,i,index;
-  unsigned long mailbox;
-  unsigned short chip_number;
-  int nports;
-
-    cy_serial_driver = alloc_tty_driver(NR_PORTS);
-    if (!cy_serial_driver)
-	return -ENOMEM;
-    show_version();
-
-    /* Initialize the tty_driver structure */
-    
-    cy_serial_driver->owner = THIS_MODULE;
-    cy_serial_driver->driver_name = "cyclades";
-    cy_serial_driver->name = "ttyC";
-    cy_serial_driver->major = CYCLADES_MAJOR;
-    cy_serial_driver->minor_start = 0;
-    cy_serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
-    cy_serial_driver->subtype = SERIAL_TYPE_NORMAL;
-    cy_serial_driver->init_termios = tty_std_termios;
-    cy_serial_driver->init_termios.c_cflag =
-            B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-    cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
-    tty_set_operations(cy_serial_driver, &cy_ops);
-
-    if (tty_register_driver(cy_serial_driver))
-            panic("Couldn't register Cyclades serial driver\n");
-
-    for (i = 0; i < NR_CARDS; i++) {
-            /* base_addr=0 indicates board not found */
-            cy_card[i].base_addr = NULL;
-    }
-
-    /* the code below is responsible to find the boards. Each different
-       type of board has its own detection routine. If a board is found,
-       the next cy_card structure available is set by the detection
-       routine. These functions are responsible for checking the
-       availability of cy_card and cy_port data structures and updating
-       the cy_next_channel. */
-
-    /* look for isa boards */
-    cy_isa_nboard = cy_detect_isa();
-
-    /* look for pci boards */
-    cy_pci_nboard = cy_detect_pci();
-
-    cy_nboard = cy_isa_nboard + cy_pci_nboard;
-
-    /* invalidate remaining cy_card structures */
-    for (i = 0 ; i < NR_CARDS ; i++) {
-        if (cy_card[i].base_addr == 0) {
-                cy_card[i].first_line = -1;
-                cy_card[i].ctl_addr = NULL;
-                cy_card[i].irq = 0;
-                cy_card[i].bus_index = 0;
-                cy_card[i].first_line = 0;
-                cy_card[i].num_chips = 0;
-        }
-    }
-    /* invalidate remaining cy_port structures */
-    for (i = cy_next_channel ; i < NR_PORTS ; i++) {
-        cy_port[i].line = -1;
-        cy_port[i].magic = -1;
-    }
-
-    /* initialize per-port data structures for each valid board found */
-    for (board = 0 ; board < cy_nboard ; board++) {
-            cinfo = &cy_card[board];
-            if (cinfo->num_chips == -1) { /* Cyclades-Z */
-		number_z_boards++;
-		mailbox = cy_readl(&((struct RUNTIME_9060 __iomem *)
-			     cy_card[board].ctl_addr)->mail_box_0);
-		nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
-		cinfo->intr_enabled = 0;
-		cinfo->nports = 0; /* Will be correctly set later, after 
-				      Z FW is loaded */
-		spin_lock_init(&cinfo->card_lock);
-                for (port = cinfo->first_line ;
-                     port < cinfo->first_line + nports;
-                     port++)
-                {
-                    info = &cy_port[port];
-                    info->magic = CYCLADES_MAGIC;
-                    info->type = PORT_STARTECH;
-                    info->card = board;
-                    info->line = port;
-		    info->chip_rev = 0;
-                    info->flags = STD_COM_FLAGS;
-                    info->tty = NULL;
-		    if (mailbox == ZO_V1)
-			info->xmit_fifo_size = CYZ_FIFO_SIZE;
-		    else
-			info->xmit_fifo_size = 4 * CYZ_FIFO_SIZE;
-                    info->cor1 = 0;
-                    info->cor2 = 0;
-                    info->cor3 = 0;
-                    info->cor4 = 0;
-                    info->cor5 = 0;
-                    info->tbpr = 0;
-                    info->tco = 0;
-                    info->rbpr = 0;
-                    info->rco = 0;
-		    info->custom_divisor = 0;
-                    info->close_delay = 5*HZ/10;
-		    info->closing_wait = CLOSING_WAIT_DELAY;
-		    info->icount.cts = info->icount.dsr = 
-			info->icount.rng = info->icount.dcd = 0;
-		    info->icount.rx = info->icount.tx = 0;
-		    info->icount.frame = info->icount.parity = 0;
-		    info->icount.overrun = info->icount.brk = 0;
-                    info->x_char = 0;
-                    info->event = 0;
-                    info->count = 0;
-                    info->blocked_open = 0;
-                    info->default_threshold = 0;
-                    info->default_timeout = 0;
-		    INIT_WORK(&info->tqueue, do_softint);
-		    init_waitqueue_head(&info->open_wait);
-		    init_waitqueue_head(&info->close_wait);
-		    init_waitqueue_head(&info->shutdown_wait);
-		    init_waitqueue_head(&info->delta_msr_wait);
-                    /* info->session */
-                    /* info->pgrp */
-                    info->read_status_mask = 0;
-                    /* info->timeout */
-		    /* Bentson's vars */
-                    info->jiffies[0] = 0;
-                    info->jiffies[1] = 0;
-                    info->jiffies[2] = 0;
-                    info->rflush_count = 0;
+	struct cyclades_port *info;
+	struct cyclades_card *cinfo;
+	int number_z_boards = 0;
+	int board, port, i, index;
+	unsigned long mailbox;
+	unsigned short chip_number;
+	int nports;
+
+	cy_serial_driver = alloc_tty_driver(NR_PORTS);
+	if (!cy_serial_driver)
+		return -ENOMEM;
+	show_version();
+
+	/* Initialize the tty_driver structure */
+
+	cy_serial_driver->owner = THIS_MODULE;
+	cy_serial_driver->driver_name = "cyclades";
+	cy_serial_driver->name = "ttyC";
+	cy_serial_driver->major = CYCLADES_MAJOR;
+	cy_serial_driver->minor_start = 0;
+	cy_serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	cy_serial_driver->subtype = SERIAL_TYPE_NORMAL;
+	cy_serial_driver->init_termios = tty_std_termios;
+	cy_serial_driver->init_termios.c_cflag =
+	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
+	tty_set_operations(cy_serial_driver, &cy_ops);
+
+	if (tty_register_driver(cy_serial_driver))
+		panic("Couldn't register Cyclades serial driver\n");
+
+	for (i = 0; i < NR_CARDS; i++) {
+		/* base_addr=0 indicates board not found */
+		cy_card[i].base_addr = NULL;
+	}
+
+	/* the code below is responsible to find the boards. Each different
+	   type of board has its own detection routine. If a board is found,
+	   the next cy_card structure available is set by the detection
+	   routine. These functions are responsible for checking the
+	   availability of cy_card and cy_port data structures and updating
+	   the cy_next_channel. */
+
+	/* look for isa boards */
+	cy_isa_nboard = cy_detect_isa();
+
+	/* look for pci boards */
+	cy_pci_nboard = cy_detect_pci();
+
+	cy_nboard = cy_isa_nboard + cy_pci_nboard;
+
+	/* invalidate remaining cy_card structures */
+	for (i = 0; i < NR_CARDS; i++) {
+		if (cy_card[i].base_addr == 0) {
+			cy_card[i].first_line = -1;
+			cy_card[i].ctl_addr = NULL;
+			cy_card[i].irq = 0;
+			cy_card[i].bus_index = 0;
+			cy_card[i].first_line = 0;
+			cy_card[i].num_chips = 0;
+		}
+	}
+	/* invalidate remaining cy_port structures */
+	for (i = cy_next_channel; i < NR_PORTS; i++) {
+		cy_port[i].line = -1;
+		cy_port[i].magic = -1;
+	}
+
+	/* initialize per-port data structures for each valid board found */
+	for (board = 0; board < cy_nboard; board++) {
+		cinfo = &cy_card[board];
+		if (cinfo->num_chips == -1) {	/* Cyclades-Z */
+			number_z_boards++;
+			mailbox = cy_readl(&((struct RUNTIME_9060 __iomem *)
+					     cy_card[board].ctl_addr)->
+					   mail_box_0);
+			nports = (mailbox == ZE_V1) ? ZE_V1_NPORTS : 8;
+			cinfo->intr_enabled = 0;
+			cinfo->nports = 0;	/* Will be correctly set later, after 
+						   Z FW is loaded */
+			spin_lock_init(&cinfo->card_lock);
+			for (port = cinfo->first_line;
+			     port < cinfo->first_line + nports; port++) {
+				info = &cy_port[port];
+				info->magic = CYCLADES_MAGIC;
+				info->type = PORT_STARTECH;
+				info->card = board;
+				info->line = port;
+				info->chip_rev = 0;
+				info->flags = STD_COM_FLAGS;
+				info->tty = NULL;
+				if (mailbox == ZO_V1)
+					info->xmit_fifo_size = CYZ_FIFO_SIZE;
+				else
+					info->xmit_fifo_size =
+					    4 * CYZ_FIFO_SIZE;
+				info->cor1 = 0;
+				info->cor2 = 0;
+				info->cor3 = 0;
+				info->cor4 = 0;
+				info->cor5 = 0;
+				info->tbpr = 0;
+				info->tco = 0;
+				info->rbpr = 0;
+				info->rco = 0;
+				info->custom_divisor = 0;
+				info->close_delay = 5 * HZ / 10;
+				info->closing_wait = CLOSING_WAIT_DELAY;
+				info->icount.cts = info->icount.dsr =
+				    info->icount.rng = info->icount.dcd = 0;
+				info->icount.rx = info->icount.tx = 0;
+				info->icount.frame = info->icount.parity = 0;
+				info->icount.overrun = info->icount.brk = 0;
+				info->x_char = 0;
+				info->event = 0;
+				info->count = 0;
+				info->blocked_open = 0;
+				info->default_threshold = 0;
+				info->default_timeout = 0;
+				INIT_WORK(&info->tqueue, do_softint);
+				init_waitqueue_head(&info->open_wait);
+				init_waitqueue_head(&info->close_wait);
+				init_waitqueue_head(&info->shutdown_wait);
+				init_waitqueue_head(&info->delta_msr_wait);
+				/* info->session */
+				/* info->pgrp */
+				info->read_status_mask = 0;
+				/* info->timeout */
+				/* Bentson's vars */
+				info->jiffies[0] = 0;
+				info->jiffies[1] = 0;
+				info->jiffies[2] = 0;
+				info->rflush_count = 0;
 #ifdef CONFIG_CYZ_INTR
-		    init_timer(&cyz_rx_full_timer[port]);
-		    cyz_rx_full_timer[port].function = NULL;
+				init_timer(&cyz_rx_full_timer[port]);
+				cyz_rx_full_timer[port].function = NULL;
 #endif
-                }
-                continue;
-            }else{ /* Cyclom-Y of some kind*/
-                index = cinfo->bus_index;
-		spin_lock_init(&cinfo->card_lock);
-		cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
-                for (port = cinfo->first_line ;
-                     port < cinfo->first_line + cinfo->nports ;
-                     port++)
-                {
-                    info = &cy_port[port];
-                    info->magic = CYCLADES_MAGIC;
-                    info->type = PORT_CIRRUS;
-                    info->card = board;
-                    info->line = port;
-                    info->flags = STD_COM_FLAGS;
-                    info->tty = NULL;
-                    info->xmit_fifo_size = CyMAX_CHAR_FIFO;
-                    info->cor1 = CyPARITY_NONE|Cy_1_STOP|Cy_8_BITS;
-                    info->cor2 = CyETC;
-                    info->cor3 = 0x08; /* _very_ small rcv threshold */
-                    info->cor4 = 0;
-                    info->cor5 = 0;
-		    info->custom_divisor = 0;
-                    info->close_delay = 5*HZ/10;
-		    info->closing_wait = CLOSING_WAIT_DELAY;
-		    info->icount.cts = info->icount.dsr = 
-			info->icount.rng = info->icount.dcd = 0;
-		    info->icount.rx = info->icount.tx = 0;
-		    info->icount.frame = info->icount.parity = 0;
-		    info->icount.overrun = info->icount.brk = 0;
-		    chip_number = (port - cinfo->first_line) / 4;
-		    if ((info->chip_rev =
-			 cy_readb(cinfo->base_addr +
-				  (cy_chip_offset[chip_number]<<index) +
-				  (CyGFRCR<<index))) >= CD1400_REV_J) {
-                        /* It is a CD1400 rev. J or later */
-                        info->tbpr = baud_bpr_60[13]; /* Tx BPR */
-                        info->tco = baud_co_60[13]; /* Tx CO */
-                        info->rbpr = baud_bpr_60[13]; /* Rx BPR */
-                        info->rco = baud_co_60[13]; /* Rx CO */
-                        info->rflow = 0;
-                        info->rtsdtr_inv = 1;
-                    } else {
-                        info->tbpr = baud_bpr_25[13]; /* Tx BPR */
-                        info->tco = baud_co_25[13]; /* Tx CO */
-                        info->rbpr = baud_bpr_25[13]; /* Rx BPR */
-                        info->rco = baud_co_25[13]; /* Rx CO */
-                        info->rflow = 0;
-                        info->rtsdtr_inv = 0;
-                    }
-                    info->x_char = 0;
-                    info->event = 0;
-                    info->count = 0;
-                    info->blocked_open = 0;
-                    info->default_threshold = 0;
-                    info->default_timeout = 0;
-		    INIT_WORK(&info->tqueue, do_softint);
-		    init_waitqueue_head(&info->open_wait);
-		    init_waitqueue_head(&info->close_wait);
-		    init_waitqueue_head(&info->shutdown_wait);
-		    init_waitqueue_head(&info->delta_msr_wait);
-                    /* info->session */
-                    /* info->pgrp */
-                    info->read_status_mask =
-		                  CyTIMEOUT| CySPECHAR| CyBREAK
-                                  | CyPARITY| CyFRAME| CyOVERRUN;
-                    /* info->timeout */
-                }
-            }
-    }
+			}
+			continue;
+		} else {	/* Cyclom-Y of some kind */
+			index = cinfo->bus_index;
+			spin_lock_init(&cinfo->card_lock);
+			cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
+			for (port = cinfo->first_line;
+			     port < cinfo->first_line + cinfo->nports; port++) {
+				info = &cy_port[port];
+				info->magic = CYCLADES_MAGIC;
+				info->type = PORT_CIRRUS;
+				info->card = board;
+				info->line = port;
+				info->flags = STD_COM_FLAGS;
+				info->tty = NULL;
+				info->xmit_fifo_size = CyMAX_CHAR_FIFO;
+				info->cor1 =
+				    CyPARITY_NONE | Cy_1_STOP | Cy_8_BITS;
+				info->cor2 = CyETC;
+				info->cor3 = 0x08;	/* _very_ small rcv threshold */
+				info->cor4 = 0;
+				info->cor5 = 0;
+				info->custom_divisor = 0;
+				info->close_delay = 5 * HZ / 10;
+				info->closing_wait = CLOSING_WAIT_DELAY;
+				info->icount.cts = info->icount.dsr =
+				    info->icount.rng = info->icount.dcd = 0;
+				info->icount.rx = info->icount.tx = 0;
+				info->icount.frame = info->icount.parity = 0;
+				info->icount.overrun = info->icount.brk = 0;
+				chip_number = (port - cinfo->first_line) / 4;
+				if ((info->chip_rev =
+				     cy_readb(cinfo->base_addr +
+					      (cy_chip_offset[chip_number] <<
+					       index) + (CyGFRCR << index))) >=
+				    CD1400_REV_J) {
+					/* It is a CD1400 rev. J or later */
+					info->tbpr = baud_bpr_60[13];	/* Tx BPR */
+					info->tco = baud_co_60[13];	/* Tx CO */
+					info->rbpr = baud_bpr_60[13];	/* Rx BPR */
+					info->rco = baud_co_60[13];	/* Rx CO */
+					info->rflow = 0;
+					info->rtsdtr_inv = 1;
+				} else {
+					info->tbpr = baud_bpr_25[13];	/* Tx BPR */
+					info->tco = baud_co_25[13];	/* Tx CO */
+					info->rbpr = baud_bpr_25[13];	/* Rx BPR */
+					info->rco = baud_co_25[13];	/* Rx CO */
+					info->rflow = 0;
+					info->rtsdtr_inv = 0;
+				}
+				info->x_char = 0;
+				info->event = 0;
+				info->count = 0;
+				info->blocked_open = 0;
+				info->default_threshold = 0;
+				info->default_timeout = 0;
+				INIT_WORK(&info->tqueue, do_softint);
+				init_waitqueue_head(&info->open_wait);
+				init_waitqueue_head(&info->close_wait);
+				init_waitqueue_head(&info->shutdown_wait);
+				init_waitqueue_head(&info->delta_msr_wait);
+				/* info->session */
+				/* info->pgrp */
+				info->read_status_mask =
+				    CyTIMEOUT | CySPECHAR | CyBREAK
+				    | CyPARITY | CyFRAME | CyOVERRUN;
+				/* info->timeout */
+			}
+		}
+	}
 
 #ifndef CONFIG_CYZ_INTR
-    if (number_z_boards && !cyz_timeron){
-	cyz_timeron++;
-	cyz_timerlist.expires = jiffies + 1;
-	add_timer(&cyz_timerlist);
+	if (number_z_boards && !cyz_timeron) {
+		cyz_timeron++;
+		cyz_timerlist.expires = jiffies + 1;
+		add_timer(&cyz_timerlist);
 #ifdef CY_PCI_DEBUG
-	printk("Cyclades-Z polling initialized\n");
+		printk("Cyclades-Z polling initialized\n");
 #endif
-    }
-#endif /* CONFIG_CYZ_INTR */
+	}
+#endif				/* CONFIG_CYZ_INTR */
+
+	return 0;
 
-    return 0;
-    
-} /* cy_init */
+}				/* cy_init */
 
-static void __exit
-cy_cleanup_module(void)
+static void __exit cy_cleanup_module(void)
 {
-    int i, e1;
+	int i, e1;
 
 #ifndef CONFIG_CYZ_INTR
-    if (cyz_timeron){
-	cyz_timeron = 0;
-	del_timer(&cyz_timerlist);
-    }
+	if (cyz_timeron){
+		cyz_timeron = 0;
+		del_timer(&cyz_timerlist);
+	}
 #endif /* CONFIG_CYZ_INTR */
 
-    if ((e1 = tty_unregister_driver(cy_serial_driver)))
-            printk("cyc: failed to unregister Cyclades serial driver(%d)\n",
-		e1);
-
-    put_tty_driver(cy_serial_driver);
-
-    for (i = 0; i < NR_CARDS; i++) {
-        if (cy_card[i].base_addr) {
-	    iounmap(cy_card[i].base_addr);
-	    if (cy_card[i].ctl_addr)
-		iounmap(cy_card[i].ctl_addr);
-	    if (cy_card[i].irq
+	if ((e1 = tty_unregister_driver(cy_serial_driver)))
+		printk("cyc: failed to unregister Cyclades serial driver(%d)\n",
+			e1);
+
+	put_tty_driver(cy_serial_driver);
+
+	for (i = 0; i < NR_CARDS; i++) {
+		if (cy_card[i].base_addr) {
+			iounmap(cy_card[i].base_addr);
+			if (cy_card[i].ctl_addr)
+				iounmap(cy_card[i].ctl_addr);
+			if (cy_card[i].irq
 #ifndef CONFIG_CYZ_INTR
-		&& cy_card[i].num_chips != -1 /* not a Z card */
+				&& cy_card[i].num_chips != -1 /* not a Z card */
 #endif /* CONFIG_CYZ_INTR */
-	    )
-		free_irq(cy_card[i].irq, &cy_card[i]);
+				)
+				free_irq(cy_card[i].irq, &cy_card[i]);
 #ifdef CONFIG_PCI
-		if (cy_card[i].pdev)
-			pci_release_regions(cy_card[i].pdev);
+			if (cy_card[i].pdev)
+				pci_release_regions(cy_card[i].pdev);
 #endif
-        }
-    }
+		}
+	}
 } /* cy_cleanup_module */
 
 module_init(cy_init);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

