From: akpm@linux-foundation.org
Subject: + sun3-print-when-lance_open-fails.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:43:25 -0800
Message-ID: <200902112343.n1BNhPeB026757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZBKXn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:43:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     sun3: print when lance_open() fails
has been added to the -mm tree.  Its filename is
     sun3-print-when-lance_open-fails.patch

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
Subject: sun3: print when lance_open() fails
From: Roel Kluin <roel.kluin@gmail.com>

With while (--i > 0) { ... } i reaches 0; print when lance_open() fails

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sun3lance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sun3lance.c~sun3-print-when-lance_open-fails drivers/net/sun3lance.c
--- a/drivers/net/sun3lance.c~sun3-print-when-lance_open-fails
+++ a/drivers/net/sun3lance.c
@@ -428,7 +428,7 @@ static int lance_open( struct net_device
 	while (--i > 0)
 		if (DREG & CSR0_IDON)
 			break;
-	if (i < 0 || (DREG & CSR0_ERR)) {
+	if (i <= 0 || (DREG & CSR0_ERR)) {
 		DPRINTK( 2, ( "lance_open(): opening %s failed, i=%d, csr0=%04x\n",
 					  dev->name, i, DREG ));
 		DREG = CSR0_STOP;
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
sun3-print-when-lance_open-fails.patch
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

