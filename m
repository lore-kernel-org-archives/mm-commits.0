From: akpm@linux-foundation.org
Subject: + m68k-amiflop-ptr-incremented-past-0x4489.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:24:15 -0800
Message-ID: <200902112324.n1BNOFaI032630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbZBKXZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:25:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, geert@linux-m68k.org, jens.axboe@oracle.com


The patch titled
     m68k: amiflop: *ptr incremented past 0x4489
has been added to the -mm tree.  Its filename is
     m68k-amiflop-ptr-incremented-past-0x4489.patch

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
Subject: m68k: amiflop: *ptr incremented past 0x4489
From: Roel Kluin <roel.kluin@gmail.com>

With while (*ptr++ != 0x4489) { ...  } *ptr will be incremented past
0x4489 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/amiflop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/amiflop.c~m68k-amiflop-ptr-incremented-past-0x4489 drivers/block/amiflop.c
--- a/drivers/block/amiflop.c~m68k-amiflop-ptr-incremented-past-0x4489
+++ a/drivers/block/amiflop.c
@@ -662,8 +662,8 @@ static unsigned long scan_sync(unsigned 
 {
 	ushort *ptr = (ushort *)raw, *endp = (ushort *)end;
 
-	while (ptr < endp && *ptr++ != 0x4489)
-		;
+	while (ptr < endp && *ptr != 0x4489)
+		++ptr;
 	if (ptr < endp) {
 		while (*ptr == 0x4489 && ptr < endp)
 			ptr++;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
rtc-t-reaches-1-tested-0.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
netdev-tg3-limit-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
m68k-amiflop-ptr-incremented-past-0x4489.patch
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
ufs-sector_t-cannot-be-negative.patch

