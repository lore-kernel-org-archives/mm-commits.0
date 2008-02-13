From: akpm@linux-foundation.org
Subject: - rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:25 -0800
Message-ID: <200802132015.m1DKFP8X011368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762432AbYBMUPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc: remove unused var in drivers/rtc/rtc-r9701.c
has been removed from the -mm tree.  Its filename was
     rtc-remove-unused-var-in-drivers-rtc-rtc-r9701o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

uml-fix-initrd-printk.patch
uml-fix-helper_wait-calls-in-watchdog.patch
