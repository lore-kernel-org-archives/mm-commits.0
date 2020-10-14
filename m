Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E1FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3A5E22257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708935;
	bh=w3W/WY1MEeAKnZv4DPZusCAJ6XDLR75I+OkOMgP1RPQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KVfJHLgF2EAwP6Bj0dCqLjVxodjj8tcqbVHVS2Yf8TTIlJwm80KjQNOII1z5Ky3lH
	 vsLeZvnqNDrUHyEB3rL49kMBqso1PpEdsNBWnvH/UeHXQFINl3+2ajGfB4LvqPTuEm
	 BLr8AyKsZzJyFa+e0ZHrofT6mVjqInHlEJaQv1UU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbgJNUzf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C732B2224E;
        Wed, 14 Oct 2020 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708934;
        bh=w3W/WY1MEeAKnZv4DPZusCAJ6XDLR75I+OkOMgP1RPQ=;
        h=Date:From:To:Subject:From;
        b=lDLd0Ns3UvTDBhA2eJsDmomdZp7nGeczhwE4XXiXl0QeCA+53C/nUqSKNVjp9sbnc
         tMDvlDQ6w9jdazky0uZgrq+ePKcTQWZDRcOYVwJjGuZHYfn4grEFlLOxSMEK+nAXSb
         /hpH5CyCc0yPuImvSXufQGGOEizn9NhDiOw4rJLI=
Date:   Wed, 14 Oct 2020 13:55:33 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?partially-revert-arm-8905-1-emit-=5F=5Fgnu=5Fmcount=5Fnc-?=
 =?US-ASCII?Q?when-using-clang-1000-or-newer.patch?= removed from -mm tree
Message-ID: <20201014205533.etIKO2UU0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Partially revert "ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer"
has been removed from the -mm tree.  Its filename was
     partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Partially revert "ARM: 8905/1: Emit __gnu_mcount_nc when using Clang 10.0.0 or newer"

This partially reverts commit b0fe66cf095016e0b238374c10ae366e1f087d11.

The minimum supported version of clang is now clang 10.0.1. We still
want to pass -meabi=gnu.

Link: https://lkml.kernel.org/r/20200902225911.209899-6-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig~partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer
+++ a/arch/arm/Kconfig
@@ -84,7 +84,7 @@ config ARM
 	select HAVE_FAST_GUP if ARM_LPAE
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_GRAPH_TRACER if !THUMB2_KERNEL && !CC_IS_CLANG
-	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && (CC_IS_GCC || CLANG_VERSION >= 100000)
+	select HAVE_FUNCTION_TRACER if !XIP_KERNEL
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_IDE if PCI || ISA || PCMCIA
_

Patches currently in -mm which might be from ndesaulniers@google.com are


