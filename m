From: akpm@linux-foundation.org
Subject: + backlight-lp8788-staticize-default_bl_config.patch added to -mm tree
Date: Wed, 18 Sep 2013 15:41:28 -0700
Message-ID: <523a2c18.RR79tBMSj3nWbzFe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3IRWl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-lp8788-staticize-default_bl_config.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:41:28 -0700


The patch titled
     Subject: backlight: lp8788: Staticize 'default_bl_config'
has been added to the -mm tree.  Its filename is
     backlight-lp8788-staticize-default_bl_config.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lp8788-staticize-default_bl_config.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lp8788-staticize-default_bl_config.patch

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
Subject: backlight: lp8788: Staticize 'default_bl_config'

Fix the following sparse warning:

drivers/video/backlight/lp8788_bl.c:55:25: warning: symbol 'default_bl_config' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp8788_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp8788_bl.c~backlight-lp8788-staticize-default_bl_config drivers/video/backlight/lp8788_bl.c
--- a/drivers/video/backlight/lp8788_bl.c~backlight-lp8788-staticize-default_bl_config
+++ a/drivers/video/backlight/lp8788_bl.c
@@ -52,7 +52,7 @@ struct lp8788_bl {
 	struct pwm_device *pwm;
 };
 
-struct lp8788_bl_config default_bl_config = {
+static struct lp8788_bl_config default_bl_config = {
 	.bl_mode    = LP8788_BL_REGISTER_ONLY,
 	.dim_mode   = LP8788_DIM_EXPONENTIAL,
 	.full_scale = LP8788_FULLSCALE_1900uA,
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

