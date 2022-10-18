Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF76DC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiJRBFL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiJRBFK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:05:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7FF7B29B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2505BCE1ACC
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6136CC433D6;
        Tue, 18 Oct 2022 01:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055102;
        bh=5csbfXSLT6O9QYdj1t9zcIKufyCAinbUHLFAI+qSy/k=;
        h=Date:To:From:Subject:From;
        b=wzNq0OCh6AjwxVRz7OG1NWwqSaGwBIThdgE3EpYNEEvnXxqa3VywEoQDAWTYJc2b4
         6hrE28tscWtXBfsPqU0XoGgLCn8ybge4lnCOtPrAohiRaCZ13KlALS9baRxnGzotH/
         VSuDLBoiA5nviolwLF/b703veiaXstt5wmA6p108=
Date:   Mon, 17 Oct 2022 18:05:01 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch added to mm-unstable branch
Message-Id: <20221018010502.6136CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: migrate kasan_rcu_uaf test to kunit
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch

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
Subject: kasan: migrate kasan_rcu_uaf test to kunit
Date: Tue, 27 Sep 2022 19:09:10 +0200

Migrate the kasan_rcu_uaf test to the KUnit framework.

Changes to the implementation of the test:

- Call rcu_barrier() after call_rcu() to make that the RCU callbacks get
  triggered before the test is over.

- Cast pointer passed to rcu_dereference_protected as __rcu to get rid of
  the Sparse warning.

- Check that KASAN prints a report via KUNIT_EXPECT_KASAN_FAIL.

Initially, this test was intended to check that Generic KASAN prints
auxiliary stack traces for RCU objects. Nevertheless, the test is enabled
for all modes to make that KASAN reports bad accesses in RCU callbacks.

The presence of auxiliary stack traces for the Generic mode needs to be
inspected manually.

Link: https://lkml.kernel.org/r/897ee08d6cd0ba7e8a4fbfd9d8502823a2f922e6.1664298455.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c        |   37 +++++++++++++++++++++++++++++++++
 mm/kasan/kasan_test_module.c |   30 --------------------------
 2 files changed, 37 insertions(+), 30 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-migrate-kasan_rcu_uaf-test-to-kunit
+++ a/mm/kasan/kasan_test.c
@@ -1141,6 +1141,42 @@ static void kmalloc_double_kzfree(struct
 	KUNIT_EXPECT_KASAN_FAIL(test, kfree_sensitive(ptr));
 }
 
+static struct kasan_rcu_info {
+	int i;
+	struct rcu_head rcu;
+} *global_rcu_ptr;
+
+static void rcu_uaf_reclaim(struct rcu_head *rp)
+{
+	struct kasan_rcu_info *fp =
+		container_of(rp, struct kasan_rcu_info, rcu);
+
+	kfree(fp);
+	((volatile struct kasan_rcu_info *)fp)->i;
+}
+
+/*
+ * Check that Generic KASAN prints auxiliary stack traces for RCU callbacks.
+ * The report needs to be inspected manually.
+ *
+ * This test is still enabled for other KASAN modes to make sure that all modes
+ * report bad accesses in tested scenarios.
+ */
+static void rcu_uaf(struct kunit *test)
+{
+	struct kasan_rcu_info *ptr;
+
+	ptr = kmalloc(sizeof(struct kasan_rcu_info), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
+	global_rcu_ptr = rcu_dereference_protected(
+				(struct kasan_rcu_info __rcu *)ptr, NULL);
+
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
+		rcu_barrier());
+}
+
 static void vmalloc_helpers_tags(struct kunit *test)
 {
 	void *ptr;
@@ -1472,6 +1508,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_bitops_generic),
 	KUNIT_CASE(kasan_bitops_tags),
 	KUNIT_CASE(kmalloc_double_kzfree),
+	KUNIT_CASE(rcu_uaf),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
--- a/mm/kasan/kasan_test_module.c~kasan-migrate-kasan_rcu_uaf-test-to-kunit
+++ a/mm/kasan/kasan_test_module.c
@@ -62,35 +62,6 @@ static noinline void __init copy_user_te
 	kfree(kmem);
 }
 
-static struct kasan_rcu_info {
-	int i;
-	struct rcu_head rcu;
-} *global_rcu_ptr;
-
-static noinline void __init kasan_rcu_reclaim(struct rcu_head *rp)
-{
-	struct kasan_rcu_info *fp = container_of(rp,
-						struct kasan_rcu_info, rcu);
-
-	kfree(fp);
-	((volatile struct kasan_rcu_info *)fp)->i;
-}
-
-static noinline void __init kasan_rcu_uaf(void)
-{
-	struct kasan_rcu_info *ptr;
-
-	pr_info("use-after-free in kasan_rcu_reclaim\n");
-	ptr = kmalloc(sizeof(struct kasan_rcu_info), GFP_KERNEL);
-	if (!ptr) {
-		pr_err("Allocation failed\n");
-		return;
-	}
-
-	global_rcu_ptr = rcu_dereference_protected(ptr, NULL);
-	call_rcu(&global_rcu_ptr->rcu, kasan_rcu_reclaim);
-}
-
 static noinline void __init kasan_workqueue_work(struct work_struct *work)
 {
 	kfree(work);
@@ -130,7 +101,6 @@ static int __init test_kasan_module_init
 	bool multishot = kasan_save_enable_multi_shot();
 
 	copy_user_test();
-	kasan_rcu_uaf();
 	kasan_workqueue_uaf();
 
 	kasan_restore_multi_shot(multishot);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-switch-kunit-tests-to-console-tracepoints.patch
kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch
kasan-migrate-workqueue_uaf-test-to-kunit.patch

