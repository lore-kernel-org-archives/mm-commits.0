From: akpm@linux-foundation.org
Subject: [merged] wireless-libertas-print-esaped-string-via-%pe.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:54 -0700
Message-ID: <543d69fe.dzhaELrYHpMlkNhp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSWx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: libertas: print esaped string via %*pE
has been removed from the -mm tree.  Its filename was
     wireless-libertas-print-esaped-string-via-%pe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: wireless: libertas: print esaped string via %*pE

Instead of custom approach this allows to print escaped strings via
recently added kernel extension: %*pE.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/libertas/cfg.c  |    8 ++------
 drivers/net/wireless/libertas/mesh.c |    7 +++----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/net/wireless/libertas/cfg.c~wireless-libertas-print-esaped-string-via-%pe drivers/net/wireless/libertas/cfg.c
--- a/drivers/net/wireless/libertas/cfg.c~wireless-libertas-print-esaped-string-via-%pe
+++ a/drivers/net/wireless/libertas/cfg.c
@@ -590,7 +590,6 @@ static int lbs_ret_scan(struct lbs_priva
 		int chan_no = -1;
 		const u8 *ssid = NULL;
 		u8 ssid_len = 0;
-		DECLARE_SSID_BUF(ssid_buf);
 
 		int len = get_unaligned_le16(pos);
 		pos += 2;
@@ -644,10 +643,8 @@ static int lbs_ret_scan(struct lbs_priva
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);
 
-			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %s, "
-				     "%d dBm\n",
-				     bssid, capa, chan_no,
-				     print_ssid(ssid_buf, ssid, ssid_len),
+			lbs_deb_scan("scan: %pM, capa %04x, chan %2d, %*pE, %d dBm\n",
+				     bssid, capa, chan_no, ssid_len, ssid,
 				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 
 			if (channel &&
@@ -1984,7 +1981,6 @@ static int lbs_join_ibss(struct wiphy *w
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = 0;
 	struct cfg80211_bss *bss;
-	DECLARE_SSID_BUF(ssid_buf);
 
 	if (dev == priv->mesh_dev)
 		return -EOPNOTSUPP;
diff -puN drivers/net/wireless/libertas/mesh.c~wireless-libertas-print-esaped-string-via-%pe drivers/net/wireless/libertas/mesh.c
--- a/drivers/net/wireless/libertas/mesh.c~wireless-libertas-print-esaped-string-via-%pe
+++ a/drivers/net/wireless/libertas/mesh.c
@@ -93,7 +93,6 @@ static int lbs_mesh_config(struct lbs_pr
 {
 	struct cmd_ds_mesh_config cmd;
 	struct mrvl_meshie *ie;
-	DECLARE_SSID_BUF(ssid);
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.channel = cpu_to_le16(chan);
@@ -122,9 +121,9 @@ static int lbs_mesh_config(struct lbs_pr
 	default:
 		return -1;
 	}
-	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %s\n",
-		    action, priv->mesh_tlv, chan,
-		    print_ssid(ssid, priv->mesh_ssid, priv->mesh_ssid_len));
+	lbs_deb_cmd("mesh config action %d type %x channel %d SSID %*pE\n",
+		    action, priv->mesh_tlv, chan, priv->mesh_ssid_len,
+		    priv->mesh_ssid);
 
 	return __lbs_mesh_config_send(priv, &cmd, action, priv->mesh_tlv);
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

