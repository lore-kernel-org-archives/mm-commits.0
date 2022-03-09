Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE41C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  9 Mar 2022 21:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiCIVgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiCIVg2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 16:36:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3DDFA231
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 13:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DAAEB823D6
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 21:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E6FC340E8;
        Wed,  9 Mar 2022 21:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646861726;
        bh=Vc0o7H5xxgZ4ONt+qU8GhjmJf4iDHKU0M8NtRHx58jY=;
        h=Date:To:From:Subject:From;
        b=o9/g7rVbK07mc9pXZiA32GVGuSU2Y3X1Jin1HO8CvteaPnryHECrMf7uGJFRVvCHy
         uvoxirTO+idELvAXF6PdV580ZPP9FqdVA8g3syM6E2llQ/xBuOEKJJvp1wEpJnm5b9
         xyor2Ku+WHo8ztxSuIrGdbdTtqecvZvOfYMLsy+Q=
Date:   Wed, 09 Mar 2022 13:35:25 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        dlatypov@google.com, davidgow@google.com,
        brendanhiggins@google.com, liupeng256@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch added to -mm tree
Message-Id: <20220309213526.05E6FC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: try to avoid test_gfpzero trigger rcu_stall
has been added to the -mm tree.  Its filename is
     kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch

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
Subject: kfence: test: try to avoid test_gfpzero trigger rcu_stall

When CONFIG_KFENCE_NUM_OBJECTS is set to a big number, kfence
kunit-test-case test_gfpzero will eat up nearly all the CPU's resources
and rcu_stall is reported as the following log which is cut from a
physical server.

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: 	68-....: (14422 ticks this GP) idle=6ce/1/0x4000000000000002
  softirq=592/592 fqs=7500 (t=15004 jiffies g=10677 q=20019)
  Task dump for CPU 68:
  task:kunit_try_catch state:R  running task
  stack:    0 pid: 9728 ppid:     2 flags:0x0000020a
  Call trace:
   dump_backtrace+0x0/0x1e4
   show_stack+0x20/0x2c
   sched_show_task+0x148/0x170
   ...
   rcu_sched_clock_irq+0x70/0x180
   update_process_times+0x68/0xb0
   tick_sched_handle+0x38/0x74
   ...
   gic_handle_irq+0x78/0x2c0
   el1_irq+0xb8/0x140
   kfree+0xd8/0x53c
   test_alloc+0x264/0x310 [kfence_test]
   test_gfpzero+0xf4/0x840 [kfence_test]
   kunit_try_run_case+0x48/0x20c
   kunit_generic_run_threadfn_adapter+0x28/0x34
   kthread+0x108/0x13c
   ret_from_fork+0x10/0x18

To avoid rcu_stall and unacceptable latency, a schedule point is
added to test_gfpzero.

Link: https://lkml.kernel.org/r/20220309083753.1561921-4-liupeng256@huawei.com
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

 mm/kfence/kfence_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/kfence_test.c~kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall
+++ a/mm/kfence/kfence_test.c
@@ -627,6 +627,7 @@ static void test_gfpzero(struct kunit *t
 			kunit_warn(test, "giving up ... cannot get same object back\n");
 			return;
 		}
+		cond_resched();
 	}
 
 	for (i = 0; i < size; i++)
_

Patches currently in -mm which might be from liupeng256@huawei.com are

kunit-fix-uaf-when-run-kfence-test-case-test_gfpzero.patch
kunit-make-kunit_test_timeout-compatible-with-comment.patch
kfence-test-try-to-avoid-test_gfpzero-trigger-rcu_stall.patch

