Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80F5C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 21:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiCIVgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiCIVgY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 16:36:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CE8F9FB8
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 13:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AD78BCE1F06
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 21:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014BDC340E8;
        Wed,  9 Mar 2022 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646861722;
        bh=8IsWTzxW0HbAW4eA5bo2QfpI19ikfLdSwwWWW4IIiqA=;
        h=Date:To:From:Subject:From;
        b=gPyqmZMteY2UPOX3VvaUC7QCxbHphn8/bCfrmnirUtUmbZ3X+qQD2x17enXuEcauP
         qJtvsY3H9lGnqRVKI4STuFdRMCBD9M8PkrB42/d7nCT4YlBb8OqCFFQe3wXfGHcy9n
         u3EGgutzkRokOZq5OESo/Ylplrmhpi4TF5TDl7kU=
Date:   Wed, 09 Mar 2022 13:35:21 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch added to -mm tree
Message-Id: <20220309213522.014BDC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: fix UAF when run kfence test case test_gfpzero
has been added to the -mm tree.  Its filename is
     kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peng Liu <liupeng256@huawei.com>
Subject: kunit: fix UAF when run kfence test case test_gfpzero

Patch series "kunit: fix a UAF bug and do some optimization", v2.

This series is to fix UAF (use after free) when running kfence test case
test_gfpzero, which is time costly.  This UAF bug can be easily triggered
by setting CONFIG_KFENCE_NUM_OBJECTS = 65535.  Furthermore, some
optimization for kunit tests has been done.


This patch (of 3):

Kunit will create a new thread to run an actual test case, and the main
process will wait for the completion of the actual test thread until
overtime.  The variable "struct kunit test" has local property in function
kunit_try_catch_run, and will be used in the test case thread.  Task
kunit_try_catch_run will free "struct kunit test" when kunit runs
overtime, but the actual test case is still run and an UAF bug will be
triggered.

The above problem has been both observed in a physical machine and qemu
platform when running kfence kunit tests.  The problem can be triggered
when setting CONFIG_KFENCE_NUM_OBJECTS = 65535.  Under this setting, the
test case test_gfpzero will cost hours and kunit will run to overtime. 
The follows show the panic log.

  BUG: unable to handle page fault for address: ffffffff82d882e9

  Call Trace:
   kunit_log_append+0x58/0xd0
   ...
   test_alloc.constprop.0.cold+0x6b/0x8a [kfence_test]
   test_gfpzero.cold+0x61/0x8ab [kfence_test]
   kunit_try_run_case+0x4c/0x70
   kunit_generic_run_threadfn_adapter+0x11/0x20
   kthread+0x166/0x190
   ret_from_fork+0x22/0x30
  Kernel panic - not syncing: Fatal exception
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  Ubuntu-1.8.2-1ubuntu1 04/01/2014

To solve this problem, the test case thread should be stopped when the
kunit frame runs overtime.  The stop signal will send in function
kunit_try_catch_run, and test_gfpzero will handle it.

Link: https://lkml.kernel.org/r/20220309083753.1561921-1-liupeng256@huawei.com
Link: https://lkml.kernel.org/r/20220309083753.1561921-2-liupeng256@huawei.com
Signed-off-by: Peng Liu <liupeng256@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Wang Kefeng <wangkefeng.wang@huawei.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kunit/try-catch.c   |    1 +
 mm/kfence/kfence_test.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/lib/kunit/try-catch.c~kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero
+++ a/lib/kunit/try-catch.c
@@ -78,6 +78,7 @@ void kunit_try_catch_run(struct kunit_tr
 	if (time_remaining == 0) {
 		kunit_err(test, "try timed out\n");
 		try_catch->try_result = -ETIMEDOUT;
+		kthread_stop(task_struct);
 	}
 
 	exit_code = try_catch->try_result;
--- a/mm/kfence/kfence_test.c~kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero
+++ a/mm/kfence/kfence_test.c
@@ -623,7 +623,7 @@ static void test_gfpzero(struct kunit *t
 			break;
 		test_free(buf2);
 
-		if (i == CONFIG_KFENCE_NUM_OBJECTS) {
+		if (kthread_should_stop() || (i == CONFIG_KFENCE_NUM_OBJECTS)) {
 			kunit_warn(test, "giving up ... cannot get same object back\n");
 			return;
 		}
_

Patches currently in -mm which might be from liupeng256@huawei.com are

kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch
kunit-make-kunit_test_timeout-compatible-with-comment.patch
kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch

