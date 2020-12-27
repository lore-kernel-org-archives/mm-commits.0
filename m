Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEC5C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E752B22A84
	for <mm-commits@archiver.kernel.org>; Sun, 27 Dec 2020 22:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgL0WF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Dec 2020 17:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgL0WF5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Dec 2020 17:05:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E04A2242A;
        Sun, 27 Dec 2020 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609106716;
        bh=SSdC1V4caJqrk2Y47YhMLzRFfY1QpRZWnPwJEtjQcq0=;
        h=Date:From:To:Subject:From;
        b=PFkt6OsKvNsCtDnqYBHD03YX2vI9wSQmrDm99OM5ajB3WuUi+m/co57jkU8Orcp/J
         568Wq+iDRgSvwzYuNRgiJz3v2lttFAywCaKF5Jkn3ZqbzRyyvhDttZYAmiGKqOM1Ww
         4P/eJeHPjyybh18Ahsa301Awh70+m4s57SKZMaoU=
Date:   Sun, 27 Dec 2020 14:05:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, steven.price@arm.com,
        osalvador@suse.de, david@redhat.com,
        alexander.h.duyck@linux.intel.com, guoren@linux.alibaba.com
Subject:  + mm-page-flagsh-typo-fix-it-if.patch added to -mm tree
Message-ID: <20201227220516.DhYJ0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-flags.h: Typo fix (It -> If)
has been added to the -mm tree.  Its filename is
     mm-page-flagsh-typo-fix-it-if.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-flagsh-typo-fix-it-if.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-flagsh-typo-fix-it-if.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -816,7 +816,7 @@ static inline void ClearPageSlabPfmemall
 
 /*
  * Flags checked when a page is freed.  Pages being freed should not have
- * these flags set.  It they are, there is a problem.
+ * these flags set.  If they are, there is a problem.
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
@@ -827,7 +827,7 @@ static inline void ClearPageSlabPfmemall
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
- * Pages being prepped should not have these flags set.  It they are set,
+ * Pages being prepped should not have these flags set.  If they are set,
  * there has been a kernel bug or struct page corruption.
  *
  * __PG_HWPOISON is exceptional because it needs to be kept beyond page's
_

Patches currently in -mm which might be from guoren@linux.alibaba.com are

mm-page-flagsh-typo-fix-it-if.patch

