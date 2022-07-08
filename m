Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757F0CCA47B
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 20:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbiGHUbS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiGHUbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 16:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A9B9A683
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 13:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699D862898
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 20:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4159C341C6;
        Fri,  8 Jul 2022 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657312274;
        bh=SEpO45WRBT7dxFPOY+G7bKjUc6IU+Lqd/CA3T6B7JZ8=;
        h=Date:To:From:Subject:From;
        b=jkdGUPWZP2obYkSyW/qJ6ECfr6PvoP5ZOae+aLd30yCA275Ag2h4D4dXAO8rXn/OD
         8MxqPTSpKNa5ciCr/uoMrbZx6wTHWLlfoth0d387kggmWCKgNi2+XX9oAYxBib+MTT
         7n2kf3ncy9KYnnHsdF86XXqDs/A0QMkjTQhzw9/g=
Date:   Fri, 08 Jul 2022 13:31:14 -0700
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
Subject: + module-panic-taint-the-kernel-when-selftest-modules-load.patch added to mm-nonmm-unstable branch
Message-Id: <20220708203114.B4159C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module: panic: taint the kernel when selftest modules load
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     module-panic-taint-the-kernel-when-selftest-modules-load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-panic-taint-the-kernel-when-selftest-modules-load.patch

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
Subject: module: panic: taint the kernel when selftest modules load
Date: Fri, 8 Jul 2022 12:48:45 +0800

Taint the kernel with TAINT_TEST whenever a test module loads, by adding a
new "TEST" module property, and setting it for all modules in the
tools/testing directory.  This property can also be set manually, for
tests which live outside the tools/testing directory with:
MODULE_INFO(test, "Y");

Link: https://lkml.kernel.org/r/20220708044847.531566-2-davidgow@google.com
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Brendan Higgins <brendanhiggins@google.com>
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

 kernel/module/main.c  |    7 +++++++
 scripts/mod/modpost.c |    3 +++
 2 files changed, 10 insertions(+)

--- a/kernel/module/main.c~module-panic-taint-the-kernel-when-selftest-modules-load
+++ a/kernel/module/main.c
@@ -1988,6 +1988,13 @@ static int check_modinfo(struct module *
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(info, "license"));
 
+	if (get_modinfo(info, "test")) {
+		if (!test_taint(TAINT_TEST))
+			pr_warn("%s: loading test module taints kernel.\n",
+				mod->name);
+		add_taint_module(mod, TAINT_TEST, LOCKDEP_STILL_OK);
+	}
+
 	return 0;
 }
 
--- a/scripts/mod/modpost.c~module-panic-taint-the-kernel-when-selftest-modules-load
+++ a/scripts/mod/modpost.c
@@ -2191,6 +2191,9 @@ static void add_header(struct buffer *b,
 
 	if (strstarts(mod->name, "drivers/staging"))
 		buf_printf(b, "\nMODULE_INFO(staging, \"Y\");\n");
+
+	if (strstarts(mod->name, "tools/testing"))
+		buf_printf(b, "\nMODULE_INFO(test, \"Y\");\n");
 }
 
 static void add_exported_symbols(struct buffer *buf, struct module *mod)
_

Patches currently in -mm which might be from davidgow@google.com are

panic-taint-kernel-if-tests-are-run.patch
module-panic-taint-the-kernel-when-selftest-modules-load.patch
kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

