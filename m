From: akpm@linux-foundation.org
Subject: [merged] omap-confusion-in-iommu_put.patch removed from -mm tree
Date: Wed, 06 Jan 2010 13:33:40 -0800
Message-ID: <201001062133.o06LXe9g019137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932854Ab0AFVd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 16:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rmk@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap: &&/|| confusion in iommu_put()
has been removed from the -mm tree.  Its filename was
     omap-confusion-in-iommu_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap: &&/|| confusion in iommu_put()
From: Roel Kluin <roel.kluin@gmail.com>

obj can't be both NULL and be an error pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-omap/iommu.c~omap-confusion-in-iommu_put arch/arm/plat-omap/iommu.c
--- a/arch/arm/plat-omap/iommu.c~omap-confusion-in-iommu_put
+++ a/arch/arm/plat-omap/iommu.c
@@ -827,7 +827,7 @@ EXPORT_SYMBOL_GPL(iommu_get);
  **/
 void iommu_put(struct iommu *obj)
 {
-	if (!obj && IS_ERR(obj))
+	if (!obj || IS_ERR(obj))
 		return;
 
 	mutex_lock(&obj->iommu_lock);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

zlib-optimize-inffast-when-copying-direct-from-output.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

