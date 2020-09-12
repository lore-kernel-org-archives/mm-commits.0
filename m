Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B172C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E8321D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937900;
	bh=/VAq89lL60Nx/xHt/+y3bbzFNVqfZJ+hH8fnMkmGOWA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DwRzOl9LOFzeCxBAN/dak3aP8Wl7Vc5YgsR0TPLVCBa3D5L9YNYS9LEPShHf7Sruo
	 tPUtdQZ+SIHHsNyHM6X7M2skM2rWdu9yiuN7ja7Tvl/0UU7OVsI6Wedtyw2HJIe4hf
	 VADErDg1F8hb5q48aVt6ed+LJZFqu6IpI3gBtH7Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgILTLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:39 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D2621531;
        Sat, 12 Sep 2020 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937898;
        bh=/VAq89lL60Nx/xHt/+y3bbzFNVqfZJ+hH8fnMkmGOWA=;
        h=Date:From:To:Subject:From;
        b=sLJ+FekgZKNSIZYkMdcW8MtiqmpQL6vpgKI4wIen5qdS1tIEQFH3eVrDaSlEefpDi
         XnWCGMn5YONst7IEOMsaG07UGm8Qp2da140wCkmZvn7VaTJpyT7CAr5Zb09Yn0yqju
         O9dcdetLYbvUmZOnWOLOpFG9F2jWbqgVg+usMh0o=
Date:   Sat, 12 Sep 2020 12:11:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, kirill@shutemov.name
Subject:  + mm-huge_memory-fix-split-assumption-of-page-size.patch
 added to -mm tree
Message-ID: <20200912191138.UKDFP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix split assumption of page size
has been added to the -mm tree.  Its filename is
     mm-huge_memory-fix-split-assumption-of-page-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-fix-split-assumption-of-page-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-fix-split-assumption-of-page-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm/huge_memory: fix split assumption of page size

File THPs may now be of arbitrary size, and we can't rely on that size
after doing the split so remember the number of pages before we start the
split.

Link: https://lkml.kernel.org/r/20200908195539.25896-6-willy@infradead.org
Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-split-assumption-of-page-size
+++ a/mm/huge_memory.c
@@ -2309,13 +2309,13 @@ static void unmap_page(struct page *page
 	VM_BUG_ON_PAGE(!unmap_success, page);
 }
 
-static void remap_page(struct page *page)
+static void remap_page(struct page *page, unsigned int nr)
 {
 	int i;
 	if (PageTransHuge(page)) {
 		remove_migration_ptes(page, page, true);
 	} else {
-		for (i = 0; i < HPAGE_PMD_NR; i++)
+		for (i = 0; i < nr; i++)
 			remove_migration_ptes(page + i, page + i, true);
 	}
 }
@@ -2390,6 +2390,7 @@ static void __split_huge_page(struct pag
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
+	unsigned int nr = thp_nr_pages(head);
 	int i;
 
 	lruvec = mem_cgroup_page_lruvec(head, pgdat);
@@ -2405,7 +2406,7 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
-	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
+	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
 		if (head[i].index >= end) {
@@ -2425,7 +2426,7 @@ static void __split_huge_page(struct pag
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_NR);
+	split_page_owner(head, nr);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
@@ -2444,9 +2445,9 @@ static void __split_huge_page(struct pag
 
 	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 
-	remap_page(head);
+	remap_page(head, nr);
 
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
+	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
 		if (subpage == page)
 			continue;
@@ -2700,7 +2701,7 @@ int split_huge_page_to_list(struct page
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
-		remap_page(head);
+		remap_page(head, thp_nr_pages(head));
 		ret = -EBUSY;
 	}
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-huge_memory-fix-total_mapcount-assumption-of-page-size.patch
mm-huge_memory-fix-split-assumption-of-page-size.patch

