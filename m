From: akpm@linux-foundation.org
Subject: + mtd-mtd_pagetest-convert-to-use-prandom-library.patch added to -mm tree
Date: Tue, 13 Nov 2012 11:54:50 -0800
Message-ID: <20121113195451.40FB0100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55182 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2KMTyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 14:54:52 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so38412yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 11:54:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, adrian.hunter@intel.com, david.laight@aculab.com, dedekind1@gmail.com, dwmw2@infradead.org, eilong@broadcom.com, robert.w.love@intel.com, tytso@mit.edu, valdis.kletnieks@vt.edu, walken@google.com


The patch titled
     Subject: mtd: mtd_pagetest: convert to use prandom library
has been added to the -mm tree.  Its filename is
     mtd-mtd_pagetest-convert-to-use-prandom-library.patch

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
Subject: mtd: mtd_pagetest: convert to use prandom library

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

 drivers/mtd/tests/mtd_pagetest.c |   43 ++++++++---------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff -puN drivers/mtd/tests/mtd_pagetest.c~mtd-mtd_pagetest-convert-to-use-prandom-library drivers/mtd/tests/mtd_pagetest.c
--- a/drivers/mtd/tests/mtd_pagetest.c~mtd-mtd_pagetest-convert-to-use-prandom-library
+++ a/drivers/mtd/tests/mtd_pagetest.c
@@ -29,6 +29,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 static int dev = -EINVAL;
 module_param(dev, int, S_IRUGO);
@@ -45,26 +46,7 @@ static int bufsize;
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
 
 static int erase_eraseblock(int ebnum)
 {
@@ -98,7 +80,7 @@ static int write_eraseblock(int ebnum)
 	size_t written;
 	loff_t addr = ebnum * mtd->erasesize;
 
-	set_random_data(writebuf, mtd->erasesize);
+	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	cond_resched();
 	err = mtd_write(mtd, addr, mtd->erasesize, &written, writebuf);
 	if (err || written != mtd->erasesize)
@@ -124,7 +106,7 @@ static int verify_eraseblock(int ebnum)
 	for (i = 0; i < ebcnt && bbt[ebcnt - i - 1]; ++i)
 		addrn -= mtd->erasesize;
 
-	set_random_data(writebuf, mtd->erasesize);
+	prandom_bytes_state(&rnd_state, writebuf, mtd->erasesize);
 	for (j = 0; j < pgcnt - 1; ++j, addr += pgsize) {
 		/* Do a read to set the internal dataRAMs to different data */
 		err = mtd_read(mtd, addr0, bufsize, &read, twopages);
@@ -160,7 +142,8 @@ static int verify_eraseblock(int ebnum)
 	}
 	/* Check boundary between eraseblocks */
 	if (addr <= addrn - pgsize - pgsize && !bbt[ebnum + 1]) {
-		unsigned long oldnext = next;
+		struct rnd_state old_state = rnd_state;
+
 		/* Do a read to set the internal dataRAMs to different data */
 		err = mtd_read(mtd, addr0, bufsize, &read, twopages);
 		if (mtd_is_bitflip(err))
@@ -188,13 +171,13 @@ static int verify_eraseblock(int ebnum)
 			return err;
 		}
 		memcpy(boundary, writebuf + mtd->erasesize - pgsize, pgsize);
-		set_random_data(boundary + pgsize, pgsize);
+		prandom_bytes_state(&rnd_state, boundary + pgsize, pgsize);
 		if (memcmp(twopages, boundary, bufsize)) {
 			pr_err("error: verify failed at %#llx\n",
 			       (long long)addr);
 			errcnt += 1;
 		}
-		next = oldnext;
+		rnd_state = old_state;
 	}
 	return err;
 }
@@ -326,7 +309,7 @@ static int erasecrosstest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
@@ -359,7 +342,7 @@ static int erasecrosstest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	strcpy(writebuf, "There is no data like this!");
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
@@ -417,7 +400,7 @@ static int erasetest(void)
 		return err;
 
 	pr_info("writing 1st page of block %d\n", ebnum);
-	set_random_data(writebuf, pgsize);
+	prandom_bytes_state(&rnd_state, writebuf, pgsize);
 	err = mtd_write(mtd, addr0, pgsize, &written, writebuf);
 	if (err || written != pgsize) {
 		pr_err("error: write failed at %#llx\n",
@@ -565,7 +548,7 @@ static int __init mtd_pagetest_init(void
 	pr_info("erased %u eraseblocks\n", i);
 
 	/* Write all eraseblocks */
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
 	pr_info("writing whole device\n");
 	for (i = 0; i < ebcnt; ++i) {
 		if (bbt[i])
@@ -580,7 +563,7 @@ static int __init mtd_pagetest_init(void
 	pr_info("written %u eraseblocks\n", i);
 
 	/* Check all eraseblocks */
-	simple_srand(1);
+	prandom_seed_state(&rnd_state, 1);
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

