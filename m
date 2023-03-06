Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946F5C64EC4
	for <mm-commits@archiver.kernel.org>; Mon,  6 Mar 2023 20:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCFU7h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Mar 2023 15:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCFU7f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2023 15:59:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F324392D
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 12:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDB460A10
        for <mm-commits@vger.kernel.org>; Mon,  6 Mar 2023 20:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A36AC433EF;
        Mon,  6 Mar 2023 20:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678136370;
        bh=McyNWmrmWXAcamBKOZy0SIxqDgNk4M0MAPJWn4wJAWo=;
        h=Date:To:From:Subject:From;
        b=azMTZVxbp6biiVchM4DPOJDJMgSK1vZgV3Pd5cm+HEJoikP/I6ff24Dkjk2uOVCiO
         IxjSPRV+WJL+6qps/WQ5tMO2St13SSAn+rFtrF+ts0tY9sOk5I3igLutRtBoVl3PxM
         OoJnEk4aiRPwLO6vkZzfEeW79O387JYNA7h+FfJw=
Date:   Mon, 06 Mar 2023 12:59:29 -0800
To:     mm-commits@vger.kernel.org, syzkaller@googlegroups.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-add-test_stackdepot_roundtrip.patch added to mm-unstable branch
Message-Id: <20230306205930.9A36AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: add test_stackdepot_roundtrip
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-add-test_stackdepot_roundtrip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-add-test_stackdepot_roundtrip.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: add test_stackdepot_roundtrip
Date: Mon, 6 Mar 2023 12:13:22 +0100

Ensure that KMSAN does not report false positives in instrumented callers
of stack_depot_save(), stack_depot_print(), and stack_depot_fetch().

Link: https://lkml.kernel.org/r/20230306111322.205724-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kmsan/kmsan_test.c~kmsan-add-test_stackdepot_roundtrip
+++ a/mm/kmsan/kmsan_test.c
@@ -551,6 +551,36 @@ static void test_long_origin_chain(struc
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+/*
+ * Test case: ensure that saving/restoring/printing stacks to/from stackdepot
+ * does not trigger errors.
+ *
+ * KMSAN uses stackdepot to store origin stack traces, that's why we do not
+ * instrument lib/stackdepot.c. Yet it must properly mark its outputs as
+ * initialized because other kernel features (e.g. netdev tracker) may also
+ * access stackdepot from instrumented code.
+ */
+static void test_stackdepot_roundtrip(struct kunit *test)
+{
+	unsigned long src_entries[16], *dst_entries;
+	unsigned int src_nentries, dst_nentries;
+	EXPECTATION_NO_REPORT(expect);
+	depot_stack_handle_t handle;
+
+	kunit_info(test, "testing stackdepot roundtrip (no reports)\n");
+
+	src_nentries =
+		stack_trace_save(src_entries, ARRAY_SIZE(src_entries), 1);
+	handle = stack_depot_save(src_entries, src_nentries, GFP_KERNEL);
+	stack_depot_print(handle);
+	dst_nentries = stack_depot_fetch(handle, &dst_entries);
+	KUNIT_EXPECT_TRUE(test, src_nentries == dst_nentries);
+
+	kmsan_check_memory((void *)dst_entries,
+			   sizeof(*dst_entries) * dst_nentries);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 static struct kunit_case kmsan_test_cases[] = {
 	KUNIT_CASE(test_uninit_kmalloc),
 	KUNIT_CASE(test_init_kmalloc),
@@ -573,6 +603,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_memset32),
 	KUNIT_CASE(test_memset64),
 	KUNIT_CASE(test_long_origin_chain),
+	KUNIT_CASE(test_stackdepot_roundtrip),
 	{},
 };
 
_

Patches currently in -mm which might be from glider@google.com are

x86-kmsan-dont-rename-memintrinsics-in-uninstrumented-files.patch
kmsan-another-take-at-fixing-memcpy-tests.patch
x86-kmsan-use-c-versions-of-memset16-memset32-memset64.patch
kmsan-add-memsetxx-tests.patch
lib-stackdepot-kmsan-mark-api-outputs-as-initialized.patch
kmsan-add-test_stackdepot_roundtrip.patch

