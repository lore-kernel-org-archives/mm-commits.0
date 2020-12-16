Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF315C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3D82311B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgLPEKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEKV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:10:21 -0500
Date:   Tue, 15 Dec 2020 20:09:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091781;
        bh=iHAm1WQV6Yu65pYp3pLdxy3zt/EaaPElKQkcYIqVpAw=;
        h=From:To:Subject:From;
        b=2mMxh689qvD+FXeuzLGCh7llHgkQm6k1xgRJPJupkBU9vR66oBJeRsmOo33yxNhAs
         mC6JsT19J2K+dhUIZmze6xr0+D3JldjdmIV9sn6mmPod4/xySXFQrKtG+c94a7fJBm
         yzbFCY7sK4HDQtCr21PQmCZJDX/rgNdr8hH4Q0Tw=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  [folded-merged]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch removed
 from -mm tree
Message-ID: <20201216040939.3hsf2gqaU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch

This patch was dropped because it was folded into lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline_kunit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/cmdline_kunit.c~lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix
+++ a/lib/cmdline_kunit.c
@@ -13,19 +13,19 @@ static const char *cmdline_test_strings[
 	"+,"  , "--", ",,", "''" , "\"\",", "\",\"", "-\"\"", "\"",
 };
 
-static const char *cmdline_test_values[] = {
+static const char cmdline_test_values[] = {
 	1, 1, 1, 1, 2, 3, 2, 3,
 	1, 3, 2, 1, 1, 1, 3, 1,
 };
 
-static void cmdline_do_one_test(struct kunit *test, char *in, int rc, int offset)
+static void cmdline_do_one_test(struct kunit *test, const char *in, int rc, int offset)
 {
 	const char *fmt = "Pattern: %s";
-	char *out = in;
+	const char *out = in;
 	int dummy;
 	int ret;
 
-	ret = get_option(&out, &dummy);
+	ret = get_option((char **)&out, &dummy);
 
 	KUNIT_EXPECT_EQ_MSG(test, ret, rc, fmt, in);
 	KUNIT_EXPECT_PTR_EQ_MSG(test, out, in + offset, fmt, in);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

