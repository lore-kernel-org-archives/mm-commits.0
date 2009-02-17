From: akpm@linux-foundation.org
Subject: [nacked] m68k-amiflop-ptr-incremented-past-0x4489.patch removed from -mm tree
Date: Tue, 17 Feb 2009 13:59:17 -0800
Message-ID: <200902172159.n1HLxH2P029853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZBQWAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:00:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, geert@linux-m68k.org, jens.axboe@oracle.com, joerg@dorchain.net, mm-commits@vger.kernel.org


The patch titled
     m68k: amiflop: *ptr incremented past 0x4489
has been removed from the -mm tree.  Its filename was
     m68k-amiflop-ptr-incremented-past-0x4489.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: amiflop: *ptr incremented past 0x4489
From: Roel Kluin <roel.kluin@gmail.com>

With while (*ptr++ != 0x4489) { ...  } *ptr will be incremented past
0x4489 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Joerg Dorchain <joerg@dorchain.net>
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

linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
v4l-dvb-calibration-still-successful-at-10.patch
leds-fix-confusion.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
m68k-amiflop-ptr-incremented-past-0x4489.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
ufs-sector_t-cannot-be-negative.patch

