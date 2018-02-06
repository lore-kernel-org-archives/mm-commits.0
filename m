From: akpm@linux-foundation.org
Subject: [folded-merged] lib-optimize-cpumask_next_and-v6.patch removed
 from -mm tree
Date: Tue, 06 Feb 2018 15:26:31 -0800
Message-ID: <5a7a39a7.xSvzeEbix8qWHvja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50164 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753653AbeBFX0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: courbet@google.com, adobriyan@gmail.com, geert@linux-m68k.org, linux@rasmusvillemoes.dk, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-optimize-cpumask_next_and-v6
has been removed from the -mm tree.  Its filename was
     lib-optimize-cpumask_next_and-v6.patch

This patch was dropped because it was folded into lib-optimize-cpumask_next_and.patch

------------------------------------------------------
From: Clement Courbet <courbet@google.com>
Subject: lib-optimize-cpumask_next_and-v6

 - Removed test for reference implementation, which was a temporary
   artifact.
 - Prettify test output.

Link: http://lkml.kernel.org/r/20171129095715.23430-1-courbet@google.com
Signed-off-by: Clement Courbet <courbet@google.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h   |    2 +-
 lib/find_bit_benchmark.c |   26 ++------------------------
 2 files changed, 3 insertions(+), 25 deletions(-)

diff -puN include/linux/bitmap.h~lib-optimize-cpumask_next_and-v6 include/linux/bitmap.h
--- a/include/linux/bitmap.h~lib-optimize-cpumask_next_and-v6
+++ a/include/linux/bitmap.h
@@ -92,7 +92,7 @@
  *                                      Position next zero bit in *addr >= bit
  *  find_next_bit(addr, nbits, bit)     Position next set bit in *addr >= bit
  *  find_next_and_bit(addr1, addr2, nbits, bit)
- *                                      Same as find_first_bit, but in
+ *                                      Same as find_next_bit, but in
  *                                      (*addr1 & *addr2)
  *
  */
diff -puN lib/find_bit_benchmark.c~lib-optimize-cpumask_next_and-v6 lib/find_bit_benchmark.c
--- a/lib/find_bit_benchmark.c~lib-optimize-cpumask_next_and-v6
+++ a/lib/find_bit_benchmark.c
@@ -114,28 +114,8 @@ static int __init test_find_next_and_bit
 	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
 		i = find_next_and_bit(bitmap, bitmap2, BITMAP_LEN, i+1);
 	cycles = get_cycles() - cycles;
-	pr_err("find_next_and_bit: %ld cycles, %ld iterations\n", (long)cycles,
-		cnt);
-
-	return 0;
-}
-
-static int __init test_find_next_and_bit_ref(const void *bitmap,
-		const void *bitmap2, unsigned long len)
-{
-	unsigned long i, cnt;
-	cycles_t cycles;
-
-	cycles = get_cycles();
-	for (cnt = i = 0; i < BITMAP_LEN; cnt++)
-		while ((i = find_next_bit(bitmap, BITMAP_LEN, i + 1))
-			< BITMAP_LEN)
-			if (test_bit(i, bitmap2))
-				break;
-
-	cycles = get_cycles() - cycles;
-	pr_err("find_next_and_bit_ref: %ld cycles, %ld iterations\n",
-		(long)cycles, cnt);
+	pr_err("find_next_and_bit:\t\t%llu cycles, %ld iterations\n",
+		(u64)cycles, cnt);
 
 	return 0;
 }
@@ -153,7 +133,6 @@ static int __init find_bit_test(void)
 	test_find_next_zero_bit(bitmap, BITMAP_LEN);
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
-	test_find_next_and_bit_ref(bitmap, bitmap2, BITMAP_LEN);
 	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	pr_err("\nStart testing find_bit() with sparse bitmap\n");
@@ -170,7 +149,6 @@ static int __init find_bit_test(void)
 	test_find_next_zero_bit(bitmap, BITMAP_LEN);
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
-	test_find_next_and_bit_ref(bitmap, bitmap2, BITMAP_LEN);
 	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	/*
_

Patches currently in -mm which might be from courbet@google.com are

lib-optimize-cpumask_next_and.patch

