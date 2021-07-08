Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23FAC11F67
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B190D61CCA
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhGHBKU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhGHBKU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659E961C77;
        Thu,  8 Jul 2021 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706458;
        bh=qQNEhEAbCr+qLALTE0+3pjBhaVUEbzqi13DBr6bPkiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W9Q4sicnZx0L135sxNkfadh/rlrY2qTWTDdSjrZGjLTTv12kGoOuAY18YLgG+O2JA
         4HzAjmplgCKhCO7J4zZROA6GNRGkDEcGKwys7LGtTybRv3QMC08A4rshhrnZXtKRyf
         tyvgTZcyU8WvNwmzhnB4jRa367uGvcbYvzNACrq8=
Date:   Wed, 07 Jul 2021 18:07:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bcain@codeaurora.org, glittao@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 04/54] hexagon: handle {,SOFT}IRQENTRY_TEXT in
 linker script
Message-ID: <20210708010738.r83aAW_mK%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script

Patch series "hexagon: Fix build error with CONFIG_STACKDEPOT and select CONFIG_ARCH_WANT_LD_ORPHAN_WARN".

This series fixes an error with ARCH=hexagon that was pointed out by the
patch "mm/slub: use stackdepot to save stack trace in objects".

The first patch fixes that error by handling the '.irqentry.text' and
'.softirqentry.text' sections.

The second patch switches Hexagon over to the common DISCARDS macro, which
should have been done when Hexagon was merged into the tree to match
commit 023bf6f1b8bf ("linker script: unify usage of discard definition").

The third patch selects CONFIG_ARCH_WANT_LD_ORPHAN_WARN so that something
like this does not happen again.


This patch (of 3):

Patch "mm/slub: use stackdepot to save stack trace in objects" in -mm
selects CONFIG_STACKDEPOT when CONFIG_STACKTRACE_SUPPORT is selected and
CONFIG_STACKDEPOT requires IRQENTRY_TEXT and SOFTIRQENTRY_TEXT to be
handled after commit 505a0ef15f96 ("kasan: stackdepot: move
filter_irq_stacks() to stackdepot.c") due to the use of the
__{,soft}irqentry_text_{start,end} section symbols.  If those sections are
not handled, the build is broken.

$ make ARCH=hexagon CROSS_COMPILE=hexagon-linux- LLVM=1 LLVM_IAS=1 defconfig all
...
ld.lld: error: undefined symbol: __irqentry_text_start
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __irqentry_text_end
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __softirqentry_text_start
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __softirqentry_text_end
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
...

Add these sections to the Hexagon linker script so the build continues to
work.  ld.lld's orphan section warning would have caught this prior to the
-mm commit mentioned above:

ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'
ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'
ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'

Link: https://lkml.kernel.org/r/20210521011239.1332345-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20210521011239.1332345-2-nathan@kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1381
Fixes: 505a0ef15f96 ("kasan: stackdepot: move filter_irq_stacks() to stackdepot.c")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vmlinux.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/hexagon/kernel/vmlinux.lds.S~hexagon-handle-softirqentry_text-in-linker-script
+++ a/arch/hexagon/kernel/vmlinux.lds.S
@@ -38,6 +38,8 @@ SECTIONS
 	.text : AT(ADDR(.text)) {
 		_text = .;
 		TEXT_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
 		LOCK_TEXT
_
