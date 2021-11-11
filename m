Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A058DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBA361108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhKKCvR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234437AbhKKCvP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B09361108;
        Thu, 11 Nov 2021 02:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598904;
        bh=GQlBTc/7X0R+OWXzNddfidpNTSFbd90L77nOIMaCxSM=;
        h=Date:From:To:Subject:From;
        b=zNMUjvwIdA5JfoBQI2e/aGRghZibME8Mg3lxgWtwySMhQfK+0AA8vYPL7SwXKHfES
         QnBE8lnpe/SdodBeBwQNWRSks/0t7lTqBuoBDYRTqRRyURmHHjTURPWMIIUmiNEPZ9
         Ogp7kIKsWmDM8o6eBGLXeREVfdJ98+UI7uv1sZX8=
Date:   Wed, 10 Nov 2021 18:48:24 -0800
From:   akpm@linux-foundation.org
To:     davidgow@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  [merged] kfence-test-use-kunit_skip-to-skip-tests.patch
 removed from -mm tree
Message-ID: <20211111024824.N423-02NG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: use kunit_skip() to skip tests
has been removed from the -mm tree.  Its filename was
     kfence-test-use-kunit_skip-to-skip-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: test: use kunit_skip() to skip tests

Use the new kunit_skip() to skip tests if requirements were not met.  It
makes it easier to see in KUnit's summary if there were skipped tests.

Link: https://lkml.kernel.org/r/20210922182541.1372400-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/kfence/kfence_test.c~kfence-test-use-kunit_skip-to-skip-tests
+++ a/mm/kfence/kfence_test.c
@@ -32,6 +32,11 @@
 #define arch_kfence_test_address(addr) (addr)
 #endif
 
+#define KFENCE_TEST_REQUIRES(test, cond) do {			\
+	if (!(cond))						\
+		kunit_skip((test), "Test requires: " #cond);	\
+} while (0)
+
 /* Report as observed from console. */
 static struct {
 	spinlock_t lock;
@@ -555,8 +560,7 @@ static void test_init_on_free(struct kun
 	};
 	int i;
 
-	if (!IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON))
-		return;
+	KFENCE_TEST_REQUIRES(test, IS_ENABLED(CONFIG_INIT_ON_FREE_DEFAULT_ON));
 	/* Assume it hasn't been disabled on command line. */
 
 	setup_test_cache(test, size, 0, NULL);
@@ -603,10 +607,8 @@ static void test_gfpzero(struct kunit *t
 	char *buf1, *buf2;
 	int i;
 
-	if (CONFIG_KFENCE_SAMPLE_INTERVAL > 100) {
-		kunit_warn(test, "skipping ... would take too long\n");
-		return;
-	}
+	/* Skip if we think it'd take too long. */
+	KFENCE_TEST_REQUIRES(test, CONFIG_KFENCE_SAMPLE_INTERVAL <= 100);
 
 	setup_test_cache(test, size, 0, NULL);
 	buf1 = test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY);
_

Patches currently in -mm which might be from elver@google.com are


