From: akpm@osdl.org
Subject: - char-cyclades-cleanup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:37 -0800
Message-ID: <200612082010.kB8KAbw9002829@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946505AbWLHUKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, cleanup
has been removed from the -mm tree.  Its filename was
     char-cyclades-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- remove cvs rcsid and alter code that uses it.
- allow a semicolon after use of macro to not confuse parsers (e.g. indent)
  by do {} while (0)
- JIFFIES_DIFF is simple subtraction, subtract directly
- returns cleanup -- do not put values in parenthesis and do not return nothing
  at the end of void functions
- comments are /* */ in C (not //)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/cyclades.c |  133 ++++++++++++++------------------------
 1 file changed, 50 insertions(+), 83 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-cleanup drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-cleanup
+++ a/drivers/char/cyclades.c
@@ -1,7 +1,6 @@
 #undef	BLOCKMOVE
 #define	Z_WAKE
 #undef	Z_EXT_CHARS_IN_BUFFER
-static char rcsid[] = "$Revision: 2.3.2.20 $$Date: 2004/02/25 18:14:16 $";
 
 /*
  *  linux/drivers/char/cyclades.c
@@ -592,6 +591,8 @@ static char rcsid[] = "$Revision: 2.3.2.
  *
  */
 
+#define CY_VERSION	"2.4"
+
 /* If you need to install more boards than NR_CARDS, change the constant
    in the definition below. No other change is necessary to support up to
    eight boards. Beyond that you'll have to extend cy_isa_addresses. */
@@ -624,9 +625,9 @@ static char rcsid[] = "$Revision: 2.3.2.
 #undef	CY_PCI_DEBUG
 
 #if 0
-#define PAUSE __asm__("nop");
+#define PAUSE __asm__("nop")
 #else
-#define PAUSE ;
+#define PAUSE do {} while (0)
 #endif
 
 /*
@@ -697,8 +698,6 @@ static void cy_send_xchar(struct tty_str
 
 #define STD_COM_FLAGS (0)
 
-#define	JIFFIES_DIFF(n, j)	((j) - (n))
-
 static struct tty_driver *cy_serial_driver;
 
 #ifdef CONFIG_ISA
@@ -870,26 +869,22 @@ static inline int serial_paranoia_check(
 		char *name, const char *routine)
 {
 #ifdef SERIAL_PARANOIA_CHECK
-	static const char *badmagic =
-		"cyc Warning: bad magic number for serial struct (%s) in %s\n";
-	static const char *badinfo =
-		"cyc Warning: null cyclades_port for (%s) in %s\n";
-	static const char *badrange =
-		"cyc Warning: cyclades_port out of range for (%s) in %s\n";
-
 	if (!info) {
-		printk(badinfo, name, routine);
+		printk("cyc Warning: null cyclades_port for (%s) in %s\n",
+				name, routine);
 		return 1;
 	}
 
 	if ((long)info < (long)(&cy_port[0]) ||
 			(long)(&cy_port[NR_PORTS]) < (long)info) {
-		printk(badrange, name, routine);
+		printk("cyc Warning: cyclades_port out of range for (%s) in "
+				"%s\n", name, routine);
 		return 1;
 	}
 
 	if (info->magic != CYCLADES_MAGIC) {
-		printk(badmagic, name, routine);
+		printk("cyc Warning: bad magic number for serial struct (%s) "
+				"in %s\n", name, routine);
 		return 1;
 	}
 #endif
@@ -991,12 +986,12 @@ static int cyy_issue_cmd(void __iomem * 
 	/* if the CCR never cleared, the previous command
 	   didn't finish within the "reasonable time" */
 	if (i == 100)
-		return (-1);
+		return -1;
 
 	/* Issue the new command */
 	cy_writeb(base_addr + (CyCCR << index), cmd);
 
-	return (0);
+	return 0;
 }				/* cyy_issue_cmd */
 
 #ifdef CONFIG_ISA
@@ -1511,7 +1506,7 @@ cyz_fetch_msg(struct cyclades_card *cinf
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
 	if (!ISZLOADED(*cinfo)) {
-		return (-1);
+		return -1;
 	}
 	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
 			0xfffff);
@@ -1542,7 +1537,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 
 	firm_id = cinfo->base_addr + ID_ADDRESS;
 	if (!ISZLOADED(*cinfo)) {
-		return (-1);
+		return -1;
 	}
 	zfw_ctrl = cinfo->base_addr + (cy_readl(&firm_id->zfwctrl_addr) &
 			0xfffff);
