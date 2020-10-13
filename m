Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB14C4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35D622201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633145;
	bh=EhWnWsayRlrHqkP6dxl0ISwqXMFPoVuEHlN49BV7eZk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=p2NsBRpy9LAy5pUBJuxhRviqOpYiiVoQdYBb5IYEUbGU0GAIuSWm3olEws7/nNNBz
	 skcpcNceMT6EIcr5O1Bj9Xqt1cYCY+HNRIbgPfzuzy3JR/c98rgtQ/zM0bu62ii3S0
	 ED5FU/Ba620wbIvP7htmZIH5bITDTRrJTphiF6Tk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgJMXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728648AbgJMXvm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79D821D7B;
        Tue, 13 Oct 2020 23:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633102;
        bh=EhWnWsayRlrHqkP6dxl0ISwqXMFPoVuEHlN49BV7eZk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NrGNXfYeKg7F6op77cBUaXid+TwAFqW67e7Jdth//e2SKN455rZ7NWEPP4vnKonwr
         euXEqvrhV/24sUAnw1mKXCDizRtnfl0gaFmBkOhSWAne5x/VOp7aYcQ2s2drjDSo6S
         gejstPwwiyyylabEkOkMJ34tfSlkdYZaX7EtEd+g=
Date:   Tue, 13 Oct 2020 16:51:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 061/181] mm: add find_lock_head
Message-ID: <20201013235141.5Wzerxsbz%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add find_lock_head

Add a new FGP_HEAD flag which avoids calling find_subpage() and add a
convenience wrapper for it.

Link: https://lkml.kernel.org/r/20200910183318.20139-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   32 ++++++++++++++++++++++++++------
 mm/filemap.c            |    9 ++++++---
 2 files changed, 32 insertions(+), 9 deletions(-)

--- a/include/linux/pagemap.h~mm-add-find_lock_head
+++ a/include/linux/pagemap.h
@@ -279,6 +279,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
+#define FGP_HEAD		0x00000080
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
 		int fgp_flags, gfp_t cache_gfp_mask);
@@ -310,18 +311,37 @@ static inline struct page *find_get_page
  * @mapping: the address_space to search
  * @offset: the page index
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * Looks up the page cache entry at @mapping & @offset.  If there is a
  * page cache page, it is returned locked and with an increased
  * refcount.
  *
- * Otherwise, %NULL is returned.
- *
- * find_lock_page() may sleep.
+ * Context: May sleep.
+ * Return: A struct page or %NULL if there is no page in the cache for this
+ * index.
  */
 static inline struct page *find_lock_page(struct address_space *mapping,
-					pgoff_t offset)
+					pgoff_t index)
+{
+	return pagecache_get_page(mapping, index, FGP_LOCK, 0);
+}
+
+/**
+ * find_lock_head - Locate, pin and lock a pagecache page.
+ * @mapping: The address_space to search.
+ * @offset: The page index.
+ *
+ * Looks up the page cache entry at @mapping & @offset.  If there is a
+ * page cache page, its head page is returned locked and with an increased
+ * refcount.
+ *
+ * Context: May sleep.
+ * Return: A struct page which is !PageTail, or %NULL if there is no page
+ * in the cache for this index.
+ */
+static inline struct page *find_lock_head(struct address_space *mapping,
+					pgoff_t index)
 {
-	return pagecache_get_page(mapping, offset, FGP_LOCK, 0);
+	return pagecache_get_page(mapping, index, FGP_LOCK | FGP_HEAD, 0);
 }
 
 /**
--- a/mm/filemap.c~mm-add-find_lock_head
+++ a/mm/filemap.c
@@ -1737,6 +1737,8 @@ repeat:
  *
  * * %FGP_ACCESSED - The page will be marked accessed.
  * * %FGP_LOCK - The page is returned locked.
+ * * %FGP_HEAD - If the page is present and a THP, return the head page
+ *   rather than the exact page specified by the index.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp_mask and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1765,7 +1767,6 @@ repeat:
 		page = NULL;
 	if (!page)
 		goto no_page;
-	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
@@ -1778,12 +1779,12 @@ repeat:
 		}
 
 		/* Has the page been truncated? */
-		if (unlikely(compound_head(page)->mapping != mapping)) {
+		if (unlikely(page->mapping != mapping)) {
 			unlock_page(page);
 			put_page(page);
 			goto repeat;
 		}
-		VM_BUG_ON_PAGE(page->index != index, page);
+		VM_BUG_ON_PAGE(!thp_contains(page, index), page);
 	}
 
 	if (fgp_flags & FGP_ACCESSED)
@@ -1793,6 +1794,8 @@ repeat:
 		if (page_is_idle(page))
 			clear_page_idle(page);
 	}
+	if (!(fgp_flags & FGP_HEAD))
+		page = find_subpage(page, index);
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
_
