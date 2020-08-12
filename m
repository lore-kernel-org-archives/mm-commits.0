Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89404C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E42D2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196218;
	bh=aMk+83/RLXXJVbImsAOvHmckd9FREpD+PPEko6ylxsM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=DJ4iW82scuaxjhS0y34nAtYrfZ5uTqvFWSEmMQTExVznJUfMj6Abiu739iU/S3LTh
	 soXQGDPWaWrRBmLI25NsLcWrn2NHgo0puH/J6R1y2T2Q4+SZb/j28Hh/6AhMVdODR5
	 M1wtAsfy1Iq7pnJAuqGcjF/UYzukNzOwUaAoy1sY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHLBg6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLBg6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:36:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613632054F;
        Wed, 12 Aug 2020 01:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196216;
        bh=aMk+83/RLXXJVbImsAOvHmckd9FREpD+PPEko6ylxsM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NDLhdAskB4G7c0ltOQFc+ZUeNTRqimIUo5vuyKpaM69DgEuhDqgSaT0RZI95rZLw2
         b5rg4Vf8FNbUsYStsecwkJEotnZXsWGZ+5IGCgVvTGOJ3XPl4hfG0/VTSBbL3BGYdC
         gtq/CbPOGE/ZSnGg5wnjSPNtlXPl92aDFeCx1V+8=
Date:   Tue, 11 Aug 2020 18:36:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 126/165] kcov: unconditionally add
 -fno-stack-protector to compiler options
Message-ID: <20200812013656.qG5s2DjpF%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
