Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC2FC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6797023A56
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbhAUWoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbhAUWoc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:44:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC85423A5B;
        Thu, 21 Jan 2021 22:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611269032;
        bh=kKBssk66l8HzM8nns4oQ0ONR8zF9rQkirvGJqRp4OVQ=;
        h=Date:From:To:Subject:From;
        b=ondBvgx+3cTgEhSKKAFpZ8dxe0izUAmGVobWJiFaSkowOHsQzBVuebymO5UPtGYBY
         n/5UgkizCaJBDOuEfxzsvV9OzMY8j3Wg+E+QKPUQvFNcBBBaUq5cxRm6b9NjA9vUp3
         jDKfb+JL1RPMStVwJNrMGame6zLv5w8E2qZn0IZA=
Date:   Thu, 21 Jan 2021 14:43:51 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, jeyu@kernel.org, johannes.berg@intel.com,
        mm-commits@vger.kernel.org, oberpar@linux.ibm.com
Subject:  +
 init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov.patch added
 to -mm tree
Message-ID: <20210121224351.uc1T8QdgR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/gcov: allow CONFIG_CONSTRUCTORS on UML to fix module gcov
has been added to the -mm tree.  Its filename is
     init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from johannes.berg@intel.com are

init-gcov-allow-config_constructors-on-uml-to-fix-module-gcov.patch
mm-slub-disable-user-tracing-for-kmemleak-caches-by-default.patch

