From: akpm@linux-foundation.org
Subject: [merged]
 drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch removed
 from -mm tree
Date: Tue, 28 May 2013 12:36:59 -0700
Message-ID: <51a5075b.5tjRYBppGtzn6QiN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab3E1ThA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, cooloney@gmail.com, bigeasy@linutronix.de, christian.gmeiner@gmail.com

Subject: [merged] drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch removed from -mm tree
To: christian.gmeiner@gmail.com,bigeasy@linutronix.de,cooloney@gmail.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:59 -0700


The patch titled
     Subject: drivers/leds/leds-ot200.c: fix error caused by shifted mask
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-ot200c-fix-error-caused-by-shifted-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: <stable@vger.kernel.org>
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


