From: akpm@linux-foundation.org
Subject: [merged] wireless-remove-redundant-tests-on-unsigned.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:17 -0700
Message-ID: <200907142033.n6EKXHVN013243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756437AbZGNUde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, linville@tuxdriver.com, proski@gnu.org, mm-commits@vger.kernel.org


The patch titled
     wireless: remove redundant tests on unsigned
has been removed from the -mm tree.  Its filename was
     wireless-remove-redundant-tests-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless: remove redundant tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

bufsize and remainder are unsigned.  When negative they are wrapped and
caught by the other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Pavel Roskin <proski@gnu.org>		[hermes.c]
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/orinoco/hermes.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/orinoco/hermes.c~wireless-remove-redundant-tests-on-unsigned drivers/net/wireless/orinoco/hermes.c
--- a/drivers/net/wireless/orinoco/hermes.c~wireless-remove-redundant-tests-on-unsigned
+++ a/drivers/net/wireless/orinoco/hermes.c
@@ -469,7 +469,7 @@ int hermes_read_ltv(hermes_t *hw, int ba
 	u16 rlength, rtype;
 	unsigned nwords;
 
-	if ((bufsize < 0) || (bufsize % 2))
+	if (bufsize % 2)
 		return -EINVAL;
 
 	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
diff -puN drivers/net/wireless/rtl818x/rtl8180_dev.c~wireless-remove-redundant-tests-on-unsigned drivers/net/wireless/rtl818x/rtl8180_dev.c
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c~wireless-remove-redundant-tests-on-unsigned
+++ a/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -280,7 +280,7 @@ static int rtl8180_tx(struct ieee80211_h
 				(ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
 		remainder = (16 * (skb->len + 4)) %
 			    ((ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
-		if (remainder > 0 && remainder <= 6)
+		if (remainder <= 6)
 			plcp_len |= 1 << 15;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

