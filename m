From: akpm@linux-foundation.org
Subject: + rtc-add-support-for-spi-rtc-rx4581-fix.patch added to -mm tree
Date: Mon, 14 Jan 2013 14:42:03 -0800
Message-ID: <20130114224203.A642082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:35846 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3ANWmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 17:42:05 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so557112qch.0
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 14:42:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torbenh@linutronix.de, dan.carpenter@oracle.com


The patch titled
     Subject: rtc rx4581: change err type from unsigned char to int in get_datetime()
has been added to the -mm tree.  Its filename is
     rtc-add-support-for-spi-rtc-rx4581-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
rtc-add-support-for-spi-rtc-rx4581-fix.patch

