From: akpm@linux-foundation.org
Subject: - pnp-do-not-stop-start-devices-in-suspend-resume-path.patch removed from -mm tree
Date: Sat, 12 Jan 2008 21:28:13 -0800
Message-ID: <200801130527.m0D5RsMn030643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYAMF3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 00:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, drzeus@drzeus.cx, jirislaby@gmail.com, kristen.c.accardi@intel.com, lenb@kernel.org, rjw@sisk.pl, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     PNP: do not stop/start devices in suspend/resume path
has been removed from the -mm tree.  Its filename was
     pnp-do-not-stop-start-devices-in-suspend-resume-path.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: do not stop/start devices in suspend/resume path
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Do not disable PNP devices in the suspend path.  We still call the driver's
suspend method, which should prevent further use of the device, and the
protocol suspend method, which may put the device in a low-power state.

I'm told that Windows puts devices in a low-power state (Linux does this in
the protocol suspend method), but does not use _DIS in the suspend path. 
Other relevant references:

  - In the ACPI 3.0b spec, I can't find any mention of _DIS in
    connection with sleep.  And Device Object Notifications,
    Section 5.6.3, Table 5-43, says we should get a bus check
    after awakening if hardware was removed while we slept.

  - This: http://msdn2.microsoft.com/en-us/library/ms810079.aspx
    makes a similar point about how the OS re-enumerates devices
    as a result of a power state change (3rd last paragraph of
    text).

  - This: http://msdn2.microsoft.com/en-us/library/aa489874.aspx
    suggests that Windows only stops a device to rebalance hardware
    resources.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/driver.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN drivers/pnp/driver.c~pnp-do-not-stop-start-devices-in-suspend-resume-path drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-do-not-stop-start-devices-in-suspend-resume-path
+++ a/drivers/pnp/driver.c
@@ -161,13 +161,6 @@ static int pnp_bus_suspend(struct device
 			return error;
 	}
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
-	    pnp_can_disable(pnp_dev)) {
-		error = pnp_stop_dev(pnp_dev);
-		if (error)
-			return error;
-	}
-
 	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
 		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
@@ -177,7 +170,6 @@ static int pnp_bus_resume(struct device 
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
 	struct pnp_driver *pnp_drv = pnp_dev->driver;
-	int error;
 
 	if (!pnp_drv)
 		return 0;
@@ -185,12 +177,6 @@ static int pnp_bus_resume(struct device 
 	if (pnp_dev->protocol && pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
-		error = pnp_start_dev(pnp_dev);
-		if (error)
-			return error;
-	}
-
 	if (pnp_drv->resume)
 		return pnp_drv->resume(pnp_dev);
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
parport_serial-netmos-9855-fix.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
declare-pnp-option-parsing-functions-as-__init.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
dont-touch-fs_struct-in-drivers.patch
