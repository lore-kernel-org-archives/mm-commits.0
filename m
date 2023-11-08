Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48361C04E85
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjKHVLs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbjKHVLo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:11:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DB52588;
        Wed,  8 Nov 2023 13:11:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E57C433CB;
        Wed,  8 Nov 2023 21:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699477902;
        bh=pXDjQLZ/pDAhio6rHbOW6MPww+X7qH/3hziBLffO+AQ=;
        h=Date:To:From:Subject:From;
        b=19LxuJ9/W5edWtWBLYyZEmvJ+MDjx4S2Zr1rUuCwUUawivhgeQjPBXqEEg7gkl0ZO
         oeT8LyRjNxXa/XnWQeVTSq505O5fWif9czkwxOk4DDnMI+DS5Y9g1HnG+0mHWi73Uy
         MhytA90Z2uhzCYnT5f5hexpgTYFPkRmNGM4/FTGU=
Date:   Wed, 08 Nov 2023 13:11:41 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-invalidate_inode_page.patch added to mm-hotfixes-unstable branch
Message-Id: <20231108211142.75E57C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove invalidate_inode_page()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-remove-invalidate_inode_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-invalidate_inode_page.patch

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
Subject: mm: remove invalidate_inode_page()
Date: Wed, 8 Nov 2023 18:28:09 +0000

All callers are now converted to call mapping_evict_folio().

Link: https://lkml.kernel.org/r/20231108182809.602073-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 -
 mm/truncate.c |   11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-remove-invalidate_inode_page
+++ a/mm/internal.h
@@ -139,7 +139,6 @@ int truncate_inode_folio(struct address_
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
-long invalidate_inode_page(struct page *page);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
 
--- a/mm/truncate.c~mm-remove-invalidate_inode_page
+++ a/mm/truncate.c
@@ -294,13 +294,6 @@ long mapping_evict_folio(struct address_
 	return remove_mapping(mapping, folio);
 }
 
-long invalidate_inode_page(struct page *page)
-{
-	struct folio *folio = page_folio(page);
-
-	return mapping_evict_folio(folio_mapping(folio), folio);
-}
-
 /**
  * truncate_inode_pages_range - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
@@ -559,9 +552,9 @@ unsigned long invalidate_mapping_pages(s
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
- * This is like invalidate_inode_page(), except it ignores the page's
+ * This is like mapping_evict_folio(), except it ignores the folio's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
- * invalidation guarantees, and cannot afford to leave pages behind because
+ * invalidation guarantees, and cannot afford to leave folios behind because
  * shrink_page_list() has a temp ref on them, or because they're transiently
  * sitting in the folio_add_lru() caches.
  */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch

