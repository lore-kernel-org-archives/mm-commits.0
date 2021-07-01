Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86038C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73BB76146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbhGABz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238512AbhGABz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563866105A;
        Thu,  1 Jul 2021 01:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104406;
        bh=75MpHzPBdLRs4LUJDA84iDhYm7fUQ5Jxo0mDUgQnjgI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bzsy12g79gC8d0yE3P6He3dBT8+a9wpYaPTVjsO5F2Y2RrAqYr/bVrN1GQ6u/O6QS
         0IPvOMlMKTypF2AIDBmJfThSGEAUr/IyrHvYnG3IDi01F+YiG/GcZXqp6izS8Ue778
         EsqW6oVoPZAjTKhkAY5+YzUssIfF0TeXEsN16dFk=
Date:   Wed, 30 Jun 2021 18:53:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 117/192] mm/page_alloc: make
 should_fail_alloc_page() static
Message-ID: <20210701015325.rUmsTZN2H%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: make should_fail_alloc_page() static

make W=1 generates the following warning for mm/page_alloc.c

  mm/page_alloc.c:3651:15: warning: no previous prototype for `should_fail_alloc_page' [-Wmissing-prototypes]
   noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
                 ^~~~~~~~~~~~~~~~~~~~~~

This function is deliberately split out for BPF to allow errors to be
injected.  The function is not used anywhere else so it is local to the
file.  Make it static which should still allow error injection to be used
similar to how block/blk-core.c:should_fail_bio() works.

Link: https://lkml.kernel.org/r/20210520084809.8576-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static
+++ a/mm/page_alloc.c
@@ -3819,7 +3819,7 @@ static inline bool __should_fail_alloc_p
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
_
