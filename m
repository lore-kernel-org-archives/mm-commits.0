From: akpm@linux-foundation.org
Subject: + backlight-ld9040-staticize-local-variable-gamma_table.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 15:41:26 -0700
Message-ID: <523a2c16.ekdjjHO9cFpQ3m3t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3IRWl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-ld9040-staticize-local-variable-gamma_table.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:41:26 -0700


The patch titled
     Subject: backlight: ld9040: Staticize local variable gamma_table
has been added to the -mm tree.  Its filename is
     backlight-ld9040-staticize-local-variable-gamma_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-ld9040-staticize-local-variable-gamma_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-ld9040-staticize-local-variable-gamma_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: Staticize local variable gamma_table

Fix the following sparse warnings:

drivers/video/backlight/ld9040_gamma.h:172:3: warning: symbol 'gamma_table' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040_gamma.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/ld9040_gamma.h~backlight-ld9040-staticize-local-variable-gamma_table drivers/video/backlight/ld9040_gamma.h
--- a/drivers/video/backlight/ld9040_gamma.h~backlight-ld9040-staticize-local-variable-gamma_table
+++ a/drivers/video/backlight/ld9040_gamma.h
@@ -169,7 +169,9 @@ static const unsigned int ld9040_22_50[]
 
 struct ld9040_gamma {
 	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
-} gamma_table = {
+};
+
+static struct ld9040_gamma gamma_table = {
 	.gamma_22_table[0] = (unsigned int *)&ld9040_22_50,
 	.gamma_22_table[1] = (unsigned int *)&ld9040_22_70,
 	.gamma_22_table[2] = (unsigned int *)&ld9040_22_80,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch

