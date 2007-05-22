From: akpm@linux-foundation.org
Subject: - libata-kiss-post_set_mode-goodbye.patch removed from -mm tree
Date: Mon, 21 May 2007 22:56:47 -0700
Message-ID: <200705220556.l4M5ukqu028410@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51421 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756383AbXEVF7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 01:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: Kiss post_set_mode goodbye
has been removed from the -mm tree.  Its filename was
     libata-kiss-post_set_mode-goodbye.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: Kiss post_set_mode goodbye
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

As of the -mm tree we don't have post_set_mode users any more.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-core.c |    3 ---
 include/linux/libata.h    |    2 --
 2 files changed, 5 deletions(-)

diff -puN drivers/ata/libata-core.c~libata-kiss-post_set_mode-goodbye drivers/ata/libata-core.c
--- a/drivers/ata/libata-core.c~libata-kiss-post_set_mode-goodbye
+++ a/drivers/ata/libata-core.c
@@ -2945,9 +2945,6 @@ int ata_do_set_mode(struct ata_port *ap,
 	if (used_dma && (ap->host->flags & ATA_HOST_SIMPLEX))
 		ap->host->simplex_claimed = ap;
 
-	/* step5: chip specific finalisation */
-	if (ap->ops->post_set_mode)
-		ap->ops->post_set_mode(ap);
  out:
 	if (rc)
 		*r_failed_dev = dev;
diff -puN include/linux/libata.h~libata-kiss-post_set_mode-goodbye include/linux/libata.h
--- a/include/linux/libata.h~libata-kiss-post_set_mode-goodbye
+++ a/include/linux/libata.h
@@ -582,8 +582,6 @@ struct ata_port_operations {
 	void (*phy_reset) (struct ata_port *ap); /* obsolete */
 	int  (*set_mode) (struct ata_port *ap, struct ata_device **r_failed_dev);
 
-	void (*post_set_mode) (struct ata_port *ap);
-
 	int (*cable_detect) (struct ata_port *ap);
 
 	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
libata-add-support-for-ata_16-on-atapi.patch
fix-build-failure-for-drivers-ata-pata_sccc.patch
hpt3x2n-correct-revision-boundary.patch
pata_sis-fix-and-clean-up-some-timing-setups.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
ide-add-seagate-stt20000a-to-dma-blacklist.patch
serial-use-resource_size_t-for-port-io-addresses.patch
add-pci_try_set_mwi.patch
fix-pci_find_present.patch
pci_find_slot-mark-deprecated.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
watchdog-documentation.patch
add-pci_try_set_mwi-prism54pci.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
update-zilog-timeout.patch
edd-switch-to-pci_get-based-api.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
