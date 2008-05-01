From: akpm@linux-foundation.org
Subject: - serial-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:19 -0700
Message-ID: <200805010933.m419XJCq031131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757193AbYEAJdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serial: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     serial-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/68360serial.c            |    4 +-
 drivers/serial/8250_early.c             |    2 -
 drivers/serial/bfin_5xx.c               |    4 +-
 drivers/serial/cpm_uart/cpm_uart_core.c |    2 -
 drivers/serial/crisv10.c                |    8 ++--
 drivers/serial/ioc3_serial.c            |   36 +++++++++++-----------
 drivers/serial/ioc4_serial.c            |   32 +++++++++----------
 drivers/serial/s3c2410.c                |    6 +--
 drivers/serial/sa1100.c                 |    4 +-
 drivers/serial/sh-sci.c                 |    2 -
 drivers/serial/sn_console.c             |    2 -
 drivers/serial/uartlite.c               |    2 -
 drivers/serial/ucc_uart.c               |    4 +-
 13 files changed, 54 insertions(+), 54 deletions(-)

diff -puN drivers/serial/68360serial.c~serial-replace-remaining-__function__-occurrences drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/68360serial.c
@@ -1247,7 +1247,7 @@ static int rs_360_tiocmget(struct tty_st
 #ifdef modem_control
 	unsigned char control, status;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
@@ -1278,7 +1278,7 @@ static int rs_360_tiocmset(struct tty_st
 	ser_info_t *info = (ser_info_t *)tty->driver_data;
  	unsigned int arg;
 
-	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
+	if (serial_paranoia_check(info, tty->name, __func__))
 		return -ENODEV;
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
diff -puN drivers/serial/8250_early.c~serial-replace-remaining-__function__-occurrences drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/8250_early.c
@@ -156,7 +156,7 @@ static int __init parse_options(struct e
 		port->membase = ioremap(port->mapbase, 64);
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
-				__FUNCTION__,
+				__func__,
 			       (unsigned long long)port->mapbase);
 			return -ENOMEM;
 		}
diff -puN drivers/serial/bfin_5xx.c~serial-replace-remaining-__function__-occurrences drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/bfin_5xx.c
@@ -762,7 +762,7 @@ bfin_serial_set_termios(struct uart_port
 		break;
 	default:
 		printk(KERN_ERR "%s: word lengh not supported\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	if (termios->c_cflag & CSTOPB)
@@ -1029,7 +1029,7 @@ bfin_serial_console_get_options(struct b
 
 		*baud = get_sclk() / (16*(dll | dlh << 8));
 	}
-	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __FUNCTION__, *baud, *parity, *bits);
+	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __func__, *baud, *parity, *bits);
 }
 #endif
 
