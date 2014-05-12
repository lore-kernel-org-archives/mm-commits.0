From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch
 removed from -mm tree
Date: Mon, 12 May 2014 12:30:42 -0700
Message-ID: <53712162.iU0tkZjR/lv6LPp2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaELTao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 15:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, a.zummo@towertech.it, heiko@sntech.de

Subject: [merged] drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch removed from -mm tree
To: heiko@sntech.de,a.zummo@towertech.it,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 12:30:42 -0700


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: set uie_unsupported
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: drivers/rtc/rtc-hym8563.c: set uie_unsupported

The alarm of the hym8563 only supports a minute accuracy, while the uie
wants an alarm one second in the future.  Therefore things like the
select() syscall will fail with a timeout, because the next alarm will
happen in a worst case of 60 seconds.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-set-uie_unsupported drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-set-uie_unsupported
+++ a/drivers/rtc/rtc-hym8563.c
@@ -569,6 +569,9 @@ static int hym8563_probe(struct i2c_clie
 	if (IS_ERR(hym8563->rtc))
 		return PTR_ERR(hym8563->rtc);
 
+	/* the hym8563 alarm only supports a minute accuracy */
+	hym8563->rtc->uie_unsupported = 1;
+
 #ifdef CONFIG_COMMON_CLK
 	hym8563_clkout_register_clk(hym8563);
 #endif
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
rtc-rtc-hym8563-make-of_device_id-array-const.patch
linux-next.patch

