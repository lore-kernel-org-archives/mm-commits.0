Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3300C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 20:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7230221D6C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940932;
	bh=knK6POYoxd+0XsaZkbq58ZNAtRpbdubZQjA3aJwYtAk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gsu+BS9byO3PDS9TwDQ5ewJatBDjdQsdDj2nuBP5+5PPwIK5JDThdG/V+0UKpau7Y
	 Oh8ekx7Fan6cZumAomtw04o9wZSJn4wSZ/Fo7Uv0QUA22l7/I/OqukUUgmvWo+cLeR
	 8LbLRKPKe7PC325aCG0l8Yxt8POMwYakDKv0RUxQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgILUCL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 16:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgILUCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 16:02:09 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AAE2151B;
        Sat, 12 Sep 2020 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940928;
        bh=knK6POYoxd+0XsaZkbq58ZNAtRpbdubZQjA3aJwYtAk=;
        h=Date:From:To:Subject:From;
        b=m0WLBIscff72wjqBgOS58KIzlNAIValUAjQt+vbUJ6bRaFpYvM3bhg3mUuI6B09hU
         4CzvLC5W8Wmv6hnxK2id1jCvAGA0iJIeqpRbXdY63PxEmAc1EiSm2944fP9eyPOit0
         aywwD/nHrSyeYpXGumKp/isc0AgEN1OidesL0Qkw=
Date:   Sat, 12 Sep 2020 13:02:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vincent.guittot@linaro.org,
        shuah@kernel.org, mingo@redhat.com, juri.lelli@redhat.com,
        dvyukov@google.com, davidgow@google.com, brendanhiggins@google.com,
        aryabinin@virtuozzo.com, a.p.zijlstra@chello.nl,
        andreyknvl@google.com, trishalfonso@google.com
Subject:  + add-kunit-struct-to-current-task.patch added to -mm tree
Message-ID: <20200912200207.oaKVf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan/kunit: add KUnit Struct to Current Task
has been added to the -mm tree.  Its filename is
     add-kunit-struct-to-current-task.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/add-kunit-struct-to-current-task.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/add-kunit-struct-to-current-task.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Patricia Alfonso <trishalfonso@google.com>
Subject: kasan/kunit: add KUnit Struct to Current Task

Patch series "KASAN-KUnit Integration", v13.

This patchset contains everything needed to integrate KASAN and KUnit.

KUnit will be able to:
(1) Fail tests when an unexpected KASAN error occurs
(2) Pass tests when an expected KASAN error occurs

Convert KASAN tests to KUnit with the exception of copy_user_test because
KUnit is unable to test those.

Add documentation on how to run the KASAN tests with KUnit and what to
expect when running these tests.


This patch (of 5):

In order to integrate debugging tools like KASAN into the KUnit framework,
add KUnit struct to the current task to keep track of the current KUnit
test.

Link: https://lkml.kernel.org/r/20200910070331.3358048-1-davidgow@google.com
Link: https://lkml.kernel.org/r/20200910070331.3358048-2-davidgow@google.com
Signed-off-by: Patricia Alfonso <trishalfonso@google.com>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/sched.h~add-kunit-struct-to-current-task
+++ a/include/linux/sched.h
@@ -1203,6 +1203,10 @@ struct task_struct {
 #endif
 #endif
 
+#if IS_ENABLED(CONFIG_KUNIT)
+	struct kunit			*kunit_test;
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	/* Index of current stored address in ret_stack: */
 	int				curr_ret_stack;
_

Patches currently in -mm which might be from trishalfonso@google.com are

add-kunit-struct-to-current-task.patch
kunit-kasan-integration.patch
kasan-port-kasan-tests-to-kunit.patch
kasan-testing-documentation.patch

