From: akpm@linux-foundation.org
Subject: + asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch added to -mm tree
Date: Wed, 25 Mar 2015 13:32:22 -0700
Message-ID: <55131b56.uOMxGzYQcabX+OYf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbCYUcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 16:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javi.merino@arm.com, broonie@kernel.org, fengguang.wu@intel.com, lgirdwood@gmail.com, peda@axentia.se, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ASoC: pcm512x: use DIV_ROUND_CLOSEST_ULL() from kernel.h
has been added to the -mm tree.  Its filename is
     asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch

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
Subject: ASoC: pcm512x: use DIV_ROUND_CLOSEST_ULL() from kernel.h

Now that the kernel provides DIV_ROUND_CLOSEST_ULL(), drop the internal
implementation and use the kernel one.

Signed-off-by: Javi Merino <javi.merino@arm.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Peter Rosin <peda@axentia.se>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/pcm512x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN sound/soc/codecs/pcm512x.c~asoc-pcm512x-use-div_round_closest_ull-from-kernelh sound/soc/codecs/pcm512x.c
--- a/sound/soc/codecs/pcm512x.c~asoc-pcm512x-use-div_round_closest_ull-from-kernelh
+++ a/sound/soc/codecs/pcm512x.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/kernel.h>
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -31,8 +32,6 @@
 
 #define DIV_ROUND_DOWN_ULL(ll, d) \
 	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
-#define DIV_ROUND_CLOSEST_ULL(ll, d) \
-	({ unsigned long long _tmp = (ll)+(d)/2; do_div(_tmp, d); _tmp; })
 
 #define PCM512x_NUM_SUPPLIES 3
 static const char * const pcm512x_supply_names[PCM512x_NUM_SUPPLIES] = {
_

Patches currently in -mm which might be from javi.merino@arm.com are

kernelh-implement-div_round_closest_ull.patch
clk-bcm-kona-use-div_round_closest_ull.patch
cpuidle-menu-use-div_round_closest_ull.patch
media-cxd2820r-use-div_round_closest_ull.patch
asoc-pcm512x-use-div_round_closest_ull-from-kernelh.patch
linux-next.patch

