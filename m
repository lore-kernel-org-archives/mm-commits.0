Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED338C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 20:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbhKXUiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 15:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234742AbhKXUiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 15:38:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1D6260F5A;
        Wed, 24 Nov 2021 20:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637786114;
        bh=AuI20SIV088dsLGNUM8D3vTBBOmQ4Dt/D2v1FRuktU8=;
        h=Date:From:To:Subject:From;
        b=Xoe1nzQs2sdMkgy+NJmSqHxWSo5aDg7TUC1z3U6v6byhBHyco5TPHlbEkpEn/zhIB
         ggPO9a9dttK57kpKckPvfDTsEAPnKXll7ysVO6dvPE9rN7KMZfjO82EsjUNSLFwbEF
         qf9OgJX+1zKTAlDL8Fk/LQzI6+4AsecFBslf0jgs=
Date:   Wed, 24 Nov 2021 12:35:14 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  [nacked] mm-thp-update-split_queue_len-correctly.patch
 removed from -mm tree
Message-ID: <20211124203514.BeKEPJ_TT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: update split_queue_len correctly
has been removed from the -mm tree.  Its filename was
     mm-thp-update-split_queue_len-correctly.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: thp: update split_queue_len correctly

The deferred THPs are split on memory pressure through shrinker callback
and splitting of THP during reclaim can fail for several reasons like
unable to lock the THP, under writeback or unexpected number of pins on
the THP.  Such pages are put back on the deferred split list for
consideration later.  However kernel does not update the deferred queue
size on putting back the pages whose split was failed.  This patch fixes
that.

Without this patch the split_queue_len can underflow.  Shrinker will
always get that there are some THPs to split even if there are not and
waste some cpu to scan the empty list.

Link: https://lkml.kernel.org/r/20211123190916.1738458-1-shakeelb@google.com
Fixes: 364c1eebe453 ("mm: thp: extract split_queue_* into a struct")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-thp-update-split_queue_len-correctly
+++ a/mm/huge_memory.c
@@ -2809,7 +2809,7 @@ static unsigned long deferred_split_scan
 	unsigned long flags;
 	LIST_HEAD(list), *pos, *next;
 	struct page *page;
-	int split = 0;
+	unsigned long split = 0;
 
 #ifdef CONFIG_MEMCG
 	if (sc->memcg)
@@ -2847,6 +2847,7 @@ next:
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	list_splice_tail(&list, &ds_queue->split_queue);
+	ds_queue->split_queue_len -= split;
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	/*
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-better-bounds-on-the-memcg-stats-updates.patch

