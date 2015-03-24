From: akpm@linux-foundation.org
Subject: + media-cxd2820r-use-div_round_closest_ull.patch added to -mm
 tree
Date: Tue, 24 Mar 2015 14:01:33 -0700
Message-ID: <5511d0ad.c0xCB08s+QjSLf2l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbCXVBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, crope@iki.fi, mchehab@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: cxd2820r: use DIV_ROUND_CLOSEST_ULL()
has been added to the -mm tree.  Its filename is
     media-cxd2820r-use-div_round_closest_ull.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-cxd2820r-use-div_round_closest_ull.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-cxd2820r-use-div_round_closest_ull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javi Merino <javi.merino@arm.com>
Subject: media: cxd2820r: use DIV_ROUND_CLOSEST_ULL()

Now that the kernel provides DIV_ROUND_CLOSEST_ULL(), drop the internal
implementation and use the kernel one.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-frontends/cxd2820r_c.c    |    2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c |    6 ------
 drivers/media/dvb-frontends/cxd2820r_priv.h |    2 --
 drivers/media/dvb-frontends/cxd2820r_t.c    |    2 +-
 drivers/media/dvb-frontends/cxd2820r_t2.c   |    2 +-
 5 files changed, 3 insertions(+), 11 deletions(-)

diff -puN drivers/media/dvb-frontends/cxd2820r_c.c~media-cxd2820r-use-div_round_closest_ull drivers/media/dvb-frontends/cxd2820r_c.c
--- a/drivers/media/dvb-frontends/cxd2820r_c.c~media-cxd2820r-use-div_round_closest_ull
+++ a/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -79,7 +79,7 @@ int cxd2820r_set_frontend_c(struct dvb_f
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x4000;
-	if_ctl = 0x4000 - cxd2820r_div_u64_round_closest(num, 41000);
+	if_ctl = 0x4000 - DIV_ROUND_CLOSEST_ULL(num, 41000);
 	buf[0] = (if_ctl >> 8) & 0x3f;
 	buf[1] = (if_ctl >> 0) & 0xff;
 
diff -puN drivers/media/dvb-frontends/cxd2820r_core.c~media-cxd2820r-use-div_round_closest_ull drivers/media/dvb-frontends/cxd2820r_core.c
--- a/drivers/media/dvb-frontends/cxd2820r_core.c~media-cxd2820r-use-div_round_closest_ull
+++ a/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -244,12 +244,6 @@ error:
 	return ret;
 }
 
-/* 64 bit div with round closest, like DIV_ROUND_CLOSEST but 64 bit */
-u32 cxd2820r_div_u64_round_closest(u64 dividend, u32 divisor)
-{
-	return div_u64(dividend + (divisor / 2), divisor);
-}
-
 static int cxd2820r_set_frontend(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
diff -puN drivers/media/dvb-frontends/cxd2820r_priv.h~media-cxd2820r-use-div_round_closest_ull drivers/media/dvb-frontends/cxd2820r_priv.h
--- a/drivers/media/dvb-frontends/cxd2820r_priv.h~media-cxd2820r-use-div_round_closest_ull
+++ a/drivers/media/dvb-frontends/cxd2820r_priv.h
@@ -64,8 +64,6 @@ int cxd2820r_wr_reg_mask(struct cxd2820r
 int cxd2820r_wr_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
 	int len);
 
-u32 cxd2820r_div_u64_round_closest(u64 dividend, u32 divisor);
-
 int cxd2820r_wr_regs(struct cxd2820r_priv *priv, u32 reginfo, u8 *val,
 	int len);
 
diff -puN drivers/media/dvb-frontends/cxd2820r_t.c~media-cxd2820r-use-div_round_closest_ull drivers/media/dvb-frontends/cxd2820r_t.c
--- a/drivers/media/dvb-frontends/cxd2820r_t.c~media-cxd2820r-use-div_round_closest_ull
+++ a/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -103,7 +103,7 @@ int cxd2820r_set_frontend_t(struct dvb_f
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x1000000;
-	if_ctl = cxd2820r_div_u64_round_closest(num, 41000);
+	if_ctl = DIV_ROUND_CLOSEST_ULL(num, 41000);
 	buf[0] = ((if_ctl >> 16) & 0xff);
 	buf[1] = ((if_ctl >>  8) & 0xff);
 	buf[2] = ((if_ctl >>  0) & 0xff);
diff -puN drivers/media/dvb-frontends/cxd2820r_t2.c~media-cxd2820r-use-div_round_closest_ull drivers/media/dvb-frontends/cxd2820r_t2.c
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c~media-cxd2820r-use-div_round_closest_ull
+++ a/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -120,7 +120,7 @@ int cxd2820r_set_frontend_t2(struct dvb_
 
 	num = if_freq / 1000; /* Hz => kHz */
 	num *= 0x1000000;
-	if_ctl = cxd2820r_div_u64_round_closest(num, 41000);
+	if_ctl = DIV_ROUND_CLOSEST_ULL(num, 41000);
 	buf[0] = ((if_ctl >> 16) & 0xff);
 	buf[1] = ((if_ctl >>  8) & 0xff);
 	buf[2] = ((if_ctl >>  0) & 0xff);
_

Patches currently in -mm which might be from javi.merino@arm.com are

kernelh-implement-div_round_closest_ull.patch
clk-bcm-kona-use-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
media-cxd2820r-use-div_round_closest_ull.patch
linux-next.patch

