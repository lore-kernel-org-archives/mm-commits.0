Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2944C48BE8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBFC361350
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 23:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFOXH5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Jun 2021 19:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhFOXH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Jun 2021 19:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F19F661055;
        Tue, 15 Jun 2021 23:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623798351;
        bh=sw3uExNTxn8kh66YYMEOesscC9GPkNNq2HkgQQ+QBJo=;
        h=Date:From:To:Subject:From;
        b=PP0C3FP0sXewf209q/2eHZBLW6zspyevVdKP/oItIchZBMiTA7C/0JhZ6QWb3FSJq
         Bmv0Q18jqQ+rej/kkTL9sDtou1vNszz+aOyUskuBYQf4PyIjzmMrYoC5q23LXe/jFm
         6LxzVCtfMvXtcdUCPXvH3ajaJQbbfQSYOoaImX28=
Date:   Tue, 15 Jun 2021 16:05:50 -0700
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, glittao@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com, vbabka@suse.cz
Subject:  + hexagon-handle-softirqentry_text-in-linker-script.patch
 added to -mm tree
Message-ID: <20210615230550.p0-Af9HPq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script
has been added to the -mm tree.  Its filename is
     hexagon-handle-softirqentry_text-in-linker-script.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hexagon-handle-softirqentry_text-in-linker-script.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hexagon-handle-softirqentry_text-in-linker-script.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from nathan@kernel.org are

hexagon-handle-softirqentry_text-in-linker-script.patch
hexagon-use-common-discards-macro.patch
hexagon-select-arch_want_ld_orphan_warn.patch

