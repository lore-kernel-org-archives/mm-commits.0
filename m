From: akpm@linux-foundation.org
Subject: [merged] bitops-remove-for_each_set_bit_cont.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:12 -0700
Message-ID: <20120326192912.722CDA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46715 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2CZT3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:14 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298392faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, broonie@opensource.wolfsonmicro.com, hpa@zytor.com, mingo@redhat.com, robert.richter@amd.com, sfr@canb.auug.org.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: remove for_each_set_bit_cont()
has been removed from the -mm tree.  Its filename was
     bitops-remove-for_each_set_bit_cont.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: bitops: remove for_each_set_bit_cont()

Remove for_each_set_bit_cont() after confirming that no one uses
for_each_set_bit_cont() anymore.

[sfr@canb.auug.org.au: regmap: cope with bitops API change]
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/regmap/regcache-lzo.c |    2 +-
 include/linux/bitops.h             |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont drivers/base/regmap/regcache-lzo.c
--- a/drivers/base/regmap/regcache-lzo.c~bitops-remove-for_each_set_bit_cont
+++ a/drivers/base/regmap/regcache-lzo.c
@@ -341,7 +341,7 @@ static int regcache_lzo_sync(struct regm
 
 	lzo_blocks = map->cache;
 	i = min;
-	for_each_set_bit_cont(i, lzo_blocks[0]->sync_bmp,
+	for_each_set_bit_from(i, lzo_blocks[0]->sync_bmp,
 			      lzo_blocks[0]->sync_bmp_nbits) {
 		if (i > max)
 			continue;
diff -puN include/linux/bitops.h~bitops-remove-for_each_set_bit_cont include/linux/bitops.h
--- a/include/linux/bitops.h~bitops-remove-for_each_set_bit_cont
+++ a/include/linux/bitops.h
@@ -32,9 +32,6 @@ extern unsigned long __sw_hweight64(__u6
 	     (bit) < (size);					\
 	     (bit) = find_next_bit((addr), (size), (bit) + 1))
 
-#define for_each_set_bit_cont(bit, addr, size) \
-	for_each_set_bit_from(bit, addr, size)
