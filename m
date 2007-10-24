From: akpm@linux-foundation.org
Subject: + pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:04:14 -0700
Message-ID: <200710242304.l9ON4Edh017090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbXJXXEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:04:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com


The patch titled
     simplify pnp_activate_dev() and pnp_disable_dev() return values
has been added to the -mm tree.  Its filename is
     pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-keep-the-dtr-setting-for-serial-console.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
