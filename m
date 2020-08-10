Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14AA4C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4EF9206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027173;
	bh=Lq8V6hgFk+FR5by3FYjceME6fXurovvUQk4xrqO+3EA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gqs+1bdg3U1jcpayaWh/wy0+je4hZZmSycmRfoaFh0rY9JZTdWAmNJPUJpmc5UukI
	 P7sWNyDuuM+w+0kVvch6PqHmUP3UGXzJlwfLBWsO2N6bxDe0Ki4EaqDmct6WYMeSDG
	 lfW/b5mApjljQjgvuL+osfR+LLN038hmIah0FU8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCjd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999C22065D;
        Mon, 10 Aug 2020 02:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027173;
        bh=Lq8V6hgFk+FR5by3FYjceME6fXurovvUQk4xrqO+3EA=;
        h=Date:From:To:Subject:From;
        b=VN9SW8L0hRD3jAAxJknuUufiqHBxypu/NZy/OG1p+Xb2ji/RLCC6hOWw2RuR932Kc
         3FA1EulnyCAoCzDILC555OPUCW5un9B67aDE6WDPTWEsDO5ZBM3W4H3vRtT2mJ75gh
         SvkvWorcRda1Ue0ln+DSV+N9P4qSGI1VRAlIRFps=
Date:   Sun, 09 Aug 2020 19:39:32 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-arm64-dont-instrument-functions-that-enable-kasan.patch removed from
 -mm tree
Message-ID: <20200810023932.1HR64nZV7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, arm64: don't instrument functions that enable kasan
has been removed from the -mm tree.  Its filename was
     kasan-arm64-dont-instrument-functions-that-enable-kasan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from andreyknvl@google.com are


