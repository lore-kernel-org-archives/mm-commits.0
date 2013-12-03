From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch
 added to -mm tree
Date: Tue, 03 Dec 2013 12:34:09 -0800
Message-ID: <529e4041.J3cJJq4y7c74s5Zb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3LCUeK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 15:34:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: + drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch added to -mm tree
To: fabio.estevam@freescale.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 12:34:09 -0800


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: check the return value from clk_prepare_enable()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/rtc/rtc-mxc.c: check the return value from clk_prepare_enable()

clk_prepare_enable() may fail, so let's check its return value and
propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable
+++ a/drivers/rtc/rtc-mxc.c
@@ -394,7 +394,10 @@ static int mxc_rtc_probe(struct platform
 		return PTR_ERR(pdata->clk);
 	}
 
-	clk_prepare_enable(pdata->clk);
+	ret = clk_prepare_enable(pdata->clk);
+	if (ret)
+		return ret;
+
 	rate = clk_get_rate(pdata->clk);
 
 	if (rate == 32768)
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
drivers-rtc-rtc-mxcc-remove-unneeded-label.patch
drivers-rtc-rtc-mxcc-check-the-return-value-from-clk_prepare_enable.patch
linux-next.patch

