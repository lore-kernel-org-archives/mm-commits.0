From: akpm@linux-foundation.org
Subject: + char-serial-switch-drivers-to-ioremap_nocache.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:30:53 -0700
Message-ID: <200804291930.m3TJUrT7005826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbYD2TcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mingo@elte.hu, paulkf@microgate.com


The patch titled
     char serial: switch drivers to ioremap_nocache
has been added to the -mm tree.  Its filename is
     char-serial-switch-drivers-to-ioremap_nocache.patch

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
Subject: char serial: switch drivers to ioremap_nocache
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Simple search/replace except for synclink.c where I noticed a real bug and
fixed it too.  It was doing NULL + offset, then checking for NULL if the remap
failed.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c    |    4 ++--
 drivers/char/istallion.c   |    6 +++---
 drivers/char/moxa.c        |    4 ++--
 drivers/char/nozomi.c      |    2 +-
 drivers/char/sx.c          |   10 +++++-----
 drivers/char/synclink.c    |    7 +++++--
 drivers/char/synclink_gt.c |    2 +-
 drivers/char/synclinkmp.c  |   10 ++++++----
 8 files changed, 25 insertions(+), 20 deletions(-)

diff -puN drivers/char/applicom.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/applicom.c
--- a/drivers/char/applicom.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/applicom.c
@@ -199,7 +199,7 @@ static int __init applicom_init(void)
 		if (pci_enable_device(dev))
 			return -EIO;
 
