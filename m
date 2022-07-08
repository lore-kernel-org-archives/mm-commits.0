Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDEDC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbiGHUbO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiGHUbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:31:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC1D904F4
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3DE762896
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108EBC341C0;
        Fri,  8 Jul 2022 20:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312272;
        bh=CsnDlsP7X8P5xp0u2dwsbTdfDbpejRNjY0ajpvS1ojU=;
        h=Date:To:From:Subject:From;
        b=RNK9cmRoWgvJZImAsWLoOordys5zOGFwupsymGmoL0Y9Ns+zoU5Mc7JMFIgb+v27s
         scLq+vdS6Px70C5hO4E4NQWdngKO/LLKPYEUK6ZA7j4PW6ZhBQs5i6H+6i61wODOlQ
         JvsuoiXVZnYkdwuqsuvQlCr8hbFIQDGPXZ/cnOQs=
Date:   Fri, 08 Jul 2022 13:31:11 -0700
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
Subject: + panic-taint-kernel-if-tests-are-run.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203112.108EBC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: taint kernel if tests are run
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-taint-kernel-if-tests-are-run.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-taint-kernel-if-tests-are-run.patch

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

panic-taint-kernel-if-tests-are-run.patch
module-panic-taint-the-kernel-when-selftest-modules-load.patch
kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

