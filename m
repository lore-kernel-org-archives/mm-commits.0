From: akpm@linux-foundation.org
Subject: + mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:41 -0800
Message-ID: <20121113195442.57C69100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45684 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2KMTyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:44 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so900565vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_bytes()
has been added to the -mm tree.  Its filename is
     mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

