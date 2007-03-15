From: akpm@linux-foundation.org
Subject: - pata_legacy-restore-cable-methods.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:57:47 -0800
Message-ID: <200703152157.l2FLvl1c027668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42412 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbXCOV57 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_legacy: restore cable methods
has been removed from the -mm tree.  Its filename was
     pata_legacy-restore-cable-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_legacy: restore cable methods
From: Alan Cox <alan@redhat.com>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_legacy.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/ata/pata_legacy.c~pata_legacy-restore-cable-methods drivers/ata/pata_legacy.c
--- a/drivers/ata/pata_legacy.c~pata_legacy-restore-cable-methods
+++ a/drivers/ata/pata_legacy.c
@@ -162,6 +162,7 @@ static struct ata_port_operations simple
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -185,6 +186,7 @@ static struct ata_port_operations legacy
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
+	.cable_detect	= ata_cable_40wire,
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
@@ -305,6 +307,7 @@ static struct ata_port_operations pdc202
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -360,6 +363,7 @@ static struct ata_port_operations ht6560
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -426,6 +430,7 @@ static struct ata_port_operations ht6560
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -547,6 +552,7 @@ static struct ata_port_operations opti82
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
@@ -680,6 +686,7 @@ static struct ata_port_operations opti82
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= opti82c46x_qc_issue_prot,
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
ata_generic-remove-all-the-crud-again-and-use-cable.patch
pata_ali-remove-all-the-crap-again-and-switch-to.patch
pata_amd-remove-all-the-crud-and-restore-the-cable-detect.patch
pata_cs5535-re-remove-all-the-crap-and-switch-to-the-cable.patch
pata_cypress-re-remove-all-the-crap-and-switch-back-to.patch
pata_netcell-re-remove-all-the-crud.patch
pata_qdi-restore-cable-detect.patch
pata_sl82c105-restore-cable-detect-method.patch
pata_winbond-restore-cable-method.patch
libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_optidma-rework-for-cable-detect-and-to-remove.patch
pata_pdc2027x-restore-various-updates-done-on-the-driver.patch
pata_acpi-restore-driver.patch
resend-iphase-64bit-cleanup.patch
pci_module_init-convertion-in-tmscsimc.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
