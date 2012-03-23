From: akpm@linux-foundation.org
Subject: [folded] bitops-remove-for_each_set_bit_cont-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:24:26 -0700
Message-ID: <20120323212426.D004DA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54588 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2CWVY3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:24:29 -0400
Received: by lbbgj3 with SMTP id gj3so187838lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:24:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, akinobu.mita@gmail.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: regmap: cope with bitops API change (for_each_set_bit_cont)
has been removed from the -mm tree.  Its filename was
     bitops-remove-for_each_set_bit_cont-fix.patch

This patch was dropped because it was folded into bitops-remove-for_each_set_bit_cont.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: regmap: cope with bitops API change (for_each_set_bit_cont)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/regmap/regcache-lzo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont-fix drivers/base/regmap/regcache-lzo.c
--- a/drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont-fix
+++ a/drivers/base/regmap/regcache-lzo.c
@@ -342,7 +342,7 @@ static int regcache_lzo_sync(struct regm
 
 	lzo_blocks = map->cache;
 	i = min;
-	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
+	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,
 			      lzo_blocks[0]->sync_bmp_nbits) {
 		if (i > max)
 			continue;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
bitops-remove-for_each_set_bit_cont.patch

