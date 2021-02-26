Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40CCC433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 698E564F10
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZBRE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229769AbhBZBQ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA4B64F17;
        Fri, 26 Feb 2021 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302168;
        bh=gW3mrySOl/0veZobiCFMJI41EsWbOLaJuFY8RpvC960=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pf0IS4ObdWgHW91w66ZgHJSRY37vCoWo2mtm4xssbeQk3Fs6mMj0BumKBMmqYP7Nj
         OOv2nMUm5VH/tbSsn5t9mj1/Nzochh8sN/ST1We5gnYc6XUJW08WFGTmafLgPA1lot
         ni9NBvZBtnPVXOQAad5NE7c3Wkx0y/O6ZxzHuJVQ=
Date:   Thu, 25 Feb 2021 17:16:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 012/118] mm: remove nr_entries parameter from
 pagevec_lookup_entries
Message-ID: <20210226011607.VeqeFZN4s%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
