Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB21DC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhKXAWe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhKXAWd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:22:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C112B60240;
        Wed, 24 Nov 2021 00:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637713165;
        bh=Bv66ABb0m0ddqGjTPm0GHa3LdaDLjVqplXTzZtbx46U=;
        h=Date:From:To:Subject:From;
        b=sOgLFVEhqc7YPV3eo/XHoqMfJwzoisPls95XPrWOaCy03h/1YNtz7kcHx0950H92E
         0u1lCM3Jvxp/l0WP34CRXiBVbSbz3pJmiJNQ7Ox8gHIjufG/tzo+AO/GVewqoNrs+r
         r7nBmxlBTkjdRH+/8hXWArLrm6LlG6NiDQ4bKrbw=
Date:   Tue, 23 Nov 2021 16:19:24 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, willy@infradead.org,
        ziy@nvidia.com
Subject:  + mm-thp-update-split_queue_len-correctly.patch added to
 -mm tree
Message-ID: <20211124001924.0Lsind2sx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: update split_queue_len correctly
has been added to the -mm tree.  Its filename is
     mm-thp-update-split_queue_len-correctly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-update-split_queue_len-correctly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-update-split_queue_len-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-thp-update-split_queue_len-correctly.patch

