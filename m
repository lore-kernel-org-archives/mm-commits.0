Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07E6C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A212C21D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632870;
	bh=2d7HtB7g6xhe9mRM5qdmxq7vJKR8f68y5AKkQBytphM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=AoDabwKE3kOavPLHuTC4268+DJ4+PeayORfpjkIFEd4IBh3EQWkwMkRGIjcgsdsEN
	 P6vASgRPfC5WQ89sUitPf3lE05wUAaY/LJWztcPioC/wLFqRHZ9WO9G9S3Iuegx2rB
	 H0w15GOGENhzuh7BxNIPwanrBb0fRAjohLHheNio=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbgJMXru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXrt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E68821582;
        Tue, 13 Oct 2020 23:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632869;
        bh=2d7HtB7g6xhe9mRM5qdmxq7vJKR8f68y5AKkQBytphM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=crIdvObs6GIx8IdyO8sI+RudXLJPTGOTDA/aLgS9lQYhN6THsMU/FlOExNzf8xlrp
         bM4vEVriV2kGD27I76jvaoxImXKb/5gcc+K7Lw7iOKzuLEZ+DHaHdlVPa13cPypMP4
         07i6VEZfwVybaD2fUdTmOyavMWlAQJhtXyy1H08s=
Date:   Tue, 13 Oct 2020 16:47:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ast@kernel.org,
        daniel@iogearbox.net, elver@google.com, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org, maskray@google.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [patch 005/181] Partially revert "ARM: 8905/1: Emit
 __gnu_mcount_nc when using Clang 10.0.0 or newer"
Message-ID: <20201013234748.iGSIRP2N6%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
