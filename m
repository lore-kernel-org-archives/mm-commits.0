From: akpm@linux-foundation.org
Subject: [merged] atl1c-wake_mcast-tested-twice-not-wake_ucast.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:26 -0700
Message-ID: <200906121822.n5CIMQm2031195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462AbZFLSZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, csnook@redhat.com, jcliburn@gmail.com, jie.yang@atheros.com, mm-commits@vger.kernel.org


The patch titled
     atl1c: WAKE_MCAST tested twice, not WAKE_UCAST
has been removed from the -mm tree.  Its filename was
     atl1c-wake_mcast-tested-twice-not-wake_ucast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
serial-fix-off-by-one-errors.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
usb-mutually-exclusive-port_status.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

