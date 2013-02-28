From: akpm@linux-foundation.org
Subject: [merged] mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:14 -0800
Message-ID: <20130228201714.D1B9B31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48394 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3B1URQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:16 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so245186vch.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_bytes()
has been removed from the -mm tree.  Its filename was
     mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_bytes()

Using prandom_bytes() is enough.  Because this data is only used
for testing, not used for cryptographic use.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Laight <david.laight@aculab.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/tests/mtd_nandecctest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/tests/mtd_nandecctest.c~mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes drivers/mtd/tests/mtd_nandecctest.c
--- a/drivers/mtd/tests/mtd_nandecctest.c~mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes
+++ a/drivers/mtd/tests/mtd_nandecctest.c
@@ -256,7 +256,7 @@ static int nand_ecc_test_run(const size_
 		goto error;
 	}
 
-	get_random_bytes(correct_data, size);
+	prandom_bytes(correct_data, size);
 	__nand_calculate_ecc(correct_data, size, correct_ecc);
 
 	for (i = 0; i < ARRAY_SIZE(nand_ecc_test); i++) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch

