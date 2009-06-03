From: akpm@linux-foundation.org
Subject: [merged] otus-80211core-coidc-fix-array-range-check.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:19 -0700
Message-ID: <200906032002.n53K2JMm001665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbZFCUCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, greg@kroah.com, lrodriguez@atheros.com, mm-commits@vger.kernel.org


The patch titled
     otus/80211core/coid.c: fix array range check
has been removed from the -mm tree.  Its filename was
     otus-80211core-coidc-fix-array-range-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: otus/80211core/coid.c: fix array range check
From: Roel Kluin <roel.kluin@gmail.com>

The test for an overindexing of wd->ap.wds.encryMode[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/otus/80211core/coid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/otus/80211core/coid.c~otus-80211core-coidc-fix-array-range-check drivers/staging/otus/80211core/coid.c
--- a/drivers/staging/otus/80211core/coid.c~otus-80211core-coidc-fix-array-range-check
+++ a/drivers/staging/otus/80211core/coid.c
@@ -2013,7 +2013,7 @@ u16_t zfiConfigWdsPort(zdev_t* dev, u8_t
 
     zmw_get_wlan_dev(dev);
 
-    if (wdsPortId > ZM_MAX_WDS_SUPPORT)
+    if (wdsPortId >= ZM_MAX_WDS_SUPPORT)
     {
         return ZM_ERR_WDS_PORT_ID;
     }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
atl1c-wake_mcast-tested-twice-not-wake_ucast.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
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

