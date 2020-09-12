Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2F8C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD486217A0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953065;
	bh=QqU07+57bdqSEVd+VtjpzeMXlw+Qubgz+uLVB8xHhPk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=O91tElPacYxvyZ1zs4dtVa9dETIazD7qt06XBpOQ9NpnOI4PHEUOefVi/IeF5jGgO
	 M5/qpbZzJjH+gwfLVUJs2+4TrYxXG1JiYzDHEF86dZZ8WQH+CKXp9YoMaZ24IXI3+i
	 MdgzZ/FAq46O+BG+XV7qyuRf25KRs2uCZMqps/QM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgILXYZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:24:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgILXYW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:24:22 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA8021531;
        Sat, 12 Sep 2020 23:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953062;
        bh=QqU07+57bdqSEVd+VtjpzeMXlw+Qubgz+uLVB8xHhPk=;
        h=Date:From:To:Subject:From;
        b=f8Lp6/DtwHHwW5HTmriZrhCoWG+P5wWVPDaYAlXtBXUwZY33iGaGCNVCDdZGWyKBO
         GS3glSusNRoEh/1LRjVHqomjLuv+01tJ87n2C1rplxhtMzVdY8yMD3vE2yYQNrzJ65
         +aSG7C/zuoSBGmxzAjivYedsNeTmVZIDzKODS720=
Date:   Sat, 12 Sep 2020 16:24:21 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        william.kucharski@oracle.com, matthew.auld@intel.com,
        jani.nikula@linux.intel.com, hughd@google.com, hannes@cmpxchg.org,
        chris@chris-wilson.co.uk, adobriyan@gmail.com, willy@infradead.org
Subject:  + i915-use-find_lock_page-instead-of-find_lock_entry.patch
 added to -mm tree
Message-ID: <20200912232421.a-UjG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: use find_lock_page instead of find_lock_entry
has been added to the -mm tree.  Its filename is
     i915-use-find_lock_page-instead-of-find_lock_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/i915-use-find_lock_page-instead-of-find_lock_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/i915-use-find_lock_page-instead-of-find_lock_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -384,8 +384,6 @@ static inline struct page *find_subpage(
 	return head + (index & (thp_nr_pages(head) - 1));
 }
 
-struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
--- a/mm/filemap.c~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/mm/filemap.c
@@ -1628,7 +1628,6 @@ repeat:
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

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-add-find_lock_head.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

