From: akpm@linux-foundation.org
Subject: + drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:15:31 -0700
Message-ID: <200710152315.l9FNFVAN030299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40842 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089AbXJOXRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, Larry.Finger@lwfinger.net, bunk@kernel.org, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     drivers/net/wireless/b43/main.c: fix an uninitialized variable
has been added to the -mm tree.  Its filename is
     drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/net/wireless/b43/main.c: fix an uninitialized variable
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix an uninitialized variable in drivers/net/wireless/b43/main.c::b43_start().

Cc: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/b43/main.c~drivers-net-wireless-b43-mainc-fix-an-uninitialized drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~drivers-net-wireless-b43-mainc-fix-an-uninitialized
+++ a/drivers/net/wireless/b43/main.c
@@ -3495,7 +3495,7 @@ static int b43_start(struct ieee80211_hw
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
documentation-spi-spidev_testc-constify-some-variables.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
