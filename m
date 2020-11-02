Return-Path: <SRS0=ZqYO=EI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF22C4741F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF0FB22268
	for <mm-commits@archiver.kernel.org>; Mon,  2 Nov 2020 01:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604279260;
	bh=bOvj7+7+AanSsf8gxFsBFIfwBJI1U9IT6oGO7W9QBp4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=i268cOYdgblWQe28f0ECEcDiqibBIvEZPf2ReuFA8Vtf1Brix6CN+6gMPnsO3sZRP
	 2wOsR2vMyS8oxwFfEWbFz0BND5AGgPbdNW2yXCDo4rLYeeDsxqx3o/c9Po5Gaz1lxA
	 s8FceHIURpu7nTjAbXwqztHDMp7JKPaMRbrNXgnQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgKBBHj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 1 Nov 2020 20:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbgKBBHj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 1 Nov 2020 20:07:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB87206A4;
        Mon,  2 Nov 2020 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604279258;
        bh=bOvj7+7+AanSsf8gxFsBFIfwBJI1U9IT6oGO7W9QBp4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=o3l9ZIu7Fi+l7d4zJvPhV4XiISlcpGiSHtIAyOKX5F3MFmrrdgSFTVx+VJ7WQsBtO
         gMdgA6aXeL9LOb5fpg0QDBSS/pEJsDuDlMsaLk/tz5HKCjEKEFnJTBh4wGEAyKsBbm
         R1xyHHMfflWXuwBh5VhCJb1AMXt2e4YMIZQA2qL0=
Date:   Sun, 01 Nov 2020 17:07:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        davidgow@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 05/15] kasan: adopt KUNIT tests to SW_TAGS mode
Message-ID: <20201102010737.6S4Uo6WPN%akpm@linux-foundation.org>
In-Reply-To: <20201101170656.48abbd5e88375219f868af5e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: adopt KUNIT tests to SW_TAGS mode

Now that we have KASAN-KUNIT tests integration, it's easy to see that some
KASAN tests are not adopted to the SW_TAGS mode and are failing.

Adjust the allocation size for kasan_memchr() and kasan_memcmp() by roung
it up to OOB_TAG_OFF so the bad access ends up in a separate memory
granule.

Add a new kmalloc_uaf_16() tests that relies on UAF, and a new
kasan_bitops_tags() test that is tailored to tag-based mode, as it's hard
to adopt the existing kmalloc_oob_16() and kasan_bitops_generic() (renamed
from kasan_bitops()) without losing the precision.

Add new kmalloc_uaf_16() and kasan_bitops_uaf() tests that rely on UAFs,
as it's hard to adopt the existing kmalloc_oob_16() and kasan_bitops_oob()
(rename from kasan_bitops()) without losing the precision.

Disable kasan_global_oob() and kasan_alloca_oob_left/right() as SW_TAGS
mode doesn't instrument globals nor dynamic allocas.

Link: https://lkml.kernel.org/r/76eee17b6531ca8b3ca92b240cb2fd23204aaff7.1603129942.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |  149 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 107 insertions(+), 42 deletions(-)

--- a/lib/test_kasan.c~kasan-adopt-kunit-tests-to-sw_tags-mode
+++ a/lib/test_kasan.c
@@ -216,6 +216,12 @@ static void kmalloc_oob_16(struct kunit
 		u64 words[2];
 	} *ptr1, *ptr2;
 
