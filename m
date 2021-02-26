Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6F1C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D32664F31
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZBTY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBZBTT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:19:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12CBC64F26;
        Fri, 26 Feb 2021 01:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302319;
        bh=4jq10kIb32d1TFfbO/rxpIHbwKJTFQvwFiqhkzMMnSI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HnUO/0mJBDJwZDxaXzBRb1HoK3F9do1d1G68qTdkC8jPjYtgxLVvDSQaCHcNBQNH1
         ZO65TfO7wLShdk2JTGX7wkaEPBAH79OGskrjZySB1Ams6YI8LbInsmSVGNZgYHMRyZ
         z6yEv2qhiBrqXmXCGJnhDew7/HulgdPxdUbKbD1Y=
Date:   Thu, 25 Feb 2021 17:18:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        david@redhat.com, guoren@linux.alibaba.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        steven.price@arm.com, torvalds@linux-foundation.org
Subject:  [patch 052/118] mm: page-flags.h: Typo fix (It -> If)
Message-ID: <20210226011838.OLWnpIkym%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
