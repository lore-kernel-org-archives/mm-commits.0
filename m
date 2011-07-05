From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:58:16 -0700
Message-ID: <201107052158.p65LwG6H026576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab1GEV6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net, a.zummo@towertech.it, gdavis@mvista.com, source@mvista.com


The patch titled
     drivers/rtc/rtc-twl.c: check return value of twl_rtc_write_u8() in twl_rtc_set_time()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-twl.c: check return value of twl_rtc_write_u8() in twl_rtc_set_time()
From: Jesper Juhl <jj@chaosbits.net>

We forget to save the return value of the call to
twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG); in 'ret', making the
test of 'ret < 0' dead code since 'ret' then couldn't possibly have
changed since the last test just a few lines above.  It also makes us not
detect failures from that specific twl_rtc_write_u8() call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Rusev <source@mvista.com>
Cc: "George G. Davis" <gdavis@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time
+++ a/drivers/rtc/rtc-twl.c
@@ -275,7 +275,7 @@ static int twl_rtc_set_time(struct devic
 		goto out;
 
 	save_control &= ~BIT_RTC_CTRL_REG_STOP_RTC_M;
-	twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
+	ret = twl_rtc_write_u8(save_control, REG_RTC_CTRL_REG);
 	if (ret < 0)
 		goto out;
 
_

Patches currently in -mm which might be from jj@chaosbits.net are

linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time.patch

