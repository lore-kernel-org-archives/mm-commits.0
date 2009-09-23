From: akpm@linux-foundation.org
Subject: [merged] stmp3xxx-deallocation-with-negative-index-of-descriptors.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:59 -0700
Message-ID: <200909232003.n8NK3xj3020355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbZIWUKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dpervushin@embeddedalley.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     STMP3xxx: deallocation with negative index of descriptors[]
has been removed from the -mm tree.  Its filename was
     stmp3xxx-deallocation-with-negative-index-of-descriptors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: STMP3xxx: deallocation with negative index of descriptors[]
From: Roel Kluin <roel.kluin@gmail.com>

The last deallocation is invalid. In the last iteration, i is -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: dmitry pervushin <dpervushin@embeddedalley.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-stmp3xxx/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/plat-stmp3xxx/dma.c~stmp3xxx-deallocation-with-negative-index-of-descriptors arch/arm/plat-stmp3xxx/dma.c
--- a/arch/arm/plat-stmp3xxx/dma.c~stmp3xxx-deallocation-with-negative-index-of-descriptors
+++ a/arch/arm/plat-stmp3xxx/dma.c
@@ -264,7 +264,7 @@ int stmp3xxx_dma_make_chain(int ch, stru
 					stmp3xxx_dma_free_command(ch,
 								  &descriptors
 								  [i]);
-				} while (i-- >= 0);
+				} while (i-- > 0);
 			}
 			return err;
 		}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

