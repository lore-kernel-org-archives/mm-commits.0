Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDB2C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9EE464E8C
	for <mm-commits@archiver.kernel.org>; Fri,  5 Feb 2021 02:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhBECdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Feb 2021 21:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhBECda (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D510064E8C;
        Fri,  5 Feb 2021 02:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492349;
        bh=zCb/7WAiBCDElm4qashemmfeIZSFHUythbcDbyDQ0bY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mqgP5hAv3U6KCM5XV3I8PuqIAozcJGrOEpwQaJMqGvg/Y8hKT2EjCYjZJf4fiSAxn
         5n3nK4ENYH6DPnJoG0Mp5wwSdnP9WG/4qVJsYKiqz/tdNKgcZe+PQk/o5ENJeDkuPj
         YRMN5fgU+AsEkwPqzDPtre8w1euqTHIUezL4pl60=
Date:   Thu, 04 Feb 2021 18:32:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, jeyu@kernel.org,
        johannes.berg@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oberpar@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 08/18] init/gcov: allow CONFIG_CONSTRUCTORS on UML
 to fix module gcov
Message-ID: <20210205023228.nBf0f2zDd%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>
Subject: init/gcov: allow CONFIG_CONSTRUCTORS on UML to fix module gcov

On ARCH=um, loading a module doesn't result in its constructors getting
called, which breaks module gcov since the debugfs files are never
registered.  On the other hand, in-kernel constructors have already been
called by the dynamic linker, so we can't call them again.

Get out of this conundrum by allowing CONFIG_CONSTRUCTORS to be selected,
but avoiding the in-kernel constructor calls.

Also remove the "if !UML" from GCOV selecting CONSTRUCTORS now, since we
really do want CONSTRUCTORS, just not kernel binary ones.

Link: https://lkml.kernel.org/r/20210120172041.c246a2cac2fb.I1358f584b76f1898373adfed77f4462c8705b736@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig        |    1 -
 init/main.c         |    8 +++++++-
 kernel/gcov/Kconfig |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/init/Kconfig~init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov
+++ a/init/Kconfig
@@ -76,7 +76,6 @@ config CC_HAS_ASM_INLINE
 
 config CONSTRUCTORS
 	bool
-	depends on !UML
 
 config IRQ_WORK
 	bool
--- a/init/main.c~init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov
+++ a/init/main.c
@@ -1066,7 +1066,13 @@ asmlinkage __visible void __init __no_sa
 /* Call all constructor functions linked into the kernel. */
 static void __init do_ctors(void)
 {
-#ifdef CONFIG_CONSTRUCTORS
+/*
+ * For UML, the constructors have already been called by the
+ * normal setup code as it's just a normal ELF binary, so we
+ * cannot do it again - but we do need CONFIG_CONSTRUCTORS
+ * even on UML for modules.
+ */
+#if defined(CONFIG_CONSTRUCTORS) && !defined(CONFIG_UML)
 	ctor_fn_t *fn = (ctor_fn_t *) __ctors_start;
 
 	for (; fn < (ctor_fn_t *) __ctors_end; fn++)
--- a/kernel/gcov/Kconfig~init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov
+++ a/kernel/gcov/Kconfig
@@ -4,7 +4,7 @@ menu "GCOV-based kernel profiling"
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
 	depends on DEBUG_FS
-	select CONSTRUCTORS if !UML
+	select CONSTRUCTORS
 	default n
 	help
 	This option enables gcov-based code profiling (e.g. for code coverage
_
