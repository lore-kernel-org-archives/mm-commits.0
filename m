From: akpm@linux-foundation.org
Subject: + char-ip2-init-deinit-cleanup.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:45:35 -0700
Message-ID: <200807220945.m6M9jZCP021594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbYGVJpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, akinobu.mita@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: ip2, init/deinit cleanup
has been added to the -mm tree.  Its filename is
     char-ip2-init-deinit-cleanup.patch

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
Subject: Char: ip2, init/deinit cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Cleanup of module_init/exit:
- mostly whitespace
- remove empty functions
- replace c++ comments
- remove useless prints (module loaded, unloaded)
- mark the calls as __exit and __init
- use break; and return; to save some indent levels after it
- note resource leakage

It's still mess, but now it's readable.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/i2ellis.c |   34 --
 drivers/char/ip2/i2ellis.h |    2 
 drivers/char/ip2/ip2main.c |  419 ++++++++++++++++-------------------
 3 files changed, 200 insertions(+), 255 deletions(-)

diff -puN drivers/char/ip2/i2ellis.c~char-ip2-init-deinit-cleanup drivers/char/ip2/i2ellis.c
--- a/drivers/char/ip2/i2ellis.c~char-ip2-init-deinit-cleanup
+++ a/drivers/char/ip2/i2ellis.c
@@ -69,40 +69,6 @@ static DEFINE_RWLOCK(Dl_spinlock);
 //=======================================================
 
 //******************************************************************************
-// Function:   iiEllisInit()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required initialization of the iiEllis subsystem.
-//
-//******************************************************************************
-static void
-iiEllisInit(void)
-{
-}
-
-//******************************************************************************
-// Function:   iiEllisCleanup()
-// Parameters: None
-//
-// Returns:    Nothing
-//
-// Description:
-//
-// This routine performs any required cleanup of the iiEllis subsystem.
-//
-//******************************************************************************
-#ifdef MODULE
-static void
-iiEllisCleanup(void)
-{
-}
-#endif
-
-//******************************************************************************
 // Function:   iiSetAddress(pB, address, delay)
 // Parameters: pB      - pointer to the board structure
 //             address - the purported I/O address of the board
