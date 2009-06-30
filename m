From: akpm@linux-foundation.org
Subject: + stlc45xx-convert-config_interface-to-bss_info_changed.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:41:46 -0700
Message-ID: <200906301941.n5UJfkEe002638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133AbZF3TnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, greg@kroah.com, johannes@sipsolutions.net, kalle.valo@nokia.com


The patch titled
     stlc45xx: convert config_interface to bss_info_changed
has been added to the -mm tree.  Its filename is
     stlc45xx-convert-config_interface-to-bss_info_changed.patch

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
Subject: stlc45xx: convert config_interface to bss_info_changed
From: Alexander Beregalov <a.beregalov@gmail.com>

See commit 2d0ddec5b2b (mac80211: unify config_interface and
bss_info_changed)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/stlc45xx/stlc45xx.c |   27 +++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff -puN drivers/staging/stlc45xx/stlc45xx.c~stlc45xx-convert-config_interface-to-bss_info_changed drivers/staging/stlc45xx/stlc45xx.c
--- a/drivers/staging/stlc45xx/stlc45xx.c~stlc45xx-convert-config_interface-to-bss_info_changed
+++ a/drivers/staging/stlc45xx/stlc45xx.c
@@ -2235,24 +2235,6 @@ static void stlc45xx_op_remove_interface
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 }
 
-static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct ieee80211_if_conf *conf)
-{
-	struct stlc45xx *stlc = hw->priv;
-
-	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
-
-	mutex_lock(&stlc->mutex);
-
-	memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
-	stlc45xx_tx_setup(stlc);
-
-	mutex_unlock(&stlc->mutex);
-
-	return 0;
-}
-
 static int stlc45xx_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct stlc45xx *stlc = hw->priv;
@@ -2295,6 +2277,14 @@ static void stlc45xx_op_bss_info_changed
 {
 	struct stlc45xx *stlc = hw->priv;
 
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+	mutex_lock(&stlc->mutex);
+
+	memcpy(stlc->bssid, info->bssid, ETH_ALEN);
+	stlc45xx_tx_setup(stlc);
+
+	mutex_unlock(&stlc->mutex);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		stlc->associated = info->assoc;
 		if (info->assoc)
@@ -2357,7 +2347,6 @@ static const struct ieee80211_ops stlc45
 	.add_interface = stlc45xx_op_add_interface,
 	.remove_interface = stlc45xx_op_remove_interface,
 	.config = stlc45xx_op_config,
-	.config_interface = stlc45xx_op_config_interface,
 	.configure_filter = stlc45xx_op_configure_filter,
 	.tx = stlc45xx_op_tx,
 	.bss_info_changed = stlc45xx_op_bss_info_changed,
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch
comedi-jr3_pcic-add-required-includes.patch
vt6655-fix-build-when-config_wireless_ext.patch
vt6655-remove-dependency-on-wireless_ext-version.patch
stlc45xx-convert-config_interface-to-bss_info_changed.patch

