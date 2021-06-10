Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2667C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 23:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96FC761403
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 23:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFJXrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFJXrP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 19:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0CA5613DE;
        Thu, 10 Jun 2021 23:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623368702;
        bh=wpAYNqIyFUTOI1XOm2Zlnwbdd8zc4lwH/5D5s0YCiVs=;
        h=Date:From:To:Subject:From;
        b=RDgM07vcfyLiMogN2G11V9xKgSFGvj8EqQcv/p3gET6PUX6xPJcvLrJ8nf5LwcjIc
         pl9dUXxmLPJY2hKHWnMiTYzRsCymrSyznrOcfnPv4Gi9+R2rFN+feMWfh2dt66hG2J
         612y3FMrNyx270vIxuBlDrp1ekzI123opnJrknz8=
Date:   Thu, 10 Jun 2021 16:45:02 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, liu.xiang@zlingsmart.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-compaction-remove-duplicate-list_emptysublist-check.patch added to -mm
 tree
Message-ID: <20210610234502.DqvZmxhAc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: remove duplicate !list_empty(&sublist) check
has been added to the -mm tree.  Its filename is
     mm-compaction-remove-duplicate-list_emptysublist-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-remove-duplicate-list_emptysublist-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-remove-duplicate-list_emptysublist-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are

mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch
mm-compaction-remove-duplicate-list_emptysublist-check.patch

