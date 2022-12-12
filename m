Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31936C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiLLCSf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiLLCQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1682DDFF5
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0673B80B67
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B63BC433D2;
        Mon, 12 Dec 2022 02:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811307;
        bh=Ey4JaFPuWXceId+1x4dYXlYa51kV4mMtZHwsW072cw0=;
        h=Date:To:From:Subject:From;
        b=TZYdYMhtg+wK5AUttYwtaMlz7PAbOtZGLJ9wPmvGHtC71mK8wd0gu0jRkfNIZFP96
         VFlhhAJgK3jxGBo4DBkdRX1YfZQ/382Q9OWDpmZaTLR1EZ796O14bpE0x2gNMxK+Oa
         G1cbdwf4SkJzWROtDsx/hzxUJ+nlct4WNnE8tt5o=
Date:   Sun, 11 Dec 2022 18:15:06 -0800
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-fix-memcpy-tests.patch removed from -mm tree
Message-Id: <20221212021507.7B63BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: fix memcpy tests
has been removed from the -mm tree.  Its filename was
     kmsan-fix-memcpy-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: fix memcpy tests
Date: Mon, 5 Dec 2022 15:57:40 +0100

Recent Clang changes may cause it to delete calls of memcpy(), if the
source is an uninitialized volatile local.  This happens because passing a
pointer to a volatile local into memcpy() discards the volatile qualifier,
giving the compiler a free hand to optimize the memcpy() call away.

Use OPTIMIZER_HIDE_VAR() to hide the uninitialized var from the too-smart
compiler.

Link: https://lkml.kernel.org/r/20221205145740.694038-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-fix-memcpy-tests
+++ a/mm/kmsan/kmsan_test.c
@@ -419,6 +419,7 @@ static void test_memcpy_aligned_to_align
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to aligned dst (UMR report)\n");
+	OPTIMIZER_HIDE_VAR(uninit_src);
 	memcpy((void *)&dst, (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst, sizeof(dst));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
@@ -441,6 +442,7 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst (UMR report)\n");
+	OPTIMIZER_HIDE_VAR(uninit_src);
 	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)dst, 4);
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
@@ -464,6 +466,7 @@ static void test_memcpy_aligned_to_unali
 	kunit_info(
 		test,
 		"memcpy()ing aligned uninit src to unaligned dst - part 2 (UMR report)\n");
+	OPTIMIZER_HIDE_VAR(uninit_src);
 	memcpy((void *)&dst[1], (void *)&uninit_src, sizeof(uninit_src));
 	kmsan_check_memory((void *)&dst[4], sizeof(uninit_src));
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
_

Patches currently in -mm which might be from glider@google.com are


