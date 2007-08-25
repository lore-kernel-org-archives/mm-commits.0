From: akpm@linux-foundation.org
Subject: - drivers-scsi-ipsc-fix-scsi_add_host-warning.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:23:37 -0700
Message-ID: <200708250323.l7P3NbM7027953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292AbXHYDXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/ips.c: fix scsi_add_host warning
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ipsc-fix-scsi_add_host-warning.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: drivers/scsi/ips.c: fix scsi_add_host warning
From: Eugene Teo <eugeneteo@kernel.sg>

drivers/scsi/ips.c: In function 'ips_register_scsi':
drivers/scsi/ips.c:6867: warning: ignoring return value of
	'scsi_add_host', declared with attribute warn_unused_result

[akpm@linux-foundation.org: build fix]
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
+	free_irq(ha->irq, ha);
+err_put_sh:
+	scsi_host_put(sh);
+	return rc;
 }
 
 /*---------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

git-alsa.patch
git-netdev-all.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
fix-tsk-exit_state-usage-resend.patch
