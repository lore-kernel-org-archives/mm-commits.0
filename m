Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE654C4338F
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 21:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C275961214
	for <mm-commits@archiver.kernel.org>; Sun, 22 Aug 2021 21:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhHVVJc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Aug 2021 17:09:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhHVVJc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Aug 2021 17:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F65A610E6;
        Sun, 22 Aug 2021 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629666530;
        bh=su0+jAzlULegTOoKuXzmRLCMeOXYtuN1QgT3H3pQ/G4=;
        h=Date:From:To:Subject:From;
        b=zp8S01IDigDkB37AFK4uPpQmsRGQ/eR8J/r7KUTvNn3c0ZysLo/JUJrBHW8fKPoeG
         yuczI1ZEm5sARUr/n9G+U5qM65Zp0anoxZnP+8w5MLxTUC5+qPb7ZSdX6kmU3RQnaG
         rqTGnPOmPEuCmGB/JrhTmxWy//wR2Gu0dxN5J/C8=
Date:   Sun, 22 Aug 2021 14:08:50 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rdunlap@infradead.org, keescook@chromium.org
Subject:  +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 added to -mm tree
Message-ID: <20210822210850.wOEqC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
has been added to the -mm tree.  Its filename is
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

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
@@ -1081,7 +1081,7 @@ KBUILD_CFLAGS += $(call cc-disable-warni
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
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch

