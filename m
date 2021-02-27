Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B034AC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F18A64F40
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhB0CbF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230163AbhB0Cap (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB4464EC4;
        Sat, 27 Feb 2021 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393018;
        bh=r+/h9Qqe1FGYqD3hBQPlw0n7Kt9zyysGQt9Uf8jZkTQ=;
        h=Date:From:To:Subject:From;
        b=NanXiOBhRm6UeWkZsY/nzLEJV6dpz7VgKswK2sOsTBjT61QoVM/Cq4daPRIYtoBi+
         Ya39EkeyX/kZGPs3hwv1dDmvV/2cn0DM/nLIL0DuViolH67sG5lqCax+wZkUBhV6Bg
         6OhVk8MoFFnbIrbxUs9fK19FhAvBpB5LUYFXx0MU=
Date:   Fri, 26 Feb 2021 18:30:18 -0800
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, david@redhat.com,
        guoren@linux.alibaba.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, steven.price@arm.com
Subject:  [merged] mm-page-flagsh-typo-fix-it-if.patch removed from
 -mm tree
Message-ID: <20210227023018.VD6ThiDuY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-flags.h: Typo fix (It -> If)
has been removed from the -mm tree.  Its filename was
     mm-page-flagsh-typo-fix-it-if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Ren <guoren@linux.alibaba.com>
Subject: mm: page-flags.h: Typo fix (It -> If)

The "If" was wrongly spelled as "It".

Link: https://lkml.kernel.org/r/1608959036-91409-1-git-send-email-guoren@kernel.org
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flagsh-typo-fix-it-if
+++ a/include/linux/page-flags.h
@@ -810,7 +810,7 @@ static inline void ClearPageSlabPfmemall
 
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
- * these flags set.  It they are, there is a problem.
+ * these flags set.  If they are, there is a problem.
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
@@ -821,7 +821,7 @@ static inline void ClearPageSlabPfmemall
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
- * Pages being prepped should not have these flags set.  It they are set,
+ * Pages being prepped should not have these flags set.  If they are set,
  * there has been a kernel bug or struct page corruption.
  *
  * __PG_HWPOISON is exceptional because it needs to be kept beyond page's
_

Patches currently in -mm which might be from guoren@linux.alibaba.com are


