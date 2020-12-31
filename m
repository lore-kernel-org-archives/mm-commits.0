Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6FCC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C9F223E0
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLaSX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:23:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgLaSX2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AFA6223E4;
        Thu, 31 Dec 2020 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438967;
        bh=ZSN5eVcp5UEZHR/KVyNovraFnCy32MY77p4x5Eyu2Fs=;
        h=Date:From:To:Subject:From;
        b=Sv+keONNymRPYF4tBqxmoli9zrJpHLxbZ+VxWw5PdzNFZlGs8EQZNY/gv6nvmc9+5
         1Yo7NyodTyFjJc/nWRnZBSqEuAQvU8CjRlSkDSOaXpQDzQHyXAnWoyXFdjBBedtBiC
         sKVB8w9H9fQddOqol2hSYz78WhG7Embx/rIb2G+Q=
Date:   Thu, 31 Dec 2020 10:22:46 -0800
From:   akpm@linux-foundation.org
To:     elver@google.com, masahiroy@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged]
 revert-kbuild-avoid-static_assert-for-genksyms.patch removed from -mm tree
Message-ID: <20201231182246.bv94RQgTA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kbuild: avoid static_assert for genksyms"
has been removed from the -mm tree.  Its filename was
     revert-kbuild-avoid-static_assert-for-genksyms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: Revert "kbuild: avoid static_assert for genksyms"

This reverts commit 14dc3983b5dff513a90bd5a8cc90acaf7867c3d0.

Macro Elver had sent a fix proper fix earlier, and also pointed out
corner cases:

"I guess what you propose is simpler, but might still have corner cases
where we still get warnings. In particular, if some file (for whatever
reason) does not include build_bug.h and uses a raw _Static_assert(),
then we still get warnings. E.g. I see 1 user of raw _Static_assert()
(drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h )."

I believe the raw use of _Static_assert() should be allowed, so this
should be fixed in genksyms.

Even after commit 14dc3983b5df ("kbuild: avoid static_assert for
genksyms"), I confirmed the following test code emits the warning.

  ---------------->8----------------
  #include <linux/export.h>

  _Static_assert((1 ?: 0), "");

  void foo(void) { }
  EXPORT_SYMBOL(foo);
  ---------------->8----------------

  WARNING: modpost: EXPORT symbol "foo" [vmlinux] version generation failed, symbol will not be versioned.

Now that commit 869b91992bce ("genksyms: Ignore module scoped
_Static_assert()") fixed this issue properly, the workaround should
be reverted.

Link: https://lkml.org/lkml/2020/12/10/845
Link: https://lkml.kernel.org/r/20201219183911.181442-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/build_bug.h~revert-kbuild-avoid-static_assert-for-genksyms
+++ a/include/linux/build_bug.h
@@ -77,9 +77,4 @@
 #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
 #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
 
-#ifdef __GENKSYMS__
-/* genksyms gets confused by _Static_assert */
-#define _Static_assert(expr, ...)
-#endif
-
 #endif	/* _LINUX_BUILD_BUG_H */
_

Patches currently in -mm which might be from masahiroy@kernel.org are


