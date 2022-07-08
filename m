Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597BAC43334
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbiGHUbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbiGHUbY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474959B1AC
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5A3CB82935
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86386C341C7;
        Fri,  8 Jul 2022 20:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312279;
        bh=eELo1u1MFPdi2VbtFUVzjNPih7CYRaTj1nsaRDLxR2I=;
        h=Date:To:From:Subject:From;
        b=2C0xxsbSMLbUknPbcwH8faEhcOYALPVf4oeEcpFv0PUr0G4+/pBW1QOSvn2B8ILQH
         NubaGgopQJlcgu996IHksKAq/jTz24RGUTBg9itX2d2Tc6+EJ7rMyFOdDnrgWGynOj
         MQPx7ZS710AkZMBe/jcRkh9/IMEaE2hXphg3I5hU=
Date:   Fri, 08 Jul 2022 13:31:18 -0700
To:     mm-commits@vger.kernel.org, sre@kernel.org,
        skhan@linuxfoundation.org, ndesaulniers@google.com,
        nathan@kernel.org, michal.lkml@markovi.net, mcgrof@kernel.org,
        masahiroy@kernel.org, lucas.demarchi@intel.com,
        keescook@chromium.org, john.ogness@linutronix.de,
        jani.nikula@linux.intel.com, gregkh@linuxfoundation.org,
        gpiccoli@igalia.com, dlatypov@google.com, corbet@lwn.net,
        brendanhiggins@google.com, atomlin@redhat.com,
        andriy.shevchenko@linux.intel.com, davidgow@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-taint-kernel-when-test-module-loaded.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203119.86386C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftest: taint kernel when test module loaded
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftest-taint-kernel-when-test-module-loaded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-taint-kernel-when-test-module-loaded.patch

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
Subject: selftest: taint kernel when test module loaded
Date: Fri, 8 Jul 2022 12:48:47 +0800

Make any kselftest test module (using the kselftest_module framework)
taint the kernel with TAINT_TEST on module load.

Also mark the module as a test module using MODULE_INFO(test, "Y") so that
other tools can tell this is a test module.  We can't rely solely on this,
though, as these test modules are also often built-in.

Finally, update the kselftest documentation to mention that the kernel
should be tainted, and how to do so manually (as below).

Note that several selftests use kernel modules which are not based on the
kselftest_module framework, and so will not automatically taint the
kernel.

This can be done in two ways:
- Moving the module to the tools/testing directory. All modules under
  this directory will taint the kernel.
- Adding the 'test' module property with:
  MODULE_INFO(test, "Y")

Similarly, selftests which do not load modules into the kernel generally
should not taint the kernel (or possibly should only do so on failure), as
it's assumed that testing from user-space should be safe.  Regardless,
they can write to /proc/sys/kernel/tainted if required.

Link: https://lkml.kernel.org/r/20220708044847.531566-4-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kselftest.rst      |    9 +++++++++
 tools/testing/selftests/kselftest_module.h |    4 ++++
 2 files changed, 13 insertions(+)

--- a/Documentation/dev-tools/kselftest.rst~selftest-taint-kernel-when-test-module-loaded
+++ a/Documentation/dev-tools/kselftest.rst
@@ -250,6 +250,14 @@ assist writing kernel modules that are f
 - ``tools/testing/selftests/kselftest_module.h``
 - ``tools/testing/selftests/kselftest/module.sh``
 
+Note that test modules should taint the kernel with TAINT_TEST. This will
+happen automatically for modules which are in the ``tools/testing/``
+directory, or for modules which use the ``kselftest_module.h`` header above.
+Otherwise, you'll need to add ``MODULE_INFO(test, "Y")`` to your module
+source. selftests which do not load modules typically should not taint the
+kernel, but in cases where a non-test module is loaded, TEST_TAINT can be
+applied from userspace by writing to ``/proc/sys/kernel/tainted``.
+
 How to use
 ----------
 
@@ -308,6 +316,7 @@ A bare bones test module might look like
    KSTM_MODULE_LOADERS(test_foo);
    MODULE_AUTHOR("John Developer <jd@fooman.org>");
    MODULE_LICENSE("GPL");
+   MODULE_INFO(test, "Y");
 
 Example test script
 -------------------
--- a/tools/testing/selftests/kselftest_module.h~selftest-taint-kernel-when-test-module-loaded
+++ a/tools/testing/selftests/kselftest_module.h
@@ -3,6 +3,7 @@
 #define __KSELFTEST_MODULE_H
 
 #include <linux/module.h>
+#include <linux/panic.h>
 
 /*
  * Test framework for writing test modules to be loaded by kselftest.
@@ -41,6 +42,7 @@ static inline int kstm_report(unsigned i
 static int __init __module##_init(void)			\
 {							\
 	pr_info("loaded.\n");				\
+	add_taint(TAINT_TEST, LOCKDEP_STILL_OK);	\
 	selftest();					\
 	return kstm_report(total_tests, failed_tests, skipped_tests);	\
 }							\
@@ -51,4 +53,6 @@ static void __exit __module##_exit(void)
 module_init(__module##_init);				\
 module_exit(__module##_exit)
 
+MODULE_INFO(test, "Y");
+
 #endif	/* __KSELFTEST_MODULE_H */
_

Patches currently in -mm which might be from davidgow@google.com are

panic-taint-kernel-if-tests-are-run.patch
module-panic-taint-the-kernel-when-selftest-modules-load.patch
kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

