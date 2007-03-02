From: akpm@linux-foundation.org
Subject: - libata-clear-drvdata-in-ata_host_release-take2.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:48 -0800
Message-ID: <200703020507.l2257mjO000896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422774AbXCBFHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     libata: clear drvdata in ata_host_release()
has been removed from the -mm tree.  Its filename was
     libata-clear-drvdata-in-ata_host_release-take2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: clear drvdata in ata_host_release()
From: Tejun Heo <htejun@gmail.com>

Clearing drvdata in ->remove_one causes NULL pointer deference.  Clear
drvdata only in ata_host_release() after all resources are freed.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c   |    3 ++-
 drivers/ata/pata_cs5520.c   |    1 -
 drivers/ata/pata_isapnp.c   |    1 -
 drivers/ata/pata_platform.c |    1 -
 4 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-clear-drvdata-in-ata_host_release-take2 drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-clear-drvdata-in-ata_host_release-take2
+++ a/drivers/ata/libata-core.c
@@ -5731,6 +5731,8 @@ static void ata_host_release(struct devi
 
 	if (host->ops->host_stop)
 		host->ops->host_stop(host);
+
+	dev_set_drvdata(gendev, NULL);
 }
 
 /**
@@ -5953,7 +5955,6 @@ int ata_device_add(const struct ata_prob
 
  err_out:
 	devres_release_group(dev, ata_device_add);
-	dev_set_drvdata(dev, NULL);
 	VPRINTK("EXIT, returning %d\n", rc);
 	return 0;
 }
diff -puN drivers/ata/pata_cs5520.c~libata-clear-drvdata-in-ata_host_release-take2 drivers/ata/pata_cs5520.c
--- a/drivers/ata/pata_cs5520.c~libata-clear-drvdata-in-ata_host_release-take2
+++ a/drivers/ata/pata_cs5520.c
@@ -306,7 +306,6 @@ static void __devexit cs5520_remove_one(
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 /**
diff -puN drivers/ata/pata_isapnp.c~libata-clear-drvdata-in-ata_host_release-take2 drivers/ata/pata_isapnp.c
--- a/drivers/ata/pata_isapnp.c~libata-clear-drvdata-in-ata_host_release-take2
+++ a/drivers/ata/pata_isapnp.c
@@ -128,7 +128,6 @@ static void isapnp_remove_one(struct pnp
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 static struct pnp_device_id isapnp_devices[] = {
diff -puN drivers/ata/pata_platform.c~libata-clear-drvdata-in-ata_host_release-take2 drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~libata-clear-drvdata-in-ata_host_release-take2
+++ a/drivers/ata/pata_platform.c
@@ -228,7 +228,6 @@ static int __devexit pata_platform_remov
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
expose-set_mode-method-so-it-can-be-wrapped.patch
acpi-driver-support-for-pata.patch
introduce-config_has_dma.patch
