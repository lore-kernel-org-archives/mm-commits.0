Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8383C433E1
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861F022CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781511;
	bh=up/UYMIfTnHWiQrb1ByS4h5OllRSo/U5p1Sql9omZ04=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HITjgxF9P9F0D1IwEuf1WIFd4X/yDNZHlUYH1SYzAHaoGWC6mGM3OAOio5LXbt37B
	 EdXB0L9Kal+qsxeDW7pw8zi15p5NoXSBB/omm0z26NG1kTucIJ0CpTqM2foOuoC1B0
	 GfYoTSYN0C9P9Mzmh2vKsCmsvCIXOvRyY5z0Kf2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHGGZK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbgHGGZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B588C22CAF;
        Fri,  7 Aug 2020 06:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781506;
        bh=up/UYMIfTnHWiQrb1ByS4h5OllRSo/U5p1Sql9omZ04=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=066hEPtn036Y8bbZXan8J8kfxG+kouLHkX5ZNOyiOwNXUzAn550glWnZgxGEX7/Xv
         Sm7u+D1ELD6QzJV6fXBusSwf45O4d4ed8B0n/2wwFCsAom0Hp3SiV7wDPDfD2S3/wU
         Y3mtdu3kJSYgTLJ6mYhjT2xwnnjy+5Xt41R0dIEo=
Date:   Thu, 06 Aug 2020 23:25:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ardb@kernel.org,
        aryabinin@virtuozzo.com, catalin.marinas@arm.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        lenaptr@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vincenzo.frascino@arm.com,
        walter-zh.wu@mediatek.com
Subject:  [patch 138/163] kasan, arm64: don't instrument functions
 that enable kasan
Message-ID: <20200807062505.BaPGOo8OA%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[andreyknvl@google.com: reorder attributes for start_kernel()]
  Link: http://lkml.kernel.org/r/26fb6165a17abcf61222eda5184c030fb6b133d1.1596544734.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/55d432671a92e931ab8234b03dc36b14d4c21bfb.1596199677.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
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
@@ -829,7 +829,7 @@ void __init __weak arch_call_rest_init(v
 	rest_init();
 }
 
-asmlinkage __visible void __init start_kernel(void)
+asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 {
 	char *command_line;
 	char *after_dashes;
_
