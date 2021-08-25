Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66191C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9C2610CB
	for <mm-commits@archiver.kernel.org>; Wed, 25 Aug 2021 17:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbhHYR0a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Aug 2021 13:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233612AbhHYR0a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Aug 2021 13:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C585610A0;
        Wed, 25 Aug 2021 17:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629912344;
        bh=OQWCTB9a1u1llPhM1QCe/kX3G+dRa2BpZNFcdaRriTs=;
        h=Date:From:To:Subject:From;
        b=RiF7cD8b/BD6EmXa5HtmnrXbvnN2mVTOtwkAaPFPwJzxAQSN5V7ANE1SSn1QgxeQx
         NZ5eY7UCKQeFPW8NZHm1PQ9N8wZH02weJwITQdacL4MheUK6ZIdfSRrZoU6DORK1PY
         anU/jN+XOI8h/kTfa0e7LjA17mBm5gDj0V/dBb+Q=
Date:   Wed, 25 Aug 2021 10:25:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, keescook@chromium.org
Subject:  +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch
 added to -mm tree
Message-ID: <20210825172543.9rFCB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix
has been added to the -mm tree.  Its filename is
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix

Okay, I think this work-around should work. I've been able to reproduce
the weird conditions, and this seems to behave correctly. Andrew, can
you fixup the fixup with this?

Link: https://lkml.kernel.org/r/202108250959.CD734CED@keescook
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/Makefile~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix
+++ a/Makefile
@@ -1096,8 +1096,13 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 # The allocators already balk at large sizes, so silence the compiler
-# warnings for bounds checks involving those possible values.
-KBUILD_CFLAGS += $(call cc-option, -Wno-alloc-size-larger-than)
+# warnings for bounds checks involving those possible values. While
+# -Wno-alloc-size-larger-than would normally be used here, some versions
+# of gcc (<9.1) weirdly don't handle the option correctly when _other_
+# warnings are produced (?!), so instead use SIZE_MAX to effectively
+# disable it.
+# https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
+KBUILD_CFLAGS += $(call cc-option, -Walloc-size-larger-than=SIZE_MAX)
 endif
 
 # disable invalid "can't wrap" optimizations for signed / pointers
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

