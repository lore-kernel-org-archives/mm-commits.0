Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A96AC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJRBFN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiJRBFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC97A7B2A8
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5864A6131F
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC8C433D6;
        Tue, 18 Oct 2022 01:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055104;
        bh=4e7cmyEnwJ2uwOXEaiU3EgxMCXiJQZ1ysTSLSjLsgZk=;
        h=Date:To:From:Subject:From;
        b=lgw2xTVgdM6spBpSAuLzZhgZaGNJKHgM3r5UoWPZ3R04K6fD9spK0n1D1NMph9bH2
         G4lezdCANvwlw3IZAzPOuUhrs/z53kc31Dh3jwAjCGGiIArYeo7QWSTgFhQbaTrRyX
         z+zWbYYJ4vAuUPZridwfTXI4oaW3v4tejxy4qt14=
Date:   Mon, 17 Oct 2022 18:05:04 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-migrate-workqueue_uaf-test-to-kunit.patch added to mm-unstable branch
Message-Id: <20221018010504.AEDC8C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: migrate workqueue_uaf test to kunit
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-migrate-workqueue_uaf-test-to-kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-migrate-workqueue_uaf-test-to-kunit.patch

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
Subject: kasan: migrate workqueue_uaf test to kunit
Date: Tue, 27 Sep 2022 19:09:11 +0200

Migrate the workqueue_uaf test to the KUnit framework.

Initially, this test was intended to check that Generic KASAN prints
auxiliary stack traces for workqueues.  Nevertheless, the test is enabled
for all modes to make that KASAN reports bad accesses in the tested
scenario.

The presence of auxiliary stack traces for the Generic mode needs to be
inspected manually.

Link: https://lkml.kernel.org/r/1d81b6cc2a58985126283d1e0de8e663716dd930.1664298455.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test.c        |   40 +++++++++++++++++++++++++++------
 mm/kasan/kasan_test_module.c |   30 ------------------------
 2 files changed, 33 insertions(+), 37 deletions(-)

--- a/mm/kasan/kasan_test.c~kasan-migrate-workqueue_uaf-test-to-kunit
+++ a/mm/kasan/kasan_test.c
@@ -1141,6 +1141,14 @@ static void kmalloc_double_kzfree(struct
 	KUNIT_EXPECT_KASAN_FAIL(test, kfree_sensitive(ptr));
 }
 
+/*
+ * The two tests below check that Generic KASAN prints auxiliary stack traces
+ * for RCU callbacks and workqueues. The reports need to be inspected manually.
+ *
+ * These tests are still enabled for other KASAN modes to make sure that all
+ * modes report bad accesses in tested scenarios.
+ */
+
 static struct kasan_rcu_info {
 	int i;
 	struct rcu_head rcu;
@@ -1155,13 +1163,6 @@ static void rcu_uaf_reclaim(struct rcu_h
 	((volatile struct kasan_rcu_info *)fp)->i;
 }
 
-/*
- * Check that Generic KASAN prints auxiliary stack traces for RCU callbacks.
- * The report needs to be inspected manually.
- *
- * This test is still enabled for other KASAN modes to make sure that all modes
- * report bad accesses in tested scenarios.
- */
 static void rcu_uaf(struct kunit *test)
 {
 	struct kasan_rcu_info *ptr;
@@ -1177,6 +1178,30 @@ static void rcu_uaf(struct kunit *test)
 		rcu_barrier());
 }
 
+static void workqueue_uaf_work(struct work_struct *work)
+{
+	kfree(work);
+}
+
+static void workqueue_uaf(struct kunit *test)
+{
+	struct workqueue_struct *workqueue;
+	struct work_struct *work;
+
+	workqueue = create_workqueue("kasan_workqueue_test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, workqueue);
+
+	work = kmalloc(sizeof(struct work_struct), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, work);
+
+	INIT_WORK(work, workqueue_uaf_work);
+	queue_work(workqueue, work);
+	destroy_workqueue(workqueue);
+
+	KUNIT_EXPECT_KASAN_FAIL(test,
+		((volatile struct work_struct *)work)->data);
+}
+
 static void vmalloc_helpers_tags(struct kunit *test)
 {
 	void *ptr;
@@ -1509,6 +1534,7 @@ static struct kunit_case kasan_kunit_tes
 	KUNIT_CASE(kasan_bitops_tags),
 	KUNIT_CASE(kmalloc_double_kzfree),
 	KUNIT_CASE(rcu_uaf),
+	KUNIT_CASE(workqueue_uaf),
 	KUNIT_CASE(vmalloc_helpers_tags),
 	KUNIT_CASE(vmalloc_oob),
 	KUNIT_CASE(vmap_tags),
--- a/mm/kasan/kasan_test_module.c~kasan-migrate-workqueue_uaf-test-to-kunit
+++ a/mm/kasan/kasan_test_module.c
@@ -62,35 +62,6 @@ static noinline void __init copy_user_te
 	kfree(kmem);
 }
 
-static noinline void __init kasan_workqueue_work(struct work_struct *work)
-{
-	kfree(work);
-}
-
-static noinline void __init kasan_workqueue_uaf(void)
-{
-	struct workqueue_struct *workqueue;
-	struct work_struct *work;
-
-	workqueue = create_workqueue("kasan_wq_test");
-	if (!workqueue) {
-		pr_err("Allocation failed\n");
-		return;
-	}
-	work = kmalloc(sizeof(struct work_struct), GFP_KERNEL);
-	if (!work) {
-		pr_err("Allocation failed\n");
-		return;
-	}
-
-	INIT_WORK(work, kasan_workqueue_work);
-	queue_work(workqueue, work);
-	destroy_workqueue(workqueue);
-
-	pr_info("use-after-free on workqueue\n");
-	((volatile struct work_struct *)work)->data;
-}
-
 static int __init test_kasan_module_init(void)
 {
 	/*
@@ -101,7 +72,6 @@ static int __init test_kasan_module_init
 	bool multishot = kasan_save_enable_multi_shot();
 
 	copy_user_test();
-	kasan_workqueue_uaf();
 
 	kasan_restore_multi_shot(multishot);
 	return -EAGAIN;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-switch-kunit-tests-to-console-tracepoints.patch
kasan-migrate-kasan_rcu_uaf-test-to-kunit.patch
kasan-migrate-workqueue_uaf-test-to-kunit.patch

