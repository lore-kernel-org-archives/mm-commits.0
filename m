From: akpm@linux-foundation.org
Subject: [merged] drm-radeon-avoid-calculating-possibly-invalid-address.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:22 -0700
Message-ID: <200908062031.n76KVMP7004538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756171AbZHFUcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:32:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     drm/radeon: avoid calculating possibly-invalid address
has been removed from the -mm tree.  Its filename was
     drm-radeon-avoid-calculating-possibly-invalid-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm/radeon: avoid calculating possibly-invalid address
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before calculating the address.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/r100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpu/drm/radeon/r100.c~drm-radeon-avoid-calculating-possibly-invalid-address drivers/gpu/drm/radeon/r100.c
--- a/drivers/gpu/drm/radeon/r100.c~drm-radeon-avoid-calculating-possibly-invalid-address
+++ a/drivers/gpu/drm/radeon/r100.c
@@ -722,13 +722,14 @@ int r100_cs_packet_parse(struct radeon_c
 			 unsigned idx)
 {
 	struct radeon_cs_chunk *ib_chunk = &p->chunks[p->chunk_ib_idx];
-	uint32_t header = ib_chunk->kdata[idx];
+	uint32_t header;
 
 	if (idx >= ib_chunk->length_dw) {
 		DRM_ERROR("Can not parse packet at %d after CS end %d !\n",
 			  idx, ib_chunk->length_dw);
 		return -EINVAL;
 	}
+	header = ib_chunk->kdata[idx];
 	pkt->idx = idx;
 	pkt->type = CP_PACKET_GET_TYPE(header);
 	pkt->count = CP_PACKET_GET_COUNT(header);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
x86-fix-buffer-overflow-in-efi_init.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-fsl-booke-read-buffer-overflow.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
media-strncpy-does-not-null-terminate-string.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
hid-fix-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
kvm-fix-read-buffer-overflow.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
slram-read-buffer-overflow-cleanup.patch
mtd-fix-read-buffer-overflow.patch
irda-fix-read-buffer-overflow.patch
hfc_usb-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow-fix.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
usb-gadget-read-buffer-overflow.patch
i915-fix-read-outside-array-bounds.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

