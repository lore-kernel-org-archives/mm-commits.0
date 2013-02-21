From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-support-for-spi-rtc-rx4581-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:29:49 -0800
Message-ID: <20130221232949.E6D9D31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42591 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3BUX3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:29:50 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so11420ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:29:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torbenh@linutronix.de, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc rx4581: change err type from unsigned char to int in get_datetime()
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-spi-rtc-rx4581-fix.patch

This patch was dropped because it was folded into rtc-add-support-for-spi-rtc-rx4581.patch

------------------------------------------------------
From: Torben Hohn <torbenh@linutronix.de>
Subject: rtc rx4581: change err type from unsigned char to int in get_datetime()

in response to these warnings posted by dan.carpenter@oracle.com:

New smatch warnings:
drivers/rtc/rtc-rx4581.c:134 rx4581_get_datetime() warn: unsigned 'err' is never less than zero.

Old smatch warnings:
drivers/rtc/rtc-rx4581.c:175 rx4581_get_datetime() warn: unsigned 'err' is never less than zero.

Signed-off-by: Torben Hohn <torbenh@linutronix.de>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx4581.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-rx4581.c~rtc-add-support-for-spi-rtc-rx4581-fix drivers/rtc/rtc-rx4581.c
--- a/drivers/rtc/rtc-rx4581.c~rtc-add-support-for-spi-rtc-rx4581-fix
+++ a/drivers/rtc/rtc-rx4581.c
@@ -103,7 +103,8 @@ static int rx4581_get_datetime(struct de
 {
 	struct spi_device *spi = to_spi_device(dev);
 	unsigned char date[7];
-	unsigned char data, err;
+	unsigned char data;
+	int err;
 
 	/* First we ensure that the "update flag" is not set, we read the
 	 * time and date then re-read the "update flag". If the update flag
_

Patches currently in -mm which might be from torbenh@linutronix.de are

rtc-add-support-for-spi-rtc-rx4581.patch