+	/* This test is specifically crafted for the generic mode. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_GENERIC required\n");
+		return;
+	}
+
 	ptr1 = kmalloc(sizeof(*ptr1) - 3, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
 
@@ -227,6 +233,23 @@ static void kmalloc_oob_16(struct kunit
 	kfree(ptr2);
 }
 
+static void kmalloc_uaf_16(struct kunit *test)
+{
+	struct {
+		u64 words[2];
+	} *ptr1, *ptr2;
+
+	ptr1 = kmalloc(sizeof(*ptr1), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
+
+	ptr2 = kmalloc(sizeof(*ptr2), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
+	kfree(ptr2);
+
+	KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 = *ptr2);
+	kfree(ptr1);
+}
+
 static void kmalloc_oob_memset_2(struct kunit *test)
 {
 	char *ptr;
@@ -429,6 +452,12 @@ static void kasan_global_oob(struct kuni
 	volatile int i = 3;
 	char *p = &global_array[ARRAY_SIZE(global_array) + i];
 
+	/* Only generic mode instruments globals. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		return;
+	}
+
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
@@ -467,6 +496,12 @@ static void kasan_alloca_oob_left(struct
 	char alloca_array[i];
 	char *p = alloca_array - 1;
 
+	/* Only generic mode instruments dynamic allocas. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
 		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
 		return;
@@ -481,6 +516,12 @@ static void kasan_alloca_oob_right(struc
 	char alloca_array[i];
 	char *p = alloca_array + i;
 
+	/* Only generic mode instruments dynamic allocas. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_GENERIC required");
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_KASAN_STACK)) {
 		kunit_info(test, "CONFIG_KASAN_STACK is not enabled");
 		return;
@@ -551,6 +592,9 @@ static void kasan_memchr(struct kunit *t
 		return;
 	}
 
+	if (OOB_TAG_OFF)
+		size = round_up(size, OOB_TAG_OFF);
+
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
@@ -573,6 +617,9 @@ static void kasan_memcmp(struct kunit *t
 		return;
 	}
 
+	if (OOB_TAG_OFF)
+		size = round_up(size, OOB_TAG_OFF);
+
 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 	memset(arr, 0, sizeof(arr));
@@ -619,13 +666,50 @@ static void kasan_strings(struct kunit *
 	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = strnlen(ptr, 1));
 }
 
-static void kasan_bitops(struct kunit *test)
+static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
+{
+	KUNIT_EXPECT_KASAN_FAIL(test, set_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __set_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, clear_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __clear_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, clear_bit_unlock(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __clear_bit_unlock(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, change_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __change_bit(nr, addr));
+}
+
+static void kasan_bitops_test_and_modify(struct kunit *test, int nr, void *addr)
+{
+	KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, test_and_clear_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_clear_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
+	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result = test_bit(nr, addr));
+
+#if defined(clear_bit_unlock_is_negative_byte)
+	KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =
+				clear_bit_unlock_is_negative_byte(nr, addr));
+#endif
+}
+
+static void kasan_bitops_generic(struct kunit *test)
 {
+	long *bits;
+
+	/* This test is specifically crafted for the generic mode. */
+	if (!IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_GENERIC required\n");
+		return;
+	}
+
 	/*
 	 * Allocate 1 more byte, which causes kzalloc to round up to 16-bytes;
 	 * this way we do not actually corrupt other memory.
 	 */
-	long *bits = kzalloc(sizeof(*bits) + 1, GFP_KERNEL);
+	bits = kzalloc(sizeof(*bits) + 1, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bits);
 
 	/*
@@ -633,55 +717,34 @@ static void kasan_bitops(struct kunit *t
 	 * below accesses are still out-of-bounds, since bitops are defined to
 	 * operate on the whole long the bit is in.
 	 */
-	KUNIT_EXPECT_KASAN_FAIL(test, set_bit(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, __set_bit(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, clear_bit(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, __clear_bit(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, clear_bit_unlock(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, __clear_bit_unlock(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, change_bit(BITS_PER_LONG, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test, __change_bit(BITS_PER_LONG, bits));
+	kasan_bitops_modify(test, BITS_PER_LONG, bits);
 
 	/*
 	 * Below calls try to access bit beyond allocated memory.
 	 */
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		test_and_set_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		__test_and_set_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+	kasan_bitops_test_and_modify(test, BITS_PER_LONG + BITS_PER_BYTE, bits);
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		test_and_set_bit_lock(BITS_PER_LONG + BITS_PER_BYTE, bits));
-
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		test_and_clear_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+	kfree(bits);
+}
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		__test_and_clear_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+static void kasan_bitops_tags(struct kunit *test)
+{
+	long *bits;
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		test_and_change_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+	/* This test is specifically crafted for the tag-based mode. */
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
+		kunit_info(test, "CONFIG_KASAN_SW_TAGS required\n");
+		return;
+	}
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		__test_and_change_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+	/* Allocation size will be rounded to up granule size, which is 16. */
+	bits = kzalloc(sizeof(*bits), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, bits);
 
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_int_result =
-			test_bit(BITS_PER_LONG + BITS_PER_BYTE, bits));
+	/* Do the accesses past the 16 allocated bytes. */
+	kasan_bitops_modify(test, BITS_PER_LONG, &bits[1]);
+	kasan_bitops_test_and_modify(test, BITS_PER_LONG + BITS_PER_BYTE, &bits[1]);
 
-#if defined(clear_bit_unlock_is_negative_byte)
-	KUNIT_EXPECT_KASAN_FAIL(test,
-		kasan_int_result = clear_bit_unlock_is_negative_byte(
-			BITS_PER_LONG + BITS_PER_BYTE, bits));
-#endif
 	kfree(bits);
 }
 
@@ -728,6 +791,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_oob_krealloc_more),
 	KUNIT_CASE(kmalloc_oob_krealloc_less),
 	KUNIT_CASE(kmalloc_oob_16),
+	KUNIT_CASE(kmalloc_uaf_16),
 	KUNIT_CASE(kmalloc_oob_in_memset),
 	KUNIT_CASE(kmalloc_oob_memset_2),
 	KUNIT_CASE(kmalloc_oob_memset_4),
@@ -751,7 +815,8 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_memchr),
 	KUNIT_CASE(kasan_memcmp),
 	KUNIT_CASE(kasan_strings),
-	KUNIT_CASE(kasan_bitops),
+	KUNIT_CASE(kasan_bitops_generic),
+	KUNIT_CASE(kasan_bitops_tags),
 	KUNIT_CASE(kmalloc_double_kzfree),
 	KUNIT_CASE(vmalloc_oob),
 	{}
_