@@ -1553,7 +1548,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	    &((struct RUNTIME_9060 __iomem *)(cinfo->ctl_addr))->pci_doorbell;
 	while ((cy_readl(pci_doorbell) & 0xff) != 0) {
 		if (index++ == 1000) {
-			return ((int)(cy_readl(pci_doorbell) & 0xff));
+			return (int)(cy_readl(pci_doorbell) & 0xff);
 		}
 		udelay(50L);
 	}
@@ -1561,7 +1556,7 @@ cyz_issue_cmd(struct cyclades_card *cinf
 	cy_writel(&board_ctrl->hcmd_param, param);
 	cy_writel(pci_doorbell, (long)cmd);
 
-	return (0);
+	return 0;
 }				/* cyz_issue_cmd */
 
 static void
@@ -1959,8 +1954,6 @@ static void cyz_poll(unsigned long arg)
 		cyz_timerlist.expires = jiffies + cyz_polling_cycle;
 	}
 	add_timer(&cyz_timerlist);
-
-	return;
 }				/* cyz_poll */
 
 #endif				/* CONFIG_CYZ_INTR */
@@ -2318,7 +2311,6 @@ static void shutdown(struct cyclades_por
 #ifdef CY_DEBUG_OPEN
 	printk(" cyc shutdown done\n");
 #endif
-	return;
 }				/* shutdown */
 
 /*
@@ -2349,8 +2341,7 @@ block_til_ready(struct tty_struct *tty, 
 		if (info->flags & ASYNC_CLOSING) {
 			interruptible_sleep_on(&info->close_wait);
 		}
-		return ((info->
-			 flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
+		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
 	/*
@@ -2629,8 +2620,7 @@ static int cy_open(struct tty_struct *tt
 	if (tty_hung_up_p(filp) || (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
 			interruptible_sleep_on(&info->close_wait);
-		return ((info->
-			 flags & ASYNC_HUP_NOTIFY) ? -EAGAIN : -ERESTARTSYS);
+		return (info->flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
 
 	/*
@@ -2727,7 +2717,7 @@ static void cy_wait_until_sent(struct tt
 				break;
 		}
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
@@ -2869,7 +2859,6 @@ static void cy_close(struct tty_struct *
 #endif
 
 	CY_UNLOCK(info, flags);
-	return;
 }				/* cy_close */
 
 /* This routine gets called when tty_write has put something into
@@ -3053,7 +3042,7 @@ static int cy_chars_in_buffer(struct tty
 #ifdef CY_DEBUG_IO
 		printk("cyc:cy_chars_in_buffer ttyC%d %d\n", info->line, info->xmit_cnt + char_count);	/* */
 #endif
-		return (info->xmit_cnt + char_count);
+		return info->xmit_cnt + char_count;
 	}
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
 }				/* cy_chars_in_buffer */
@@ -3918,7 +3907,7 @@ static int set_threshold(struct cyclades
 		cyy_issue_cmd(base_addr, CyCOR_CHANGE | CyCOR3ch, index);
 		CY_UNLOCK(info, flags);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 	}
 	return 0;
 }				/* set_threshold */
@@ -3942,7 +3931,7 @@ get_threshold(struct cyclades_port *info
 		tmp = cy_readb(base_addr + (CyCOR3 << index)) & CyREC_FIFO;
 		return put_user(tmp, value);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 		return 0;
 	}
 }				/* get_threshold */
@@ -3979,7 +3968,7 @@ static int set_timeout(struct cyclades_p
 		cy_writeb(base_addr + (CyRTPR << index), value & 0xff);
 		CY_UNLOCK(info, flags);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 	}
 	return 0;
 }				/* set_timeout */
@@ -4002,7 +3991,7 @@ static int get_timeout(struct cyclades_p
 		tmp = cy_readb(base_addr + (CyRTPR << index));
 		return put_user(tmp, value);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 		return 0;
 	}
 }				/* get_timeout */
@@ -4249,8 +4238,6 @@ static void cy_set_termios(struct tty_st
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&info->open_wait);
 #endif
