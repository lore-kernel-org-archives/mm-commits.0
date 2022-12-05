Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4BCC4321E
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 21:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiLEVHq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 16:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiLEVH0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 16:07:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261D123EAD
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 13:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B59A661416
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 21:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E8AC433D7;
        Mon,  5 Dec 2022 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670274402;
        bh=LD4AsnxItjcXFvYqDMrv7vHRyL/Fhrjka4jLGnOA16A=;
        h=Date:To:From:Subject:From;
        b=GM5zVhBCMH9/eM3cf2Q9Nf+G9Rz0/7kQYqqIpYD/wqJ+pHyXvyby61qGFQ+BfGTeC
         9qMLTsK8qR8y5ti6KN5YENJ0z/e1qvbaHyBZYmORwyOIX/l/o6md23O/GXMTO3gSx6
         gT4u8RBksdUhFLKHbhrkwVaG3S8nan+UBah0z2M0=
Date:   Mon, 05 Dec 2022 13:06:41 -0800
To:     mm-commits@vger.kernel.org, elver@google.com, dvyukov@google.com,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-fix-memcpy-tests.patch added to mm-unstable branch
Message-Id: <20221205210642.13E8AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: fix memcpy tests
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-fix-memcpy-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-fix-memcpy-tests.patch

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

lockdep-allow-instrumenting-lockdepc-with-kmsan.patch
kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch
kmsan-fix-memcpy-tests.patch

