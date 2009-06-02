From: akpm@linux-foundation.org
Subject: [merged] uwb-event_size-should-be-signed.patch removed from -mm tree
Date: Tue, 02 Jun 2009 12:17:50 -0700
Message-ID: <200906021917.n52JHo3J012827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZFBTSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 15:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, david.vrabel@csr.com, inaky.perez-gonzalez@intel.com, mm-commits@vger.kernel.org


The patch titled
     uwb: event_size should be signed
has been removed from the -mm tree.  Its filename was
     uwb-event_size-should-be-signed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uwb: event_size should be signed
From: Roel Kluin <roel.kluin@gmail.com>

event_size should be ssize_t to notice when hwarc_get_event_size() returns
-ENOSPC.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uwb/hwa-rc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/uwb/hwa-rc.c~uwb-event_size-should-be-signed drivers/uwb/hwa-rc.c
--- a/drivers/uwb/hwa-rc.c~uwb-event_size-should-be-signed
+++ a/drivers/uwb/hwa-rc.c
@@ -501,7 +501,7 @@ int hwarc_filter_event_WUSB_0100(struct 
 	int result = -ENOANO;
 	struct uwb_rceb *rceb = *header;
 	int event = le16_to_cpu(rceb->wEvent);
-	size_t event_size;
+	ssize_t event_size;
 	size_t core_size, offset;
 
 	if (rceb->bEventType != UWB_RC_CET_GENERAL)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
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