-
-	return;
 }				/* cy_set_termios */
 
 /* This function is used to send a high-priority XON/XOFF character to
@@ -4337,8 +4324,6 @@ static void cy_throttle(struct tty_struc
 			info->throttle = 1;
 		}
 	}
-
-	return;
 }				/* cy_throttle */
 
 /*
@@ -4396,8 +4381,6 @@ static void cy_unthrottle(struct tty_str
 			info->throttle = 0;
 		}
 	}
-
-	return;
 }				/* cy_unthrottle */
 
 /* cy_start and cy_stop provide software output flow control as a
@@ -4434,10 +4417,8 @@ static void cy_stop(struct tty_struct *t
 			  cy_readb(base_addr + (CySRER << index)) & ~CyTxRdy);
 		CY_UNLOCK(info, flags);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 	}
-
-	return;
 }				/* cy_stop */
 
 static void cy_start(struct tty_struct *tty)
@@ -4470,10 +4451,8 @@ static void cy_start(struct tty_struct *
 			  cy_readb(base_addr + (CySRER << index)) | CyTxRdy);
 		CY_UNLOCK(info, flags);
 	} else {
-		// Nothing to do!
+		/* Nothing to do! */
 	}
-
-	return;
 }				/* cy_start */
 
 static void cy_flush_buffer(struct tty_struct *tty)
@@ -4661,7 +4640,7 @@ static int __init cy_detect_isa(void)
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
 		unsigned int isa_address = cy_isa_addresses[i];
 		if (isa_address == 0x0000) {
-			return (nboard);
+			return nboard;
 		}
 
 		/* probe for CD1400... */
@@ -4691,7 +4670,7 @@ static int __init cy_detect_isa(void)
 			printk("but no more channels are available.\n");
 			printk("Change NR_PORTS in cyclades.c and recompile "
 					"kernel.\n");
-			return (nboard);
+			return nboard;
 		}
 		/* fill the next cy_card structure available */
 		for (j = 0; j < NR_CARDS; j++) {
@@ -4704,7 +4683,7 @@ static int __init cy_detect_isa(void)
 			printk("but no more cards can be used .\n");
 			printk("Change NR_CARDS in cyclades.c and recompile "
 					"kernel.\n");
-			return (nboard);
+			return nboard;
 		}
 
 		/* allocate IRQ */
@@ -4713,7 +4692,7 @@ static int __init cy_detect_isa(void)
 			printk("Cyclom-Y/ISA found at 0x%lx ",
 				(unsigned long)cy_isa_address);
 			printk("but could not allocate IRQ#%d.\n", cy_isa_irq);
-			return (nboard);
+			return nboard;
 		}
 
 		/* set cy_card */
@@ -4734,9 +4713,9 @@ static int __init cy_detect_isa(void)
 			cy_isa_nchan, cy_next_channel);
 		cy_next_channel += cy_isa_nchan;
 	}
-	return (nboard);
+	return nboard;
 #else
-	return (0);
+	return 0;
 #endif				/* CONFIG_ISA */
 }				/* cy_detect_isa */
 
@@ -4867,7 +4846,7 @@ static int __init cy_detect_pci(void)
 				printk("but no channels are available.\n");
 				printk("Change NR_PORTS in cyclades.c and "
 						"recompile kernel.\n");
-				return (i);
+				return i;
 			}
 			/* fill the next cy_card structure available */
 			for (j = 0; j < NR_CARDS; j++) {
@@ -4880,7 +4859,7 @@ static int __init cy_detect_pci(void)
 				printk("but no more cards can be used.\n");
 				printk("Change NR_CARDS in cyclades.c and "
 						"recompile kernel.\n");
-				return (i);
+				return i;
 			}
 
 			/* allocate IRQ */
@@ -4890,7 +4869,7 @@ static int __init cy_detect_pci(void)
 					(ulong) cy_pci_phys2);
 				printk("but could not allocate IRQ%d.\n",
 					cy_pci_irq);
-				return (i);
+				return i;
 			}
 
 			/* set cy_card */
@@ -5029,7 +5008,7 @@ static int __init cy_detect_pci(void)
 				cy_writel(&((struct RUNTIME_9060 *)
 					(cy_pci_addr0))->loc_addr_base,
 					WIN_CREG);
-				PAUSE
+				PAUSE;
 				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
 					"%lx\n", (ulong) (0xff &
 					cy_readl(&((struct CUSTOM_REG *)
@@ -5050,7 +5029,7 @@ static int __init cy_detect_pci(void)
 			   ensures that the driver will not attempt to talk to
 			   the board until it has been properly initialized.
 			 */
-			PAUSE
+			PAUSE;
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
 
@@ -5064,7 +5043,7 @@ static int __init cy_detect_pci(void)
 					"no channels are available.\nChange "
 					"NR_PORTS in cyclades.c and recompile "
 					"kernel.\n", (ulong)cy_pci_phys2);
-				return (i);
+				return i;
 			}
 
 			/* fill the next cy_card structure available */
@@ -5077,7 +5056,7 @@ static int __init cy_detect_pci(void)
 					"no more cards can be used.\nChange "
 					"NR_CARDS in cyclades.c and recompile "
 					"kernel.\n", (ulong)cy_pci_phys2);
