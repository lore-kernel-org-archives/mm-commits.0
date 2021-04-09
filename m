Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437CDC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 202056113A
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhDIU2B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234193AbhDIU2B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCFCA61007;
        Fri,  9 Apr 2021 20:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000068;
        bh=mMDpKYHqmSvIqaubbAnmGKdLBkLFNKzTsowpAWt6XIY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GM1YwKYj0Fsilfe+h4vrcD95cN71gi1uIvNdHPv1kPOO8m/NqK+LLuCP4/MWFfs5S
         poLPg2kS4nbVbBqjGwnl2XZuRuhH8Az1ercZtXzn+jUxVMf0QMLD/zbPsybSiGc9+T
         EGSXWq5uY7dktYBH79qNhYUyvLf1yE4PCKV1Seok=
Date:   Fri, 09 Apr 2021 13:27:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, fazilyildiran@gmail.com,
        geert@linux-m68k.org, julianbraha@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, schwab@linux-m68k.org,
        torvalds@linux-foundation.org
Subject:  [patch 16/16] lib: fix kconfig dependency on
 ARCH_WANT_FRAME_POINTERS
Message-ID: <20210409202747.g-bi9jHw8%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
