Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD7BC4742C
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90542225F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AC4oBrJh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgKNBpK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:53942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgKNBpK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:10 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1727F2225D;
        Sat, 14 Nov 2020 01:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318309;
        bh=CMcrz7Is1uUx7W9vzHbOA5lG24tu7Y2zRyLv0HPRKdM=;
        h=Date:From:To:Subject:From;
        b=AC4oBrJhjeCxjh/VV+cfRqN6655yfCqgIGSAVhsMy8oF2BM7hyESNzrnboN3MNnKv
         JOZYKz3DolrmC5ut9vLkvXUbVvXvOyHOAPAOJDf/+WJiH4WUya3SXjWfd5F4t6Aytd
         kDNrKb5fiq7dm9CqNrSJ7dPWL6Tbr2CX/++yicFs=
Date:   Fri, 13 Nov 2020 17:45:08 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-make-pagecache-tagged-lookups-return-only-head-pages.patch added to -mm
 tree
Message-ID: <20201114014508.iLG_MLnzf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make pagecache tagged lookups return only head pages
has been added to the -mm tree.  Its filename is
     mm-make-pagecache-tagged-lookups-return-only-head-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-pagecache-tagged-lookups-return-only-head-pages.patch

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
Subject: mm: make pagecache tagged lookups return only head pages

Patch series "Overhaul multi-page lookups for THP", v4.

This THP prep patchset changes several page cache iteration APIs to only
return head pages.

 - It's only possible to tag head pages in the page cache, so only
   return head pages, not all their subpages.
 - Factor a lot of common code out of the various batch lookup routines
 - Add mapping_seek_hole_data()
 - Unify find_get_entries() and pagevec_lookup_entries()
 - Make find_get_entries only return head pages, like find_get_entry().

These are only loosely connected, but they seem to make sense together as
a series.


This patch (of 16):

Pagecache tags are used for dirty page writeback.  Since dirtiness is
tracked on a per-THP basis, we only want to return the head page rather
than each subpage of a tagged page.  All the filesystems which use huge
pages today are in-memory, so there are no tagged huge pages today.

Link: https://lkml.kernel.org/r/20201112212641.27837-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~mm-make-pagecache-tagged-lookups-return-only-head-pages
+++ a/mm/filemap.c
@@ -2066,7 +2066,7 @@ retry:
 EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
- * find_get_pages_range_tag - find and return pages in given range matching @tag
+ * find_get_pages_range_tag - Find and return head pages matching @tag.
  * @mapping:	the address_space to search
  * @index:	the starting page index
  * @end:	The final page index (inclusive)
@@ -2074,8 +2074,9 @@ EXPORT_SYMBOL(find_get_pages_contig);
  * @nr_pages:	the maximum number of pages
  * @pages:	where the resulting pages are placed
  *
- * Like find_get_pages, except we only return pages which are tagged with
- * @tag.   We update @index to index the next page for the traversal.
+ * Like find_get_pages(), except we only return head pages which are tagged
+ * with @tag.  @index is updated to the index immediately after the last
+ * page we return, ready for the next iteration.
  *
  * Return: the number of pages which were found.
  */
@@ -2109,9 +2110,9 @@ unsigned find_get_pages_range_tag(struct
 		if (unlikely(page != xas_reload(&xas)))
 			goto put_page;
 
-		pages[ret] = find_subpage(page, xas.xa_index);
+		pages[ret] = page;
 		if (++ret == nr_pages) {
-			*index = xas.xa_index + 1;
+			*index = page->index + thp_nr_pages(page);
 			goto out;
 		}
 		continue;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

