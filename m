Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BC2E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjJFTSI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjJFTSH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22736A2
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D54EC433C7;
        Fri,  6 Oct 2023 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619885;
        bh=otIuV7W0asO7ywZI+h9r9uQa7Gzqh4W06J7Fj3q6duA=;
        h=Date:To:From:Subject:From;
        b=KaoMqf+CZjN5Hm3+jTIIR5scpUtIPoz4B/ch8k+ojzjrT3rLt/l0JZQuO4BOJeBL4
         UojrRC45Bdae2SKUszNyroIrPcX11AVjHCrvgOimDMgpZXoexhjSQqEvlqOjSNLnS+
         P3KmzIDhN1SKx3SuGvEU/CNC3hFrPZ77MuEcD4rc=
Date:   Fri, 06 Oct 2023 12:18:03 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch added to mm-unstable branch
Message-Id: <20231006191805.6D54EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix and update KUNIT_EXPECT_KASAN_FAIL comment
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
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

arm64-kasan-update-comment-in-kasan_init.patch
kasan-unify-printk-prefixes.patch
kasan-use-unchecked-__memset-internally.patch
kasan-fix-and-update-kunit_expect_kasan_fail-comment.patch
documentation-san-drop-the-from-article-titles.patch

