From: akpm@linux-foundation.org
Subject: [merged] drivers-isdn-eliminate-duplicated-test.patch removed from -mm tree
Date: Tue, 05 Jan 2010 13:12:44 -0800
Message-ID: <201001052112.o05LCiHn019887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979Ab0AEVMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 16:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn: eliminate duplicated test
has been removed from the -mm tree.  Its filename was
     drivers-isdn-eliminate-duplicated-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn: eliminate duplicated test
From: Julia Lawall <julia@diku.dk>

The code checked slot_rx twice.  Check slot_tx by analogy with the bank
case.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E;
@@

(
*E && E
|
*E || E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/mISDN/hfcmulti.c~drivers-isdn-eliminate-duplicated-test drivers/isdn/hardware/mISDN/hfcmulti.c
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c~drivers-isdn-eliminate-duplicated-test
+++ a/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3152,7 +3152,7 @@ static void
 hfcmulti_pcm(struct hfc_multi *hc, int ch, int slot_tx, int bank_tx,
     int slot_rx, int bank_rx)
 {
-	if (slot_rx < 0 || slot_rx < 0 || bank_tx < 0 || bank_rx < 0) {
+	if (slot_tx < 0 || slot_rx < 0 || bank_tx < 0 || bank_rx < 0) {
 		/* disable PCM */
 		mode_hfcmulti(hc, ch, hc->chan[ch].protocol, -1, 0, -1, 0);
 		return;
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-sesc-eliminate-double-free.patch
kernel-credc-use-kmem_cache_free.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-gpu-drm-nouveau-nouveau_grctxc-correct-null-test.patch
drivers-media-video-move-dereference-after-null-test.patch
arch-mips-alchemy-correct-code-taking-the-size-of-a-pointer.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-staging-tm6000-tm6000-videoc-correct-null-test.patch
drivers-edac-introduce-missing-kfree.patch

