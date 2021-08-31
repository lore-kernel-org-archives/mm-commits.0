Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30984C4320E
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107F761041
	for <mm-commits@archiver.kernel.org>; Tue, 31 Aug 2021 22:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhHaWYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Aug 2021 18:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230199AbhHaWYU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Aug 2021 18:24:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A31C6103D;
        Tue, 31 Aug 2021 22:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630448605;
        bh=B54QXKCLkJ/782a7AU/HrxMut5xNVqTVsEkmNHFkqik=;
        h=Date:From:To:Subject:From;
        b=PyygsbtZGJN1hblnh2bNiZeY4VP1MV2ztiFYhI5dXg/v/CL7zfILgGdZbRYbe5SEL
         P1th/I/q+OhE1LStfMYLOgH5PTCtVXh0uHSLtLz8dNFHIUDqKTJMfMwCevO/HvpBsP
         RNMGcJJ0S5yts+wBC+0564KkaeT0HnJCesLYgnU4=
Date:   Tue, 31 Aug 2021 15:23:24 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, sfr@canb.auug.org.au
Subject:  [alternative-merged]
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 removed from -mm tree
Message-ID: <20210831222324.ZkJdsC4Zz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
has been removed from the -mm tree.  Its filename was
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix

fix warning

cc1: warning: unrecognized command line option '-Wno-alloc-size-larger-than'

Ew. Thanks for letting me know. I thought I'd verified this existed in
gcc going back to 4.9, but it looks like I did something wrong in that
test.

Link: https://lkml.kernel.org/r/202108202248.921E8C66@keescook
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
+++ a/Makefile
@@ -1097,7 +1097,7 @@ endif
 ifdef CONFIG_CC_IS_GCC
 # The allocators already balk at large sizes, so silence the compiler
 # warnings for bounds checks involving those possible values.
-KBUILD_CFLAGS += -Wno-alloc-size-larger-than
+KBUILD_CFLAGS += $(call cc-option, -Wno-alloc-size-larger-than)
 endif
 
 # disable invalid "can't wrap" optimizations for signed / pointers
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-2.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

