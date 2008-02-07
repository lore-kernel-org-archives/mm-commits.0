From: akpm@linux-foundation.org
Subject: - pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:15 -0800
Message-ID: <200802070029.m170TueP007332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46223 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935013AbYBGAnq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, mm-commits@vger.kernel.org


The patch titled
     simplify pnp_activate_dev() and pnp_disable_dev() return values
has been removed from the -mm tree.  Its filename was
     pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: simplify pnp_activate_dev() and pnp_disable_dev() return values
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Make pnp_activate_dev() and pnp_disable_dev() return only 0 (success) or a
negative error value, as pci_enable_device() and pci_disable_device() do.

Previously they returned:

    0:	device was already active (or disabled)
    1:	we just activated (or disabled) device
    <0:	-EBUSY or error from pnp_start_dev() (or pnp_stop_dev())

Now we return only 0 (device is active or disabled) or <0 (error).

All in-tree callers either ignore the return values or check only for
errors (negative values).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values
+++ a/drivers/pnp/manager.c
@@ -513,7 +513,7 @@ int pnp_activate_dev(struct pnp_dev *dev
 	int error;
 
 	if (dev->active)
-		return 0;	/* the device is already active */
+		return 0;
 
 	/* ensure resources are allocated */
 	if (pnp_auto_config_dev(dev))
@@ -524,7 +524,7 @@ int pnp_activate_dev(struct pnp_dev *dev
 		return error;
 
 	dev->active = 1;
-	return 1;
+	return 0;
 }
 
 /**
@@ -538,7 +538,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	int error;
 
 	if (!dev->active)
-		return 0;	/* the device is already disabled */
+		return 0;
 
 	error = pnp_stop_dev(dev);
 	if (error)
@@ -551,7 +551,7 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	pnp_clean_resource_table(&dev->res);
 	up(&pnp_res_mutex);
 
-	return 1;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
dont-touch-fs_struct-in-drivers.patch
