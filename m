From: akpm@linux-foundation.org
Subject: + rtc-bq3000-fix-register-value.patch added to -mm tree
Date: Wed, 22 Oct 2014 12:23:30 -0700
Message-ID: <54480432.x5kFU5iHVsnn/QiJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaJVTXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, mike@bfo.com, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-bq32k.c: fix register value
has been added to the -mm tree.  Its filename is
     rtc-bq3000-fix-register-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-bq3000-fix-register-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-bq3000-fix-register-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-bq3000-fix-register-value.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

