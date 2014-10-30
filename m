From: akpm@linux-foundation.org
Subject: [merged] rtc-bq3000-fix-register-value.patch removed from -mm
 tree
Date: Thu, 30 Oct 2014 13:27:40 -0700
Message-ID: <54529f3c.AvxdIffQpvk9hU+8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161172AbaJ3U1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, mike@bfo.com, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-bq32k.c: fix register value
has been removed from the -mm tree.  Its filename was
     rtc-bq3000-fix-register-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: drivers/rtc/rtc-bq32k.c: fix register value

Fix register value in bq32000 trickle charging.

Mike reported that I'm using wrong value in one trickle-charging case, and
after checking docs, I must admit he's right.

Signed-off-by: Pavel Machek <pavel@denx.de>
Reported-by: Mike Bremford <mike@bfo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-bq3000-fix-register-value drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-bq3000-fix-register-value
+++ a/drivers/rtc/rtc-bq32k.c
@@ -160,7 +160,7 @@ static int trickle_charger_of_init(struc
 			dev_err(dev, "bq32k: diode and resistor mismatch\n");
 			return -EINVAL;
 		}
-		reg = 0x25;
+		reg = 0x45;
 		break;
 
 	default:
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

