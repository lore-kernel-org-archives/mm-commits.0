Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E60C2BB48
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CE2022CB8
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgLPAAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbgLOX0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:42 -0500
Date:   Tue, 15 Dec 2020 15:17:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074275;
        bh=xAC0DdTM4Z4BQ2Ix0NYgT6CS7ey0/AS2ZeCQla75Kak=;
        h=From:To:Subject:From;
        b=phhSREgkpVhjhPLGuqdnffyJUhZG1jcFfHnMzIucrYnHyx83CgXqQ2bJVJXwMmkDo
         j58kIcbM5KzdPqvUgyygsCMDs2e/wFSbrN0yBYo4cgTbWCH5yjUCbdTzgo3wBJGcrR
         273VZagGzOvhcZNEcD14usrT5eJXaruRmnuAoGeU=
From:   akpm@linux-foundation.org
To:     jlayton@kernel.org, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [merged] mm-remove-pagevec_lookup_range_nr_tag.patch
 removed from -mm tree
Message-ID: <20201215231755.IdVagQUQU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove pagevec_lookup_range_nr_tag()
has been removed from the -mm tree.  Its filename was
     mm-remove-pagevec_lookup_range_nr_tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@kernel.org>
Subject: mm: remove pagevec_lookup_range_nr_tag()

With the merge of 2e1692966034 ("ceph: have ceph_writepages_start call
pagevec_lookup_range_tag"), nothing calls this anymore.

Link: https://lkml.kernel.org/r/20201021193926.101474-1-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    3 ---
 mm/swap.c               |    9 ---------
 2 files changed, 12 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-pagevec_lookup_range_nr_tag
+++ a/include/linux/pagevec.h
@@ -43,9 +43,6 @@ static inline unsigned pagevec_lookup(st
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
 		xa_mark_t tag);
-unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag, unsigned max_pages);
 static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, xa_mark_t tag)
 {
--- a/mm/swap.c~mm-remove-pagevec_lookup_range_nr_tag
+++ a/mm/swap.c
@@ -1167,15 +1167,6 @@ unsigned pagevec_lookup_range_tag(struct
 }
 EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
-unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag, unsigned max_pages)
-{
-	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
-		min_t(unsigned int, max_pages, PAGEVEC_SIZE), pvec->pages);
-	return pagevec_count(pvec);
-}
-EXPORT_SYMBOL(pagevec_lookup_range_nr_tag);
 /*
  * Perform any setup for the swap system
  */
_

Patches currently in -mm which might be from jlayton@kernel.org are


