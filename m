From: akpm@linux-foundation.org
Subject: + pnpacpi-enable-power-management.patch added to -mm tree
Date: Fri, 28 Nov 2008 22:10:22 -0800
Message-ID: <200811290610.mAT6AM3k012043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYK2GLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 01:11:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Witold.Szczeponik@gmx.net, bjorn.helgaas@hp.com, lenb@kernel.org, rjw@sisk.pl


The patch titled
     pnpacpi: enable Power Management
has been added to the -mm tree.  Its filename is
     pnpacpi-enable-power-management.patch

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
Subject: pnpacpi: enable Power Management
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>

Set the power of PnP ACPI devices to D0 when they are activated and to D3
when they are disabled.  The latter is in correspondence with the ACPI 3.0
specification, whereas the former is added in order to be able to power up
a device after it has been previously disabled (or when booting up a
system).  (As a consequence, the patch makes the PnP ACPI code more ACPI
compliant.)

The patch fixes the problem with some IBM ThinkPads (at least the 600E and
the 600X) where the serial ports have a dedicated power source that needs
to be brought up before the serial port can be used.  Without this patch,
the serial port is enabled but has no power.

No regressions were observed on hardware that does not require this patch.

Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/core.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/pnpacpi/core.c~pnpacpi-enable-power-management drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnpacpi-enable-power-management
+++ a/drivers/pnp/pnpacpi/core.c
@@ -98,18 +98,24 @@ static int pnpacpi_set_resources(struct 
 	status = acpi_set_current_resources(handle, &buffer);
 	if (ACPI_FAILURE(status))
 		ret = -EINVAL;
+	else if (acpi_bus_power_manageable(handle))
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D0);
 	kfree(buffer.pointer);
 	return ret;
 }
 
 static int pnpacpi_disable_resources(struct pnp_dev *dev)
 {
+	acpi_handle handle = dev->data;
+	int ret = 0;
 	acpi_status status;
 
-	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
-	status = acpi_evaluate_object((acpi_handle) dev->data,
-				      "_DIS", NULL, NULL);
-	return ACPI_FAILURE(status) ? -ENODEV : 0;
+	if (acpi_bus_power_manageable(handle))
+		ret = acpi_bus_set_power(handle, ACPI_STATE_D3);
+	status = acpi_evaluate_object(handle, "_DIS", NULL, NULL);
+	if (ACPI_FAILURE(status))
+		ret = -ENODEV;
+	return ret;
 }
 
 #ifdef CONFIG_ACPI_SLEEP
_

Patches currently in -mm which might be from Witold.Szczeponik@gmx.net are

pnpacpi-enable-power-management.patch

