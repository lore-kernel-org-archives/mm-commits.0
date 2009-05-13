From: akpm@linux-foundation.org
Subject: + m68k-cnt-reaches-1-not-0.patch added to -mm tree
Date: Wed, 13 May 2009 11:42:25 -0700
Message-ID: <200905131842.n4DIgPBM025750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760700AbZEMSpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, geert@linux-m68k.org


The patch titled
     m68k: cnt reaches -1, not 0
has been added to the -mm tree.  Its filename is
     m68k-cnt-reaches-1-not-0.patch

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
Subject: m68k: cnt reaches -1, not 0
From: Roel Kluin <roel.kluin@gmail.com>

With the postfix decrement cnt reaches -1 rather than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/config.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/m68k/amiga/config.c~m68k-cnt-reaches-1-not-0 arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~m68k-cnt-reaches-1-not-0
+++ a/arch/m68k/amiga/config.c
@@ -574,10 +574,11 @@ static int a2000_hwclk(int op, struct rt
 
 	tod_2000.cntrl1 = TOD2000_CNTRL1_HOLD;
 
-	while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt--) {
+	while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
 		tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
 		udelay(70);
 		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
+		--cnt;
 	}
 
 	if (!cnt)
@@ -649,10 +650,11 @@ static int amiga_set_clock_mmss(unsigned
 
 		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
 
-		while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt--) {
+		while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
 			tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
 			udelay(70);
 			tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
+			--cnt;
 		}
 
 		if (!cnt)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

