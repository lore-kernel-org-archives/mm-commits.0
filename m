From: akpm@linux-foundation.org
Subject: + aty128fb-test-below-0-on-unsigned-pll-post_divider.patch added to -mm tree
Date: Wed, 07 May 2008 16:05:09 -0700
Message-ID: <200805072305.m47N59x3021569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761805AbYEGXFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 19:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, adaplas@pol.net, benh@kernel.crashing.org


The patch titled
     aty128fb: test below 0 on unsigned pll->post_divider
has been added to the -mm tree.  Its filename is
     aty128fb-test-below-0-on-unsigned-pll-post_divider.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aty128fb: test below 0 on unsigned pll->post_divider
From: Roel Kluin <12o3l@tiscali.nl>

pll->post_divider is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~aty128fb-test-below-0-on-unsigned-pll-post_divider drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~aty128fb-test-below-0-on-unsigned-pll-post_divider
+++ a/drivers/video/aty/aty128fb.c
@@ -1339,10 +1339,8 @@ static int aty128_var_to_pll(u32 period_
 	if (vclk * 12 < c.ppll_min)
 		vclk = c.ppll_min/12;
 
-	pll->post_divider = -1;
-
 	/* now, find an acceptable divider */
-	for (i = 0; i < sizeof(post_dividers); i++) {
+	for (i = 0; i < ARRAY_SIZE(post_dividers); i++) {
 		output_freq = post_dividers[i] * vclk;
 		if (output_freq >= c.ppll_min && output_freq <= c.ppll_max) {
 			pll->post_divider = post_dividers[i];
@@ -1350,7 +1348,7 @@ static int aty128_var_to_pll(u32 period_
 		}
 	}
 
-	if (pll->post_divider < 0)
+	if (i == ARRAY_SIZE(post_dividers))
 		return -EINVAL;
 
 	/* calculate feedback divider */
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

atmel_lcdfb-fix-pixclok-divider-calculation.patch
linux-next.patch
ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
spi_mpc83xx-much-improved-driver.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

