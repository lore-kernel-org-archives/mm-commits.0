From: akpm@linux-foundation.org
Subject: - hptiop-fix-type-mismatch-warning.patch removed from -mm tree
Date: Mon, 10 Dec 2007 16:28:45 -0800
Message-ID: <200712110028.lBB0Sk02026742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbXLKA3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 19:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, linux@highpoint-tech.com, mm-commits@vger.kernel.org


The patch titled
     hptiop: fix type mismatch warning
has been removed from the -mm tree.  Its filename was
     hptiop-fix-type-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hptiop: fix type mismatch warning
From: Jeff Garzik <jeff@garzik.org>

drivers/scsi/hptiop.c: In function 'hptiop_host_request_callback':
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast

Use min_t(size_t, ...) to fix.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning
+++ a/drivers/scsi/hptiop.c
@@ -376,7 +376,7 @@ static void hptiop_host_request_callback
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
 		memcpy(&scp->sense_buffer, &req->sg_list,
-				min(sizeof(scp->sense_buffer),
+				min_t(size_t, sizeof(scp->sense_buffer),
 					le32_to_cpu(req->dataxfer_length)));
 		break;
 
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-arm.patch
powerpc-fix-typo-ifdef-ifndef.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
ata-ahci-enclosure-management-via-led.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
e100-free-irq-to-remove-warning-when-rebooting.patch
net-smc911x-shut-up-compiler-warnings.patch
bnx2x-depends-on-zlib_inflate.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-wireless.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
fix-versus-precedence-in-various-places.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
