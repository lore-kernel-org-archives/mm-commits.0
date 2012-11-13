From: akpm@linux-foundation.org
Subject: + mtd-mtd_oobtest-convert-to-use-prandom-library.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:46 -0800
Message-ID: <20121113195446.D408A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33073 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2KMTyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:50 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so503164wey.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: mtd: mtd_oobtest: convert to use prandom library
has been added to the -mm tree.  Its filename is
     mtd-mtd_oobtest-convert-to-use-prandom-library.patch

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
Subject: mtd: mtd_oobtest: convert to use prandom library

This removes home-brewed pseudo-random number generator and use
prandom library.

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

 drivers/mtd/tests/mtd_oobtest.c |   49 +++++++++---------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff -puN drivers/mtd/tests/mtd_oobtest.c~mtd-mtd_oobtest-convert-to-use-prandom-library drivers/mtd/tests/mtd_oobtest.c
--- a/drivers/mtd/tests/mtd_oobtest.c~mtd-mtd_oobtest-convert-to-use-prandom-library
+++ a/drivers/mtd/tests/mtd_oobtest.c
@@ -29,6 +29,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 static int dev = -EINVAL;
 module_param(dev, int, S_IRUGO);
@@ -46,26 +47,7 @@ static int use_offset;
 static int use_len;
 static int use_len_max;
 static int vary_offset;
-static unsigned long next = 1;
-
-static inline unsigned int simple_rand(void)
-{
-	next = next * 1103515245 + 12345;
-	return (unsigned int)((next / 65536) % 32768);
-}
-
-static inline void simple_srand(unsigned long seed)
-{
-	next = seed;
-}
-
-static void set_random_data(unsigned char *buf, size_t len)
-{
-	size_t i;
-
-	for (i = 0; i < len; ++i)
-		buf[i] = simple_rand();
-}
+static struct rnd_state rnd_state;
 
 static int erase_eraseblock(int ebnum)
 {
@@ -129,7 +111,7 @@ static int write_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
-		set_random_data(writebuf, use_len);
+		prandom_bytes_state(&rnd_state, writebuf, use_len);
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
 		ops.retlen    = 0;
@@ -182,7 +164,7 @@ static int verify_eraseblock(int ebnum)
 	loff_t addr = ebnum * mtd->erasesize;
 
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
-		set_random_data(writebuf, use_len);
+		prandom_bytes_state(&rnd_state, writebuf, use_len);
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
 		ops.retlen    = 0;
@@ -273,7 +255,7 @@ static int verify_eraseblock_in_one_go(i
 	loff_t addr = ebnum * mtd->erasesize;
 	size_t len = mtd->ecclayout->oobavail * pgcnt;
 
-	set_random_data(writebuf, len);
+	prandom_bytes_state(&rnd_state, writebuf, len);
 	ops.mode      = MTD_OPS_AUTO_OOB;
 	ops.len       = 0;
 	ops.retlen    = 0;
@@ -424,12 +406,12 @@ static int __init mtd_oobtest_init(void)
 	if (err)
 		goto out;
 
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	err = write_whole_device();
 	if (err)
 		goto out;
 
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	err = verify_all_eraseblocks();
 	if (err)
 		goto out;
@@ -444,13 +426,13 @@ static int __init mtd_oobtest_init(void)
 	if (err)
 		goto out;
 
-	simple_srand(3);
+	prandom_seed_state(&rnd_state, 3);
 	err = write_whole_device();
 	if (err)
 		goto out;
 
 	/* Check all eraseblocks */
-	simple_srand(3);
+	prandom_seed_state(&rnd_state, 3);
 	pr_info("verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -479,7 +461,7 @@ static int __init mtd_oobtest_init(void)
 	use_len = mtd->ecclayout->oobavail;
 	use_len_max = mtd->ecclayout->oobavail;
 	vary_offset = 1;
-	simple_srand(5);
+	prandom_seed_state(&rnd_state, 5);
 
 	err = write_whole_device();
 	if (err)
@@ -490,7 +472,7 @@ static int __init mtd_oobtest_init(void)
 	use_len = mtd->ecclayout->oobavail;
 	use_len_max = mtd->ecclayout->oobavail;
 	vary_offset = 1;
-	simple_srand(5);
+	prandom_seed_state(&rnd_state, 5);
 	err = verify_all_eraseblocks();
 	if (err)
 		goto out;
@@ -649,7 +631,7 @@ static int __init mtd_oobtest_init(void)
 		goto out;
 
 	/* Write all eraseblocks */
-	simple_srand(11);
+	prandom_seed_state(&rnd_state, 11);
 	pr_info("writing OOBs of whole device\n");
 	for (i = 0; i < ebcnt - 1; ++i) {
 		int cnt = 2;
@@ -659,7 +641,7 @@ static int __init mtd_oobtest_init(void)
 			continue;
 		addr = (i + 1) * mtd->erasesize - mtd->writesize;
 		for (pg = 0; pg < cnt; ++pg) {
-			set_random_data(writebuf, sz);
+			prandom_bytes_state(&rnd_state, writebuf, sz);
 			ops.mode      = MTD_OPS_AUTO_OOB;
 			ops.len       = 0;
 			ops.retlen    = 0;
@@ -680,12 +662,13 @@ static int __init mtd_oobtest_init(void)
 	pr_info("written %u eraseblocks\n", i);
 
 	/* Check all eraseblocks */
-	simple_srand(11);
+	prandom_seed_state(&rnd_state, 11);
 	pr_info("verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt - 1; ++i) {
 		if (bbt[i] || bbt[i + 1])
 			continue;
-		set_random_data(writebuf, mtd->ecclayout->oobavail * 2);
+		prandom_bytes_state(&rnd_state, writebuf,
+					mtd->ecclayout->oobavail * 2);
 		addr = (i + 1) * mtd->erasesize - mtd->writesize;
 		ops.mode      = MTD_OPS_AUTO_OOB;
 		ops.len       = 0;
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

