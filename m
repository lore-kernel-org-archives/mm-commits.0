From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch added to -mm tree
Date: Fri, 01 Feb 2013 14:12:22 -0800
Message-ID: <20130201221223.758B45A4303@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40453 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806Ab3BAWM0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 17:12:26 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so492275qcq.3
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 14:12:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christian.gmeiner@gmail.com, bigeasy@linutronix.de, cooloney@gmail.com


The patch titled
     Subject: drivers/leds/leds-ot200.c: fix error caused by shifted mask
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Subject: drivers/leds/leds-ot200.c: fix error caused by shifted mask

During the development of this driver an in-house register documentation
was used.  The last week some integration tests were done and this problem
was found.  It turned out that the released register documentation is
wrong.

The fix is very simple: shift all masks by one.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ot200.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/leds/leds-ot200.c~drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask drivers/leds/leds-ot200.c
--- a/drivers/leds/leds-ot200.c~drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask
+++ a/drivers/leds/leds-ot200.c
@@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
 	{
 		.name = "led_1",
 		.port = 0x49,
-		.mask = BIT(7),
+		.mask = BIT(6),
 	},
 	{
 		.name = "led_2",
 		.port = 0x49,
-		.mask = BIT(6),
+		.mask = BIT(5),
 	},
 	{
 		.name = "led_3",
 		.port = 0x49,
-		.mask = BIT(5),
+		.mask = BIT(4),
 	},
 	{
 		.name = "led_4",
 		.port = 0x49,
-		.mask = BIT(4),
+		.mask = BIT(3),
 	},
 	{
 		.name = "led_5",
 		.port = 0x49,
-		.mask = BIT(3),
+		.mask = BIT(2),
 	},
 	{
 		.name = "led_6",
 		.port = 0x49,
-		.mask = BIT(2),
+		.mask = BIT(1),
 	},
 	{
 		.name = "led_7",
 		.port = 0x49,
-		.mask = BIT(1),
+		.mask = BIT(0),
 	}
 };
 
_

Patches currently in -mm which might be from christian.gmeiner@gmail.com are

drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch

