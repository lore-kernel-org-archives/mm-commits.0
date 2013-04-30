From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:59 -0700
Message-ID: <20130430185659.64FFD5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:57658 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3D3S5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:00 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so77409ves.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-fm3130: use dev_dbg() instead of pr_debug()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-fm3130: use dev_dbg() instead of pr_debug()

dev_dbg() is preferred to pr_debug().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-rtc-fm3130-use-dev_dbg-instead-of-pr_debug
+++ a/drivers/rtc/rtc-fm3130.c
@@ -395,7 +395,7 @@ static int fm3130_probe(struct i2c_clien
 
 	tmp = i2c_transfer(adapter, fm3130->msg, 4);
 	if (tmp != 4) {
-		pr_debug("read error %d\n", tmp);
+		dev_dbg(&client->dev, "read error %d\n", tmp);
 		err = -EIO;
 		goto exit_free;
 	}
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

