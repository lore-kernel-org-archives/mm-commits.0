Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A11C2BBCF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD2E223A51
	for <mm-commits@archiver.kernel.org>; Thu, 17 Dec 2020 23:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgLQXDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Dec 2020 18:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbgLQXDu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Dec 2020 18:03:50 -0500
Date:   Thu, 17 Dec 2020 15:02:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608246161;
        bh=4emgPp/qfP2Zix3WHKLZyIGYxsUZ2EJgosZrxg1lh6E=;
        h=From:To:Subject:From;
        b=myM/T3cKrmXPcghJoezaAmDqp0gQPeHxyDemUbq1vJelO+oeVDboSWrKDSp02ksyc
         5BRErG77b5QxeFoEIAxe2AUcw84N2PtYS+lI90H11uDC+5hCWzsXDSL8xeSxvGLQnt
         VnpWlXPHH+ie9CjWbA7nQlWbWgqtRZA8PfivBMBQ=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        skhan@linuxfoundation.org, matti.vaittinen@fi.rohmeurope.com,
        davidgow@google.com, broonie@kernel.org, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
Subject:  [to-be-updated]
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch removed from
 -mm tree
Message-ID: <20201217230240.dOpUT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix
has been removed from the -mm tree.  Its filename was
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch

This patch was dropped because an updated version will be merged

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

revert-mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
scripts-ld-versionsh-fix-build.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

