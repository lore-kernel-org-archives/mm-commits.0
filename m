Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8146AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687F2208E4
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 19:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596223466;
	bh=Q5tLWveLSr5FBqHmrF3QdbporCvTgyHcnf8IvlrithY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MZKDw9eF0vkpO+JcqErtYYmaQLUKhyF2eq2yrSnTqAR4CJdsv+CxLdeYhoT7Y9ofr
	 yr6/PgIahfDBvP4+XtTCQrPQmtUaTgPZ7hKqWYSmT9rgzOODFdRb6nu3WXtdAtUPuY
	 CE8GhR6SrAwJZLx6FCj8MolXYjD+VDOQezt7Ku0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGaTY0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 15:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgGaTYZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 15:24:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB2722B3F;
        Fri, 31 Jul 2020 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596223465;
        bh=Q5tLWveLSr5FBqHmrF3QdbporCvTgyHcnf8IvlrithY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aS9lpSuIqz6xUZrWWxyaF+heA/pxbZ2mKNdnNoIKLosQ/+iFzaDgyqoOTi1RxTrbk
         JJ/1h4ymr9tPNGAUX3zD5Y/q9dGMdV+XpkPh7W2C5RNMzguIWHLOKM9QPCdav8S2ZF
         q6uZQZBAvJ6gZ/CZ5TC7R66PnqQYq7SG6QP/aIkQ=
Date:   Fri, 31 Jul 2020 12:24:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  +
 kasan-arm64-dont-instrument-functions-that-enable-kasan.patch added to -mm
 tree
Message-ID: <20200731192424.asLN2ondr%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: don't instrument functions that enable kasan
has been added to the -mm tree.  Its filename is
     kasan-arm64-dont-instrument-functions-that-enable-kasan.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-arm64-dont-instrument-functions-that-enable-kasan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan, arm64: don't instrument functions that enable kasan

This patch prepares Software Tag-Based KASAN for stack tagging support.

With stack tagging enabled, KASAN tags stack variable in each function in
its prologue.  In start_kernel() stack variables get tagged before KASAN
is enabled via setup_arch()->kasan_init().  As the result the tags for
start_kernel()'s stack variables end up in the temporary shadow memory. 
Later when KASAN gets enabled, switched to normal shadow, and starts
checking tags, this leads to false-positive reports, as proper tags are
missing in normal shadow.

Disable KASAN instrumentation for start_kernel().  Also disable it for
arm64's setup_arch() as a precaution (it doesn't have any stack variables
right now).

Link: http://lkml.kernel.org/r/55d432671a92e931ab8234b03dc36b14d4c21bfb.1596199677.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/setup.c |    2 +-
 init/main.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/kernel/setup.c~kasan-arm64-dont-instrument-functions-that-enable-kasan
+++ a/arch/arm64/kernel/setup.c
@@ -276,7 +276,7 @@ arch_initcall(reserve_memblock_reserved_
 
 u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
-void __init setup_arch(char **cmdline_p)
+void __init __no_sanitize_address setup_arch(char **cmdline_p)
 {
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
--- a/init/main.c~kasan-arm64-dont-instrument-functions-that-enable-kasan
+++ a/init/main.c
@@ -827,7 +827,7 @@ void __init __weak arch_call_rest_init(v
 	rest_init();
 }
 
-asmlinkage __visible void __init start_kernel(void)
+asmlinkage __visible __no_sanitize_address void __init start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-dont-tag-stacks-allocated-with-pagealloc.patch
kasan-arm64-dont-instrument-functions-that-enable-kasan.patch
kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch
kasan-adjust-kasan_stack_oob-for-tag-based-mode.patch

