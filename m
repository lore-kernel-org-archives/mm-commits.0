Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ED5C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E137361279
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhKEUii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15805611EE;
        Fri,  5 Nov 2021 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144557;
        bh=5z2+sfRC8ejjpEzOSr92a4X3PtVD+qQDarEhEA6O8+M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=szMOgNXbW0wH5634+zpp3IPREpaTyErXfkkNOL/KGBUP778okP7ODUFndtlFQYsS4
         WC58wytpPY9xxRLqleO2TbNnH6SZ8UEhDa3ewuGh9G4r5dhN6/lFVy4y5pHYwHtlUF
         3RFXYtGnvMWRB65dw9jbNR49VP6Rg35FaaYMFKj8=
Date:   Fri, 05 Nov 2021 13:35:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        catalin.marinas@arm.com, elver@google.com, eugenis@google.com,
        glider@google.com, linux-mm@kvack.org, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, robin.murphy@arm.com,
        torvalds@linux-foundation.org, will@kernel.org
Subject:  [patch 026/262] kasan: test: add memcpy test that avoids
 out-of-bounds write
Message-ID: <20211105203556.oqhUL-8Gp%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>
Subject: kasan: test: add memcpy test that avoids out-of-bounds write

With HW tag-based KASAN, error checks are performed implicitly by the load
and store instructions in the memcpy implementation.  A failed check
results in tag checks being disabled and execution will keep going.  As a
result, under HW tag-based KASAN, prior to commit 1b0668be62cf ("kasan:
test: disable kmalloc_memmove_invalid_size for HW_TAGS"), this memcpy
would end up corrupting memory until it hits an inaccessible page and
causes a kernel panic.

This is a pre-existing issue that was revealed by commit 285133040e6c
("arm64: Import latest memcpy()/memmove() implementation") which changed
the memcpy implementation from using signed comparisons (incorrectly,
resulting in the memcpy being terminated early for negative sizes) to
using unsigned comparisons.

It is unclear how this could be handled by memcpy itself in a reasonable
way.  One possibility would be to add an exception handler that would
force memcpy to return if a tag check fault is detected -- this would make
the behavior roughly similar to generic and SW tag-based KASAN.  However,
this wouldn't solve the problem for asynchronous mode and also makes
memcpy behavior inconsistent with manually copying data.

This test was added as a part of a series that taught KASAN to detect
negative sizes in memory operations, see commit 8cceeff48f23 ("kasan:
detect negative size in memory operation function").  Therefore we should
keep testing for negative sizes with generic and SW tag-based KASAN.  But
there is some value in testing small memcpy overflows, so let's add
another test with memcpy that does not destabilize the kernel by
performing out-of-bounds writes, and run it in all modes.

Link: https://linux-review.googlesource.com/id/I048d1e6a9aff766c4a53f989fb0c83de68923882
Link: https://lkml.kernel.org/r/20210910211356.3603758-1-pcc@google.com
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-test-add-memcpy-test-that-avoids-out-of-bounds-write
+++ a/lib/test_kasan.c
@@ -493,7 +493,7 @@ static void kmalloc_oob_in_memset(struct
 	kfree(ptr);
 }
 
-static void kmalloc_memmove_invalid_size(struct kunit *test)
+static void kmalloc_memmove_negative_size(struct kunit *test)
 {
 	char *ptr;
 	size_t size = 64;
@@ -515,6 +515,21 @@ static void kmalloc_memmove_invalid_size
 	kfree(ptr);
 }
 
+static void kmalloc_memmove_invalid_size(struct kunit *test)
+{
+	char *ptr;
+	size_t size = 64;
+	volatile size_t invalid_size = size;
+
+	ptr = kmalloc(size, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	memset((char *)ptr, 0, 64);
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		memmove((char *)ptr, (char *)ptr + 4, invalid_size));
+	kfree(ptr);
+}
+
 static void kmalloc_uaf(struct kunit *test)
 {
 	char *ptr;
@@ -1129,6 +1144,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kmalloc_oob_memset_4),
 	KUNIT_CASE(kmalloc_oob_memset_8),
 	KUNIT_CASE(kmalloc_oob_memset_16),
+	KUNIT_CASE(kmalloc_memmove_negative_size),
 	KUNIT_CASE(kmalloc_memmove_invalid_size),
 	KUNIT_CASE(kmalloc_uaf),
 	KUNIT_CASE(kmalloc_uaf_memset),
_
