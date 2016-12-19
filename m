From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:26:02 -0800
Message-ID: <58585e7a.doJgGznW6sfJyH4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcLSWZC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "swithc" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "swithc" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  swithc||switch
  swithced||switched
  swithcing||switching

Link: http://lkml.kernel.org/r/1481573103-11329-3-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/extcon/extcon-rt8973a.c                        |    2 +-
 drivers/media/i2c/adv7183_regs.h                       |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h         |    4 ++--
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 scripts/spelling.txt                                   |    3 +++
 5 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/extcon/extcon-rt8973a.c~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances drivers/extcon/extcon-rt8973a.c
--- a/drivers/extcon/extcon-rt8973a.c~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances
+++ a/drivers/extcon/extcon-rt8973a.c
@@ -537,7 +537,7 @@ static void rt8973a_init_dev_type(struct
 		regmap_update_bits(info->regmap, reg, mask, val);
 	}
 
-	/* Check whether RT8973A is auto swithcing mode or not */
+	/* Check whether RT8973A is auto switching mode or not */
 	ret = regmap_read(info->regmap, RT8973A_REG_CONTROL1, &data);
 	if (ret) {
 		dev_err(info->dev,
diff -puN drivers/media/i2c/adv7183_regs.h~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances drivers/media/i2c/adv7183_regs.h
--- a/drivers/media/i2c/adv7183_regs.h~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances
+++ a/drivers/media/i2c/adv7183_regs.h
@@ -87,7 +87,7 @@
 #define ADV7183_LETTERBOX_3        0x9D /* Letterbox 3 */
 #define ADV7183_CRC_EN             0xB2 /* CRC enable */
 #define ADV7183_ADC_SWITCH_1       0xC3 /* ADC switch 1 */
-#define ADV7183_ADC_SWITCH_2       0xC4 /* ADC swithc 2 */
+#define ADV7183_ADC_SWITCH_2       0xC4 /* ADC switch 2 */
 #define ADV7183_LETTERBOX_CTRL_1   0xDC /* Letterbox control 1 */
 #define ADV7183_LETTERBOX_CTRL_2   0xDD /* Letterbox control 2 */
 #define ADV7183_SD_OFFSET_CB       0xE1 /* SD offset Cb */
diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211.h~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances drivers/staging/rtl8192u/ieee80211/ieee80211.h
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -1943,7 +1943,7 @@ struct ieee80211_device {
 
 	/* ask to the driver to retune the radio .
 	 * This function can sleep. the driver should ensure
-	 * the radio has been swithced before return.
+	 * the radio has been switched before return.
 	 */
 	void (*set_chan)(struct net_device *dev, short ch);
 
@@ -1954,7 +1954,7 @@ struct ieee80211_device {
 	 * The syncro version is similar to the start_scan but
 	 * does not return until all channels has been scanned.
 	 * this is called in user context and should sleep,
-	 * it is called in a work_queue when swithcing to ad-hoc mode
+	 * it is called in a work_queue when switching to ad-hoc mode
 	 * or in behalf of iwlist scan when the card is associated
 	 * and root user ask for a scan.
 	 * the function stop_scan should stop both the syncro and
diff -puN drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances
+++ a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2359,7 +2359,7 @@ static void ieee80211_start_ibss_wq(stru
 //	if((IS_DOT11D_ENABLE(ieee)) && (ieee->state == IEEE80211_NOLINK))
 	if (ieee->state == IEEE80211_NOLINK)
 		ieee->current_network.channel = 6;
-	/* if not then the state is not linked. Maybe the user swithced to
+	/* if not then the state is not linked. Maybe the user switched to
 	 * ad-hoc mode just after being in monitor mode, or just after
 	 * being very few time in managed mode (so the card have had no
 	 * time to scan all the chans..) or we have just run up the iface
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -993,6 +993,9 @@ swaping||swapping
 switchs||switches
 swith||switch
 swithable||switchable
+swithc||switch
+swithced||switched
+swithcing||switching
 swithed||switched
 swithing||switching
 symetric||symmetric
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

