From: akpm@linux-foundation.org
Subject: + ar9170-fix-bug-in-iq-auto-calibration-value-calculation.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:13:43 -0700
Message-ID: <200909291913.n8TJDhB0030689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbZI2TO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chunkeey@googlemail.com, akpm@linux-foundation.org, davem@davemloft.net, jal2@gmx.de, linville@tuxdriver.com


The patch titled
     ar9170: fix bug in iq-auto calibration value calculation
has been added to the -mm tree.  Its filename is
     ar9170-fix-bug-in-iq-auto-calibration-value-calculation.patch

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
Subject: ar9170: fix bug in iq-auto calibration value calculation
From: Christian Lamparter <chunkeey@googlemail.com>

This patch fixes a embarrassing bug which was introduced by: "[PATCH]
ar9170: implement frequency calibration for one-stage/openfw"

The phy_data variable initialization has to done outside the for-loop
scope.  This is because the for-loop uses u32 phy_data variable more like
a 4-byte field.  But in each run only a single byte is calculated. 
Therefore phy_data content needs to stay the same for at least 3 more
iterations, before the complete set can be uploaded.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Cc: Joerg Albert <jal2@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath/ar9170/phy.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/wireless/ath/ar9170/phy.c~ar9170-fix-bug-in-iq-auto-calibration-value-calculation drivers/net/wireless/ath/ar9170/phy.c
--- a/drivers/net/wireless/ath/ar9170/phy.c~ar9170-fix-bug-in-iq-auto-calibration-value-calculation
+++ a/drivers/net/wireless/ath/ar9170/phy.c
@@ -1141,7 +1141,8 @@ static int ar9170_set_freq_cal_data(stru
 	u8 vpds[2][AR5416_PD_GAIN_ICEPTS];
 	u8 pwrs[2][AR5416_PD_GAIN_ICEPTS];
 	int chain, idx, i;
-	u8 f;
+	u32 phy_data = 0;
+	u8 f, tmp;
 
 	switch (channel->band) {
 	case IEEE80211_BAND_2GHZ:
@@ -1208,9 +1209,6 @@ static int ar9170_set_freq_cal_data(stru
 		}
 
 		for (i = 0; i < 76; i++) {
-			u32 phy_data;
-			u8 tmp;
