From: akpm@linux-foundation.org
Subject: + correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc.patch added to -mm tree
Date: Thu, 04 Oct 2007 16:25:54 -0700
Message-ID: <200710042325.l94NPsQg001234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbXJDX1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 19:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, Larry.Finger@lwfinger.net, linville@tuxdriver.com


The patch titled
     Correct printk with PFX before KERN_ in drivers/net/wireless/bcm43xx/bcm43xx_wx.c
has been added to the -mm tree.  Its filename is
     correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-hid.patch
git-net.patch
correct-printk-with-pfx-before-kern_-in-drivers-net-wireless-bcm43xx-bcm43xx_wxc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
