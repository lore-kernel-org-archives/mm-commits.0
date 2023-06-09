Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EA6C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjFIXdf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjFIXcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:32:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E2249CF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348EB63E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89458C433D2;
        Fri,  9 Jun 2023 23:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353398;
        bh=PPywdsIZW+Ws7m6AKTTydO4R4rcf/PS6g4M1+2ecd28=;
        h=Date:To:From:Subject:From;
        b=hjwOal1799lnhNNcXvoODurE0HOLvblzyjKXNtJaDrGLUEyNmY/jGIygUF/mcCO9H
         XSBAq1urNRKwpVy4rp6Pp0DXjqsUV5VZzVVomjZuEyFWGOP8ndNK1rzhPfOEogpB8J
         /aqBUqU9EXV2CBFBKG9TBsdpwbt3HCcpQbMpQAJo=
Date:   Fri, 09 Jun 2023 16:29:57 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, ryan.roberts@arm.com,
        kirill.shutemov@linux.intel.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] thp-avoid-lock-when-check-whether-thp-is-in-deferred-list.patch removed from -mm tree
Message-Id: <20230609232958.89458C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: THP: avoid lock when check whether THP is in deferred list
has been removed from the -mm tree.  Its filename was
     thp-avoid-lock-when-check-whether-thp-is-in-deferred-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: THP: avoid lock when check whether THP is in deferred list
Date: Sat, 29 Apr 2023 16:27:58 +0800

free_transhuge_page() acquires split queue lock then check whether the THP
was added to deferred list or not.  It brings high deferred queue lock
contention.

It's safe to check whether the THP is in deferred list or not without
holding the deferred queue lock in free_transhuge_page() because when code
hit free_transhuge_page(), there is no one tries to add the folio to
_deferred_list.

Running page_fault1 of will-it-scale + order 2 folio for anonymous
mapping with 96 processes on an Ice Lake 48C/96T test box, we could
see the 61% split_queue_lock contention:
-   63.02%     0.01%  page_fault1_pro  [kernel.kallsyms]         [k] free_transhuge_page
   - 63.01% free_transhuge_page
      + 62.91% _raw_spin_lock_irqsave

With this patch applied, the split_queue_lock contention is less
than 1%.

Link: https://lkml.kernel.org/r/20230429082759.1600796-2-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~thp-avoid-lock-when-check-whether-thp-is-in-deferred-list
+++ a/mm/huge_memory.c
@@ -2792,12 +2792,19 @@ void free_transhuge_page(struct page *pa
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	unsigned long flags;
 
-	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-	if (!list_empty(&folio->_deferred_list)) {
-		ds_queue->split_queue_len--;
-		list_del(&folio->_deferred_list);
+	/*
+	 * At this point, there is no one trying to add the folio to
+	 * deferred_list. If folio is not in deferred_list, it's safe
+	 * to check without acquiring the split_queue_lock.
+	 */
+	if (data_race(!list_empty(&folio->_deferred_list))) {
+		spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+		if (!list_empty(&folio->_deferred_list)) {
+			ds_queue->split_queue_len--;
+			list_del(&folio->_deferred_list);
+		}
+		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 	}
-	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 	free_compound_page(page);
 }
 
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


