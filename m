From: akpm@linux-foundation.org
Subject: + lib-find_bit_benchmarkc-improvements.patch added to -mm tree
Date: Mon, 27 Nov 2017 16:19:16 -0800
Message-ID: <5a1cab84.0pbFMMO0mLVgKoNA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdK1ATR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 19:19:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ynorov@caviumnetworks.com, adobriyan@gmail.com, courbet@google.com, geert@linux-m68k.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/find_bit_benchmark.c: improvements
has been added to the -mm tree.  Its filename is
     lib-find_bit_benchmarkc-improvements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-find_bit_benchmarkc-improvements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-find_bit_benchmarkc-improvements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <ynorov@caviumnetworks.com>
Subject: lib/find_bit_benchmark.c: improvements

As suggested in review comments:
* printk: align numbers using whitespaces instead of tabs;
* return error value from init() to avoid calling rmmod if testing again;
* use ktime_get instead of get_cycles as some arches don't support it;

The output in dmesg (on QEMU arm64):
[   38.823430] Start testing find_bit() with random-filled bitmap
[   38.845358] find_next_bit:                20138448 ns, 163968 iterations
[   38.856217] find_next_zero_bit:           10615328 ns, 163713 iterations
[   38.863564] find_last_bit:                 7111888 ns, 163967 iterations
[   40.944796] find_first_bit:             2081007216 ns, 163968 iterations
[   40.944975]
[   40.944975] Start testing find_bit() with sparse bitmap
[   40.945268] find_next_bit:                   73216 ns,    656 iterations
[   40.967858] find_next_zero_bit:           22461008 ns, 327025 iterations
[   40.968047] find_last_bit:                   62320 ns,    656 iterations
[   40.978060] find_first_bit:                9889360 ns,    656 iterations

Link: http://lkml.kernel.org/r/20171124143040.a44jvhmnaiyedg2i@yury-thinkpad
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Clement Courbet <courbet@google.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/find_bit_benchmark.c |   47 ++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff -puN lib/find_bit_benchmark.c~lib-find_bit_benchmarkc-improvements lib/find_bit_benchmark.c
--- a/lib/find_bit_benchmark.c~lib-find_bit_benchmarkc-improvements
+++ a/lib/find_bit_benchmark.c
@@ -43,16 +43,15 @@ static DECLARE_BITMAP(bitmap, BITMAP_LEN
 static int __init test_find_first_bit(void *bitmap, unsigned long len)
 {
 	unsigned long i, cnt;
-	cycles_t cycles;
+	ktime_t time;
 
-	cycles = get_cycles();
+	time = ktime_get();
 	for (cnt = i = 0; i < len; cnt++) {
 		i = find_first_bit(bitmap, len);
 		__clear_bit(i, bitmap);
 	}
-	cycles = get_cycles() - cycles;
-	pr_err("find_first_bit:\t\t%llu cycles,\t%ld iterations\n",
-	       (u64)cycles, cnt);
+	time = ktime_get() - time;
+	pr_err("find_first_bit:     %18llu ns, %6ld iterations\n", time, cnt);
 
 	return 0;
 }
@@ -60,14 +59,13 @@ static int __init test_find_first_bit(vo
 static int __init test_find_next_bit(const void *bitmap, unsigned long len)
 {
 	unsigned long i, cnt;
-	cycles_t cycles;
+	ktime_t time;
 
-	cycles = get_cycles();
+	time = ktime_get();
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_bit(bitmap, BITMAP_LEN, i) + 1;
-	cycles = get_cycles() - cycles;
-	pr_err("find_next_bit:\t\t%llu cycles,\t%ld iterations\n",
-	       (u64)cycles, cnt);
+	time = ktime_get() - time;
+	pr_err("find_next_bit:      %18llu ns, %6ld iterations\n", time, cnt);
 
 	return 0;
 }
@@ -75,14 +73,13 @@ static int __init test_find_next_bit(con
 static int __init test_find_next_zero_bit(const void *bitmap, unsigned long len)
 {
 	unsigned long i, cnt;
-	cycles_t cycles;
+	ktime_t time;
 
-	cycles = get_cycles();
+	time = ktime_get();
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_zero_bit(bitmap, len, i) + 1;
-	cycles = get_cycles() - cycles;
-	pr_err("find_next_zero_bit:\t%llu cycles,\t%ld iterations\n",
-	       (u64)cycles, cnt);
+	time = ktime_get() - time;
+	pr_err("find_next_zero_bit: %18llu ns, %6ld iterations\n", time, cnt);
 
 	return 0;
 }
@@ -90,9 +87,9 @@ static int __init test_find_next_zero_bi
 static int __init test_find_last_bit(const void *bitmap, unsigned long len)
 {
 	unsigned long l, cnt = 0;
-	cycles_t cycles;
+	ktime_t time;
 
-	cycles = get_cycles();
+	time = ktime_get();
 	do {
 		cnt++;
 		l = find_last_bit(bitmap, len);
@@ -100,9 +97,8 @@ static int __init test_find_last_bit(con
 			break;
 		len = l;
 	} while (len);
-	cycles = get_cycles() - cycles;
-	pr_err("find_last_bit:\t\t%llu cycles,\t%ld iterations\n",
-	       (u64)cycles, cnt);
+	time = ktime_get() - time;
+	pr_err("find_last_bit:      %18llu ns, %6ld iterations\n", time, cnt);
 
 	return 0;
 }
@@ -132,13 +128,12 @@ static int __init find_bit_test(void)
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
 
-	return 0;
+	/*
+	 * Everything is OK. Return error just to let user run benchmark
+	 * again without annoying rmmod.
+	 */
+	return -EINVAL;
 }
 module_init(find_bit_test);
 
-static void __exit test_find_bit_cleanup(void)
-{
-}
-module_exit(test_find_bit_cleanup);
