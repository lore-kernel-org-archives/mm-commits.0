From: akpm@linux-foundation.org
Subject: [merged] ubifs-use-prandom_bytes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:57 -0800
Message-ID: <20121218201157.CCD8E100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:32862 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2LRUL7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:59 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so159299qad.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubifs: use prandom_bytes
has been removed from the -mm tree.  Its filename was
     ubifs-use-prandom_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ubifs: use prandom_bytes

This also converts filling memory loop to use memset.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: David Laight <david.laight@aculab.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/debug.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/ubifs/debug.c~ubifs-use-prandom_bytes fs/ubifs/debug.c
--- a/fs/ubifs/debug.c~ubifs-use-prandom_bytes
+++ a/fs/ubifs/debug.c
@@ -2560,7 +2560,7 @@ static int power_cut_emulated(struct ubi
 static int corrupt_data(const struct ubifs_info *c, const void *buf,
 			unsigned int len)
 {
-	unsigned int from, to, i, ffs = chance(1, 2);
+	unsigned int from, to, ffs = chance(1, 2);
 	unsigned char *p = (void *)buf;
 
 	from = random32() % (len + 1);
@@ -2571,11 +2571,9 @@ static int corrupt_data(const struct ubi
 		   ffs ? "0xFFs" : "random data");
 
 	if (ffs)
-		for (i = from; i < to; i++)
-			p[i] = 0xFF;
+		memset(p + from, 0xFF, to - from);
 	else
-		for (i = from; i < to; i++)
-			p[i] = random32() % 0x100;
+		prandom_bytes(p + from, to - from);
 
 	return to;
 }
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

