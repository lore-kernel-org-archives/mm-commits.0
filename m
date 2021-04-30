Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198D8C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA1961452
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3FeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FeP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:34:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F70261423;
        Fri, 30 Apr 2021 05:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760807;
        bh=6rlDR7nllUzQtiVQBQOyu17ogmk7PZROIbQeAr1HI6s=;
        h=Date:From:To:Subject:From;
        b=T+oq5C7Y05OQTQJ2Rx9LlPk4IzAOwGYobm843aYyJ6VKoheZpAwvC8mVuqqq8MRf0
         8RKe/8EqFXn8Kms58DqXAFZqYqv+CrOXAxXpGXT54Lf0SvElcQATHsfT8PcNyIEcD8
         WKTGl/hvZFDPdE7cHf+L7KiIZ0q6JNApa/5QdgvQ=
Date:   Thu, 29 Apr 2021 22:33:27 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [folded-merged]
 mm-page_alloc-add-a-bulk-page-allocator-fix.patch removed from -mm tree
Message-ID: <20210430053327.K_xssNVFH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-a-bulk-page-allocator-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-a-bulk-page-allocator-fix.patch

This patch was dropped because it was folded into mm-page_alloc-add-a-bulk-page-allocator.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm-page_alloc-add-a-bulk-page-allocator-fix

Matthew Wilcox pointed out that the return type for alloc_pages_bulk()
and __alloc_pages_bulk() is inconsistent. Fix it.

Link: https://lkml.kernel.org/r/20210325123713.GQ3697@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/page_alloc.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-add-a-bulk-page-allocator-fix
+++ a/include/linux/gfp.h
@@ -518,7 +518,7 @@ static inline int arch_make_page_accessi
 struct page *__alloc_pages(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 
-int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct list_head *list);
 
--- a/mm/page_alloc.c~mm-page_alloc-add-a-bulk-page-allocator-fix
+++ a/mm/page_alloc.c
@@ -5019,7 +5019,7 @@ static inline bool prepare_alloc_pages(g
  *
  * Returns the number of pages on the list.
  */
-int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
+unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 			nodemask_t *nodemask, int nr_pages,
 			struct list_head *page_list)
 {
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix.patch
mm-page_alloc-add-a-bulk-page-allocator-fix-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch
mm-memory_hotplug-make-unpopulated-zones-pcp-structures-unreachable-during-hot-remove.patch

