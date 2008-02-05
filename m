From: akpm@linux-foundation.org
Subject: - serial-keep-the-dtr-setting-for-serial-console.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:27:33 -0800
Message-ID: <200802052227.m15MREph011760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761238AbYBEWn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@sun.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, bjorn.helgaas@hp.com, rmk@arm.linux.org.uk, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     serial: keep the DTR setting for serial console.
has been removed from the -mm tree.  Its filename was
     serial-keep-the-dtr-setting-for-serial-console.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: keep the DTR setting for serial console.
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

with reverting "x86, serial: convert legacy COM ports to platform devices",
we will have the serial console before the port is probled again.

uart_add_one_port==>uart_configure_port==>set_mcttrl(port, 0) will clear
the DTR setting by uart_set_options().  then I will lose my output from
serial console again.

So try to keep DTR in uart_configure_port()

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/serial_core.c~serial-keep-the-dtr-setting-for-serial-console drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-keep-the-dtr-setting-for-serial-console
+++ a/drivers/serial/serial_core.c
@@ -2150,10 +2150,11 @@ uart_configure_port(struct uart_driver *
 
 		/*
 		 * Ensure that the modem control lines are de-activated.
+		 * keep the DTR setting that is set in uart_set_options()
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, 0);
+		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-cpufreq.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
kernel-printkc-concerns-about-the-console-handover.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
