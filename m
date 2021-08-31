Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3182FC432BE
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2D861057
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhHaWYQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhHaWYM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8FA86103D;
        Tue, 31 Aug 2021 22:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630448596;
        bh=e8Qe34h2M+KQqGJO/9hxEusoq27vkeJz4dyZxoLLuXM=;
        h=Date:From:To:Subject:From;
        b=IE0MQYIzog3mg7C0OoC2+6jBQyOust3ECJD/8gR/N8Qb7xNZa594rLgaYwc53Nb7W
         N+PjBFyyo8BVOMn7ycQp0qd8YcOkS4RWi3M8CzxD7oswTRH7BZnIq3L7KUhhTkUQxT
         6Bnl6krOPjDKceeIU7CJEeKXNTc3fRCZzKkVuLjo=
Date:   Tue, 31 Aug 2021 15:23:16 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch
 added to -mm tree
Message-ID: <20210831222316.MR647AJiz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Compiler Attributes: Add __alloc_size for better bounds checking fix
has been added to the -mm tree.  Its filename is
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch

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
Subject: Compiler Attributes: Add __alloc_size for better bounds checking fix

Adjust the warning logic to deal with pre-9.1 gcc behaviors.

Link: https://lkml.kernel.org/r/20210827151327.2729736-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/Makefile~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2
+++ a/Makefile
@@ -1094,8 +1094,17 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 # The allocators already balk at large sizes, so silence the compiler
-# warnings for bounds checks involving those possible values.
-KBUILD_CFLAGS += -Wno-alloc-size-larger-than
+# warnings for bounds checks involving those possible values. While
+# -Wno-alloc-size-larger-than would normally be used here, earlier versions
+# of gcc (<9.1) weirdly don't handle the option correctly when _other_
+# warnings are produced (?!). Using -Walloc-size-larger-than=SIZE_MAX
+# doesn't work (as it is documented to), silently resolving to "0" prior to
+# version 9.1 (and producing an error more recently). Numeric values larger
+# than PTRDIFF_MAX also don't work prior to version 9.1, which are silently
+# ignored, continuing to default to PTRDIFF_MAX. So, left with no other
+# choice, we must perform a versioned check to disable this warning.
+# https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
+KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0901, -Wno-alloc-size-larger-than)
 endif
 
 # disable invalid "can't wrap" optimizations for signed / pointers
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

