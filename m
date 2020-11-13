Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB0DC388F9
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 04:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ECC922244
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 04:00:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5JaS8iM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgKMEA0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 23:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgKMEA0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 23:00:26 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E411422241;
        Fri, 13 Nov 2020 04:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605240025;
        bh=CHq4fZJaPIHsiwsizGeWZOZqXGOdukPeUXd4tDDqu9A=;
        h=Date:From:To:Subject:From;
        b=j5JaS8iMNJs7FIuVI0QDGkGOE8/W/cXH5PSoSPJ9Gq1PckMsBhVH77R4oOF6itpnS
         6KJUdIkfFN99+1GoTPGoggnhl4LCpjToR+MNZvIJ4I88E75A2O7f7TsqED3cNNQBrX
         X471kAFt1IJIbZj4xj4P1QAtj0hZySofB/qYIo7k=
Date:   Thu, 12 Nov 2020 20:00:23 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, broonie@kernel.org, davidgow@google.com,
        matti.vaittinen@fi.rohmeurope.com, mm-commits@vger.kernel.org,
        skhan@linuxfoundation.org, vitor@massaru.org
Subject:  +
 lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch added to
 -mm tree
Message-ID: <20201113040023.Hpz_yLeg3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix
has been added to the -mm tree.  Its filename is
     lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
linux-next-rejects.patch
kasan-split-out-shadowc-from-commonc-fix.patch
kasan-mm-check-kasan_enabled-in-annotations-fix.patch
kasan-mm-rename-kasan_poison_kfree-temp-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
secretmem-add-memcg-accounting-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

