From: akpm@linux-foundation.org
Subject: + rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch added to -mm tree
Date: Mon, 11 Feb 2008 13:43:53 -0800
Message-ID: <200802112144.m1BLhr9f001813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbYBKWGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net, a.zummo@towertech.it


The patch titled
     rtc: remove unused var in drivers/rtc/rtc-r9701.c
has been added to the -mm tree.  Its filename is
     rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: remove unused var in drivers/rtc/rtc-r9701.c
From: Johann Felix Soden <johfel@users.sourceforge.net>

fix this build warning:
drivers/rtc/rtc-r9701.c: In function 'r9701_get_datetime':
drivers/rtc/rtc-r9701.c:74: warning: unused variable 'time'

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-r9701.c~rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o
+++ a/drivers/rtc/rtc-r9701.c
@@ -71,7 +71,6 @@ static int read_regs(struct device *dev,
 
 static int r9701_get_datetime(struct device *dev, struct rtc_time *dt)
 {
-	unsigned long time;
 	int ret;
 	unsigned char buf[] = { RSECCNT, RMINCNT, RHRCNT,
 				RDAYCNT, RMONCNT, RYRCNT };
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

origin.patch
rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch
