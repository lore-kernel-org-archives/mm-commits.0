Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2ECC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61437610F7
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhKKCnT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhKKCnT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFF0661284;
        Thu, 11 Nov 2021 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598431;
        bh=mlx71nQ+FRTACd9tDuU2ogxouCgXnUX5TORnTFuiqwo=;
        h=Date:From:To:Subject:From;
        b=QkNFhhjyvr/FvEy4bjvSG7LO75cH2A68Z092gaV1YVFHjFfXiXCUCcOxgnbHHq0Ep
         o85V3lh7T4lsustqqBLvdDmJR8PQTzeA5vVXhtib1Xf3Va2UX7ZjSsuBMNBNvE67zU
         aHx7nufza2HEVZ8TTziiSqJphQaHpBynu5YqhjMw=
Date:   Wed, 10 Nov 2021 18:40:30 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, catalin.marinas@arm.com, elver@google.com,
        eugenis@google.com, glider@google.com, mark.rutland@arm.com,
        mm-commits@vger.kernel.org, pcc@google.com, robin.murphy@arm.com,
        will@kernel.org
Subject:  [merged]
 kasan-test-add-memcpy-test-that-avoids-out-of-bounds-write.patch removed
 from -mm tree
Message-ID: <20211111024030.J3WwC7VEM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: test: add memcpy test that avoids out-of-bounds write
has been removed from the -mm tree.  Its filename was
     kasan-test-add-memcpy-test-that-avoids-out-of-bounds-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from pcc@google.com are