-		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
+		RamIO = ioremap_nocache(pci_resource_start(dev, 0), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap PCI memory "
@@ -254,7 +254,7 @@ static int __init applicom_init(void)
 	/* Now try the specified ISA cards */
 
 	for (i = 0; i < MAX_ISA_BOARD; i++) {
-		RamIO = ioremap(mem + (LEN_RAM_IO * i), LEN_RAM_IO);
+		RamIO = ioremap_nocache(mem + (LEN_RAM_IO * i), LEN_RAM_IO);
 
 		if (!RamIO) {
 			printk(KERN_INFO "ac.o: Failed to ioremap the ISA card's memory space (slot #%d)\n", i + 1);
diff -puN drivers/char/istallion.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/istallion.c
@@ -3257,7 +3257,7 @@ static int stli_initecp(struct stlibrd *
  */
 	EBRDINIT(brdp);
 
-	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+	brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 	if (brdp->membase == NULL) {
 		retval = -ENOMEM;
 		goto err_reg;
@@ -3414,7 +3414,7 @@ static int stli_initonb(struct stlibrd *
  */
 	EBRDINIT(brdp);
 
-	brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+	brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 	if (brdp->membase == NULL) {
 		retval = -ENOMEM;
 		goto err_reg;
@@ -3665,7 +3665,7 @@ static int stli_eisamemprobe(struct stli
  */
 	for (i = 0; (i < stli_eisamempsize); i++) {
 		brdp->memaddr = stli_eisamemprobeaddrs[i];
-		brdp->membase = ioremap(brdp->memaddr, brdp->memsize);
+		brdp->membase = ioremap_nocache(brdp->memaddr, brdp->memsize);
 		if (brdp->membase == NULL)
 			continue;
 
diff -puN drivers/char/moxa.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/moxa.c
@@ -937,7 +937,7 @@ static int __devinit moxa_pci_probe(stru
 		goto err;
 	}
 
-	board->basemem = ioremap(pci_resource_start(pdev, 2), 0x4000);
+	board->basemem = ioremap_nocache(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
 		goto err_reg;
@@ -1042,7 +1042,7 @@ static int __init moxa_init(void)
 			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
 					numports[i];
 			brd->busType = MOXA_BUS_TYPE_ISA;
-			brd->basemem = ioremap(baseaddr[i], 0x4000);
+			brd->basemem = ioremap_nocache(baseaddr[i], 0x4000);
 			if (!brd->basemem) {
 				printk(KERN_ERR "MOXA: can't remap %lx\n",
 						baseaddr[i]);
diff -puN drivers/char/nozomi.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/nozomi.c
@@ -1407,7 +1407,7 @@ static int __devinit nozomi_card_init(st
 	/* Find out what card type it is */
 	nozomi_get_card_type(dc);
 
-	dc->base_addr = ioremap(start, dc->card_type);
+	dc->base_addr = ioremap_nocache(start, dc->card_type);
 	if (!dc->base_addr) {
 		dev_err(&pdev->dev, "Unable to map card MMIO\n");
 		ret = -ENODEV;
diff -puN drivers/char/sx.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/sx.c
--- a/drivers/char/sx.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/sx.c
@@ -2543,7 +2543,7 @@ static int __devinit sx_eisa_probe(struc
 		goto err_flag;
 	}
 	board->base2 =
-	board->base = ioremap(board->hw_base, SI2_EISA_WINDOW_LEN);
+	board->base = ioremap_nocache(board->hw_base, SI2_EISA_WINDOW_LEN);
 	if (!board->base) {
 		dev_err(dev, "can't remap memory\n");
 		goto err_reg;
@@ -2620,7 +2620,7 @@ static void __devinit fix_sx_pci(struct 
 
 	pci_read_config_dword(pdev, PCI_BASE_ADDRESS_0, &hwbase);
 	hwbase &= PCI_BASE_ADDRESS_MEM_MASK;
-	rebase = ioremap(hwbase, 0x80);
+	rebase = ioremap_nocache(hwbase, 0x80);
 	t = readl(rebase + CNTRL_REG_OFFSET);
 	if (t != CNTRL_REG_GOODVALUE) {
 		printk(KERN_DEBUG "sx: performing cntrl reg fix: %08x -> "
@@ -2764,7 +2764,7 @@ static int __init sx_init(void)
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_sx_reg;
 		board->flags &= ~SX_BOARD_TYPE;
@@ -2788,7 +2788,7 @@ err_sx_reg:
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_si_reg;
 		board->flags &= ~SX_BOARD_TYPE;
@@ -2811,7 +2811,7 @@ err_si_reg:
 		if (!request_region(board->hw_base, board->hw_len, "sx"))
 			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, board->hw_len);
+		board->base = ioremap_nocache(board->hw_base, board->hw_len);
 		if (!board->base)
 			goto err_si1_reg;
 		board->flags &= ~SX_BOARD_TYPE;
diff -puN drivers/char/synclink.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/synclink.c
--- a/drivers/char/synclink.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/synclink.c
@@ -4150,7 +4150,8 @@ static int mgsl_claim_resources(struct m
 		}
 		info->lcr_mem_requested = true;
 
-		info->memory_base = ioremap(info->phys_memory_base,0x40000);
+		info->memory_base = ioremap_nocache(info->phys_memory_base,
+								0x40000);
 		if (!info->memory_base) {
 			printk( "%s(%d):Cant map shared memory on device %s MemAddr=%08X\n",
 				__FILE__,__LINE__,info->device_name, info->phys_memory_base );
@@ -4163,12 +4164,14 @@ static int mgsl_claim_resources(struct m
 			goto errout;
 		}
 		
-		info->lcr_base = ioremap(info->phys_lcr_base,PAGE_SIZE) + info->lcr_offset;
+		info->lcr_base = ioremap_nocache(info->phys_lcr_base,
+								PAGE_SIZE);
 		if (!info->lcr_base) {
 			printk( "%s(%d):Cant map LCR memory on device %s MemAddr=%08X\n",
 				__FILE__,__LINE__,info->device_name, info->phys_lcr_base );
 			goto errout;
 		}
+		info->lcr_base += info->lcr_offset;
 		
 	} else {
 		/* claim DMA channel */
diff -puN drivers/char/synclink_gt.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/synclink_gt.c
@@ -3350,7 +3350,7 @@ static int claim_resources(struct slgt_i
 	else
 		info->reg_addr_requested = true;
 
-	info->reg_addr = ioremap(info->phys_reg_addr, SLGT_REG_SIZE);
+	info->reg_addr = ioremap_nocache(info->phys_reg_addr, SLGT_REG_SIZE);
 	if (!info->reg_addr) {
 		DBGERR(("%s cant map device registers, addr=%08X\n",
 			info->device_name, info->phys_reg_addr));
diff -puN drivers/char/synclinkmp.c~char-serial-switch-drivers-to-ioremap_nocache drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~char-serial-switch-drivers-to-ioremap_nocache
+++ a/drivers/char/synclinkmp.c
@@ -3643,7 +3643,8 @@ static int claim_resources(SLMP_INFO *in
 	else
 		info->sca_statctrl_requested = true;
 
-	info->memory_base = ioremap(info->phys_memory_base,SCA_MEM_SIZE);
+	info->memory_base = ioremap_nocache(info->phys_memory_base,
+								SCA_MEM_SIZE);
 	if (!info->memory_base) {
 		printk( "%s(%d):%s Cant map shared memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_memory_base );
@@ -3651,7 +3652,7 @@ static int claim_resources(SLMP_INFO *in
 		goto errout;
 	}
 
-	info->lcr_base = ioremap(info->phys_lcr_base,PAGE_SIZE);
+	info->lcr_base = ioremap_nocache(info->phys_lcr_base, PAGE_SIZE);
 	if (!info->lcr_base) {
 		printk( "%s(%d):%s Cant map LCR memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_lcr_base );
@@ -3660,7 +3661,7 @@ static int claim_resources(SLMP_INFO *in
 	}
 	info->lcr_base += info->lcr_offset;
 
-	info->sca_base = ioremap(info->phys_sca_base,PAGE_SIZE);
+	info->sca_base = ioremap_nocache(info->phys_sca_base, PAGE_SIZE);
 	if (!info->sca_base) {
 		printk( "%s(%d):%s Cant map SCA memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_sca_base );
@@ -3669,7 +3670,8 @@ static int claim_resources(SLMP_INFO *in
 	}
 	info->sca_base += info->sca_offset;
 
-	info->statctrl_base = ioremap(info->phys_statctrl_base,PAGE_SIZE);
+	info->statctrl_base = ioremap_nocache(info->phys_statctrl_base,
+								PAGE_SIZE);
 	if (!info->statctrl_base) {
 		printk( "%s(%d):%s Cant map SCA Status/Control memory, MemAddr=%08X\n",
 			__FILE__,__LINE__,info->device_name, info->phys_statctrl_base );
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
vt-fix-background-color-on-line-feed.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
edac-new-support-for-intel-3100-chipset.patch
edac-add-e752x-parameter-for-sysbus_parity-selection.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
edac-fix-module-initialization-on-several-modules-2nd-time.patch
maintainers-sort-ordering.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-more-tsstcorp-pain-keep-in-sync-with-legacy-ide.patch
pata_atiixp-simplex-clear.patch
pata_via-fix-6410-misdetect.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
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
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
toshiba-use-ioremap_cached.patch
isicom-fix-buffer-allocation.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

