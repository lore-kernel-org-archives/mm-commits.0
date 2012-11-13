From: akpm@linux-foundation.org
Subject: + ubifs-use-prandom_bytes.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:36 -0800
Message-ID: <20121113195437.C022B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43978 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab2KMTyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:41 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so18940wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: ubifs: use prandom_bytes
has been added to the -mm tree.  Its filename is
     ubifs-use-prandom_bytes.patch

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

