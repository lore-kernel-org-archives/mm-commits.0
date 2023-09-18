Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9B4CD37B0
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 15:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239726AbjIRPWV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239739AbjIRPWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 11:22:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CF3E6C
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 08:20:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458B9C32794;
        Mon, 18 Sep 2023 15:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695049896;
        bh=BblOKfWzj5+DzmyOsuJrmfhRyprp1b1pJA2ziITjOcg=;
        h=Date:To:From:Subject:From;
        b=fqU1i3Ky1Q+XvpXkNo/oBZqbvqTFdCP2kbZo+uyEl8s9JJ95/I1sfFLKwqgjqLwjL
         4yhhmtFgoT7+1OYKfieOb8xIp8gV3D/knXnm7xRdiWq+ERjz6K0UQb+pzryllIr4wb
         tf4GrMI6lAsrbJHRInlcKlOxamik3ewhB6gIM4Es=
Date:   Mon, 18 Sep 2023 08:11:35 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, feng.tang@intel.com,
        brendan.higgins@linux.dev, ruanjinjie@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch added to mm-unstable branch
Message-Id: <20230918151136.458B9C32794@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: fix memory leak in damon_new_ctx()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch

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
Subject: mm/damon/core-test: fix memory leak in damon_new_ctx()
Date: Mon, 18 Sep 2023 20:09:51 +0800

When CONFIG_DAMON_KUNIT_TEST=y and making CONFIG_DEBUG_KMEMLEAK=y and
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y, the below memory leak is detected.

The damon_ctx which is allocated by kzalloc() in damon_new_ctx() in
damon_test_ops_registration() and damon_test_set_attrs() are not freed. 
So use damon_destroy_ctx() to free it.  After applying this patch, the
following memory leak is never detected

    unreferenced object 0xffff2b49c6968800 (size 512):
      comm "kunit_try_catch", pid 350, jiffies 4294895294 (age 557.028s)
      hex dump (first 32 bytes):
        88 13 00 00 00 00 00 00 a0 86 01 00 00 00 00 00  ................
        00 87 93 03 00 00 00 00 0a 00 00 00 00 00 00 00  ................
      backtrace:
        [<0000000088e71769>] slab_post_alloc_hook+0xb8/0x368
        [<0000000073acab3b>] __kmem_cache_alloc_node+0x174/0x290
        [<00000000b5f89cef>] kmalloc_trace+0x40/0x164
        [<00000000eb19e83f>] damon_new_ctx+0x28/0xb4
        [<00000000daf6227b>] damon_test_ops_registration+0x34/0x328
        [<00000000559c4801>] kunit_try_run_case+0x50/0xac
        [<000000003932ed49>] kunit_generic_run_threadfn_adapter+0x20/0x2c
        [<000000003c3e9211>] kthread+0x124/0x130
        [<0000000028f85bdd>] ret_from_fork+0x10/0x20
    unreferenced object 0xffff2b49c1a9cc00 (size 512):
      comm "kunit_try_catch", pid 356, jiffies 4294895306 (age 557.000s)
      hex dump (first 32 bytes):
        88 13 00 00 00 00 00 00 a0 86 01 00 00 00 00 00  ................
        00 00 00 00 00 00 00 00 0a 00 00 00 00 00 00 00  ................
      backtrace:
        [<0000000088e71769>] slab_post_alloc_hook+0xb8/0x368
        [<0000000073acab3b>] __kmem_cache_alloc_node+0x174/0x290
        [<00000000b5f89cef>] kmalloc_trace+0x40/0x164
        [<00000000eb19e83f>] damon_new_ctx+0x28/0xb4
        [<00000000058495c4>] damon_test_set_attrs+0x30/0x1a8
        [<00000000559c4801>] kunit_try_run_case+0x50/0xac
        [<000000003932ed49>] kunit_generic_run_threadfn_adapter+0x20/0x2c
        [<000000003c3e9211>] kthread+0x124/0x130
        [<0000000028f85bdd>] ret_from_fork+0x10/0x20

Link: https://lkml.kernel.org/r/20230918120951.2230468-3-ruanjinjie@huawei.com
Fixes: d1836a3b2a9a ("mm/damon/core-test: initialise context before test in damon_test_set_attrs()")
Fixes: 4f540f5ab4f2 ("mm/damon/core-test: add a kunit test case for ops registration")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-memory-leak-in-damon_new_ctx
+++ a/mm/damon/core-test.h
@@ -269,6 +269,8 @@ static void damon_test_ops_registration(
 
 	/* Check double-registration failure again */
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
+
+	damon_destroy_ctx(c);
 }
 
 static void damon_test_set_regions(struct kunit *test)
@@ -346,6 +348,8 @@ static void damon_test_set_attrs(struct
 	invalid_attrs = valid_attrs;
 	invalid_attrs.aggr_interval = 4999;
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
+
+	damon_destroy_ctx(c);
 }
 
 static void damon_test_moving_sum(struct kunit *test)
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

mm-damon-core-test-fix-memory-leak-in-damon_new_region.patch
mm-damon-core-test-fix-memory-leak-in-damon_new_ctx.patch

