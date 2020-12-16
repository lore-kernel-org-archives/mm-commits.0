Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F758C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BF123433
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgLPRLv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgLPRLv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:51 -0500
Date:   Wed, 16 Dec 2020 09:11:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138695;
        bh=HqLYXfJclC/PYjqpT1mhd9l96bYeH+T73I+4WpGDbmQ=;
        h=From:To:Subject:From;
        b=0402B11/plz7oWXecKkngi1O+TeVX25YY9DGyCFTD/zbeoJ9g2kqxBg/CueoYCfZX
         VQPRGNTN/4srXA8EOKfYU1Eh0klKAzKnvuGG8+vI/0HwDvxnhyxta8J4CxonCgX270
         A+K140NYKtCoaIotemGT28osiAVChefqbXNyqqnM=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [merged] kcov-dont-instrument-with-ubsan.patch removed
 from -mm tree
Message-ID: <20201216171135.bCjjMcEPU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: don't instrument with UBSAN
has been removed from the -mm tree.  Its filename was
     kcov-dont-instrument-with-ubsan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kcov: don't instrument with UBSAN

Both KCOV and UBSAN use compiler instrumentation.  If UBSAN detects a bug
in KCOV, it may cause infinite recursion via printk and other common
functions.  We already don't instrument KCOV with KASAN/KCSAN for this
reason, don't instrument it with UBSAN as well.

As a side effect this also resolves the following gcc warning:

conflicting types for built-in function '__sanitizer_cov_trace_switch';
expected 'void(long unsigned int, void *)'
[-Wbuiltin-declaration-mismatch]

It's only reported when kcov.c is compiled with any of the sanitizers
enabled.  Size of the arguments is correct, it's just that gcc uses 'long'
on 64-bit arches and 'long long' on 32-bit arches, while kernel type is
always 'long long'.

Link: https://lkml.kernel.org/r/20201209100152.2492072-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/Makefile~kcov-dont-instrument-with-ubsan
+++ a/kernel/Makefile
@@ -34,8 +34,11 @@ KCOV_INSTRUMENT_extable.o := n
 KCOV_INSTRUMENT_stacktrace.o := n
 # Don't self-instrument.
 KCOV_INSTRUMENT_kcov.o := n
+# If sanitizers detect any issues in kcov, it may lead to recursion
+# via printk, etc.
 KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
+UBSAN_SANITIZE_kcov.o := n
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 obj-y += sched/
_

Patches currently in -mm which might be from dvyukov@google.com are


