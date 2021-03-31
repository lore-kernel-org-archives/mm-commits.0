Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE692C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976CB619D3
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 05:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhCaFZM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 01:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233654AbhCaFYw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 01:24:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E617A619C9;
        Wed, 31 Mar 2021 05:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617168292;
        bh=QBNQdhdROus9x+dGKO+OcOLePRv5DfuKqwr+Nl7dqr8=;
        h=Date:From:To:Subject:From;
        b=Q2GC7erxgs5bSy8U9v8xaU1xyWD5gCC+/IXc9nCrYDhQ9TuHIcuNiclO05vBAMA1F
         E/M9CpZ/OsGSir4iAcGk5HeAJetACnPy6o6+Mz1ClLwyyV5iaKbWzBn1PfLuYxMPh+
         Q8QeNm/yPR32qK9toREZQ/avZ8u9/nKVXHF4Ck+8=
Date:   Tue, 30 Mar 2021 22:24:51 -0700
From:   akpm@linux-foundation.org
To:     fazilyildiran@gmail.com, geert@linux-m68k.org,
        julianbraha@gmail.com, mm-commits@vger.kernel.org,
        schwab@linux-m68k.org
Subject:  +
 lib-fix-kconfig-dependency-on-arch_want_frame_pointers.patch added to -mm
 tree
Message-ID: <20210331052451.TQyehbBcy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS
has been added to the -mm tree.  Its filename is
     lib-fix-kconfig-dependency-on-arch_want_frame_pointers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-fix-kconfig-dependency-on-arch_want_frame_pointers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-kconfig-dependency-on-arch_want_frame_pointers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Julian Braha <julianbraha@gmail.com>
Subject: lib: fix kconfig dependency on ARCH_WANT_FRAME_POINTERS

When LATENCYTOP, LOCKDEP, or FAULT_INJECTION_STACKTRACE_FILTER is enabled
and ARCH_WANT_FRAME_POINTERS is disabled, Kbuild gives a warning such as:

WARNING: unmet direct dependencies detected for FRAME_POINTER
  Depends on [n]: DEBUG_KERNEL [=y] && (M68K || UML || SUPERH) || ARCH_WANT_FRAME_POINTERS [=n] || MCOUNT [=n]
  Selected by [y]:
  - LATENCYTOP [=y] && DEBUG_KERNEL [=y] && STACKTRACE_SUPPORT [=y] && PROC_FS [=y] && !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86

Depending on ARCH_WANT_FRAME_POINTERS causes a recursive dependency error.
ARCH_WANT_FRAME_POINTERS is to be selected by the architecture, and is
not supposed to be overridden by other config options.

Link: https://lkml.kernel.org/r/20210329165329.27994-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/Kconfig.debug~lib-fix-kconfig-dependency-on-arch_want_frame_pointers
+++ a/lib/Kconfig.debug
@@ -1363,7 +1363,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && LOCK_DEBUGGING_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM && !S390 && !MICROBLAZE && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 
@@ -1665,7 +1665,7 @@ config LATENCYTOP
 	depends on DEBUG_KERNEL
 	depends on STACKTRACE_SUPPORT
 	depends on PROC_FS
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	select KALLSYMS
 	select KALLSYMS_ALL
 	select STACKTRACE
@@ -1918,7 +1918,7 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 	depends on !X86_64
 	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM && !ARC && !X86
+	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || ARC || X86
 	help
 	  Provide stacktrace filter for fault-injection capabilities
 
_

Patches currently in -mm which might be from julianbraha@gmail.com are

lib-fix-kconfig-dependency-on-arch_want_frame_pointers.patch

