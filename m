From: akpm@linux-foundation.org
Subject: - oss-trident-fix-locking-around-write_voice_regs.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:05 -0700
Message-ID: <200707172306.l6HN65MA011982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933128AbXGQXPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, bunk@stusta.de, tammy000@gmail.com, mm-commits@vger.kernel.org


The patch titled
     OSS trident: fix locking around write_voice_regs
has been removed from the -mm tree.  Its filename was
     oss-trident-fix-locking-around-write_voice_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OSS trident: fix locking around write_voice_regs
From: Muli Ben-Yehuda <muli@il.ibm.com>

trident_write_voice_regs() was getting called with the card spinlock held in
only some cases.  Fix it.

Explanation: we allocate a new virtual channel in open, and then we frob some
hardware registers (in write_voice_regs) for that channel.  But the hardware
registers are shared with other channels, which may be trying to frob the some
registers (albeit for another channel) via ioctl(SNDCTL_DSP_SPEED).

Fixed bugzilla.kernel.org bug #8172 (http://bugme.osdl.org/show_bug.cgi?id=8172)

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: <tammy000@gmail.com>
Cc: <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN sound/oss/trident.c~oss-trident-fix-locking-around-write_voice_regs sound/oss/trident.c
--- a/sound/oss/trident.c~oss-trident-fix-locking-around-write_voice_regs
+++ a/sound/oss/trident.c
@@ -2702,6 +2702,7 @@ trident_open(struct inode *inode, struct
 	struct trident_card *card = devs;
 	struct trident_state *state = NULL;
 	struct dmabuf *dmabuf = NULL;
+	unsigned long flags;
 
 	/* Added by Matt Wu 01-05-2001 */
 	/* TODO: there's some redundacy here wrt the check below */
@@ -2779,7 +2780,9 @@ trident_open(struct inode *inode, struct
 			/* set default channel attribute to normal playback */
 			dmabuf->channel->attribute = CHANNEL_PB;
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_dac_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -2797,7 +2800,9 @@ trident_open(struct inode *inode, struct
 			dmabuf->channel->attribute = (CHANNEL_REC | PCM_LR |
 						      MONO_MIX);
 		}
+		spin_lock_irqsave(&card->lock, flags);
 		trident_set_adc_rate(state, 8000);
+		spin_unlock_irqrestore(&card->lock, flags);
 
 		/* Added by Matt Wu 01-05-2001 */
 		if (card->pci_id == PCI_DEVICE_ID_ALI_5451)
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
x86-64-calgary-tighten-up-the-bitmap-locking.patch
x86-64-calgary-fold-in-redundant-functions.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
