Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088B3CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:36:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbjJRVg5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbjJRVgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0709518E
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C34C433CB;
        Wed, 18 Oct 2023 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664927;
        bh=wo1xF+hrkv/LaHx1Bcj/6JcLL9PMo6VV9DjC2QD5Cn4=;
        h=Date:To:From:Subject:From;
        b=XJWqV1E0LpAimHFqqJd6/M2oM5S+hYwkJUQ+dkgtcNXxfslQvOuj+CfDNKpBW6yRo
         tGswT2nBJF4dguNJSNXBjAYvz8S/Gs4Z+0AgqqvZd1UwfJMlGnB59M7hurPSUJ4gcs
         ovc5HkKn2fUmBv6t2DP8sDbJGZHTO6Xzj+WJLMt4=
Date:   Wed, 18 Oct 2023 14:35:27 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch removed from -mm tree
Message-Id: <20231018213527.96C34C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: fix and update KUNIT_EXPECT_KASAN_FAIL comment
has been removed from the -mm tree.  Its filename was
     kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix and update KUNIT_EXPECT_KASAN_FAIL comment
Date: Fri, 6 Oct 2023 17:18:45 +0200

Update the comment for KUNIT_EXPECT_KASAN_FAIL to describe the parameters
this macro accepts.

Also drop the mention of the "kasan_status" KUnit resource, as it no
longer exists.

Link: https://lkml.kernel.org/r/6fad6661e72c407450ae4b385c71bc4a7e1579cd.1696605143.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308171757.7V5YUcje-lkp@intel.com/
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-fix-and-update-kunit_expect_kasan_fail-comment
+++ a/mm/kasan/kasan_test.c
@@ -91,10 +91,11 @@ static void kasan_test_exit(struct kunit
 }
 
 /**
- * KUNIT_EXPECT_KASAN_FAIL() - check that the executed expression produces a
- * KASAN report; causes a test failure otherwise. This relies on a KUnit
- * resource named "kasan_status". Do not use this name for KUnit resources
- * outside of KASAN tests.
+ * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces a
+ * KASAN report; causes a KUnit test failure otherwise.
+ *
+ * @test: Currently executing KUnit test.
+ * @expression: Expression that must produce a KASAN report.
  *
  * For hardware tag-based KASAN, when a synchronous tag fault happens, tag
  * checking is auto-disabled. When this happens, this test handler reenables
_

Patches currently in -mm which might be from andreyknvl@google.com are


