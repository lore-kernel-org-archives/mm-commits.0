From: akpm@linux-foundation.org
Subject: [patch 052/126] linux/kernel.h: move DIV_ROUND_DOWN_ULL()
 macro
Date: Fri, 08 Sep 2017 16:13:45 -0700
Message-ID: <20170908231345.lZLJ9kZg7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757003AbdIHXNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, boris.brezillon@free-electrons.com, broonie@kernel.org, computersforpeace@gmail.com, cyrille.pitchen@wedev4u.fr, dwmw2@infradead.org, lgirdwood@gmail.com, marek.vasut@gmail.com, mm-commits@vger.kernel.org, perex@perex.cz, richard@nod.at, tiwai@suse.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: linux/kernel.h: move DIV_ROUND_DOWN_ULL() macro

This macro is useful to avoid link error on 32-bit systems.

We have the same definition in two drivers, so move it to
include/linux/kernel.h

While we are here, refactor DIV_ROUND_UP_ULL() by using
DIV_ROUND_DOWN_ULL().

Link: http://lkml.kernel.org/r/1500945156-12907-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/denali.c  |    3 ---
 include/linux/kernel.h     |    7 +++++--
 sound/soc/codecs/pcm512x.c |    3 ---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/nand/denali.c~linux-kernelh-move-div_round_down_ull-macro drivers/mtd/nand/denali.c
--- a/drivers/mtd/nand/denali.c~linux-kernelh-move-div_round_down_ull-macro
+++ a/drivers/mtd/nand/denali.c
@@ -980,9 +980,6 @@ static int denali_erase(struct mtd_info
 	return irq_status & INTR__ERASE_COMP ? 0 : NAND_STATUS_FAIL;
 }
 
-#define DIV_ROUND_DOWN_ULL(ll, d) \
-	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
-
 static int denali_setup_data_interface(struct mtd_info *mtd, int chipnr,
 				       const struct nand_data_interface *conf)
 {
diff -puN include/linux/kernel.h~linux-kernelh-move-div_round_down_ull-macro include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-move-div_round_down_ull-macro
+++ a/include/linux/kernel.h
@@ -78,8 +78,11 @@
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
-#define DIV_ROUND_UP_ULL(ll,d) \
-	({ unsigned long long _tmp = (ll)+(d)-1; do_div(_tmp, d); _tmp; })
+
+#define DIV_ROUND_DOWN_ULL(ll, d) \
+	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
+
+#define DIV_ROUND_UP_ULL(ll, d)		DIV_ROUND_DOWN_ULL((ll) + (d) - 1, (d))
 
 #if BITS_PER_LONG == 32
 # define DIV_ROUND_UP_SECTOR_T(ll,d) DIV_ROUND_UP_ULL(ll, d)
diff -puN sound/soc/codecs/pcm512x.c~linux-kernelh-move-div_round_down_ull-macro sound/soc/codecs/pcm512x.c
--- a/sound/soc/codecs/pcm512x.c~linux-kernelh-move-div_round_down_ull-macro
+++ a/sound/soc/codecs/pcm512x.c
@@ -30,9 +30,6 @@
 
 #include "pcm512x.h"
 
-#define DIV_ROUND_DOWN_ULL(ll, d) \
-	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
