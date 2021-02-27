Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B6FC4332D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0C2164F3F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhB0C3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhB0C3f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C2664F29;
        Sat, 27 Feb 2021 02:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392916;
        bh=GcPwx4CSAvqtkb5/tTIgLID5qTiKz7ZHlb0CIvWGxLE=;
        h=Date:From:To:Subject:From;
        b=E3An4cTNIrRgGZI8KELDX+CqUZbf/qObH+QhxEkstfNZ7ZXAWwnqy/cggAwjsjr5H
         lWGOz6pAeGyRnCCEstkcnEaVzdh7FO3ZibXiQN8iMFCffbxcHcRaRcxCSalhi3bsaI
         aPUJ4pz8oODY4duPFEBxMQsv8BFz55vj184Qgw7Q=
Date:   Fri, 26 Feb 2021 18:28:36 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch removed
 from -mm tree
Message-ID: <20210227022836.wIwblDsbG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove nr_entries parameter from pagevec_lookup_entries
has been removed from the -mm tree.  Its filename was
     mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove nr_entries parameter from pagevec_lookup_entries

All callers want to fetch the full size of the pvec.

Link: https://lkml.kernel.org/r/20201112212641.27837-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    2 +-
 mm/swap.c               |    4 ++--
 mm/truncate.c           |    5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/include/linux/pagevec.h
@@ -27,7 +27,7 @@ void __pagevec_release(struct pagevec *p
 void __pagevec_lru_add(struct pagevec *pvec);
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		unsigned nr_entries, pgoff_t *indices);
+		pgoff_t *indices);
 void pagevec_remove_exceptionals(struct pagevec *pvec);
 unsigned pagevec_lookup_range(struct pagevec *pvec,
 			      struct address_space *mapping,
--- a/mm/swap.c~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/mm/swap.c
@@ -1044,9 +1044,9 @@ void __pagevec_lru_add(struct pagevec *p
  */
 unsigned pagevec_lookup_entries(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t start, pgoff_t end,
-		unsigned nr_entries, pgoff_t *indices)
+		pgoff_t *indices)
 {
-	pvec->nr = find_get_entries(mapping, start, end, nr_entries,
+	pvec->nr = find_get_entries(mapping, start, end, PAGEVEC_SIZE,
 				    pvec->pages, indices);
 	return pagevec_count(pvec);
 }
--- a/mm/truncate.c~mm-remove-nr_entries-parameter-from-pagevec_lookup_entries
+++ a/mm/truncate.c
@@ -377,7 +377,7 @@ void truncate_inode_pages_range(struct a
 	for ( ; ; ) {
 		cond_resched();
 		if (!pagevec_lookup_entries(&pvec, mapping, index, end - 1,
-				PAGEVEC_SIZE, indices)) {
+				indices)) {
 			/* If all gone from start onwards, we're done */
 			if (index == start)
 				break;
@@ -638,8 +638,7 @@ int invalidate_inode_pages2_range(struct
 
 	pagevec_init(&pvec);
 	index = start;
-	while (pagevec_lookup_entries(&pvec, mapping, index, end,
-			PAGEVEC_SIZE, indices)) {
+	while (pagevec_lookup_entries(&pvec, mapping, index, end, indices)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
_

Patches currently in -mm which might be from willy@infradead.org are


