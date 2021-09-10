Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB75C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 00:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4558611C2
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 00:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhIJA4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhIJAx4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 20:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ED05610C9;
        Fri, 10 Sep 2021 00:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631235164;
        bh=PcDVhZA7Iev6NA6rGPvFZy6f2y/lGgkOU7+zzASUph4=;
        h=Date:From:To:Subject:From;
        b=SpVHZ522WAo+2LYsH2ktJjJQWFHJg46I8D2LfwD3JZDkRoefxJTzTA84eNKR/m6jx
         bkJsejJK30cA55UrOE+v4E4maazWZmPDnGeYKOec9wKLJXRFjoEptZRnXqH6zvR/zh
         pF8kxF7L8sZ/IXJS4dJDX1lnKMN+SLMiog3zIoho=
Date:   Thu, 09 Sep 2021 17:52:44 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch
 removed from -mm tree
Message-ID: <20210910005244.6cGfxyyiL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Compiler Attributes: Add __alloc_size for better bounds checking fix
has been removed from the -mm tree.  Its filename was
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch

This patch was dropped because it was folded into compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch

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

rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

