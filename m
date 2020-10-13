Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9726CC35265
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7746D22227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633146;
	bh=OMPOTaXtALCvYFccvVsAb98Hw0Yh2S7OUhttx197hZU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Pq0kq/y2SzMCqJ3EsTAOsXpg/4875Ay/JcM5CS5m6KqIilVm5oqHI8IR/zULVgp3Q
	 +o5Ilg5L39kZDf2f6j4Vy1no6s1sNW8KsqHjhHVRs5RdWwWpPUMGMOEtW0nQ88f9Lh
	 OZLtf1yLJQ6uJIDcXxRSXCJoRVIGTxCkRsXYHbbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgJMXw0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgJMXvd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1ABE21D7B;
        Tue, 13 Oct 2020 23:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633092;
        bh=OMPOTaXtALCvYFccvVsAb98Hw0Yh2S7OUhttx197hZU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bYgd1Fuu4YVAVHlzxBOnCWOSAt2ZPhK+2o9ABHANnJLm+FEMr8sNW4KS9mlZiHXs+
         w/cUPJltB8/ERXM/mZ8gWXBpm/ICPgp5pkm2K5O0oS9d/b/8v7mPP2u6iv/j4uDm2j
         oDiUuOAGiClhAwIYxYcnHCFx3teT5xpn3X56xwgw=
Date:   Tue, 13 Oct 2020 16:51:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        chris@chris-wilson.co.uk, hannes@cmpxchg.org, hughd@google.com,
        jani.nikula@linux.intel.com, linux-mm@kvack.org,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 058/181] i915: use find_lock_page instead of
 find_lock_entry
Message-ID: <20201013235131.eBDIIjQ5U%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: i915: use find_lock_page instead of find_lock_entry

i915 does not want to see value entries.  Switch it to use
find_lock_page() instead, and remove the export of find_lock_entry().
Move find_lock_entry() and find_get_entry() to mm/internal.h to discourage
any future use.

Link: https://lkml.kernel.org/r/20200910183318.20139-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    4 ++--
 include/linux/pagemap.h                   |    2 --
 mm/filemap.c                              |    1 -
 mm/internal.h                             |    3 +++
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -258,8 +258,8 @@ shmem_writeback(struct drm_i915_gem_obje
 	for (i = 0; i < obj->base.size >> PAGE_SHIFT; i++) {
 		struct page *page;
 
-		page = find_lock_entry(mapping, i);
-		if (!page || xa_is_value(page))
+		page = find_lock_page(mapping, i);
+		if (!page)
 			continue;
 
 		if (!page_mapped(page) && clear_page_dirty_for_io(page)) {
--- a/include/linux/pagemap.h~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/include/linux/pagemap.h
@@ -385,8 +385,6 @@ static inline struct page *find_subpage(
 	return head + (index & (thp_nr_pages(head) - 1));
 }
 
-struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
--- a/mm/filemap.c~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/mm/filemap.c
@@ -1726,7 +1726,6 @@ repeat:
 	}
 	return page;
 }
-EXPORT_SYMBOL(find_lock_entry);
 
 /**
  * pagecache_get_page - Find and get a reference to a page.
--- a/mm/internal.h~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/mm/internal.h
@@ -65,6 +65,9 @@ static inline void ra_submit(struct file
 			ra->start, ra->size, ra->async_size);
 }
 
+struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t index);
+
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
_
