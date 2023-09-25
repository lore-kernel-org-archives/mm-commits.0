Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3722DCE7A81
	for <mm-commits@archiver.kernel.org>; Mon, 25 Sep 2023 15:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjIYPO6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Sep 2023 11:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjIYPO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2023 11:14:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681FCFF
        for <mm-commits@vger.kernel.org>; Mon, 25 Sep 2023 08:14:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC64BC433C9;
        Mon, 25 Sep 2023 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695654891;
        bh=2Zl1yfsfwC1Gz0Ri89EbqX1ObJHm1Y+GhUF8aOlngBw=;
        h=Date:To:From:Subject:From;
        b=vyUf5vE000GoGCdZgyfxTgZK2usQct2G8yUY+Khq6hQLMKApDK+MJWYnngcOVn03k
         eWr5ArJSxzXjxvWtswTFohqLVfTXLlONksqQj+slKTlDYtsuBhZGAhCn9toGDvNWG3
         TW+Mzr97HorWgLfd9QZKeHUpxxECb1eKCXMc0cGk=
Date:   Mon, 25 Sep 2023 08:14:50 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, ruanjinjie@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-test-fix-memory-leak-in-damon_do_test_apply_three_regions.patch added to mm-hotfixes-unstable branch
Message-Id: <20230925151450.EC64BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr-test: fix memory leak in damon_do_test_apply_three_regions()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-vaddr-test-fix-memory-leak-in-damon_do_test_apply_three_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-test-fix-memory-leak-in-damon_do_test_apply_three_regions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/vaddr-test: fix memory leak in damon_do_test_apply_three_regions()
Date: Mon, 25 Sep 2023 15:20:59 +0800

When CONFIG_DAMON_VADDR_KUNIT_TEST=y and making CONFIG_DEBUG_KMEMLEAK=y
and CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y, the below memory leak is detected.

Since commit 9f86d624292c ("mm/damon/vaddr-test: remove unnecessary
variables"), the damon_destroy_ctx() is removed, but still call
damon_new_target() and damon_new_region(), the damon_region which is
allocated by kmem_cache_alloc() in damon_new_region() and the damon_target
which is allocated by kmalloc in damon_new_target() are not freed.  And
the damon_region which is allocated in damon_new_region() in
damon_set_regions() is also not freed.

So use damon_destroy_target to free all the damon_regions and damon_target.

    unreferenced object 0xffff888107c9a940 (size 64):
      comm "kunit_try_catch", pid 1069, jiffies 4294670592 (age 732.761s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        60 c7 9c 07 81 88 ff ff f8 cb 9c 07 81 88 ff ff  `...............
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c82be>] damon_test_apply_three_regions1+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff8881079cc740 (size 56):
      comm "kunit_try_catch", pid 1069, jiffies 4294670592 (age 732.761s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c82be>] damon_test_apply_three_regions1+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888107c9ac40 (size 64):
      comm "kunit_try_catch", pid 1071, jiffies 4294670595 (age 732.843s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        a0 cc 9c 07 81 88 ff ff 78 a1 76 07 81 88 ff ff  ........x.v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c851e>] damon_test_apply_three_regions2+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff8881079ccc80 (size 56):
      comm "kunit_try_catch", pid 1071, jiffies 4294670595 (age 732.843s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c851e>] damon_test_apply_three_regions2+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888107c9af40 (size 64):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.011s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 06 00 00 00 6b 6b 6b 6b  ............kkkk
        20 a2 76 07 81 88 ff ff b8 a6 76 07 81 88 ff ff   .v.......v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776a200 (size 56):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.011s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 14 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819c7d91>] damon_do_test_apply_three_regions.constprop.0+0xd1/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776a740 (size 56):
      comm "kunit_try_catch", pid 1073, jiffies 4294670597 (age 733.025s)
      hex dump (first 32 bytes):
        3d 00 00 00 00 00 00 00 3f 00 00 00 00 00 00 00  =.......?.......
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819bfcc2>] damon_set_regions+0x4c2/0x8e0
        [<ffffffff819c7dbb>] damon_do_test_apply_three_regions.constprop.0+0xfb/0x3e0
        [<ffffffff819c877e>] damon_test_apply_three_regions3+0x21e/0x260
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff888108038240 (size 64):
      comm "kunit_try_catch", pid 1075, jiffies 4294670600 (age 733.022s)
      hex dump (first 32 bytes):
        00 00 00 00 00 00 00 00 03 00 00 00 6b 6b 6b 6b  ............kkkk
        48 ad 76 07 81 88 ff ff 98 ae 76 07 81 88 ff ff  H.v.......v.....
      backtrace:
        [<ffffffff817e0167>] kmalloc_trace+0x27/0xa0
        [<ffffffff819c11cf>] damon_new_target+0x3f/0x1b0
        [<ffffffff819c7d55>] damon_do_test_apply_three_regions.constprop.0+0x95/0x3e0
        [<ffffffff819c898d>] damon_test_apply_three_regions4+0x1cd/0x210
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20
    unreferenced object 0xffff88810776ad28 (size 56):
      comm "kunit_try_catch", pid 1075, jiffies 4294670600 (age 733.022s)
      hex dump (first 32 bytes):
        05 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00  ................
        6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b  kkkkkkkk....kkkk
      backtrace:
        [<ffffffff819bc492>] damon_new_region+0x22/0x1c0
        [<ffffffff819bfcc2>] damon_set_regions+0x4c2/0x8e0
        [<ffffffff819c7dbb>] damon_do_test_apply_three_regions.constprop.0+0xfb/0x3e0
        [<ffffffff819c898d>] damon_test_apply_three_regions4+0x1cd/0x210
        [<ffffffff829fce6a>] kunit_generic_run_threadfn_adapter+0x4a/0x90
        [<ffffffff81237cf6>] kthread+0x2b6/0x380
        [<ffffffff81097add>] ret_from_fork+0x2d/0x70
        [<ffffffff81003791>] ret_from_fork_asm+0x11/0x20

Link: https://lkml.kernel.org/r/20230925072100.3725620-1-ruanjinjie@huawei.com
Fixes: 9f86d624292c ("mm/damon/vaddr-test: remove unnecessary variables")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-test-fix-memory-leak-in-damon_do_test_apply_three_regions
+++ a/mm/damon/vaddr-test.h
@@ -148,6 +148,8 @@ static void damon_do_test_apply_three_re
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
+
+	damon_destroy_target(t);
 }
 
 /*
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

mm-damon-vaddr-test-fix-memory-leak-in-damon_do_test_apply_three_regions.patch
mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch
mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch

