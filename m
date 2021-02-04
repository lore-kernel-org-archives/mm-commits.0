Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C843C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B25C064DE8
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhBDAVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:21:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233288AbhBDAVR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:21:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A2A64F64;
        Thu,  4 Feb 2021 00:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612398031;
        bh=1WVyVeAKbOT2iTg5f+QSSEihAoBcWV2S5z0G5Lr0SlE=;
        h=Date:From:To:Subject:From;
        b=aP60UbyzwMZnOpIUGaY2OTy8EJLADR6WXnmDRNTRQsi0O97RhFtmsunjEimzIZFr2
         JtkpoLMWsZJ+FVT3kMDzbXQvYckNaaipYxk/YObYPiGGawnlfn9kCjNlw3Zfj5fXbn
         0eoxQkdurXhCNAZknDbtuQ+FUDATcMiqOozl5V3c=
Date:   Wed, 03 Feb 2021 16:20:30 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, arnd@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-mremap-fix-build_bug_on-error-in-get_extent.patch
 added to -mm tree
Message-ID: <20210204002030.FFOSUHLTU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: fix BUILD_BUG_ON() error in get_extent
has been added to the -mm tree.  Its filename is
     mm-mremap-fix-build_bug_on-error-in-get_extent.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-fix-build_bug_on-error-in-get_extent.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-fix-build_bug_on-error-in-get_extent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@kernel.org>
Subject: mm/mremap: fix BUILD_BUG_ON() error in get_extent


clang cannt evaluate this function argument at compile time
when the function is not inlined, which leads to a link
time failure:

ld.lld: error: undefined symbol: __compiletime_assert_414
>>> referenced by mremap.c
>>>               mremap.o:(get_extent) in archive mm/built-in.a

Mark the function as __always_inline to avoid it.

Link: https://lkml.kernel.org/r/20201230154104.522605-1-arnd@kernel.org
Fixes: 9ad9718bfa41 ("mm/mremap: calculate extent in one place")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

Patches currently in -mm which might be from arnd@kernel.org are

mm-mremap-fix-build_bug_on-error-in-get_extent.patch