-				return (i);
+				return i;
 			}
 #ifdef CONFIG_CYZ_INTR
 			/* allocate IRQ only if board has an IRQ */
@@ -5089,7 +5068,7 @@ static int __init cy_detect_pci(void)
 						"but could not allocate "
 						"IRQ%d.\n", (ulong)cy_pci_phys2,
 						cy_pci_irq);
-					return (i);
+					return i;
 				}
 			}
 #endif				/* CONFIG_CYZ_INTR */
@@ -5149,7 +5128,7 @@ static int __init cy_detect_pci(void)
 		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
 				"loaded\n");
 #endif
-		PAUSE
+		PAUSE;
 		/* This must be the new Cyclades-Ze/PCI. */
 		cy_pci_nchan = ZE_V1_NPORTS;
 
@@ -5158,7 +5137,7 @@ static int __init cy_detect_pci(void)
 				"are available.\nChange NR_PORTS in cyclades.c "
 				"and recompile kernel.\n",
 				(ulong) cy_pci_phys2);
-			return (i);
+			return i;
 		}
 
 		/* fill the next cy_card structure available */
@@ -5171,7 +5150,7 @@ static int __init cy_detect_pci(void)
 				"cards can be used.\nChange NR_CARDS in "
 				"cyclades.c and recompile kernel.\n",
 				(ulong) cy_pci_phys2);
-			return (i);
+			return i;
 		}
 #ifdef CONFIG_CYZ_INTR
 		/* allocate IRQ only if board has an IRQ */
@@ -5183,7 +5162,7 @@ static int __init cy_detect_pci(void)
 					(ulong) cy_pci_phys2);
 				printk("but could not allocate IRQ%d.\n",
 					cy_pci_irq);
-				return (i);
+				return i;
 			}
 		}
 #endif				/* CONFIG_CYZ_INTR */
@@ -5222,9 +5201,9 @@ static int __init cy_detect_pci(void)
 			"used.\nChange NR_CARDS in cyclades.c and recompile "
 			"kernel.\n", (unsigned int)Ze_phys2[0]);
 	}
-	return (i);
+	return i;
 #else
-	return (0);
+	return 0;
 #endif				/* ifdef CONFIG_PCI */
 }				/* cy_detect_pci */
 
@@ -5234,16 +5213,7 @@ static int __init cy_detect_pci(void)
  */
 static inline void show_version(void)
 {
-	char *rcsvers, *rcsdate, *tmp;
-	rcsvers = strchr(rcsid, ' ');
-	rcsvers++;
-	tmp = strchr(rcsvers, ' ');
-	*tmp++ = '\0';
-	rcsdate = strchr(tmp, ' ');
-	rcsdate++;
-	tmp = strrchr(rcsdate, ' ');
-	*tmp = '\0';
-	printk("Cyclades driver %s %s\n", rcsvers, rcsdate);
+	printk("Cyclades driver " CY_VERSION "\n");
 	printk("        built %s %s\n", __DATE__, __TIME__);
 }				/* show_version */
 
@@ -5272,14 +5242,11 @@ cyclades_get_proc_info(char *buf, char *
 		if (info->count)
 			size = sprintf(buf + len, "%3d %8lu %10lu %8lu %10lu "
 				"%8lu %9lu %6ld\n", info->line,
-				JIFFIES_DIFF(info->idle_stats.in_use,
-					cur_jifs) / HZ,
+				(cur_jifs - info->idle_stats.in_use) / HZ,
 				info->idle_stats.xmit_bytes,
-				JIFFIES_DIFF(info->idle_stats.xmit_idle,
-					cur_jifs) / HZ,
+				(cur_jifs - info->idle_stats.xmit_idle) / HZ,
 				info->idle_stats.recv_bytes,
-				JIFFIES_DIFF(info->idle_stats.recv_idle,
-					cur_jifs) / HZ,
+				(cur_jifs - info->idle_stats.recv_idle) / HZ,
 				info->idle_stats.overruns,
 				(long)info->tty->ldisc.num);
 		else
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

