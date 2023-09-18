Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A765CC46CA1
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 15:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjIRPSu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjIRPSt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 11:18:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16A21707
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 08:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BBCC32793;
        Mon, 18 Sep 2023 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695049894;
        bh=FKKnM+rD4IbWcm7qto3J0FwACCEKr2OP28HIhK+guI0=;
        h=Date:To:From:Subject:From;
        b=QmQ9EEDwQKJ9WQ3VscDxdOXTI8Y9fWLSJBpkiOCs63WZVL5ncXuDAMERIc0IO43Rs
         NmUxg+KhtPwL/TSHGtOGazORU5I6rm3pnKRApvzsWE+YDhwZ4O5Iy4RRcN5Xfw1nny
         9RaZEFgt9WCB3LETmt3wkOjNQaBKdPWfW+IEswRo=
Date:   Mon, 18 Sep 2023 08:11:33 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, feng.tang@intel.com,
        brendan.higgins@linux.dev, ruanjinjie@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch added to mm-unstable branch
Message-Id: <20230918151134.55BBCC32793@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: fix memory leak in damon_new_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch

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
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: mm/damon/core-test: fix memory leak in damon_new_region()
Date: Mon, 18 Sep 2023 20:09:50 +0800

Patch series "mm/damon/core-test: Fix memory leaks in core-test", v3.

There are a few memory leaks in core-test which are detected by kmemleak. 
This patchset fixes the issues.


This patch (of 2):

When CONFIG_DAMON_KUNIT_TEST=y and making CONFIG_DEBUG_KMEMLEAK=y
and CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y, the below memory leak is detected.

The damon_region which is allocated by kmem_cache_alloc() in
damon_new_region() in damon_test_regions() and
damon_test_update_monitoring_result() are not freed.

So for damon_test_regions(), replace damon_del_region() call with
damon_destroy_region() so that it calls both damon_del_region() and
damon_free_region(), the latter will free the damon_region. For
damon_test_update_monitoring_result(), call damon_free_region() to
free it. After applying this patch, the following memory leak is never
detected.

    unreferenced object 0xffff2b49c3edc000 (size 56):
      comm "kunit_try_catch", pid 338, jiffies 4294895280 (age 557.084s)
      hex dump (first 32 bytes):
        01 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 00 00 00 00 49 2b ff ff  ............I+..
      backtrace:
        [<0000000088e71769>] slab_post_alloc_hook+0xb8/0x368
        [<00000000b528f67c>] kmem_cache_alloc+0x168/0x284
        [<000000008603f022>] damon_new_region+0x28/0x54
        [<00000000a3b8c64e>] damon_test_regions+0x38/0x270
        [<00000000559c4801>] kunit_try_run_case+0x50/0xac
        [<000000003932ed49>] kunit_generic_run_threadfn_adapter+0x20/0x2c
        [<000000003c3e9211>] kthread+0x124/0x130
        [<0000000028f85bdd>] ret_from_fork+0x10/0x20
    unreferenced object 0xffff2b49c5b20000 (size 56):
      comm "kunit_try_catch", pid 354, jiffies 4294895304 (age 556.988s)
      hex dump (first 32 bytes):
        03 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 96 00 00 00 49 2b ff ff  ............I+..
      backtrace:
        [<0000000088e71769>] slab_post_alloc_hook+0xb8/0x368
        [<00000000b528f67c>] kmem_cache_alloc+0x168/0x284
        [<000000008603f022>] damon_new_region+0x28/0x54
        [<00000000ca019f80>] damon_test_update_monitoring_result+0x18/0x34
        [<00000000559c4801>] kunit_try_run_case+0x50/0xac
        [<000000003932ed49>] kunit_generic_run_threadfn_adapter+0x20/0x2c
        [<000000003c3e9211>] kthread+0x124/0x130
        [<0000000028f85bdd>] ret_from_fork+0x10/0x20

Link: https://lkml.kernel.org/r/20230918120951.2230468-1-ruanjinjie@huawei.com
Link: https://lkml.kernel.org/r/20230918120951.2230468-2-ruanjinjie@huawei.com
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Fixes: f4c978b6594b ("mm/damon/core-test: add a test for damon_update_monitoring_results()")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-memory-leak-in-damon_new_region
+++ a/mm/damon/core-test.h
@@ -30,7 +30,7 @@ static void damon_test_regions(struct ku
 	damon_add_region(r, t);
 	KUNIT_EXPECT_EQ(test, 1u, damon_nr_regions(t));
 
-	damon_del_region(r, t);
+	damon_destroy_region(r, t);
 	KUNIT_EXPECT_EQ(test, 0u, damon_nr_regions(t));
 
 	damon_free_target(t);
@@ -321,6 +321,8 @@ static void damon_test_update_monitoring
 	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 20);
+
+	damon_free_region(r);
 }
 
 static void damon_test_set_attrs(struct kunit *test)
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch
mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch

