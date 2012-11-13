From: akpm@linux-foundation.org
Subject: + mtd-mtd_stresstest-use-prandom_bytes.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:55:04 -0800
Message-ID: <20121113195505.187AA200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:64916 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab2KMTzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:55:08 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so218399eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:55:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: mtd: mtd_stresstest: use prandom_bytes()
has been added to the -mm tree.  Its filename is
     mtd-mtd_stresstest-use-prandom_bytes.patch

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
Subject: mtd: mtd_stresstest: use prandom_bytes()

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

 drivers/mtd/tests/mtd_stresstest.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/tests/mtd_stresstest.c~mtd-mtd_stresstest-use-prandom_bytes drivers/mtd/tests/mtd_stresstest.c
--- a/drivers/mtd/tests/mtd_stresstest.c~mtd-mtd_stresstest-use-prandom_bytes
+++ a/drivers/mtd/tests/mtd_stresstest.c
@@ -282,8 +282,7 @@ static int __init mtd_stresstest_init(vo
 	}
 	for (i = 0; i < ebcnt; i++)
 		offsets[i] = mtd->erasesize;
-	for (i = 0; i < bufsize; i++)
-		writebuf[i] = random32();
+	prandom_bytes(writebuf, bufsize);
 
 	err = scan_for_bad_eraseblocks();
 	if (err)
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

