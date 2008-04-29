From: akpm@linux-foundation.org
Subject: + 8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:28:28 -0700
Message-ID: <200804291928.m3TJSShQ005746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbYD2T3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mingo@elte.hu, rmk@arm.linux.org.uk


The patch titled
     8250: switch 8250 drivers to use _nocache ioremaps
has been added to the -mm tree.  Its filename is
     8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch

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
Subject: 8250: switch 8250 drivers to use _nocache ioremaps
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |    3 ++-
 drivers/serial/8250_early.c |    2 +-
 drivers/serial/8250_pci.c   |   14 ++++++++------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/serial/8250.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250.c
@@ -2271,7 +2271,8 @@ static int serial8250_request_std_resour
 		}
 
 		if (up->port.flags & UPF_IOREMAP) {
-			up->port.membase = ioremap(up->port.mapbase, size);
+			up->port.membase = ioremap_nocache(up->port.mapbase,
+									size);
 			if (!up->port.membase) {
 				release_mem_region(up->port.mapbase, size);
 				ret = -ENOMEM;
diff -puN drivers/serial/8250_early.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250_early.c
@@ -153,7 +153,7 @@ static int __init parse_options(struct e
 			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		port->membase += port->mapbase & ~PAGE_MASK;
 #else
-		port->membase = ioremap(port->mapbase, 64);
+		port->membase = ioremap_nocache(port->mapbase, 64);
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__FUNCTION__,
diff -puN drivers/serial/8250_pci.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250-switch-8250-drivers-to-use-_nocache-ioremaps
+++ a/drivers/serial/8250_pci.c
@@ -86,7 +86,7 @@ setup_port(struct serial_private *priv, 
 		len =  pci_resource_len(dev, bar);
 
 		if (!priv->remapped_bar[bar])
-			priv->remapped_bar[bar] = ioremap(base, len);
+			priv->remapped_bar[bar] = ioremap_nocache(base, len);
 		if (!priv->remapped_bar[bar])
 			return -ENOMEM;
 
@@ -270,7 +270,7 @@ static int pci_plx9050_init(struct pci_d
 	/*
 	 * enable/disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 	writel(irq_config, p + 0x4c);
@@ -294,7 +294,7 @@ static void __devexit pci_plx9050_exit(s
 	/*
 	 * disable interrupts
 	 */
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p != NULL) {
 		writel(0, p + 0x4c);
 
@@ -341,7 +341,8 @@ static int sbs_init(struct pci_dev *dev)
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+						pci_resource_len(dev, 0));
 
 	if (p == NULL)
 		return -ENOMEM;
@@ -365,7 +366,8 @@ static void __devexit sbs_exit(struct pc
 {
 	u8 __iomem *p;
 
-	p = ioremap(pci_resource_start(dev, 0), pci_resource_len(dev, 0));
+	p = ioremap_nocache(pci_resource_start(dev, 0),
+					pci_resource_len(dev, 0));
 	/* FIXME: What if resource_len < OCT_REG_CR_OFF */
 	if (p != NULL)
 		writeb(0, p + OCT_REG_CR_OFF);
@@ -419,7 +421,7 @@ static int pci_siig10x_init(struct pci_d
 		break;
 	}
 
-	p = ioremap(pci_resource_start(dev, 0), 0x80);
+	p = ioremap_nocache(pci_resource_start(dev, 0), 0x80);
 	if (p == NULL)
 		return -ENOMEM;
 
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
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
maintainers-sort-ordering.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

