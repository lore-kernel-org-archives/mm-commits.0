Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71CCC43334
	for <mm-commits@archiver.kernel.org>; Wed,  6 Jul 2022 21:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiGFVX6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Jul 2022 17:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiGFVX6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2022 17:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F3317E0D
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 14:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2273B81EFD
        for <mm-commits@vger.kernel.org>; Wed,  6 Jul 2022 21:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B49BC3411C;
        Wed,  6 Jul 2022 21:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657142633;
        bh=fGAWqhw++lJzxUQFwPeT9+on7oF7dmFF8NtUOSGu3/4=;
        h=Date:To:From:Subject:From;
        b=cQ60C49TU7NUnugnO7T1s1SJCgZ15uosE8K5FDCszcCXojp/fpEMu+c7Mg4mP5ZkS
         MdQGiUYVcYkpckRxz7jDtCxXr+nhBYnRT9yonPG3fgATYTbtCaTlqy/NvRsuXILNhw
         IndK5lLZoQyWGyy5Uf+qFbON3xVv1KyVJvoOALns=
Date:   Wed, 06 Jul 2022 14:23:52 -0700
To:     mm-commits@vger.kernel.org, sre@kernel.org,
        skhan@linuxfoundation.org, ndesaulniers@google.com,
        michal.lkml@markovi.net, mcgrof@kernel.org, masahiroy@kernel.org,
        lucas.demarchi@intel.com, keescook@chromium.org,
        john.ogness@linutronix.de, jani.nikula@linux.intel.com,
        gregkh@linuxfoundation.org, gpiccoli@igalia.com,
        dlatypov@google.com, corbet@lwn.net, brendanhiggins@google.com,
        atomlin@redhat.com, andriy.shevchenko@linux.intel.com,
        davidgow@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-taint-the-kernel-when-kunit-tests-are-run.patch added to mm-nonmm-unstable branch
Message-Id: <20220706212353.8B49BC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: taint the kernel when KUnit tests are run
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-taint-the-kernel-when-kunit-tests-are-run.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-taint-the-kernel-when-kunit-tests-are-run.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: David Gow <davidgow@google.com>
Subject: kunit: taint the kernel when KUnit tests are run
Date: Sat, 2 Jul 2022 12:09:58 +0800

Make KUnit trigger the new TAINT_TEST taint when any KUnit test is run. 
Due to KUnit tests not being intended to run on production systems, and
potentially causing problems (or security issues like leaking kernel
addresses), the kernel's state should not be considered safe for
production use after KUnit tests are run.

This both marks KUnit modules as test modules using MODULE_INFO() and
manually taints the kernel when tests are run (which catches builtin
tests).

Link: https://lkml.kernel.org/r/20220702040959.3232874-3-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/kunit/test.h |    3 ++-
 lib/kunit/test.c     |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/kunit/test.h~kunit-taint-the-kernel-when-kunit-tests-are-run
+++ a/include/kunit/test.h
@@ -277,7 +277,8 @@ static inline int kunit_run_all_tests(vo
 	{								\
 		return __kunit_test_suites_exit(__suites);		\
 	}								\
-	module_exit(kunit_test_suites_exit)
+	module_exit(kunit_test_suites_exit)				\
+	MODULE_INFO(test, "Y");
 #else
 #define kunit_test_suites_for_module(__suites)
 #endif /* MODULE */
--- a/lib/kunit/test.c~kunit-taint-the-kernel-when-kunit-tests-are-run
+++ a/lib/kunit/test.c
@@ -11,6 +11,7 @@
 #include <kunit/test-bug.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
+#include <linux/panic.h>
 #include <linux/sched/debug.h>
 #include <linux/sched.h>
 
@@ -501,6 +502,9 @@ int kunit_run_tests(struct kunit_suite *
 	struct kunit_result_stats suite_stats = { 0 };
 	struct kunit_result_stats total_stats = { 0 };
 
+	/* Taint the kernel so we know we've run tests. */
+	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
+
 	if (suite->suite_init) {
 		suite->suite_init_err = suite->suite_init(suite);
 		if (suite->suite_init_err) {
_

Patches currently in -mm which might be from davidgow@google.com are

panic-taint-kernel-if-tests-are-run.patch
module-panic-taint-the-kernel-when-selftest-modules-load.patch
kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

