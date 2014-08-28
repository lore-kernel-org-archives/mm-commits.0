From: akpm@linux-foundation.org
Subject: + wireless-libertas-print-esaped-string-via-%pe.patch added to
 -mm tree
Date: Thu, 28 Aug 2014 14:09:11 -0700
Message-ID: <53ff9a77.byYVjtTNZuDKX4+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:59798 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaH2NaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 09:30:23 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so184073pde.3
        for <mm-commits@vger.kernel.org>; Fri, 29 Aug 2014 06:30:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: libertas: print esaped string via %*pE
has been added to the -mm tree.  Its filename is
     wireless-libertas-print-esaped-string-via-%pe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wireless-libertas-print-esaped-string-via-%pe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wireless-libertas-print-esaped-string-via-%pe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1982,7 +1979,6 @@ static int lbs_join_ibss(struct wiphy *w
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

lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch
linux-next.patch

