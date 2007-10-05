From: akpm@linux-foundation.org
Subject: - correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:58:28 -0700
Message-ID: <200710051958.l95JwS0u022548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763597AbXJEUC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 16:02:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, Larry.Finger@lwfinger.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Correct printk with PFX before KERN_ in drivers/net/wireless/bcm43xx/bcm43xx_wx.c
has been removed from the -mm tree.  Its filename was
     correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Correct printk with PFX before KERN_ in drivers/net/wireless/bcm43xx/bcm43xx_wx.c
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/wireless/bcm43xx/bcm43xx_wx.c~correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc drivers/net/wireless/bcm43xx/bcm43xx_wx.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c~correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -444,7 +444,7 @@ static int bcm43xx_wx_set_xmitpower(stru
 	u16 maxpower;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM) {
-		printk(PFX KERN_ERR "TX power not in dBm.\n");
+		printk(KERN_ERR PFX "TX power not in dBm.\n");
 		return -EOPNOTSUPP;
 	}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
git-hid.patch
git-net.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
