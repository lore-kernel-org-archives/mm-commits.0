From: akpm@linux-foundation.org
Subject: + atl1c-wake_mcast-tested-twice-not-wake_ucast.patch added to -mm tree
Date: Thu, 28 May 2009 00:00:01 -0700
Message-ID: <200905280700.n4S701xM026314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbZE1HAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, csnook@redhat.com, jcliburn@gmail.com, jie.yang@atheros.com


The patch titled
     atl1c: WAKE_MCAST tested twice, not WAKE_UCAST
has been added to the -mm tree.  Its filename is
     atl1c-wake_mcast-tested-twice-not-wake_ucast.patch

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
Subject: atl1c: WAKE_MCAST tested twice, not WAKE_UCAST
From: Roel Kluin <roel.kluin@gmail.com>

The WAKE_MCAST bit is tested twice, the first should be WAKE_UCAST.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jie Yang <jie.yang@atheros.com>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <csnook@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1c/atl1c_ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/atl1c/atl1c_ethtool.c~atl1c-wake_mcast-tested-twice-not-wake_ucast drivers/net/atl1c/atl1c_ethtool.c
--- a/drivers/net/atl1c/atl1c_ethtool.c~atl1c-wake_mcast-tested-twice-not-wake_ucast
+++ a/drivers/net/atl1c/atl1c_ethtool.c
@@ -271,7 +271,7 @@ static int atl1c_set_wol(struct net_devi
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 
 	if (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE |
-			    WAKE_MCAST | WAKE_BCAST | WAKE_MCAST))
+			    WAKE_UCAST | WAKE_BCAST | WAKE_MCAST))
 		return -EOPNOTSUPP;
 	/* these settings will always override what we currently have */
 	adapter->wol = 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
linux-next.patch
soc-correct-print-specifiers-for-unsigneds.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
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

