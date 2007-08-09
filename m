From: akpm@linux-foundation.org
Subject: + drivers-scsi-ipsc-fix-scsi_add_host-warning.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:41:19 -0700
Message-ID: <200708091941.l79JfJQI016050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbXHITld (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eugeneteo@kernel.sg


The patch titled
     drivers/scsi/ips.c: fix scsi_add_host warning
has been added to the -mm tree.  Its filename is
     drivers-scsi-ipsc-fix-scsi_add_host-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/scsi/ips.c: fix scsi_add_host warning
From: Eugene Teo <eugeneteo@kernel.sg>

drivers/scsi/ips.c: In function 'ips_register_scsi':
drivers/scsi/ips.c:6867: warning: ignoring return value of
	'scsi_add_host', declared with attribute warn_unused_result

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ips.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ips.c~drivers-scsi-ipsc-fix-scsi_add_host-warning drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~drivers-scsi-ipsc-fix-scsi_add_host-warning
+++ a/drivers/scsi/ips.c
@@ -6824,13 +6824,14 @@ ips_order_controllers(void)
 static int
 ips_register_scsi(int index)
 {
+	int rc = -1;
 	struct Scsi_Host *sh;
 	ips_ha_t *ha, *oldha = ips_ha[index];
 	sh = scsi_host_alloc(&ips_driver_template, sizeof (ips_ha_t));
 	if (!sh) {
 		IPS_PRINTK(KERN_WARNING, oldha->pcidev,
 			   "Unable to register controller with SCSI subsystem\n");
-		return -1;
+		return rc;
 	}
 	ha = IPS_HA(sh);
 	memcpy(ha, oldha, sizeof (ips_ha_t));
@@ -6839,8 +6840,7 @@ ips_register_scsi(int index)
 	if (request_irq(ha->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_put_sh;
 	}
 
 	kfree(oldha);
@@ -6864,10 +6864,18 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	rc = scsi_add_host(sh, NULL);
+	if (rc)
+		goto err_free_irq;
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_free_irq:
+	free_irq(ha->irq);
+err_put_sh:
+	scsi_host_put(sh);
+	return rc;
 }
 
 /*---------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

git-acpi.patch
git-alsa.patch
git-netdev-all.patch
drivers-scsi-ipsc-fix-scsi_add_host-warning.patch
fs-partitions-checkc-add-add_partition-error-handling.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
