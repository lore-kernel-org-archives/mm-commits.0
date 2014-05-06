From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch added to -mm tree
Date: Tue, 06 May 2014 14:04:56 -0700
Message-ID: <53694e78.7MAFvZ2Uy72TmYP2%akpm__37871.2281970822$1399410423$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaEFVFB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:05:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, a.zummo@towertech.it, heiko@sntech.de

Subject: + drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch added to -mm tree
To: heiko@sntech.de,a.zummo@towertech.it,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:04:56 -0700


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: set uie_unsupported
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-hym8563c-set-uie_unsupported.patch
linux-next.patch

