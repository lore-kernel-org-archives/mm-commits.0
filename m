Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874F3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7331061469
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbhGABxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238452AbhGABxV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:53:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD246105A;
        Thu,  1 Jul 2021 01:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104251;
        bh=sW2YVX7JTuv9Ix1neyEH1wc4ioUwYFcLg/KnAEK56IU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R0ZKT8tfejr1U1nVw8VVLIoGqnl24//nDqcbxAZx1i/pRcjCADRXy5shOap6GCoR6
         /6hD70M/Hc1CdonIjnrbWGXfIHGCdQ0zZMyOMEQvTDcUHpit0nIjqrRszxcXQZXoEd
         yglUG2zjulto5GFvHHwvE6eFb7KYShC0NvDUEQMs=
Date:   Wed, 30 Jun 2021 18:50:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        liu.xiang@zlingsmart.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 069/192] mm: compaction: remove duplicate
 !list_empty(&sublist) check
Message-ID: <20210701015051.qyVr1V2h4%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm: compaction: remove duplicate !list_empty(&sublist) check

The list_splice_tail(&sublist, freelist) also do !list_empty(&sublist)
check, so remove the duplicate call.

Link: https://lkml.kernel.org/r/20210609095409.19920-1-liu.xiang@zlingsmart.com
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-duplicate-list_emptysublist-check
+++ a/mm/compaction.c
@@ -1297,8 +1297,7 @@ move_freelist_head(struct list_head *fre
 
 	if (!list_is_last(freelist, &freepage->lru)) {
 		list_cut_before(&sublist, freelist, &freepage->lru);
-		if (!list_empty(&sublist))
-			list_splice_tail(&sublist, freelist);
+		list_splice_tail(&sublist, freelist);
 	}
 }
 
@@ -1315,8 +1314,7 @@ move_freelist_tail(struct list_head *fre
 
 	if (!list_is_first(freelist, &freepage->lru)) {
 		list_cut_position(&sublist, freelist, &freepage->lru);
-		if (!list_empty(&sublist))
-			list_splice_tail(&sublist, freelist);
+		list_splice_tail(&sublist, freelist);
 	}
 }
 
_