diff -puN drivers/char/ip2/i2ellis.h~char-ip2-init-deinit-cleanup drivers/char/ip2/i2ellis.h
--- a/drivers/char/ip2/i2ellis.h~char-ip2-init-deinit-cleanup
+++ a/drivers/char/ip2/i2ellis.h
@@ -511,7 +511,6 @@ typedef void (*delayFunc_t)(unsigned int
 //
 // Initialization of a board & structure is in four (five!) parts:
 //
-// 0) iiEllisInit()  - Initialize iiEllis subsystem.
 // 1) iiSetAddress() - Define the board address & delay function for a board.
 // 2) iiReset()      - Reset the board   (provided it exists)
 //       -- Note you may do this to several boards --
@@ -523,7 +522,6 @@ typedef void (*delayFunc_t)(unsigned int
 // loadware.  To change loadware, you must begin again with step 2, resetting
 // the board again (step 1 not needed).
 
-static void iiEllisInit(void);
 static int iiSetAddress(i2eBordStrPtr, int, delayFunc_t );
 static int iiReset(i2eBordStrPtr);
 static int iiResetDelay(i2eBordStrPtr);
diff -puN drivers/char/ip2/ip2main.c~char-ip2-init-deinit-cleanup drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~char-ip2-init-deinit-cleanup
+++ a/drivers/char/ip2/ip2main.c
@@ -314,31 +314,27 @@ MODULE_PARM_DESC(poll_only, "Do not use 
 /* for sysfs class support */
 static struct class *ip2_class;
 
-// Some functions to keep track of what irq's we have
+/* Some functions to keep track of what irqs we have */
 
-static int
-is_valid_irq(int irq)
+static int __init is_valid_irq(int irq)
 {
 	int *i = Valid_Irqs;
 	
-	while ((*i != 0) && (*i != irq)) {
+	while (*i != 0 && *i != irq)
 		i++;
-	}
-	return (*i);
+
+	return *i;
 }
 
-static void
-mark_requested_irq( char irq )
+static void __init mark_requested_irq(char irq)
 {
 	rirqs[iindx++] = irq;
 }
 
-#ifdef MODULE
-static int
-clear_requested_irq( char irq )
+static int __exit clear_requested_irq(char irq)
 {
 	int i;
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		if (rirqs[i] == irq) {
 			rirqs[i] = 0;
 			return 1;
@@ -346,17 +342,15 @@ clear_requested_irq( char irq )
 	}
 	return 0;
 }
-#endif
 
-static int
-have_requested_irq( char irq )
+static int have_requested_irq(char irq)
 {
-	// array init to zeros so 0 irq will not be requested as a side effect
+	/* array init to zeros so 0 irq will not be requested as a side
+	 * effect */
 	int i;
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
+	for (i = 0; i < IP2_MAX_BOARDS; ++i)
 		if (rirqs[i] == irq)
 			return 1;
-	}
 	return 0;
 }
 
@@ -380,46 +374,44 @@ static void __exit ip2_cleanup_module(vo
 	int err;
 	int i;
 
-#ifdef IP2DEBUG_INIT
-	printk (KERN_DEBUG "Unloading %s: version %s\n", pcName, pcVersion );
-#endif
 	/* Stop poll timer if we had one. */
-	if ( TimerOn ) {
-		del_timer ( &PollTimer );
+	if (TimerOn) {
+		del_timer(&PollTimer);
 		TimerOn = 0;
 	}
 
 	/* Reset the boards we have. */
-	for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if ( i2BoardPtrTable[i] ) {
-			iiReset( i2BoardPtrTable[i] );
-		}
-	}
+	for (i = 0; i < IP2_MAX_BOARDS; i++)
+		if (i2BoardPtrTable[i])
+			iiReset(i2BoardPtrTable[i]);
 
 	/* The following is done at most once, if any boards were installed. */
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if ( i2BoardPtrTable[i] ) {
-			iiResetDelay( i2BoardPtrTable[i] );
+	for (i = 0; i < IP2_MAX_BOARDS; i++) {
+		if (i2BoardPtrTable[i]) {
+			iiResetDelay(i2BoardPtrTable[i]);
 			/* free io addresses and Tibet */
-			release_region( ip2config.addr[i], 8 );
+			release_region(ip2config.addr[i], 8);
 			device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i));
-			device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR, 4 * i + 1));
+			device_destroy(ip2_class, MKDEV(IP2_IPL_MAJOR,
+						4 * i + 1));
 		}
 		/* Disable and remove interrupt handler. */
-		if ( (ip2config.irq[i] > 0) && have_requested_irq(ip2config.irq[i]) ) {	
-			free_irq ( ip2config.irq[i], (void *)&pcName);
-			clear_requested_irq( ip2config.irq[i]);
+		if (ip2config.irq[i] > 0 &&
+				have_requested_irq(ip2config.irq[i])) {
+			free_irq(ip2config.irq[i], (void *)&pcName);
+			clear_requested_irq(ip2config.irq[i]);
 		}
 	}
 	class_destroy(ip2_class);
-	if ( ( err = tty_unregister_driver ( ip2_tty_driver ) ) ) {
-		printk(KERN_ERR "IP2: failed to unregister tty driver (%d)\n", err);
-	}
+	err = tty_unregister_driver(ip2_tty_driver);
+	if (err)
+		printk(KERN_ERR "IP2: failed to unregister tty driver (%d)\n",
+				err);
 	put_tty_driver(ip2_tty_driver);
 	unregister_chrdev(IP2_IPL_MAJOR, pcIpl);
 	remove_proc_entry("ip2mem", NULL);
 
-	// free memory
+	/* free memory */
 	for (i = 0; i < IP2_MAX_BOARDS; i++) {
 		void *pB;
 #ifdef CONFIG_PCI
@@ -431,20 +423,14 @@ static void __exit ip2_cleanup_module(vo
 #endif
 		pB = i2BoardPtrTable[i];
 		if (pB != NULL) {
-			kfree ( pB );
+			kfree(pB);
 			i2BoardPtrTable[i] = NULL;
 		}
-		if ((DevTableMem[i]) != NULL ) {
-			kfree ( DevTableMem[i]  );
+		if (DevTableMem[i] != NULL) {
+			kfree(DevTableMem[i]);
 			DevTableMem[i] = NULL;
 		}
 	}
-
-	/* Cleanup the iiEllis subsystem. */
-	iiEllisCleanup();
-#ifdef IP2DEBUG_INIT
-	printk (KERN_DEBUG "IP2 Unloaded\n" );
-#endif
 }
 module_exit(ip2_cleanup_module);
 
@@ -552,14 +538,13 @@ static int __init ip2_setup(char *str)
 __setup("ip2=", ip2_setup);
 #endif /* !MODULE */
 
-static int ip2_loadmain(void)
+static int __init ip2_loadmain(void)
 {
 	int i, j, box;
 	int err = 0;
-	static int loaded;
 	i2eBordStrPtr pB = NULL;
 	int rc = -1;
-	static struct pci_dev *pci_dev_i = NULL;
+	struct pci_dev *pdev = NULL;
 	const struct firmware *fw = NULL;
 
 	if (poll_only) {
@@ -567,119 +552,108 @@ static int ip2_loadmain(void)
 		irq[0] = irq[1] = irq[2] = irq[3] = poll_only = 0;
 	}
 
-	ip2trace (ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0 );
+	ip2trace(ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0);
 
 	/* process command line arguments to modprobe or
 		insmod i.e. iop & irqp */
 	/* irqp and iop should ALWAYS be specified now...  But we check
 		them individually just to be sure, anyways... */
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		ip2config.addr[i] = io[i];
 		if (irq[i] >= 0)
 			ip2config.irq[i] = irq[i];
 		else
 			ip2config.irq[i] = 0;
-	// This is a little bit of a hack.  If poll_only=1 on command
-	// line back in ip2.c OR all IRQs on all specified boards are
-	// explicitly set to 0, then drop to poll only mode and override
-	// PCI or EISA interrupts.  This superceeds the old hack of
-	// triggering if all interrupts were zero (like da default).
-	// Still a hack but less prone to random acts of terrorism.
-	//
-	// What we really should do, now that the IRQ default is set
-	// to -1, is to use 0 as a hard coded, do not probe.
-	//
-	//	/\/\|=mhw=|\/\/
+	/* This is a little bit of a hack.  If poll_only=1 on command
+	   line back in ip2.c OR all IRQs on all specified boards are
+	   explicitly set to 0, then drop to poll only mode and override
+	   PCI or EISA interrupts.  This superceeds the old hack of
+	   triggering if all interrupts were zero (like da default).
+	   Still a hack but less prone to random acts of terrorism.
+
+	   What we really should do, now that the IRQ default is set
+	   to -1, is to use 0 as a hard coded, do not probe.
+
+		/\/\|=mhw=|\/\/
+	*/
 		poll_only |= irq[i];
 	}
 	poll_only = !poll_only;
 
 	/* Announce our presence */
-	printk( KERN_INFO "%s version %s\n", pcName, pcVersion );
-
-	// ip2 can be unloaded and reloaded for no good reason
-	// we can't let that happen here or bad things happen
-	// second load hoses board but not system - fixme later
-	if (loaded) {
-		printk( KERN_INFO "Still loaded\n" );
-		return 0;
-	}
-	loaded++;
+	printk(KERN_INFO "%s version %s\n", pcName, pcVersion);
 
 	ip2_tty_driver = alloc_tty_driver(IP2_MAX_PORTS);
 	if (!ip2_tty_driver)
 		return -ENOMEM;
 
-	/* Initialise the iiEllis subsystem. */
-	iiEllisInit();
-
 	/* Initialise all the boards we can find (up to the maximum). */
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		switch ( ip2config.addr[i] ) { 
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
+		switch (ip2config.addr[i]) {
 		case 0:	/* skip this slot even if card is present */
 			break;
 		default: /* ISA */
 		   /* ISA address must be specified */
-			if ( (ip2config.addr[i] < 0x100) || (ip2config.addr[i] > 0x3f8) ) {
-				printk ( KERN_ERR "IP2: Bad ISA board %d address %x\n",
-							 i, ip2config.addr[i] );
+			if (ip2config.addr[i] < 0x100 ||
+					ip2config.addr[i] > 0x3f8) {
+				printk(KERN_ERR "IP2: Bad ISA board %d "
+						"address %x\n", i,
+						ip2config.addr[i]);
 				ip2config.addr[i] = 0;
-			} else {
-				ip2config.type[i] = ISA;
+				break;
+			}
+			ip2config.type[i] = ISA;
 
-				/* Check for valid irq argument, set for polling if invalid */
-				if (ip2config.irq[i] && !is_valid_irq(ip2config.irq[i])) {
-					printk(KERN_ERR "IP2: Bad IRQ(%d) specified\n",ip2config.irq[i]);
-					ip2config.irq[i] = 0;// 0 is polling and is valid in that sense
-				}
+			/* Check for valid irq argument, set for polling if
+			 * invalid */
+			if (ip2config.irq[i] &&
+					!is_valid_irq(ip2config.irq[i])) {
+				printk(KERN_ERR "IP2: Bad IRQ(%d) specified\n",
+						ip2config.irq[i]);
+				/* 0 is polling and is valid in that sense */
+				ip2config.irq[i] = 0;
 			}
 			break;
 		case PCI:
 #ifdef CONFIG_PCI
-			{
-				int status;
-
-				pci_dev_i = pci_get_device(PCI_VENDOR_ID_COMPUTONE,
-							  PCI_DEVICE_ID_COMPUTONE_IP2EX, pci_dev_i);
-				if (pci_dev_i != NULL) {
-					unsigned int addr;
-
-					if (pci_enable_device(pci_dev_i)) {
-						printk( KERN_ERR "IP2: can't enable PCI device at %s\n",
-							pci_name(pci_dev_i));
-						break;
-					}
-					ip2config.type[i] = PCI;
-					ip2config.pci_dev[i] = pci_dev_get(pci_dev_i);
-					status =
-					pci_read_config_dword(pci_dev_i, PCI_BASE_ADDRESS_1, &addr);
-					if ( addr & 1 ) {
-						ip2config.addr[i]=(USHORT)(addr&0xfffe);
-					} else {
-						printk( KERN_ERR "IP2: PCI I/O address error\n");
-					}
-
-//		If the PCI BIOS assigned it, lets try and use it.  If we
-//		can't acquire it or it screws up, deal with it then.
+		{
+			u32 addr;
+			int status;
+
+			pdev = pci_get_device(PCI_VENDOR_ID_COMPUTONE,
+					PCI_DEVICE_ID_COMPUTONE_IP2EX, pdev);
+			if (pdev == NULL) {
+				ip2config.addr[i] = 0;
+				printk(KERN_ERR "IP2: PCI board %d not "
+						"found\n", i);
+				break;
+			}
 
-//					if (!is_valid_irq(pci_irq)) {
-//						printk( KERN_ERR "IP2: Bad PCI BIOS IRQ(%d)\n",pci_irq);
-//						pci_irq = 0;
-//					}
-					ip2config.irq[i] = pci_dev_i->irq;
-				} else {	// ann error
-					ip2config.addr[i] = 0;
-					printk(KERN_ERR "IP2: PCI board %d not found\n", i);
-				} 
+			if (pci_enable_device(pdev)) {
+				dev_err(&pdev->dev, "can't enable device\n");
+				break;
 			}
+			ip2config.type[i] = PCI;
+			ip2config.pci_dev[i] = pci_dev_get(pdev);
+			status = pci_read_config_dword(pdev, PCI_BASE_ADDRESS_1,
+					&addr);
+			if (addr & 1)
+				ip2config.addr[i] = (USHORT)(addr & 0xfffe);
+			else
+				dev_err(&pdev->dev, "I/O address error\n");
+
+			ip2config.irq[i] = pdev->irq;
+		}
 #else
-			printk( KERN_ERR "IP2: PCI card specified but PCI support not\n");
-			printk( KERN_ERR "IP2: configured in this kernel.\n");
-			printk( KERN_ERR "IP2: Recompile kernel with CONFIG_PCI defined!\n");
+			printk(KERN_ERR "IP2: PCI card specified but PCI "
+					"support not enabled.\n");
+			printk(KERN_ERR "IP2: Recompile kernel with CONFIG_PCI "
+					"defined!\n");
 #endif /* CONFIG_PCI */
 			break;
 		case EISA:
-			if ( (ip2config.addr[i] = find_eisa_board( Eisa_slot + 1 )) != 0) {
+			ip2config.addr[i] = find_eisa_board(Eisa_slot + 1);
+			if (ip2config.addr[i] != 0) {
 				/* Eisa_irq set as side effect, boo */
 				ip2config.type[i] = EISA;
 			} 
@@ -687,31 +661,32 @@ static int ip2_loadmain(void)
 			break;
 		}	/* switch */
 	}	/* for */
-	if (pci_dev_i)
-		pci_dev_put(pci_dev_i);
+	pci_dev_put(pdev);
 
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if ( ip2config.addr[i] ) {
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
+		if (ip2config.addr[i]) {
 			pB = kzalloc(sizeof(i2eBordStr), GFP_KERNEL);
 			if (pB) {
 				i2BoardPtrTable[i] = pB;
-				iiSetAddress( pB, ip2config.addr[i], ii2DelayTimer );
-				iiReset( pB );
-			} else {
-				printk(KERN_ERR "IP2: board memory allocation error\n");
-			}
+				iiSetAddress(pB, ip2config.addr[i],
+						ii2DelayTimer);
+				iiReset(pB);
+			} else
+				printk(KERN_ERR "IP2: board memory allocation "
+						"error\n");
 		}
 	}
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-		if ( ( pB = i2BoardPtrTable[i] ) != NULL ) {
-			iiResetDelay( pB );
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
+		pB = i2BoardPtrTable[i];
+		if (pB != NULL) {
+			iiResetDelay(pB);
 			break;
 		}
 	}
-	for ( i = 0; i < IP2_MAX_BOARDS; ++i ) {
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
 		/* We don't want to request the firmware unless we have at
 		   least one board */
-		if ( i2BoardPtrTable[i] != NULL ) {
+		if (i2BoardPtrTable[i] != NULL) {
 			if (!fw)
 				fw = ip2_request_firmware();
 			if (!fw)
@@ -722,7 +697,7 @@ static int ip2_loadmain(void)
 	if (fw)
 		release_firmware(fw);
 
-	ip2trace (ITRC_NO_PORT, ITRC_INIT, 2, 0 );
+	ip2trace(ITRC_NO_PORT, ITRC_INIT, 2, 0);
 
 	ip2_tty_driver->owner		    = THIS_MODULE;
 	ip2_tty_driver->name                 = "ttyF";
@@ -733,20 +708,23 @@ static int ip2_loadmain(void)
 	ip2_tty_driver->subtype              = SERIAL_TYPE_NORMAL;
 	ip2_tty_driver->init_termios         = tty_std_termios;
 	ip2_tty_driver->init_termios.c_cflag = B9600|CS8|CREAD|HUPCL|CLOCAL;
-	ip2_tty_driver->flags                = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	ip2_tty_driver->flags                = TTY_DRIVER_REAL_RAW |
+		TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(ip2_tty_driver, &ip2_ops);
 
-	ip2trace (ITRC_NO_PORT, ITRC_INIT, 3, 0 );
+	ip2trace(ITRC_NO_PORT, ITRC_INIT, 3, 0);
 
-	/* Register the tty devices. */
-	if ( ( err = tty_register_driver ( ip2_tty_driver ) ) ) {
-		printk(KERN_ERR "IP2: failed to register tty driver (%d)\n", err);
+	err = tty_register_driver(ip2_tty_driver);
+	if (err) {
+		printk(KERN_ERR "IP2: failed to register tty driver\n");
 		put_tty_driver(ip2_tty_driver);
-		return -EINVAL;
-	} else
-	/* Register the IPL driver. */
-	if ( ( err = register_chrdev ( IP2_IPL_MAJOR, pcIpl, &ip2_ipl ) ) ) {
-		printk(KERN_ERR "IP2: failed to register IPL device (%d)\n", err );
+		return err; /* leaking resources */
+	}
+
+	err = register_chrdev(IP2_IPL_MAJOR, pcIpl, &ip2_ipl);
+	if (err) {
+		printk(KERN_ERR "IP2: failed to register IPL device (%d)\n",
+				err);
 	} else {
 		/* create the sysfs class */
 		ip2_class = class_create(THIS_MODULE, "ip2");
@@ -758,82 +736,85 @@ static int ip2_loadmain(void)
 	/* Register the read_procmem thing */
 	if (!proc_create("ip2mem",0,NULL,&ip2mem_proc_fops)) {
 		printk(KERN_ERR "IP2: failed to register read_procmem\n");
-	} else {
+		return -EIO; /* leaking resources */
+	}
 
-	ip2trace (ITRC_NO_PORT, ITRC_INIT, 4, 0 );
-		/* Register the interrupt handler or poll handler, depending upon the
-		 * specified interrupt.
-		 */
+	ip2trace(ITRC_NO_PORT, ITRC_INIT, 4, 0);
+	/* Register the interrupt handler or poll handler, depending upon the
+	 * specified interrupt.
+	 */
 
-		for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-			if ( 0 == ip2config.addr[i] ) {
-				continue;
-			}
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
+		if (ip2config.addr[i] == 0)
+			continue;
 
-			if ( NULL != ( pB = i2BoardPtrTable[i] ) ) {
-				device_create_drvdata(ip2_class, NULL,
-						      MKDEV(IP2_IPL_MAJOR, 4 * i),
-						      NULL, "ipl%d", i);
-				device_create_drvdata(ip2_class, NULL,
-						      MKDEV(IP2_IPL_MAJOR, 4 * i + 1),
-						      NULL, "stat%d", i);
-
-			    for ( box = 0; box < ABS_MAX_BOXES; ++box )
-			    {
-			        for ( j = 0; j < ABS_BIGGEST_BOX; ++j )
-			        {
-				    if ( pB->i2eChannelMap[box] & (1 << j) )
-				    {
-				        tty_register_device(ip2_tty_driver,
-					    j + ABS_BIGGEST_BOX *
-						    (box+i*ABS_MAX_BOXES), NULL);
-			    	    }
-			        }
-			    }
-			}
-
-			if (poll_only) {
-//		Poll only forces driver to only use polling and
-//		to ignore the probed PCI or EISA interrupts.
-				ip2config.irq[i] = CIR_POLL;
-			}
-			if ( ip2config.irq[i] == CIR_POLL ) {
+		pB = i2BoardPtrTable[i];
+		if (pB != NULL) {
+			device_create_drvdata(ip2_class, NULL,
+					      MKDEV(IP2_IPL_MAJOR, 4 * i),
+					      NULL, "ipl%d", i);
+			device_create_drvdata(ip2_class, NULL,
+					      MKDEV(IP2_IPL_MAJOR, 4 * i + 1),
+					      NULL, "stat%d", i);
+
+			for (box = 0; box < ABS_MAX_BOXES; box++)
+				for (j = 0; j < ABS_BIGGEST_BOX; j++)
+					if (pB->i2eChannelMap[box] & (1 << j))
+						tty_register_device(
+							ip2_tty_driver,
+							j + ABS_BIGGEST_BOX *
+							(box+i*ABS_MAX_BOXES),
+							NULL);
+		}
+
+		if (poll_only) {
+			/* Poll only forces driver to only use polling and
+			   to ignore the probed PCI or EISA interrupts. */
+			ip2config.irq[i] = CIR_POLL;
+		}
+		if (ip2config.irq[i] == CIR_POLL) {
 retry:
-				if (!TimerOn) {
-					PollTimer.expires = POLL_TIMEOUT;
-					add_timer ( &PollTimer );
-					TimerOn = 1;
-					printk( KERN_INFO "IP2: polling\n");
-				}
-			} else {
-				if (have_requested_irq(ip2config.irq[i]))
-					continue;
-				rc = request_irq( ip2config.irq[i], ip2_interrupt,
-					IP2_SA_FLAGS | (ip2config.type[i] == PCI ? IRQF_SHARED : 0),
-					pcName, i2BoardPtrTable[i]);
-				if (rc) {
-					printk(KERN_ERR "IP2: an request_irq failed: error %d\n",rc);
-					ip2config.irq[i] = CIR_POLL;
-					printk( KERN_INFO "IP2: Polling %ld/sec.\n",
-							(POLL_TIMEOUT - jiffies));
-					goto retry;
-				} 
-				mark_requested_irq(ip2config.irq[i]);
-				/* Initialise the interrupt handler bottom half (aka slih). */
-			}
-		}
-		for( i = 0; i < IP2_MAX_BOARDS; ++i ) {
-			if ( i2BoardPtrTable[i] ) {
-				set_irq( i, ip2config.irq[i] ); /* set and enable board interrupt */
+			if (!TimerOn) {
+				PollTimer.expires = POLL_TIMEOUT;
+				add_timer(&PollTimer);
+				TimerOn = 1;
+				printk(KERN_INFO "IP2: polling\n");
+			}
+		} else {
+			if (have_requested_irq(ip2config.irq[i]))
+				continue;
+			rc = request_irq(ip2config.irq[i], ip2_interrupt,
+				IP2_SA_FLAGS |
+				(ip2config.type[i] == PCI ? IRQF_SHARED : 0),
+				pcName, i2BoardPtrTable[i]);
+			if (rc) {
+				printk(KERN_ERR "IP2: request_irq failed: "
+						"error %d\n", rc);
+				ip2config.irq[i] = CIR_POLL;
+				printk(KERN_INFO "IP2: Polling %ld/sec.\n",
+						(POLL_TIMEOUT - jiffies));
+				goto retry;
 			}
+			mark_requested_irq(ip2config.irq[i]);
+			/* Initialise the interrupt handler bottom half
+			 * (aka slih). */
 		}
 	}
-	ip2trace (ITRC_NO_PORT, ITRC_INIT, ITRC_RETURN, 0 );
-	goto out;
+
+	for (i = 0; i < IP2_MAX_BOARDS; ++i) {
+		if (i2BoardPtrTable[i]) {
+			/* set and enable board interrupt */
+			set_irq(i, ip2config.irq[i]);
+		}
+	}
+
+	ip2trace(ITRC_NO_PORT, ITRC_INIT, ITRC_RETURN, 0);
+
+	return 0;
 
 out_chrdev:
 	unregister_chrdev(IP2_IPL_MAJOR, "ip2");
-out:
+	/* unregister and put tty here */
 	return err;
 }
 module_init(ip2_loadmain);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
serial-z85c30-avoid-a-hang-at-console-switch-over.patch
serial-dz11-avoid-a-hang-at-console-switch-over.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
drivers-misc-phantom-note-pci.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

