Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF24CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBCGgv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBCGgC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:36:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555168B37C
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E614061D1D
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4780BC433D2;
        Fri,  3 Feb 2023 06:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406160;
        bh=FnVmp1Tzglnaz7hAA4LCDLHRtuvv7FMidJ01Qc7UHyk=;
        h=Date:To:From:Subject:From;
        b=nZhbK77rV/raCfcwAmh6/EuAu15Vo5M6oWXlej1CScDaY9BlvAk7wzI8l3XfR9dmq
         c3PjLZAYOWPT9ilJ2YnWOtseH01ArHsqs72lhHK1v04KAx4EHFMglU5LA6Zwfu9Sct
         E0fNQj7T36bYGHzQpu3yKvMHj9VZJVCXKCnMKM3c=
Date:   Thu, 02 Feb 2023 22:35:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch removed from -mm tree
Message-Id: <20230203063600.4780BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/huge_memory: convert get_deferred_split_queue() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/huge_memory: convert get_deferred_split_queue() to take a folio
Date: Wed, 11 Jan 2023 14:29:12 +0000

Removes a few calls to compound_head().

Link: https://lkml.kernel.org/r/20230111142915.1001531-27-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio
+++ a/mm/huge_memory.c
@@ -559,10 +559,11 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 }
 
 #ifdef CONFIG_MEMCG
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
 {
-	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
 
 	if (memcg)
 		return &memcg->deferred_split_queue;
@@ -570,9 +571,10 @@ static inline struct deferred_split *get
 		return &pgdat->deferred_split_queue;
 }
 #else
-static inline struct deferred_split *get_deferred_split_queue(struct page *page)
+static inline
+struct deferred_split *get_deferred_split_queue(struct folio *folio)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
+	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
 
 	return &pgdat->deferred_split_queue;
 }
@@ -2650,7 +2652,7 @@ bool can_split_folio(struct folio *folio
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct folio *folio = page_folio(page);
-	struct deferred_split *ds_queue = get_deferred_split_queue(&folio->page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2801,7 +2803,7 @@ out:
 void free_transhuge_page(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
@@ -2816,7 +2818,7 @@ void free_transhuge_page(struct page *pa
 void deferred_split_huge_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	struct deferred_split *ds_queue = get_deferred_split_queue(page);
+	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup *memcg = folio_memcg(folio);
 #endif
_

Patches currently in -mm which might be from willy@infradead.org are


