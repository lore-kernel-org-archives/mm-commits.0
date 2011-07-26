From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:32 -0700
Message-ID: <201107260755.p6Q7tZXC003473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab1GZH4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, a.zummo@towertech.it, gdavis@mvista.com, source@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-twl.c: check return value of twl_rtc_write_u8() in twl_rtc_set_time()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-check-return-value-of-twl_rtc_write_u8-in-twl_rtc_set_time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
audit-always-follow-va_copy-with-va_end.patch
drivers-scsi-aacraid-commctrlc-fix-mem-leak-in-aac_send_raw_srb.patch

