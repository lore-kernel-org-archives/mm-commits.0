From: akpm@linux-foundation.org
Subject: + scsi-ncr53c8xx-div-reaches-1.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:06:44 -0800
Message-ID: <200902112306.n1BN6i5m008241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbZBKXHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:07:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, matthew@wil.cx


The patch titled
     scsi: ncr53c8xx: div reaches -1
has been added to the -mm tree.  Its filename is
     scsi-ncr53c8xx-div-reaches-1.patch

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
Subject: scsi: ncr53c8xx: div reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With while(--div >= 0) { ... } div reaches -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ncr53c8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1 drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1
+++ a/drivers/scsi/ncr53c8xx.c
@@ -5444,7 +5444,7 @@ static void ncr_getsync(struct ncb *np, 
 	**	input speed faster than the period.
 	*/
 	kpc = per * clk;
-	while (--div >= 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
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
mm-get_nid_for_pfn-returns-int.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
ufs-sector_t-cannot-be-negative.patch

