From: akpm@linux-foundation.org
Subject: + serial-only-use-pnp-irq-if-its-valid.patch added to -mm tree
Date: Fri, 26 Oct 2007 12:38:07 -0700
Message-ID: <200710261938.l9QJc7en011052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbXJZTii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 15:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, alan@lxorguk.ukuu.org.uk, luming.yu@gmail.com, luming.yu@intel.com, matthew@wil.cx, rmk@arm.linux.org.uk


The patch titled
     serial: only use PNP IRQ if it's valid
has been added to the -mm tree.  Its filename is
     serial-only-use-pnp-irq-if-its-valid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: only use PNP IRQ if it's valid
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

"Luming Yu" <luming.yu@gmail.com> says:

  There is a "ttyS1 irq is -1" problem observed on tiger4 which cause the
  serial port broken.

  It is because that there is __no__ ACPI IRQ resource assigned for the
  serial port.  So the value of the IRQ for the port is never changed since it
  got initialized to -1.

If PNP supplies a valid IRQ, use it.  Otherwise, leave port.irq == 0, which
means "no IRQ" to the serial core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yu Luming <luming.yu@intel.com>
Acked-by: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250_pnp.c~serial-only-use-pnp-irq-if-its-valid drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-only-use-pnp-irq-if-its-valid
+++ a/drivers/serial/8250_pnp.c
@@ -432,7 +432,8 @@ serial_pnp_probe(struct pnp_dev *dev, co
 	}
 
 	memset(&port, 0, sizeof(struct uart_port));
-	port.irq = pnp_irq(dev, 0);
+	if (pnp_irq_valid(dev, 0))
+		port.irq = pnp_irq(dev, 0);
 	if (pnp_port_valid(dev, 0)) {
 		port.iobase = pnp_port_start(dev, 0);
 		port.iotype = UPIO_PORT;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
provide-acpi_check_mem_region.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
serial-only-use-pnp-irq-if-its-valid.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
