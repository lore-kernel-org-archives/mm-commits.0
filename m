Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7E9C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjC1XWu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjC1XWD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C42D56
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD4D2619A3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41846C433D2;
        Tue, 28 Mar 2023 23:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045712;
        bh=9G4l39AQSztz1I9HoeFIeKQG/vx+BZNgsi5US5EnSFs=;
        h=Date:To:From:Subject:From;
        b=J7CcmQ910I8fwWkMy+52YQbgIAD3xISi2hx5hBkjIwwcyjtQlpWwSYDJbwy4jLZb0
         iuAwT+OQa+4qGv4cVVnb/lWkh9BqOH2bra6HVuCbVzzkK6K0UoDBw2VBEv73LODmkt
         0HMpQ2TSN3Fw8fepkSkQBJVFI8hf1dsndM2lNGIg=
Date:   Tue, 28 Mar 2023 16:21:51 -0700
To:     mm-commits@vger.kernel.org, syzkaller@googlegroups.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-add-test_stackdepot_roundtrip.patch removed from -mm tree
Message-Id: <20230328232152.41846C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: add test_stackdepot_roundtrip
has been removed from the -mm tree.  Its filename was
     kmsan-add-test_stackdepot_roundtrip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/kmsan/kmsan_test.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

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