diff -puN drivers/serial/cpm_uart/cpm_uart_core.c~serial-replace-remaining-__function__-occurrences drivers/serial/cpm_uart/cpm_uart_core.c
--- a/drivers/serial/cpm_uart/cpm_uart_core.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/cpm_uart/cpm_uart_core.c
@@ -1117,7 +1117,7 @@ int cpm_uart_drv_get_platform_data(struc
 
 	line = cpm_uart_id2nr(idx);
 	if(line < 0) {
-		printk(KERN_ERR"%s(): port %d is not registered", __FUNCTION__, idx);
+		printk(KERN_ERR"%s(): port %d is not registered", __func__, idx);
 		return -EINVAL;
 	}
 
diff -puN drivers/serial/crisv10.c~serial-replace-remaining-__function__-occurrences drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/crisv10.c
@@ -1788,7 +1788,7 @@ static unsigned int handle_descr_data(st
 
 	if (info->recv_cnt + recvl > 65536) {
 		printk(KERN_CRIT
-		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __FUNCTION__, recvl);
+		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
 		return 0;
 	}
 
@@ -1801,7 +1801,7 @@ static unsigned int handle_descr_data(st
 	append_recv_buffer(info, buffer);
 
 	if (!(buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE)))
-		panic("%s: Failed to allocate memory for receive buffer!\n", __FUNCTION__);
+		panic("%s: Failed to allocate memory for receive buffer!\n", __func__);
 
 	descr->buf = virt_to_phys(buffer->buffer);
 
@@ -1925,7 +1925,7 @@ static int start_recv_dma(struct e100_se
 	/* Set up the receiving descriptors */
 	for (i = 0; i < SERIAL_RECV_DESCRIPTORS; i++) {
 		if (!(buffer = alloc_recv_buffer(SERIAL_DESCR_BUF_SIZE)))
-			panic("%s: Failed to allocate memory for receive buffer!\n", __FUNCTION__);
+			panic("%s: Failed to allocate memory for receive buffer!\n", __func__);
 
 		descr[i].ctrl = d_int;
 		descr[i].buf = virt_to_phys(buffer->buffer);
@@ -4519,7 +4519,7 @@ rs_init(void)
 
 	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt,
 			IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
-		panic("%s: Failed to request irq8", __FUNCTION__);
+		panic("%s: Failed to request irq8", __func__);
 
 #endif
 #endif /* CONFIG_SVINTO_SIM */
diff -puN drivers/serial/ioc3_serial.c~serial-replace-remaining-__function__-occurrences drivers/serial/ioc3_serial.c
--- a/drivers/serial/ioc3_serial.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/ioc3_serial.c
@@ -52,7 +52,7 @@ static unsigned int Submodule_slot;
 #define DPRINT_CONFIG(_x...)	;
 //#define DPRINT_CONFIG(_x...)  printk _x
 #define NOT_PROGRESS()	;
-//#define NOT_PROGRESS()	printk("%s : fails %d\n", __FUNCTION__, __LINE__)
+//#define NOT_PROGRESS()	printk("%s : fails %d\n", __func__, __LINE__)
 
 /* number of characters we want to transmit to the lower level at a time */
 #define MAX_CHARS		256
@@ -445,7 +445,7 @@ static int inline port_init(struct ioc3_
 		sbbr_h = &idd->vma->sbbr_h;
 		ring_pci_addr = (unsigned long __iomem)port->ip_dma_ringbuf;
 		DPRINT_CONFIG(("%s: ring_pci_addr 0x%p\n",
-			       __FUNCTION__, (void *)ring_pci_addr));
+			       __func__, (void *)ring_pci_addr));
 
 		writel((unsigned int)((uint64_t) ring_pci_addr >> 32), sbbr_h);
 		writel((unsigned int)ring_pci_addr | BUF_SIZE_BIT, sbbr_l);
@@ -593,7 +593,7 @@ config_port(struct ioc3_port *port,
 
 	DPRINT_CONFIG(("%s: line %d baud %d byte_size %d stop %d parenb %d "
 			"parodd %d\n",
-		       __FUNCTION__, ((struct uart_port *)port->ip_port)->line,
+		       __func__, ((struct uart_port *)port->ip_port)->line,
 			baud, byte_size, stop_bits, parenb, parodd));
 
 	if (set_baud(port, baud))
@@ -871,14 +871,14 @@ static int ioc3_set_proto(struct ioc3_po
 	default:
 	case PROTO_RS232:
 		/* Clear the appropriate GIO pin */
-		DPRINT_CONFIG(("%s: rs232\n", __FUNCTION__));
+		DPRINT_CONFIG(("%s: rs232\n", __func__));
 		writel(0, (&port->ip_idd->vma->gppr[0]
 					+ hooks->rs422_select_pin));
 		break;
 
 	case PROTO_RS422:
 		/* Set the appropriate GIO pin */
-		DPRINT_CONFIG(("%s: rs422\n", __FUNCTION__));
+		DPRINT_CONFIG(("%s: rs422\n", __func__));
 		writel(1, (&port->ip_idd->vma->gppr[0]
 					+ hooks->rs422_select_pin));
 		break;
@@ -988,7 +988,7 @@ ioc3_change_speed(struct uart_port *the_
 	}
 	baud = uart_get_baud_rate(the_port, new_termios, old_termios,
 				  MIN_BAUD_SUPPORTED, MAX_BAUD_SUPPORTED);
-	DPRINT_CONFIG(("%s: returned baud %d for line %d\n", __FUNCTION__, baud,
+	DPRINT_CONFIG(("%s: returned baud %d for line %d\n", __func__, baud,
 				the_port->line));
 
 	if (!the_port->fifosize)
@@ -1026,7 +1026,7 @@ ioc3_change_speed(struct uart_port *the_
 	DPRINT_CONFIG(("%s : port 0x%p line %d cflag 0%o "
 		       "config_port(baud %d data %d stop %d penable %d "
 			" parity %d), notification 0x%x\n",
-		       __FUNCTION__, (void *)port, the_port->line, cflag, baud,
+		       __func__, (void *)port, the_port->line, cflag, baud,
 		       new_data, new_stop, new_parity_enable, new_parity,
 		       the_port->ignore_status_mask));
 
@@ -1919,7 +1919,7 @@ static inline int ioc3_serial_core_attac
 	struct pci_dev *pdev = idd->pdev;
 
 	DPRINT_CONFIG(("%s: attach pdev 0x%p - card_ptr 0x%p\n",
-		       __FUNCTION__, pdev, (void *)card_ptr));
+		       __func__, pdev, (void *)card_ptr));
 
 	if (!card_ptr)
 		return -ENODEV;
@@ -1933,7 +1933,7 @@ static inline int ioc3_serial_core_attac
 		port->ip_port = the_port;
 
 		DPRINT_CONFIG(("%s: attach the_port 0x%p / port 0x%p [%d/%d]\n",
-			__FUNCTION__, (void *)the_port, (void *)port,
+			__func__, (void *)the_port, (void *)port,
 				phys_port, ii));
 
 		/* membase, iobase and mapbase just need to be non-0 */
@@ -1950,7 +1950,7 @@ static inline int ioc3_serial_core_attac
 		if (uart_add_one_port(&ioc3_uart, the_port) < 0) {
 			printk(KERN_WARNING
 		          "%s: unable to add port %d bus %d\n",
-			       __FUNCTION__, the_port->line, pdev->bus->number);
+			       __func__, the_port->line, pdev->bus->number);
 		} else {
 			DPRINT_CONFIG(("IOC3 serial port %d irq %d bus %d\n",
 		          the_port->line, the_port->irq, pdev->bus->number));
@@ -2017,7 +2017,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 	struct ioc3_port *ports[PORTS_PER_CARD];
 	int phys_port;
 
-	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __FUNCTION__, is, idd));
+	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __func__, is, idd));
 
 	card_ptr = kzalloc(sizeof(struct ioc3_card), GFP_KERNEL);
 	if (!card_ptr) {
@@ -2067,7 +2067,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 
 			DPRINT_CONFIG(("%s : Port A ip_serial_regs 0x%p "
 				       "ip_uart_regs 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_serial_regs,
 				       (void *)port->ip_uart_regs));
 
@@ -2082,7 +2082,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 			DPRINT_CONFIG(("%s : Port A ip_cpu_ringbuf 0x%p "
 				       "ip_dma_ringbuf 0x%p, ip_inring 0x%p "
 					"ip_outring 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_cpu_ringbuf,
 				       (void *)port->ip_dma_ringbuf,
 				       (void *)port->ip_inring,
@@ -2094,7 +2094,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 
 			DPRINT_CONFIG(("%s : Port B ip_serial_regs 0x%p "
 				       "ip_uart_regs 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_serial_regs,
 				       (void *)port->ip_uart_regs));
 
@@ -2108,7 +2108,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 			DPRINT_CONFIG(("%s : Port B ip_cpu_ringbuf 0x%p "
 				       "ip_dma_ringbuf 0x%p, ip_inring 0x%p "
 					"ip_outring 0x%p\n",
-				       __FUNCTION__,
+				       __func__,
 				       (void *)port->ip_cpu_ringbuf,
 				       (void *)port->ip_dma_ringbuf,
 				       (void *)port->ip_inring,
@@ -2116,7 +2116,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 		}
 
 		DPRINT_CONFIG(("%s : port %d [addr 0x%p] card_ptr 0x%p",
-			       __FUNCTION__,
+			       __func__,
 			       phys_port, (void *)port, (void *)card_ptr));
 		DPRINT_CONFIG((" ip_serial_regs 0x%p ip_uart_regs 0x%p\n",
 			       (void *)port->ip_serial_regs,
@@ -2127,7 +2127,7 @@ ioc3uart_probe(struct ioc3_submodule *is
 
 		DPRINT_CONFIG(("%s: phys_port %d port 0x%p inring 0x%p "
 			       "outring 0x%p\n",
-			       __FUNCTION__,
+			       __func__,
 			       phys_port, (void *)port,
 			       (void *)port->ip_inring,
 			       (void *)port->ip_outring));
@@ -2170,7 +2170,7 @@ static int __devinit ioc3uart_init(void)
 	if ((ret = uart_register_driver(&ioc3_uart)) < 0) {
 		printk(KERN_WARNING
 		       "%s: Couldn't register IOC3 uart serial driver\n",
-		       __FUNCTION__);
+		       __func__);
 		return ret;
 	}
 	ret = ioc3_register_submodule(&ioc3uart_submodule);
diff -puN drivers/serial/ioc4_serial.c~serial-replace-remaining-__function__-occurrences drivers/serial/ioc4_serial.c
--- a/drivers/serial/ioc4_serial.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/ioc4_serial.c
@@ -889,7 +889,7 @@ static int inline port_init(struct ioc4_
 
 		ring_pci_addr = (unsigned long __iomem)port->ip_dma_ringbuf;
 		DPRINT_CONFIG(("%s: ring_pci_addr 0x%lx\n",
-					__FUNCTION__, ring_pci_addr));
+					__func__, ring_pci_addr));
 
 		writel((unsigned int)((uint64_t)ring_pci_addr >> 32), sbbr_h);
 		writel((unsigned int)ring_pci_addr | IOC4_BUF_SIZE_BIT, sbbr_l);
@@ -1028,7 +1028,7 @@ static irqreturn_t ioc4_intr(int irq, vo
 		spin_lock_irqsave(&soft->is_ir_lock, flag);
 		printk ("%s : %d : mem 0x%p sio_ir 0x%x sio_ies 0x%x "
 				"other_ir 0x%x other_ies 0x%x mask 0x%x\n",
-		     __FUNCTION__, __LINE__,
+		     __func__, __LINE__,
 		     (void *)mem, readl(&mem->sio_ir.raw),
 		     readl(&mem->sio_ies.raw),
 		     readl(&mem->other_ir.raw),
@@ -1155,14 +1155,14 @@ static int inline ioc4_attach_local(stru
 				(TOTAL_RING_BUF_SIZE - 1)) == 0));
 			DPRINT_CONFIG(("%s : ip_cpu_ringbuf 0x%p "
 						"ip_dma_ringbuf 0x%p\n",
-					__FUNCTION__,
+					__func__,
 					(void *)port->ip_cpu_ringbuf,
 					(void *)port->ip_dma_ringbuf));
 			port->ip_inring = RING(port, RX_0_OR_2);
 			port->ip_outring = RING(port, TX_0_OR_2);
 		}
 		DPRINT_CONFIG(("%s : port %d [addr 0x%p] control 0x%p",
-				__FUNCTION__,
+				__func__,
 				port_number, (void *)port, (void *)control));
 		DPRINT_CONFIG((" ip_serial_regs 0x%p ip_uart_regs 0x%p\n",
 				(void *)port->ip_serial_regs,
@@ -1173,7 +1173,7 @@ static int inline ioc4_attach_local(stru
 
 		DPRINT_CONFIG(("%s: port_number %d port 0x%p inring 0x%p "
 						"outring 0x%p\n",
-				__FUNCTION__,
+				__func__,
 				port_number, (void *)port,
 				(void *)port->ip_inring,
 				(void *)port->ip_outring));
@@ -1317,7 +1317,7 @@ config_port(struct ioc4_port *port,
 	int spiniter = 0;
 
 	DPRINT_CONFIG(("%s: baud %d byte_size %d stop %d parenb %d parodd %d\n",
-		__FUNCTION__, baud, byte_size, stop_bits, parenb, parodd));
+		__func__, baud, byte_size, stop_bits, parenb, parodd));
 
 	if (set_baud(port, baud))
 		return 1;
@@ -1725,7 +1725,7 @@ ioc4_change_speed(struct uart_port *the_
 	}
 	baud = uart_get_baud_rate(the_port, new_termios, old_termios,
 				MIN_BAUD_SUPPORTED, MAX_BAUD_SUPPORTED);
-	DPRINT_CONFIG(("%s: returned baud %d\n", __FUNCTION__, baud));
+	DPRINT_CONFIG(("%s: returned baud %d\n", __func__, baud));
 
 	/* default is 9600 */
 	if (!baud)
@@ -1765,7 +1765,7 @@ ioc4_change_speed(struct uart_port *the_
 	DPRINT_CONFIG(("%s : port 0x%p cflag 0%o "
 		"config_port(baud %d data %d stop %d p enable %d parity %d),"
 		" notification 0x%x\n",
-	     __FUNCTION__, (void *)port, cflag, baud, new_data, new_stop,
+	     __func__, (void *)port, cflag, baud, new_data, new_stop,
 	     new_parity_enable, new_parity, the_port->ignore_status_mask));
 
 	if ((config_port(port, baud,		/* baud */
@@ -2715,7 +2715,7 @@ ioc4_serial_core_attach(struct pci_dev *
 
 
 	DPRINT_CONFIG(("%s: attach pdev 0x%p - control 0x%p\n",
-			__FUNCTION__, pdev, (void *)control));
+			__func__, pdev, (void *)control));
 
 	if (!control)
 		return -ENODEV;
@@ -2734,7 +2734,7 @@ ioc4_serial_core_attach(struct pci_dev *
 		port->ip_all_ports[port_type_idx] = the_port;
 
 		DPRINT_CONFIG(("%s: attach the_port 0x%p / port 0x%p : type %s\n",
-				__FUNCTION__, (void *)the_port,
+				__func__, (void *)the_port,
 				(void *)port,
 				port_type == PROTO_RS232 ? "rs232" : "rs422"));
 
@@ -2752,7 +2752,7 @@ ioc4_serial_core_attach(struct pci_dev *
 		if (uart_add_one_port(u_driver, the_port) < 0) {
 			printk(KERN_WARNING
 		           "%s: unable to add port %d bus %d\n",
-			       __FUNCTION__, the_port->line, pdev->bus->number);
+			       __func__, the_port->line, pdev->bus->number);
 		} else {
 			DPRINT_CONFIG(
 			    ("IOC4 serial port %d irq = %d, bus %d\n",
@@ -2777,7 +2777,7 @@ ioc4_serial_attach_one(struct ioc4_drive
 	int ret = 0;
 
 
-	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __FUNCTION__, idd->idd_pdev,
+	DPRINT_CONFIG(("%s (0x%p, 0x%p)\n", __func__, idd->idd_pdev,
 							idd->idd_pci_id));
 
 	/* PCI-RT does not bring out serial connections.
@@ -2806,7 +2806,7 @@ ioc4_serial_attach_one(struct ioc4_drive
 		goto out2;
 	}
 	DPRINT_CONFIG(("%s : mem 0x%p, serial 0x%p\n",
-				__FUNCTION__, (void *)idd->idd_misc_regs,
+				__func__, (void *)idd->idd_misc_regs,
 				(void *)serial));
 
 	/* Get memory for the new card */
@@ -2858,7 +2858,7 @@ ioc4_serial_attach_one(struct ioc4_drive
 	} else {
 		printk(KERN_WARNING
 		    "%s : request_irq fails for IRQ 0x%x\n ",
-			__FUNCTION__, idd->idd_pdev->irq);
+			__func__, idd->idd_pdev->irq);
 	}
 	ret = ioc4_attach_local(idd);
 	if (ret)
@@ -2911,13 +2911,13 @@ int ioc4_serial_init(void)
 	if ((ret = uart_register_driver(&ioc4_uart_rs232)) < 0) {
 		printk(KERN_WARNING
 			"%s: Couldn't register rs232 IOC4 serial driver\n",
-			__FUNCTION__);
+			__func__);
 		return ret;
 	}
 	if ((ret = uart_register_driver(&ioc4_uart_rs422)) < 0) {
 		printk(KERN_WARNING
 			"%s: Couldn't register rs422 IOC4 serial driver\n",
-			__FUNCTION__);
+			__func__);
 		return ret;
 	}
 
diff -puN drivers/serial/s3c2410.c~serial-replace-remaining-__function__-occurrences drivers/serial/s3c2410.c
--- a/drivers/serial/s3c2410.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/s3c2410.c
@@ -1096,13 +1096,13 @@ static int s3c24xx_serial_probe(struct p
 	ourport = &s3c24xx_serial_ports[probe_index];
 	probe_index++;
 
-	dbg("%s: initialising port %p...\n", __FUNCTION__, ourport);
+	dbg("%s: initialising port %p...\n", __func__, ourport);
 
 	ret = s3c24xx_serial_init_port(ourport, info, dev);
 	if (ret < 0)
 		goto probe_err;
 
-	dbg("%s: adding port\n", __FUNCTION__);
+	dbg("%s: adding port\n", __func__);
 	uart_add_one_port(&s3c24xx_uart_drv, &ourport->port);
 	platform_set_drvdata(dev, &ourport->port);
 
@@ -1587,7 +1587,7 @@ static int s3c2412_serial_resetport(stru
 	unsigned long ucon = rd_regl(port, S3C2410_UCON);
 
 	dbg("%s: port=%p (%08lx), cfg=%p\n",
-	    __FUNCTION__, port, port->mapbase, cfg);
+	    __func__, port, port->mapbase, cfg);
 
 	/* ensure we don't change the clock settings... */
 
diff -puN drivers/serial/sa1100.c~serial-replace-remaining-__function__-occurrences drivers/serial/sa1100.c
--- a/drivers/serial/sa1100.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/sa1100.c
@@ -655,7 +655,7 @@ void __init sa1100_register_uart_fns(str
 void __init sa1100_register_uart(int idx, int port)
 {
 	if (idx >= NR_PORTS) {
-		printk(KERN_ERR "%s: bad index number %d\n", __FUNCTION__, idx);
+		printk(KERN_ERR "%s: bad index number %d\n", __func__, idx);
 		return;
 	}
 
@@ -682,7 +682,7 @@ void __init sa1100_register_uart(int idx
 		break;
 
 	default:
-		printk(KERN_ERR "%s: bad port number %d\n", __FUNCTION__, port);
+		printk(KERN_ERR "%s: bad port number %d\n", __func__, port);
 	}
 }
 
diff -puN drivers/serial/sh-sci.c~serial-replace-remaining-__function__-occurrences drivers/serial/sh-sci.c
--- a/drivers/serial/sh-sci.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/sh-sci.c
@@ -855,7 +855,7 @@ static int sci_notifier(struct notifier_
 
 		printk(KERN_INFO "%s: got a postchange notification "
 		       "for cpu %d (old %d, new %d)\n",
-		       __FUNCTION__, freqs->cpu, freqs->old, freqs->new);
+		       __func__, freqs->cpu, freqs->old, freqs->new);
 	}
 
 	return NOTIFY_OK;
diff -puN drivers/serial/sn_console.c~serial-replace-remaining-__function__-occurrences drivers/serial/sn_console.c
--- a/drivers/serial/sn_console.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/sn_console.c
@@ -839,7 +839,7 @@ static int __init sn_sal_module_init(voi
 
 	if (uart_add_one_port(&sal_console_uart, &sal_console_port.sc_port) < 0) {
 		/* error - not sure what I'd do - so I'll do nothing */
-		printk(KERN_ERR "%s: unable to add port\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unable to add port\n", __func__);
 	}
 
 	/* when this driver is compiled in, the console initialization
diff -puN drivers/serial/uartlite.c~serial-replace-remaining-__function__-occurrences drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/uartlite.c
@@ -584,7 +584,7 @@ ulite_of_probe(struct of_device *op, con
 	const unsigned int *id;
 	int irq, rc;
 
-	dev_dbg(&op->dev, "%s(%p, %p)\n", __FUNCTION__, op, match);
+	dev_dbg(&op->dev, "%s(%p, %p)\n", __func__, op, match);
 
 	rc = of_address_to_resource(op->node, 0, &res);
 	if (rc) {
diff -puN drivers/serial/ucc_uart.c~serial-replace-remaining-__function__-occurrences drivers/serial/ucc_uart.c
--- a/drivers/serial/ucc_uart.c~serial-replace-remaining-__function__-occurrences
+++ a/drivers/serial/ucc_uart.c
@@ -215,7 +215,7 @@ static inline dma_addr_t cpu2qe_addr(voi
 		return qe_port->bd_dma_addr + (addr - qe_port->bd_virt);
 
 	/* something nasty happened */
-	printk(KERN_ERR "%s: addr=%p\n", __FUNCTION__, addr);
+	printk(KERN_ERR "%s: addr=%p\n", __func__, addr);
 	BUG();
 	return 0;
 }
@@ -234,7 +234,7 @@ static inline void *qe2cpu_addr(dma_addr
 		return qe_port->bd_virt + (addr - qe_port->bd_dma_addr);
 
 	/* something nasty happened */
-	printk(KERN_ERR "%s: addr=%x\n", __FUNCTION__, addr);
+	printk(KERN_ERR "%s: addr=%x\n", __func__, addr);
 	BUG();
 	return NULL;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

