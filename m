From: akpm@linux-foundation.org
Subject: + serial-add-pnp-id-for-davicom-isa-336k-modem.patch added to -mm tree
Date: Wed, 07 Nov 2007 14:09:20 -0800
Message-ID: <200711072209.lA7M9MMA030362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757697AbXKGWOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 17:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, vavilov@ihep.ru


The patch titled
     serial: add PNP ID for Davicom ISA 33.6K modem
has been added to the -mm tree.  Its filename is
     serial-add-pnp-id-for-davicom-isa-336k-modem.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: add PNP ID for Davicom ISA 33.6K modem
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This should resolve these bug reports of the modem not working:
    http://bugzilla.kernel.org/show_bug.cgi?id=4355
    http://www.linuxquestions.org/questions/linux-newbie-8/connect-script-failed-on-ppp-go-123975/

I don't have hardware to test this, but the initial report in the kernel
bugzilla indicates that this change fixed the problem.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Dmitry Vavilov <vavilov@ihep.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-add-pnp-id-for-davicom-isa-336k-modem drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-add-pnp-id-for-davicom-isa-336k-modem
+++ a/drivers/serial/8250_pnp.c
@@ -69,6 +69,8 @@ static const struct pnp_device_id pnp_de
 	{	"CTL3001",		0	},
 	/* Creative Labs Modem Blaster 28.8 DSVD PnP Voice */
 	{	"CTL3011",		0	},
+	/* Davicom ISA 33.6K Modem */
+	{	"DAV0336",		0	},
 	/* Creative */
 	/* Creative Modem Blaster Flash56 DI5601-1 */
 	{	"DMB1032",		0	},
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-add-pnp-id-for-davicom-isa-336k-modem.patch
8250_pnp-add-support-for-lg-c1-express-dual-machines.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
small-acpica-extension-to-be-able-to-store-the-name-of-fix.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
serial-only-use-pnp-irq-if-its-valid.patch
__do_irq-does-not-check-irq_disabled-when-irq_per_cpu-is-set.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
dont-touch-fs_struct-in-drivers.patch
