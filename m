From: akpm@linux-foundation.org
Subject: + rtc-m41t80-do-not-use-rtc_valid_tm-in-m41t80_rtc_read_alarm.patch added to -mm tree
Date: Fri, 03 Sep 2010 14:27:45 -0700
Message-ID: <201009032127.o83LRjOC013228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab0ICV2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 17:28:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, geert@linux-m68k.org, mcuos.com@gmail.com


The patch titled
     rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm
has been added to the -mm tree.  Its filename is
     rtc-m41t80-do-not-use-rtc_valid_tm-in-m41t80_rtc_read_alarm.patch

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
Subject: rtc: m41t80: do not use rtc_valid_tm in m41t80_rtc_read_alarm
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Commit b485fe5ea ("rtc/m41t80: use rtc_valid_tm() to check returned tm")
added rtc_valid_tm to m41t80_rtc_read_alarm() but it was wrong while the
t->time does not contain complete date/time.

This patch also fixes a warning:
warning: passing argument 1 of 'rtc_valid_tm' from incompatible pointer type

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-m41t80-do-not-use-rtc_valid_tm-in-m41t80_rtc_read_alarm drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-m41t80-do-not-use-rtc_valid_tm-in-m41t80_rtc_read_alarm
+++ a/drivers/rtc/rtc-m41t80.c
@@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct 
 	t->time.tm_isdst = -1;
 	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
 	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return rtc_valid_tm(t);
+	return 0;
 }
 
 static struct rtc_class_ops m41t80_rtc_ops = {
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
rtc-m41t80-do-not-use-rtc_valid_tm-in-m41t80_rtc_read_alarm.patch

