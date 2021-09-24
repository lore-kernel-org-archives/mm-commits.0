Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64839C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D7666103D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 02:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243877AbhIXCaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Sep 2021 22:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233335AbhIXCaT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Sep 2021 22:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB5B860F4B;
        Fri, 24 Sep 2021 02:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632450526;
        bh=b77+o4YCzJhHiPUQpVj9r3Q6nuNa/y4/pza7Bnor+VU=;
        h=Date:From:To:Subject:From;
        b=HjrQmPkDosV8BROAGEj30CknFk1DleiK3pDxab5NX5VNRv9ntg/Q3S1H9YOdmfmx0
         1cFpeFY5dl5/sMa+/y6JWAbc/3h/OB4ZxQlqN+UOPw+IKSliyfjNzyBCsFAdHGMyIG
         wLDmuhe2Y6OOVhkMZ2lFMiB7Un/8Xdgr+EpMYSs0=
Date:   Thu, 23 Sep 2021 19:28:46 -0700
From:   akpm@linux-foundation.org
To:     davidgow@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject:  + kfence-test-use-kunit_skip-to-skip-tests.patch added to
 -mm tree
Message-ID: <20210924022846.KDFAMjZbF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: use kunit_skip() to skip tests
has been added to the -mm tree.  Its filename is
     kfence-test-use-kunit_skip-to-skip-tests.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-test-use-kunit_skip-to-skip-tests.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-test-use-kunit_skip-to-skip-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch
stacktrace-move-filter_irq_stacks-to-kernel-stacktracec.patch
kfence-count-unexpectedly-skipped-allocations.patch
kfence-move-saving-stack-trace-of-allocations-into-__kfence_alloc.patch
kfence-limit-currently-covered-allocations-when-pool-nearly-full.patch
kfence-add-note-to-documentation-about-skipping-covered-allocations.patch
kfence-test-use-kunit_skip-to-skip-tests.patch

