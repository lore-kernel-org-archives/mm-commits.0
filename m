Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F70CCA479
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 18:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiGMS0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 14:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbiGMS0d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 14:26:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC92E9E6
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 11:26:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E9961D85
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 18:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5485AC341C0;
        Wed, 13 Jul 2022 18:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657736791;
        bh=1rvuplKDLcWvfsD31fSziKQbxELhmyql+kF00XHIacw=;
        h=Date:To:From:Subject:From;
        b=AlObDXd3U7o3wlA/7liIz2OdJ4tF0OMAN7B9feT82wfEj7NGC/vK0MiWFs7f5Z/zl
         uhTRezbEDDiIFk3H29GmY4bvEsq/vou0vsge1On/TVcgmDs5/2WAxP8C3/oFSArEHM
         F6Y0O8LPi9EsPphok6JmYDkkFuQc4HjiReO0n6GE=
Date:   Wed, 13 Jul 2022 11:26:30 -0700
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
Subject: [merged] module-panic-taint-the-kernel-when-selftest-modules-load.patch removed from -mm tree
Message-Id: <20220713182631.5485AC341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: module: panic: taint the kernel when selftest modules load
has been removed from the -mm tree.  Its filename was
     module-panic-taint-the-kernel-when-selftest-modules-load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kunit-taint-the-kernel-when-kunit-tests-are-run.patch
selftest-taint-kernel-when-test-module-loaded.patch

