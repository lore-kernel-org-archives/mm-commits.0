Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5D3C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928ED22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709327;
	bh=b31vGDTNfHr1jUmwdNjrsgup+sdZIiC5hWDL1y+/rYo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YzQ+UceSNb/sM7J729hsJPovyvUFVqu+bAAZIN/ZPuBxYwkJV+bgZezzM3KMmp3i2
	 QpX1altqrnBFk9hAas7cPNMR3sXZoZumOv9HAMcw2D1bgBuBEcO0aJW7MIbDdMxdft
	 qKQHNHVbnUjpByI+0/l4+Hi8dPcevDBqgq9JTqbE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730705AbgJNVCH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730681AbgJNVCH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B634720725;
        Wed, 14 Oct 2020 21:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709326;
        bh=b31vGDTNfHr1jUmwdNjrsgup+sdZIiC5hWDL1y+/rYo=;
        h=Date:From:To:Subject:From;
        b=jGG9rHz1syRIMSVNXbZomk0aORpNx5HE5e0eBL38YgytKIATNJyaYTOadrW2ETLFY
         GsU5+SPzMC4KMxzb7dQ4wRTYt8gtzENhrGay+N+IElxm8q3o4bsICG7JqPi7Mwd0R7
         fsrRqotWwP+Jv4w706oPLdX6l69Ow1vEjv0pLO5s=
Date:   Wed, 14 Oct 2020 14:02:05 -0700
From:   akpm@linux-foundation.org
To:     a.p.zijlstra@chello.nl, andreyknvl@google.com,
        aryabinin@virtuozzo.com, brendanhiggins@google.com,
        davidgow@google.com, dvyukov@google.com, juri.lelli@redhat.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, shuah@kernel.org,
        trishalfonso@google.com, vincent.guittot@linaro.org
Subject:  [merged] add-kunit-struct-to-current-task.patch removed
 from -mm tree
Message-ID: <20201014210205.gk_xuxiZT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan/kunit: add KUnit Struct to Current Task
has been removed from the -mm tree.  Its filename was
     add-kunit-struct-to-current-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from trishalfonso@google.com are


