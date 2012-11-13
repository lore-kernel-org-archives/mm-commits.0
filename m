From: akpm@linux-foundation.org
Subject: + mtd-mtd_subpagetest-convert-to-use-prandom-library.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:58 -0800
Message-ID: <20121113195459.8E4775C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33073 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2KMTzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:55:02 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so503164wey.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:55:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: mtd: mtd_subpagetest: convert to use prandom library
has been added to the -mm tree.  Its filename is
     mtd-mtd_subpagetest-convert-to-use-prandom-library.patch

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
Subject: mtd: mtd_subpagetest: convert to use prandom library

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

 drivers/mtd/tests/mtd_subpagetest.c |   42 +++++++-------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff -puN drivers/mtd/tests/mtd_subpagetest.c~mtd-mtd_subpagetest-convert-to-use-prandom-library drivers/mtd/tests/mtd_subpagetest.c
--- a/drivers/mtd/tests/mtd_subpagetest.c~mtd-mtd_subpagetest-convert-to-use-prandom-library
+++ a/drivers/mtd/tests/mtd_subpagetest.c
@@ -28,6 +28,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 static int dev = -EINVAL;
 module_param(dev, int, S_IRUGO);
@@ -43,26 +44,7 @@ static int bufsize;
 static int ebcnt;
 static int pgcnt;
 static int errcnt;
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
 
 static inline void clear_data(unsigned char *buf, size_t len)
 {
@@ -119,7 +101,7 @@ static int write_eraseblock(int ebnum)
 	int err = 0;
 	loff_t addr = ebnum * mtd->erasesize;
 
-	set_random_data(writebuf, subpgsize);
+	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	err = mtd_write(mtd, addr, subpgsize, &written, writebuf);
 	if (unlikely(err || written != subpgsize)) {
 		pr_err("error: write failed at %#llx\n",
@@ -133,7 +115,7 @@ static int write_eraseblock(int ebnum)
 
 	addr += subpgsize;
 
-	set_random_data(writebuf, subpgsize);
+	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	err = mtd_write(mtd, addr, subpgsize, &written, writebuf);
 	if (unlikely(err || written != subpgsize)) {
 		pr_err("error: write failed at %#llx\n",
@@ -157,7 +139,7 @@ static int write_eraseblock2(int ebnum)
 	for (k = 1; k < 33; ++k) {
 		if (addr + (subpgsize * k) > (ebnum + 1) * mtd->erasesize)
 			break;
-		set_random_data(writebuf, subpgsize * k);
+		prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
 		err = mtd_write(mtd, addr, subpgsize * k, &written, writebuf);
 		if (unlikely(err || written != subpgsize * k)) {
 			pr_err("error: write failed at %#llx\n",
@@ -193,7 +175,7 @@ static int verify_eraseblock(int ebnum)
 	int err = 0;
 	loff_t addr = ebnum * mtd->erasesize;
 
-	set_random_data(writebuf, subpgsize);
+	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	clear_data(readbuf, subpgsize);
 	err = mtd_read(mtd, addr, subpgsize, &read, readbuf);
 	if (unlikely(err || read != subpgsize)) {
@@ -220,7 +202,7 @@ static int verify_eraseblock(int ebnum)
 
 	addr += subpgsize;
 
-	set_random_data(writebuf, subpgsize);
+	prandom_bytes_state(&rnd_state, writebuf, subpgsize);
 	clear_data(readbuf, subpgsize);
 	err = mtd_read(mtd, addr, subpgsize, &read, readbuf);
 	if (unlikely(err || read != subpgsize)) {
@@ -257,7 +239,7 @@ static int verify_eraseblock2(int ebnum)
 	for (k = 1; k < 33; ++k) {
 		if (addr + (subpgsize * k) > (ebnum + 1) * mtd->erasesize)
 			break;
-		set_random_data(writebuf, subpgsize * k);
+		prandom_bytes_state(&rnd_state, writebuf, subpgsize * k);
 		clear_data(readbuf, subpgsize * k);
 		err = mtd_read(mtd, addr, subpgsize * k, &read, readbuf);
 		if (unlikely(err || read != subpgsize * k)) {
@@ -430,7 +412,7 @@ static int __init mtd_subpagetest_init(v
 		goto out;
 
 	pr_info("writing whole device\n");
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
 			continue;
@@ -443,7 +425,7 @@ static int __init mtd_subpagetest_init(v
 	}
 	pr_info("written %u eraseblocks\n", i);
 
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	pr_info("verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -466,7 +448,7 @@ static int __init mtd_subpagetest_init(v
 		goto out;
 
 	/* Write all eraseblocks */
-	simple_srand(3);
+	prandom_seed_state(&rnd_state, 3);
 	pr_info("writing whole device\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -481,7 +463,7 @@ static int __init mtd_subpagetest_init(v
 	pr_info("written %u eraseblocks\n", i);
 
 	/* Check all eraseblocks */
-	simple_srand(3);
+	prandom_seed_state(&rnd_state, 3);
 	pr_info("verifying all eraseblocks\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
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

