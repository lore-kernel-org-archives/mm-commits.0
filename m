Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC57C83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 00:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348919AbjIDAGC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 20:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjIDAGC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 20:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EB1C4
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 17:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D522860BC9
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 00:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6B8C433C7;
        Mon,  4 Sep 2023 00:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785957;
        bh=0VjrBl8+Muu9W4f2F6X2FC7lmnUrQfNWf9lxpi5qZhg=;
        h=Date:To:From:Subject:From;
        b=Nco9XFUiRbKAXBtbz6wTlXSes8niQRb1L3KcR1mnIN+qLOIhIKqHB7Lf3nzBem2MO
         dteBGO1Qqdjgq6A4fyErIY85j2toJArciV3y54b2/J7u/m2cubpucUTQEuuQ0y1IJc
         PxA7KlFC2vPVpJWM2yqBBNHJo47lwZHnIp3DrLJA=
Date:   Sun, 03 Sep 2023 17:05:54 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        dan.j.williams@intel.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch added to mm-unstable branch
Message-Id: <20230904000557.1E6B8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert DAX lock/unlock page to lock/unlock folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert DAX lock/unlock page to lock/unlock folio
Date: Wed, 23 Aug 2023 00:13:14 +0100

The one caller of DAX lock/unlock page already calls compound_head(), so
use page_folio() instead, then use a folio throughout the DAX code to
remove uses of page->mapping and page->index.

Link: https://lkml.kernel.org/r/20230822231314.349200-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c            |   24 ++++++++++++------------
 include/linux/dax.h |   10 +++++-----
 mm/memory-failure.c |   19 +++++++------------
 3 files changed, 24 insertions(+), 29 deletions(-)

--- a/fs/dax.c~mm-convert-dax-lock-unlock-page-to-lock-unlock-folio
+++ a/fs/dax.c
@@ -412,23 +412,23 @@ static struct page *dax_busy_page(void *
 	return NULL;
 }
 
-/*
- * dax_lock_page - Lock the DAX entry corresponding to a page
- * @page: The page whose entry we want to lock
+/**
+ * dax_lock_folio - Lock the DAX entry corresponding to a folio
+ * @folio: The folio whose entry we want to lock
  *
  * Context: Process context.
- * Return: A cookie to pass to dax_unlock_page() or 0 if the entry could
+ * Return: A cookie to pass to dax_unlock_folio() or 0 if the entry could
  * not be locked.
  */
-dax_entry_t dax_lock_page(struct page *page)
+dax_entry_t dax_lock_folio(struct folio *folio)
 {
 	XA_STATE(xas, NULL, 0);
 	void *entry;
 
-	/* Ensure page->mapping isn't freed while we look at it */
+	/* Ensure folio->mapping isn't freed while we look at it */
 	rcu_read_lock();
 	for (;;) {
-		struct address_space *mapping = READ_ONCE(page->mapping);
+		struct address_space *mapping = READ_ONCE(folio->mapping);
 
 		entry = NULL;
 		if (!mapping || !dax_mapping(mapping))
@@ -447,11 +447,11 @@ dax_entry_t dax_lock_page(struct page *p
 
 		xas.xa = &mapping->i_pages;
 		xas_lock_irq(&xas);
-		if (mapping != page->mapping) {
+		if (mapping != folio->mapping) {
 			xas_unlock_irq(&xas);
 			continue;
 		}
-		xas_set(&xas, page->index);
+		xas_set(&xas, folio->index);
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			rcu_read_unlock();
@@ -467,10 +467,10 @@ dax_entry_t dax_lock_page(struct page *p
 	return (dax_entry_t)entry;
 }
 
-void dax_unlock_page(struct page *page, dax_entry_t cookie)
+void dax_unlock_folio(struct folio *folio, dax_entry_t cookie)
 {
-	struct address_space *mapping = page->mapping;
-	XA_STATE(xas, &mapping->i_pages, page->index);
+	struct address_space *mapping = folio->mapping;
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 
 	if (S_ISCHR(mapping->host->i_mode))
 		return;
--- a/include/linux/dax.h~mm-convert-dax-lock-unlock-page-to-lock-unlock-folio
+++ a/include/linux/dax.h
@@ -159,8 +159,8 @@ int dax_writeback_mapping_range(struct a
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
-dax_entry_t dax_lock_page(struct page *page);
-void dax_unlock_page(struct page *page, dax_entry_t cookie);
+dax_entry_t dax_lock_folio(struct folio *folio);
+void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
 dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
 		unsigned long index, struct page **page);
 void dax_unlock_mapping_entry(struct address_space *mapping,
@@ -182,14 +182,14 @@ static inline int dax_writeback_mapping_
 	return -EOPNOTSUPP;
 }
 
-static inline dax_entry_t dax_lock_page(struct page *page)
+static inline dax_entry_t dax_lock_folio(struct folio *folio)
 {
-	if (IS_DAX(page->mapping->host))
+	if (IS_DAX(folio->mapping->host))
 		return ~0UL;
 	return 0;
 }
 
-static inline void dax_unlock_page(struct page *page, dax_entry_t cookie)
+static inline void dax_unlock_folio(struct folio *folio, dax_entry_t cookie)
 {
 }
 
--- a/mm/memory-failure.c~mm-convert-dax-lock-unlock-page-to-lock-unlock-folio
+++ a/mm/memory-failure.c
@@ -1724,28 +1724,23 @@ static int mf_generic_kill_procs(unsigne
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
+	struct folio *folio = page_folio(page);
 	LIST_HEAD(to_kill);
 	dax_entry_t cookie;
 	int rc = 0;
 
 	/*
-	 * Pages instantiated by device-dax (not filesystem-dax)
-	 * may be compound pages.
-	 */
-	page = compound_head(page);
-
-	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
 	 * lock_page(), but dax pages do not use the page lock. This
 	 * also prevents changes to the mapping of this pfn until
 	 * poison signaling is complete.
 	 */
-	cookie = dax_lock_page(page);
+	cookie = dax_lock_folio(folio);
 	if (!cookie)
 		return -EBUSY;
 
-	if (hwpoison_filter(page)) {
+	if (hwpoison_filter(&folio->page)) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -1767,7 +1762,7 @@ static int mf_generic_kill_procs(unsigne
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(page);
+	SetPageHWPoison(&folio->page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1776,11 +1771,11 @@ static int mf_generic_kill_procs(unsigne
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &to_kill, true);
+	collect_procs(&folio->page, &to_kill, true);
 
-	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
+	unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
 unlock:
-	dax_unlock_page(page, cookie);
+	dax_unlock_folio(folio, cookie);
 	return rc;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch

