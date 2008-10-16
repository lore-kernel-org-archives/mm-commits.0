From: akpm@linux-foundation.org
Subject: + dvb-input-data-pointer-of-cx24116_writeregn-should-be-const.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:04:35 -0700
Message-ID: <200810162104.m9GL4ZPE020046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbYJPVEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, mchehab@infradead.org


The patch titled
     dvb: input data pointer of cx24116_writeregN() should be const
has been added to the -mm tree.  Its filename is
     dvb-input-data-pointer-of-cx24116_writeregn-should-be-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dvb: input data pointer of cx24116_writeregN() should be const
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

| drivers/media/dvb/frontends/cx24116.c:573: warning: passing argument 3 of 'cx24116_writeregN' discards qualifiers from pointer target type

Make the `data' input pointer parameter of cx24116_writeregN() const to
kill the warning.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/cx24116.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/media/dvb/frontends/cx24116.c~dvb-input-data-pointer-of-cx24116_writeregn-should-be-const drivers/media/dvb/frontends/cx24116.c
--- a/drivers/media/dvb/frontends/cx24116.c~dvb-input-data-pointer-of-cx24116_writeregn-should-be-const
+++ a/drivers/media/dvb/frontends/cx24116.c
@@ -200,7 +200,8 @@ static int cx24116_writereg(struct cx241
 }
 
 /* Bulk byte writes to a single I2C address, for 32k firmware load */
-static int cx24116_writeregN(struct cx24116_state* state, int reg, u8 *data, u16 len)
+static int cx24116_writeregN(struct cx24116_state* state, int reg,
+			     const u8 *data, u16 len)
 {
 	int ret = -EREMOTEIO;
 	struct i2c_msg msg;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
identify_ramdisk_image-correct-typo-about-return-value-in-comment.patch
efifb-imacfb-consolidation-hardware-support.patch
dvb-input-data-pointer-of-cx24116_writeregn-should-be-const.patch

