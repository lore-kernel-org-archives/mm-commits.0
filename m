From: akpm@linux-foundation.org
Subject: + drivers-isdn-eliminate-duplicated-test.patch added to -mm tree
Date: Thu, 10 Dec 2009 15:20:40 -0800
Message-ID: <200912102320.nBANKe9J023218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbZLJXUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 18:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, isdn@linux-pingi.de


The patch titled
     drivers/isdn: eliminate duplicated test
has been added to the -mm tree.  Its filename is
     drivers-isdn-eliminate-duplicated-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-media-video-move-dereference-after-null-test.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-cpuidle-move-dereference-after-null-test.patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-function.patch
drivers-mmc-move-dereference-after-null-test.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-edac-introduce-missing-kfree.patch

