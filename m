From: akpm@linux-foundation.org
Subject: [merged] vt6655-fix-read-buffer-overflow.patch removed from -mm tree
Date: Tue, 18 Aug 2009 13:18:29 -0700
Message-ID: <200908182018.n7IKIT8Q021936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbZHRUTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 16:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, forest@alittletooquiet.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     vt6655: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     vt6655-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt6655: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

If pDevice->sOpts.nRxDescs{0,1} or nTxDescs[{0,1}] is zero, the loop ends with
i == 0, and we write aRD{0,1}Ring[-1]. apTD{0,1}Rings[-1] respectively.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Forest Bond <forest@alittletooquiet.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/vt6655/device_main.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/staging/vt6655/device_main.c~vt6655-fix-read-buffer-overflow drivers/staging/vt6655/device_main.c
--- a/drivers/staging/vt6655/device_main.c~vt6655-fix-read-buffer-overflow
+++ a/drivers/staging/vt6655/device_main.c
@@ -1449,7 +1449,8 @@ static void device_init_rd0_ring(PSDevic
         pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
     }
 
-    pDevice->aRD0Ring[i-1].next_desc = cpu_to_le32(pDevice->rd0_pool_dma);
+    if (i > 0)
+        pDevice->aRD0Ring[i-1].next_desc = cpu_to_le32(pDevice->rd0_pool_dma);
     pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
 }
 
@@ -1473,7 +1474,8 @@ static void device_init_rd1_ring(PSDevic
         pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
     }
 
-    pDevice->aRD1Ring[i-1].next_desc = cpu_to_le32(pDevice->rd1_pool_dma);
+    if (i > 0)
+        pDevice->aRD1Ring[i-1].next_desc = cpu_to_le32(pDevice->rd1_pool_dma);
     pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
 }
 
@@ -1566,7 +1568,8 @@ static void device_init_td0_ring(PSDevic
         pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
     }
 
-    pDevice->apTD0Rings[i-1].next_desc = cpu_to_le32(pDevice->td0_pool_dma);
+    if (i > 0)
+        pDevice->apTD0Rings[i-1].next_desc = cpu_to_le32(pDevice->td0_pool_dma);
     pDevice->apTailTD[0] = pDevice->apCurrTD[0] =&(pDevice->apTD0Rings[0]);
 
 }
@@ -1591,7 +1594,8 @@ static void device_init_td1_ring(PSDevic
         pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
     }
 
-    pDevice->apTD1Rings[i-1].next_desc = cpu_to_le32(pDevice->td1_pool_dma);
+    if (i > 0)
+        pDevice->apTD1Rings[i-1].next_desc = cpu_to_le32(pDevice->td1_pool_dma);
     pDevice->apTailTD[1] = pDevice->apCurrTD[1] = &(pDevice->apTD1Rings[0]);
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-avoid-calculating-possibly-invalid-address.patch
drm-i915-intel_sdvo_multifunc_encoder-sdvo_output_svid0-tested-twice.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
slram-read-buffer-overflow.patch
mtd-fix-read-buffer-overflow.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch

