Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC31C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 877A061CD8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhF2AQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AQQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCF361CD0;
        Tue, 29 Jun 2021 00:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925629;
        bh=akvVNBySvedj8aogjrnRUGHvYNhPsY2OMAUlyEHnw7Q=;
        h=Date:From:To:Subject:From;
        b=xUV849vOqBrquV6p0bsMOeBXhCsKHrJ7qCpuFyltkto1SRnyMxCPvD3Rd1CNmcA/U
         eBc2guz+UUh5aijxm3if39YulCXHSIRl23Sfxtp2sspLh7GUi9iT++ZFLWSq5Mi8E7
         gAyXYDLMrip7NJ6O7rUlT13sq2hZih8rwM8qiU+E=
Date:   Mon, 28 Jun 2021 17:13:49 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, glittao@gmail.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch
 removed from -mm tree
Message-ID: <20210629001349.z6YmIztYp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch

This patch was dropped because it was folded into mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality-fix

Remove unused function test_exit(), from SLUB KUnit test.

Link: https://lkml.kernel.org/r/20210512140656.12083-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/slub_kunit.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/slub_kunit.c~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix
+++ a/lib/slub_kunit.c
@@ -129,8 +129,6 @@ static int test_init(struct kunit *test)
 	return 0;
 }
 
-static void test_exit(struct kunit *test) {}
-
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -147,7 +145,6 @@ static struct kunit_case test_cases[] =
 static struct kunit_suite test_suite = {
 	.name = "slub_test",
 	.init = test_init,
-	.exit = test_exit,
 	.test_cases = test_cases,
 };
 kunit_test_suite(test_suite);
_

Patches currently in -mm which might be from glittao@gmail.com are

mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
slub-remove-resiliency_test-function.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

