From: akpm@linux-foundation.org
Subject: [merged] fsldma-fix-check-on-potential-fdev-chan-overflow.patch removed from -mm tree
Date: Thu, 28 May 2009 12:26:57 -0700
Message-ID: <200905281926.n4SJQvnS002663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677AbZE1T1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 15:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dan.j.williams@intel.com, leoli@freescale.com, mm-commits@vger.kernel.org


The patch titled
     fsldma: fix check on potential fdev->chan[] overflow
has been removed from the -mm tree.  Its filename was
     fsldma-fix-check-on-potential-fdev-chan-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsldma: fix check on potential fdev->chan[] overflow
From: Roel Kluin <roel.kluin@gmail.com>

Fix the check of potential array overflow when using corrupted channel
device tree nodes.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Li Yang <leoli@freescale.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/fsldma.c~fsldma-fix-check-on-potential-fdev-chan-overflow drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~fsldma-fix-check-on-potential-fdev-chan-overflow
+++ a/drivers/dma/fsldma.c
@@ -831,7 +831,7 @@ static int __devinit fsl_dma_chan_probe(
 			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
 
 	new_fsl_chan->id = ((new_fsl_chan->reg.start - 0x100) & 0xfff) >> 7;
-	if (new_fsl_chan->id > FSL_DMA_MAX_CHANS_PER_DEVICE) {
+	if (new_fsl_chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "There is no %d channel!\n",
 				new_fsl_chan->id);
 		err = -EINVAL;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
wmm_paramac_aci_acm_aifsn-tested-twice.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

