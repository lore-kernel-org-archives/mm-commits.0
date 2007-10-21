From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch removed from -mm tree
Date: Sun, 21 Oct 2007 15:07:52 -0700
Message-ID: <200710212207.l9LM7qD5029740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbXJUWJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 18:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, Larry.Finger@lwfinger.net, bunk@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/b43/main.c: fix an uninitialized variable
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
