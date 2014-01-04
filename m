From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch added to
 -mm tree
Date: Fri, 03 Jan 2014 16:02:45 -0800
Message-ID: <52c74fa5.SBlmy1nU5wLMwhN7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaADACq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 19:02:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch added to -mm tree
To: sachin.kamat@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 16:02:45 -0800


The patch titled
     Subject: drivers/rtc/rtc-hym8563.c: staticize local symbol
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-hym8563.c: staticize local symbol

'hym8563_clkout_ops' is used only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-staticize-local-symbol drivers/rtc/rtc-hym8563.c
--- a/drivers/rtc/rtc-hym8563.c~drivers-rtc-rtc-hym8563c-staticize-local-symbol
+++ a/drivers/rtc/rtc-hym8563.c
@@ -389,7 +389,7 @@ static int hym8563_clkout_is_prepared(st
 	return !(ret & HYM8563_CLKOUT_DISABLE);
 }
 
-const struct clk_ops hym8563_clkout_ops = {
+static const struct clk_ops hym8563_clkout_ops = {
 	.prepare = hym8563_clkout_prepare,
 	.unprepare = hym8563_clkout_unprepare,
 	.is_prepared = hym8563_clkout_is_prepared,
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

drivers-rtc-rtc-ds1742c-remove-redundant-of_match_ptr-helper.patch
drivers-rtc-rtc-hym8563c-remove-redundant-of_match_ptr-helper.patch
drivers-rtc-rtc-hym8563c-staticize-local-symbol.patch
linux-next.patch

