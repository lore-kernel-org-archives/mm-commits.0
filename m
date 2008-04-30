From: akpm@linux-foundation.org
Subject: + pata_atiixp-dont-disable.patch added to -mm tree
Date: Wed, 30 Apr 2008 10:55:20 -0700
Message-ID: <200804301755.m3UHtK2t026917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbYD3R4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 13:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, davidg@havidave.com


The patch titled
     pata_atiixp: Don't disable
has been added to the -mm tree.  Its filename is
     pata_atiixp-dont-disable.patch

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
Subject: pata_atiixp: Don't disable
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A couple of distributions (Fedora, Ubuntu) were having weird problems with the
ATI IXP series PATA controllers being reported as simplex.  At the heart of
the problem is that both distros ignored the recommendations to load pata_acpi
and ata_generic *AFTER* specific host drivers.

The underlying cause however is that if you D3 and then D0 an ATI IXP it
helpfully throws away some configuration and won't let you rewrite it.

Add checks to ata_generic and pata_acpi to pin ATIIXP devices.  Possibly the
real answer here is to quirk them and pin them, but right now we can't do that
before they've been pcim_enable()'d by a driver.

I'm indebted to David Gero for this.  His bug report not only reported the
problem but identified the cause correctly and he had tested the right values
to prove what was going on

[If you backport this for 2.6.24 you will need to pull in the 2.6.25
removal of the bogus WARN_ON() in pcim_enagle]

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: David Gero <davidg@havidave.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ata_generic.c |    6 ++++++
 drivers/ata/pata_acpi.c   |    6 ++++++
 drivers/ata/pata_atiixp.c |    3 ---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/ata/ata_generic.c~pata_atiixp-dont-disable drivers/ata/ata_generic.c
--- a/drivers/ata/ata_generic.c~pata_atiixp-dont-disable
+++ a/drivers/ata/ata_generic.c
@@ -152,6 +152,12 @@ static int ata_generic_init_one(struct p
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 		ata_pci_bmdma_clear_simplex(dev);
 
+	if (dev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
 }
 
diff -puN drivers/ata/pata_acpi.c~pata_atiixp-dont-disable drivers/ata/pata_acpi.c
--- a/drivers/ata/pata_acpi.c~pata_atiixp-dont-disable
+++ a/drivers/ata/pata_acpi.c
@@ -259,6 +259,12 @@ static int pacpi_init_one (struct pci_de
 		.port_ops	= &pacpi_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
+	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
 }
 
diff -puN drivers/ata/pata_atiixp.c~pata_atiixp-dont-disable drivers/ata/pata_atiixp.c
--- a/drivers/ata/pata_atiixp.c~pata_atiixp-dont-disable
+++ a/drivers/ata/pata_atiixp.c
@@ -243,9 +243,6 @@ static int atiixp_init_one(struct pci_de
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	/* Some of the quirk reconfiguration messes up the simplex flag, so
-	   clear it again */
-	ata_pci_bmdma_clear_simplex(dev);
 	return ata_pci_sff_init_one(dev, ppi, &atiixp_sht, NULL);
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
maintainers-sort-ordering.patch
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
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
tty-drop-the-bkl-for-driver-ldisc-ioctl-methods.patch
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
tty-the-big-operations-rework.patch
strip-fix-up-strip-for-the-new-order.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
tty-add-throttle-unthrottle-helpers.patch
ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
git-x86.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
pata_atiixp-dont-disable.patch

