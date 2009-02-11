From: akpm@linux-foundation.org
Subject: + netdev-tg3-limit-reaches-1.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:05:12 -0800
Message-ID: <200902112305.n1BN5CYB006117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbZBKXFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, mchan@broadcom.com


The patch titled
     netdev: tg3: limit reaches -1
has been added to the -mm tree.  Its filename is
     netdev-tg3-limit-reaches-1.patch

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
Subject: netdev: tg3: limit reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With while (limit--) { ... } limit reaches -1, so 0 means success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/tg3.c~netdev-tg3-limit-reaches-1 drivers/net/tg3.c
--- a/drivers/net/tg3.c~netdev-tg3-limit-reaches-1
+++ a/drivers/net/tg3.c
@@ -852,7 +852,7 @@ static int tg3_bmcr_reset(struct tg3 *tp
 		}
 		udelay(10);
 	}
-	if (limit <= 0)
+	if (limit < 0)
 		return -EBUSY;
 
 	return 0;
@@ -1603,7 +1603,7 @@ static int tg3_wait_macro_done(struct tg
 				break;
 		}
 	}
-	if (limit <= 0)
+	if (limit < 0)
 		return -EBUSY;
 
 	return 0;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
rtc-t-reaches-1-tested-0.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
paride-pgc-xs-confusion.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
ufs-sector_t-cannot-be-negative.patch
netdev-tg3-limit-reaches-1.patch

