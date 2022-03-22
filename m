Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00C1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiCVVt7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiCVVts (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CA6F51
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 527E7B81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BBDC340EC;
        Tue, 22 Mar 2022 21:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985697;
        bh=1SzSqyKKcHEJ9DMHDkyZiaGv+c9q1oyFNVD1PLarfDM=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=CsXzAp9QkWuWMMTF8MEOWhixZZ9yOHmwaBa6N24TV6SJkLBLKpfan2NlDDrP//W47
         OLZgj4nckZR+gT01XaU6pE2kzhqQ5x3Ln1nDCQrU0BZAq5zbckuGXV3atfHrun0NA1
         1lGBLW7id6mWU3juGtfBcYjUjUhvJxogfPLB/0JE=
Date:   Tue, 22 Mar 2022 14:48:16 -0700
To:     wangkefeng.wang@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 192/227] kunit: fix UAF when run kfence test case test_gfpzero
Message-Id: <20220322214817.09BBDC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
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
