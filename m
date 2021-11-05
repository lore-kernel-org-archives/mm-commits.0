Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F24CC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E1A361373
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhKEUsW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233806AbhKEUsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B43036135A;
        Fri,  5 Nov 2021 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145141;
        bh=AksBvyK2+J34v4VU0G9t1Lm0wLcMVV2rPzybMUopnnY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eytZhVn53WoDNgyMUiTnmjfTPo13aa30BkLk2zUIVcgpgcmUYVthZcZuNZGZagcmV
         qWRcUiVdBELmqrn7QaC6UYL6COkPYWOA/5YbhnQVaDrpFs+XgU+KM/TtN96q/Pv2EG
         bF8J4/M6FlZgWeqxueZVjaconyfDJTsfGS0ELkxc=
Date:   Fri, 05 Nov 2021 13:45:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, davidgow@google.com, dvyukov@google.com,
        elver@google.com, glider@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com, torvalds@linux-foundation.org
Subject:  [patch 210/262] kfence: test: use kunit_skip() to skip
 tests
Message-ID: <20211105204540.jMRK9-vcN%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
