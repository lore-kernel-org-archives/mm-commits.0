Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F026C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18019611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbhIIVGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346197AbhIIVFi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A58161179;
        Thu,  9 Sep 2021 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221468;
        bh=YFoXdBBUbzYUydDf4MfCDLqcbtrjUpVmbYZTnJ0JAms=;
        h=Date:From:To:Subject:From;
        b=R9gdlPVo+4nr8phhWHoapOBl5MVrZ/O1FZdAkolyfj0AeQpnSNPkq9wxLRgcHRMzM
         pc8D0m0F+Oqyj/BeNA/HJcBvgnvS+xaawkMK4+gXdeOBGTIn4o1H+XQU0UXE0uplwI
         5zi9RCCf+GKfNtynkJ/vjS85SPqtaMhVr7pT8JRA=
Date:   Thu, 09 Sep 2021 14:04:28 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [merged] lib-add-find_first_and_bit.patch removed from
 -mm tree
Message-ID: <20210909210428.3T14BTTbE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add find_first_and_bit()
has been removed from the -mm tree.  Its filename was
     lib-add-find_first_and_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: lib: add find_first_and_bit()

Currently find_first_and_bit() is an alias to find_next_and_bit(). 
However, it is widely used in cpumask, so it worth to optimize it.  This
patch adds its own implementation for find_first_and_bit().

On x86_64 find_bit_benchmark says:

Before (#define find_first_and_bit(...) find_next_and_bit(..., 0):
Start testing find_bit() with random-filled bitmap
[  140.291468] find_first_and_bit:           46890919 ns,  32671 iterations
Start testing find_bit() with sparse bitmap
[  140.295028] find_first_and_bit:               7103 ns,      1 iterations

After:
Start testing find_bit() with random-filled bitmap
[  162.574907] find_first_and_bit:           25045813 ns,  32846 iterations
Start testing find_bit() with sparse bitmap
[  162.578458] find_first_and_bit:               4900 ns,      1 iterations

(Thanks to Alexey Klimov for thorough testing.)

Link: https://lkml.kernel.org/r/20210814211713.180533-6-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Alexey Klimov <aklimov@redhat.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/find.h     |   27 +++++++++++++++++++++++++++
 lib/find_bit.c           |   21 +++++++++++++++++++++
 lib/find_bit_benchmark.c |   21 +++++++++++++++++++++
 3 files changed, 69 insertions(+)

--- a/include/linux/find.h~lib-add-find_first_and_bit
+++ a/include/linux/find.h
@@ -12,6 +12,8 @@ extern unsigned long _find_next_bit(cons
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_and_bit(const unsigned long *addr1,
+					 const unsigned long *addr2, unsigned long size);
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
 extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
 
@@ -123,6 +125,31 @@ unsigned long find_first_bit(const unsig
 }
 #endif
 
+#ifndef find_first_and_bit
+/**
+ * find_first_and_bit - find the first set bit in both memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_first_and_bit(const unsigned long *addr1,
+				 const unsigned long *addr2,
+				 unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr1 & *addr2 & GENMASK(size - 1, 0);
+
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_first_and_bit(addr1, addr2, size);
+}
+#endif
+
 #ifndef find_first_zero_bit
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
--- a/lib/find_bit_benchmark.c~lib-add-find_first_and_bit
+++ a/lib/find_bit_benchmark.c
@@ -49,6 +49,25 @@ static int __init test_find_first_bit(vo
 	return 0;
 }
 
+static int __init test_find_first_and_bit(void *bitmap, const void *bitmap2, unsigned long len)
+{
+	static DECLARE_BITMAP(cp, BITMAP_LEN) __initdata;
+	unsigned long i, cnt;
+	ktime_t time;
+
+	bitmap_copy(cp, bitmap, BITMAP_LEN);
+
+	time = ktime_get();
+	for (cnt = i = 0; i < len; cnt++) {
+		i = find_first_and_bit(cp, bitmap2, len);
+		__clear_bit(i, cp);
+	}
+	time = ktime_get() - time;
+	pr_err("find_first_and_bit: %18llu ns, %6ld iterations\n", time, cnt);
+
+	return 0;
+}
+
 static int __init test_find_next_bit(const void *bitmap, unsigned long len)
 {
 	unsigned long i, cnt;
@@ -129,6 +148,7 @@ static int __init find_bit_test(void)
 	 * traverse only part of bitmap to avoid soft lockup.
 	 */
 	test_find_first_bit(bitmap, BITMAP_LEN / 10);
+	test_find_first_and_bit(bitmap, bitmap2, BITMAP_LEN / 2);
 	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	pr_err("\nStart testing find_bit() with sparse bitmap\n");
@@ -145,6 +165,7 @@ static int __init find_bit_test(void)
 	test_find_next_zero_bit(bitmap, BITMAP_LEN);
 	test_find_last_bit(bitmap, BITMAP_LEN);
 	test_find_first_bit(bitmap, BITMAP_LEN);
+	test_find_first_and_bit(bitmap, bitmap2, BITMAP_LEN);
 	test_find_next_and_bit(bitmap, bitmap2, BITMAP_LEN);
 
 	/*
--- a/lib/find_bit.c~lib-add-find_first_and_bit
+++ a/lib/find_bit.c
@@ -89,6 +89,27 @@ unsigned long _find_first_bit(const unsi
 EXPORT_SYMBOL(_find_first_bit);
 #endif
 
+#ifndef find_first_and_bit
+/*
+ * Find the first set bit in two memory regions.
+ */
+unsigned long _find_first_and_bit(const unsigned long *addr1,
+				  const unsigned long *addr2,
+				  unsigned long size)
+{
+	unsigned long idx, val;
+
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		val = addr1[idx] & addr2[idx];
+		if (val)
+			return min(idx * BITS_PER_LONG + __ffs(val), size);
+	}
+
+	return size;
+}
+EXPORT_SYMBOL(_find_first_and_bit);
+#endif
+
 #ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
_

Patches currently in -mm which might be from yury.norov@gmail.com are


