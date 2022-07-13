Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8646C43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 18:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbiGMS0g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236649AbiGMS0d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 14:26:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D7C2E9D0
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 11:26:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F02B8211B
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 18:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB93C34114;
        Wed, 13 Jul 2022 18:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657736790;
        bh=jCRtRWNg8H0zFrNfo2/ByVdR9ZHJc7/aT8DoYRKPzKg=;
        h=Date:To:From:Subject:From;
        b=MqKkUG1zxH9qvq1eGb7eRFaqt0E1wgRFK9QPtbp0iYmwigvYUZIl3nB3MUb9REJT/
         tcKR2TY/dFFW5ebqroWMXgxvMCBFrX7gCQHQ03NSYObOmBfYGW4+5ZoQ24PEe1+5Cj
         hhfJ0c69902qkuKPYxlbtsX34m9UGTrDT8rO+eWs=
Date:   Wed, 13 Jul 2022 11:26:29 -0700
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
Subject: [merged] panic-taint-kernel-if-tests-are-run.patch removed from -mm tree
Message-Id: <20220713182629.EBB93C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: panic: taint kernel if tests are run
has been removed from the -mm tree.  Its filename was
     panic-taint-kernel-if-tests-are-run.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Gow <davidgow@google.com>
Subject: panic: taint kernel if tests are run
Date: Fri, 8 Jul 2022 12:48:44 +0800

Most in-kernel tests (such as KUnit tests) are not supposed to run on
production systems: they may do deliberately illegal things to trigger
errors, and have security implications (for example, KUnit assertions will
often deliberately leak kernel addresses).

Add a new taint type, TAINT_TEST to signal that a test has been run.  This
will be printed as 'N' (originally for kuNit, as every other sensible
letter was taken.)

This should discourage people from running these tests on production
systems, and to make it easier to tell if tests have been run accidentally
(by loading the wrong configuration, etc.)

Link: https://lkml.kernel.org/r/20220708044847.531566-1-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/tainted-kernels.rst |    1 +
 include/linux/panic.h                         |    3 ++-
 kernel/panic.c                                |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/tainted-kernels.rst~panic-taint-kernel-if-tests-are-run
+++ a/Documentation/admin-guide/tainted-kernels.rst
@@ -100,6 +100,7 @@ Bit  Log  Number  Reason that got the ke
  15  _/K   32768  kernel has been live patched
  16  _/X   65536  auxiliary taint, defined for and used by distros
  17  _/T  131072  kernel was built with the struct randomization plugin
+ 18  _/N  262144  an in-kernel test has been run
 ===  ===  ======  ========================================================
 
 Note: The character ``_`` is representing a blank in this table to make reading
--- a/include/linux/panic.h~panic-taint-kernel-if-tests-are-run
+++ a/include/linux/panic.h
@@ -68,7 +68,8 @@ static inline void set_arch_panic_timeou
 #define TAINT_LIVEPATCH			15
 #define TAINT_AUX			16
 #define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
+#define TAINT_TEST			18
+#define TAINT_FLAGS_COUNT		19
 #define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
 
 struct taint_flag {
--- a/kernel/panic.c~panic-taint-kernel-if-tests-are-run
+++ a/kernel/panic.c
@@ -428,6 +428,7 @@ const struct taint_flag taint_flags[TAIN
 	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
 	[ TAINT_AUX ]			= { 'X', ' ', true },
 	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
+	[ TAINT_TEST ]			= { 'N', ' ', true },
 };
 
 /**
_

Patches currently in -mm which might be from davidgow@google.com are

module-panic-taint-the-kernel-when-selftest-modules-load.patch
kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

