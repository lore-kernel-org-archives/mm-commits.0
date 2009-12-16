From: akpm@linux-foundation.org
Subject: + serial-fix-test-of-unsigned.patch added to -mm tree
Date: Wed, 16 Dec 2009 15:04:57 -0800
Message-ID: <200912162304.nBGN4v4L020673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935310AbZLPXFI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 18:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     serial: fix test of unsigned
has been added to the -mm tree.  Its filename is
     serial-fix-test-of-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix test of unsigned
From: Roel Kluin <roel.kluin@gmail.com>

The variables were unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/msm_serial.c |    6 ++++--
 drivers/serial/timbuart.c   |    7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/serial/msm_serial.c~serial-fix-test-of-unsigned drivers/serial/msm_serial.c
--- a/drivers/serial/msm_serial.c~serial-fix-test-of-unsigned
+++ a/drivers/serial/msm_serial.c
@@ -691,6 +691,7 @@ static int __init msm_serial_probe(struc
 	struct msm_port *msm_port;
 	struct resource *resource;
 	struct uart_port *port;
+	int irq;
 
 	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
 		return -ENXIO;
@@ -711,9 +712,10 @@ static int __init msm_serial_probe(struc
 		return -ENXIO;
 	port->mapbase = resource->start;
 
-	port->irq = platform_get_irq(pdev, 0);
-	if (unlikely(port->irq < 0))
+	irq = platform_get_irq(pdev, 0);
+	if (unlikely(irq < 0))
 		return -ENXIO;
+	port->irq = irq;
 
 	platform_set_drvdata(pdev, port);
 
diff -puN drivers/serial/timbuart.c~serial-fix-test-of-unsigned drivers/serial/timbuart.c
--- a/drivers/serial/timbuart.c~serial-fix-test-of-unsigned
+++ a/drivers/serial/timbuart.c
@@ -421,7 +421,7 @@ static struct uart_driver timbuart_drive
 
 static int timbuart_probe(struct platform_device *dev)
 {
-	int err;
+	int err, irq;
 	struct timbuart_port *uart;
 	struct resource *iomem;
 
@@ -453,11 +453,12 @@ static int timbuart_probe(struct platfor
 	uart->port.mapbase = iomem->start;
 	uart->port.membase = NULL;
 
-	uart->port.irq = platform_get_irq(dev, 0);
-	if (uart->port.irq < 0) {
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0) {
 		err = -EINVAL;
 		goto err_register;
 	}
+	uart->port.irq = irq;
 
 	tasklet_init(&uart->tasklet, timbuart_tasklet, (unsigned long)uart);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
thermal-fix-test-of-unsigned-in-thermal_cooling_device_cur_state_store.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
serial-fix-test-of-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
drbd-fix-test-of-unsigned-in-_drbd_fault_random.patch
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

