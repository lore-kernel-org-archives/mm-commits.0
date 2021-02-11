Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B887C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1273564E66
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBKSeZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232499AbhBKScl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 13:32:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C23F64E74;
        Thu, 11 Feb 2021 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613068251;
        bh=QXN1M0yqt5XjWf9+xTEmjPYmY59jaw42WQBvaZ/G++c=;
        h=Date:From:To:Subject:From;
        b=Po4blRRDQrBxuCTlcxSqSvt8IN6JqzU7G9ci2iwbnITiyIvIhs2mmqIUZx9CO0puN
         ayFkRQY2YGu3HlH0a+t8hLy+wMdBn85HBiIhHqpaa4NwoEOUHysmREfGRBrX4yBOVL
         GMJXnFgm4w9V6oqmJghDnwleEX9/PUNnm3cF/cyA=
Date:   Thu, 11 Feb 2021 10:30:51 -0800
From:   akpm@linux-foundation.org
To:     0x7f454c46@gmail.com, arnd@arndb.de, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        richard.weiyang@linux.alibaba.com, sedat.dilek@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-mremap-fix-build_bug_on-error-in-get_extent.patch removed from -mm tree
Message-ID: <20210211183051.vosKS1eDm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix BUILD_BUG_ON() error in get_extent
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-build_bug_on-error-in-get_extent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/mremap: fix BUILD_BUG_ON() error in get_extent

clang can't evaluate this function argument at compile time when the
function is not inlined, which leads to a link time failure:

ld.lld: error: undefined symbol: __compiletime_assert_414
>>> referenced by mremap.c
>>>               mremap.o:(get_extent) in archive mm/built-in.a

Mark the function as __always_inline to avoid it.

Link: https://lkml.kernel.org/r/20201230154104.522605-1-arnd@kernel.org
Fixes: 9ad9718bfa41 ("mm/mremap: calculate extent in one place")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-build_bug_on-error-in-get_extent
+++ a/mm/mremap.c
@@ -336,8 +336,9 @@ enum pgt_entry {
  * valid. Else returns a smaller extent bounded by the end of the source and
  * destination pgt_entry.
  */
-static unsigned long get_extent(enum pgt_entry entry, unsigned long old_addr,
-			unsigned long old_end, unsigned long new_addr)
+static __always_inline unsigned long get_extent(enum pgt_entry entry,
+			unsigned long old_addr, unsigned long old_end,
+			unsigned long new_addr)
 {
 	unsigned long next, extent, mask, size;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-add-match-all-tag-tests-fix.patch

