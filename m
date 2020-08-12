Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899BAC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5736D20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266343;
	bh=b03nJAD1U/RrO3EvhZ2JFesvNY6Rp0THGcKDYf/DvH0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Q5X0F6QooxemcRw7fLNLM5cu6FZHaIvqeTCnZDeyWpiSJ9GXl2gY481h8qGvO7fkd
	 8g6Ec+2WPbCaF67hAYgKQEtYYKaCGNxh6J+bfjuN1HAw2cYwppIqZi8cFg9IntyK/2
	 CZWCdu0P33TldqlzRpaO8W2UZqUcv+Hjz+fvqMkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVFm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4152080C;
        Wed, 12 Aug 2020 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266341;
        bh=b03nJAD1U/RrO3EvhZ2JFesvNY6Rp0THGcKDYf/DvH0=;
        h=Date:From:To:Subject:From;
        b=1cj3GQd/sWYu1HfYy6AvKrE62jl1tb/InLqQLQkmxbTDkvJcT9b6in3npoB1yeSVB
         dxZ2r9SlX42OGpg2Rc4vBlXEwI3zzCpmpCaa13d49teXXwI+8C/pZ2LSosUCoGmgkG
         hTmpgyPAEov4i4wfklWolbhbCJ3ioAk3YTdNPMJI=
Date:   Wed, 12 Aug 2020 14:05:41 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org,
        ndesaulniers@google.com
Subject:  [merged]
 kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch
 removed from -mm tree
Message-ID: <20200812210541.XmFn0L3zm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: unconditionally add -fno-stack-protector to compiler options
has been removed from the -mm tree.  Its filename was
     kcov-unconditionally-add-fno-stack-protector-to-compiler-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcov: unconditionally add -fno-stack-protector to compiler options

Unconditionally add -fno-stack-protector to KCOV's compiler options, as
all supported compilers support the option.  This saves a compiler
invocation to determine if the option is supported.

Because Clang does not support -fno-conserve-stack, and
-fno-stack-protector was wrapped in the same cc-option, we were missing
-fno-stack-protector with Clang. Unconditionally adding this option
fixes this for Clang.

Link: http://lkml.kernel.org/r/20200615184302.7591-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Makefile~kcov-unconditionally-add-fno-stack-protector-to-compiler-options
+++ a/kernel/Makefile
@@ -36,7 +36,7 @@ KCOV_INSTRUMENT_stacktrace.o := n
 KCOV_INSTRUMENT_kcov.o := n
 KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
-CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector)
+CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 # cond_syscall is currently not LTO compatible
 CFLAGS_sys_ni.o = $(DISABLE_LTO)
_

Patches currently in -mm which might be from elver@google.com are


