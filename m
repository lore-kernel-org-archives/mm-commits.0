Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE57C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2AA321D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633301;
	bh=iTOfcqWbEyzt78v+29y45RlvxIeJ8u2DfuKLb0K2tc8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tdMSc3eMltu871ywvlMBkKqwAjHP3gUkyo9RriddQInInESyEcYdrFmvP2XYJkj0r
	 9O0X7R6o8W2rF5b5tyYvV213MSeJmbooexW9rAIFXbT/hsZCy44xSyqRaat3H4TopR
	 GxUYPSBr4Tsz4wVeuAio0t1KwpcieORjw79wS9Ps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgJMXzA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF126208B3;
        Tue, 13 Oct 2020 23:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633299;
        bh=iTOfcqWbEyzt78v+29y45RlvxIeJ8u2DfuKLb0K2tc8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=edAvTQfFHpCJgD319qXSMIscwRF/ihpZn0DheYKC1Fty3KZzfBJIvcFxVe74bPQ42
         7KIuBJyRhYCtB1yP5VGDxAjzs0hkMQmPCyq7pfYH5uRx/oLuyK/pk/g68nByW7amH/
         wy/TnbmUITy1mJZ+2kT2fqjvdantji9H+T98hEa0=
Date:   Tue, 13 Oct 2020 16:54:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        andreyknvl@google.com, aryabinin@virtuozzo.com,
        brendanhiggins@google.com, davidgow@google.com, dvyukov@google.com,
        juri.lelli@redhat.com, linux-mm@kvack.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, shuah@kernel.org,
        torvalds@linux-foundation.org, trishalfonso@google.com,
        vincent.guittot@linaro.org
Subject:  [patch 120/181] kasan/kunit: add KUnit Struct to Current
 Task
Message-ID: <20201013235458.faYXl5asw%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Patricia Alfonso <trishalfonso@google.com>
Subject: kasan/kunit: add KUnit Struct to Current Task

Patch series "KASAN-KUnit Integration", v14.

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

Link: https://lkml.kernel.org/r/20200915035828.570483-1-davidgow@google.com
Link: https://lkml.kernel.org/r/20200915035828.570483-2-davidgow@google.com
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
@@ -1208,6 +1208,10 @@ struct task_struct {
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
