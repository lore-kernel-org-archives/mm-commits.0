Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BA8C4167D
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjKHVLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjKHVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECED2586;
        Wed,  8 Nov 2023 13:11:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6C3C433C8;
        Wed,  8 Nov 2023 21:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477896;
        bh=RNPYp2RRvbKeBv0MVRQJLUBZC01uqKTtPVlOjv9y+FM=;
        h=Date:To:From:Subject:From;
        b=TwZt8JyfqIAf8cX8Gj2ANhJZxa09ybRJcpfn1LBdGDmhXglG5ErC2+shXbf59CYC1
         DcDMo3kGCoxd3kuoHeFwzhuey9uPXc3JGb9N3AbvZ4C9O4FHBs81hGHp881oPIB+tJ
         LhcdLFwwxrMDVz3Thtnb8D/ab4ljVmNIcL2oiOjs=
Date:   Wed, 08 Nov 2023 13:11:35 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211136.8D6C3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make mapping_evict_folio() the preferred way to evict clean folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: make mapping_evict_folio() the preferred way to evict clean folios
Date: Wed, 8 Nov 2023 18:28:04 +0000

Patch series "Fix fault handler's handling of poisoned tail pages".

Since introducing the ability to have large folios in the page cache, it's
been possible to have a hwpoisoned tail page returned from the fault
handler.  We handle this situation poorly; failing to remove the affected
page from use.

This isn't a minimal patch to fix it, it's a full conversion of all the
code surrounding it.


This patch (of 6):

invalidate_inode_page() does very little beyond calling
mapping_evict_folio().  Move the check for mapping being NULL into
mapping_evict_folio() and make it available to the rest of the MM for use
in the next few patches.

Link: https://lkml.kernel.org/r/20231108182809.602073-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231108182809.602073-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/truncate.c |   33 ++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios
+++ a/mm/internal.h
@@ -138,6 +138,7 @@ void filemap_free_folio(struct address_s
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
+long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 long invalidate_inode_page(struct page *page);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
--- a/mm/truncate.c~mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios
+++ a/mm/truncate.c
@@ -266,9 +266,22 @@ int generic_error_remove_page(struct add
 }
 EXPORT_SYMBOL(generic_error_remove_page);
 
-static long mapping_evict_folio(struct address_space *mapping,
-		struct folio *folio)
+/**
+ * mapping_evict_folio() - Remove an unused folio from the page-cache.
+ * @mapping: The mapping this folio belongs to.
+ * @folio: The folio to remove.
+ *
+ * Safely remove one folio from the page cache.
+ * It only drops clean, unused folios.
+ *
+ * Context: Folio must be locked.
+ * Return: The number of pages successfully removed.
+ */
+long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 {
+	/* The page may have been truncated before it was locked */
+	if (!mapping)
+		return 0;
 	if (folio_test_dirty(folio) || folio_test_writeback(folio))
 		return 0;
 	/* The refcount will be elevated if any page in the folio is mapped */
@@ -281,25 +294,11 @@ static long mapping_evict_folio(struct a
 	return remove_mapping(mapping, folio);
 }
 
-/**
- * invalidate_inode_page() - Remove an unused page from the pagecache.
- * @page: The page to remove.
- *
- * Safely invalidate one page from its pagecache mapping.
- * It only drops clean, unused pages.
- *
- * Context: Page must be locked.
- * Return: The number of pages successfully removed.
- */
 long invalidate_inode_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	struct address_space *mapping = folio_mapping(folio);
 
-	/* The page may have been truncated before it was locked */
-	if (!mapping)
-		return 0;
-	return mapping_evict_folio(mapping, folio);
+	return mapping_evict_folio(folio_mapping(folio), folio);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

