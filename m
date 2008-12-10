From: akpm@linux-foundation.org
Subject: - pnpacpi-enable-power-management.patch removed from -mm tree
Date: Wed, 10 Dec 2008 12:52:36 -0800
Message-ID: <200812102052.mBAKqaxJ011203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbYLJUxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 15:53:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Witold.Szczeponik@gmx.net, bjorn.helgaas@hp.com, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: enable Power Management
has been removed from the -mm tree.  Its filename was
     pnpacpi-enable-power-management.patch

This patch was dropped because an updated version will be merged

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

