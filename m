Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368A5C0015E
	for <mm-commits@archiver.kernel.org>; Tue, 18 Jul 2023 17:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjGRRKr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Jul 2023 13:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjGRRKr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2023 13:10:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F62CC
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 10:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F41C61666
        for <mm-commits@vger.kernel.org>; Tue, 18 Jul 2023 17:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D309C433C8;
        Tue, 18 Jul 2023 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689700244;
        bh=fZNxSwhb0DLv+Hrq/pkQOMh91OeymlThhKUjZISi6VA=;
        h=Date:To:From:Subject:From;
        b=XXOWFUL2Y+2nA5fnIx8O0FYhrwMDlec3vu6K+WA4uQFq0sj/11y1Rq+ucwyVd4Dt3
         2Pwf6FRwzMO1C5sM+CTPZtG517KFuvpUqlWCkOVdbKgRGzL+5b5tQE6EXoOTtl9NZA
         37z98zmO5iyi+cIzZOkxTtsl41NyuJLe+SrTcAWM=
Date:   Tue, 18 Jul 2023 10:10:43 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, feng.tang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-initialise-context-before-test-in-damon_test_set_attrs.patch added to mm-hotfixes-unstable branch
Message-Id: <20230718171044.7D309C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: initialise context before test in damon_test_set_attrs()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-test-initialise-context-before-test-in-damon_test_set_attrs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-initialise-context-before-test-in-damon_test_set_attrs.patch

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
From: Feng Tang <feng.tang@intel.com>
Subject: mm/damon/core-test: initialise context before test in damon_test_set_attrs()
Date: Tue, 18 Jul 2023 13:28:11 +0800

Running kunit test for 6.5-rc1 hits one bug:

        ok 10 damon_test_update_monitoring_result
    general protection fault, probably for non-canonical address 0x1bffa5c419cfb81: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 1 PID: 110 Comm: kunit_try_catch Tainted: G                 N 6.5.0-rc2 #15
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
    RIP: 0010:damon_set_attrs+0xb9/0x120
    Code: f8 00 00 00 4c 8d 58 e0 48 39 c3 74 ba 41 ba 59 17 b7 d1 49 8b 43 10 4d
    8d 4b 10 48 8d 70 e0 49 39 c1 74 50 49 8b 40 08 31 d2 <69> 4e 18 10 27 00 00
    49 f7 30 31 d2 48 89 c5 89 c8 f7 f5 31 d2 89
    RSP: 0000:ffffc900005bfd40 EFLAGS: 00010246
    RAX: ffffffff81159fc0 RBX: ffffc900005bfeb8 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 01bffa5c419cfb69 RDI: ffffc900005bfd70
    RBP: ffffc90000013c10 R08: ffffc900005bfdc0 R09: ffffffff81ff10ed
    R10: 00000000d1b71759 R11: ffffffff81ff10dd R12: ffffc90000013a78
    R13: ffff88810eb78180 R14: ffffffff818297c0 R15: ffffc90000013c28
    FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 0000000002a1c001 CR4: 0000000000370ee0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     <TASK>
     damon_test_set_attrs+0x63/0x1f0
     kunit_generic_run_threadfn_adapter+0x17/0x30
     kthread+0xfd/0x130

The problem seems to be related with the damon_ctx was used without
being initialized. Fix it by adding the initialization.

Link: https://lkml.kernel.org/r/20230718052811.1065173-1-feng.tang@intel.com
Fixes: aa13779be6b7 ("mm/damon/core-test: add a test for damon_set_attrs()")
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-initialise-context-before-test-in-damon_test_set_attrs
+++ a/mm/damon/core-test.h
@@ -320,25 +320,25 @@ static void damon_test_update_monitoring
 
 static void damon_test_set_attrs(struct kunit *test)
 {
-	struct damon_ctx ctx;
+	struct damon_ctx *c = damon_new_ctx();
 	struct damon_attrs valid_attrs = {
 		.min_nr_regions = 10, .max_nr_regions = 1000,
 		.sample_interval = 5000, .aggr_interval = 100000,};
 	struct damon_attrs invalid_attrs;
 
-	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &valid_attrs), 0);
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &valid_attrs), 0);
 
 	invalid_attrs = valid_attrs;
 	invalid_attrs.min_nr_regions = 1;
-	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 
 	invalid_attrs = valid_attrs;
 	invalid_attrs.max_nr_regions = 9;
-	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 
 	invalid_attrs = valid_attrs;
 	invalid_attrs.aggr_interval = 4999;
-	KUNIT_EXPECT_EQ(test, damon_set_attrs(&ctx, &invalid_attrs), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 }
 
 static struct kunit_case damon_test_cases[] = {
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-damon-core-test-initialise-context-before-test-in-damon_test_set_attrs.patch

