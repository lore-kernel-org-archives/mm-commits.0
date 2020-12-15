Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FD0C3526C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5F322D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgLOX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729332AbgLOXUJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:09 -0500
Date:   Tue, 15 Dec 2020 15:19:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074367;
        bh=3US5oTGlLuj/IT1Px5xdaOUHzHHjGCpiZf3mV1sWusU=;
        h=From:To:Subject:From;
        b=YiKRmyJtLEqdBWFLjAJdj19FIMKwRPLThxaHL3Aef1WgwIjpXRa6smLc+Zx8ftCJt
         bYTVecJ9rl9gCv506i/qvop7+AwU5MdGFXuIFAewcHKnitI7fasLm/PZeryVSOqTOB
         dnNKgoU9+4prRmUDwtE9sHX+joSvz05tHUg/i8io=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-move-free_unref_page-to-mm-internalh.patch
 removed from -mm tree
Message-ID: <20201215231927.wzSJvROwh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move free_unref_page to mm/internal.h
has been removed from the -mm tree.  Its filename was
     mm-move-free_unref_page-to-mm-internalh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: move free_unref_page to mm/internal.h

Code outside mm/ should not be calling free_unref_page().  Also move
free_unref_page_list().

Link: https://lkml.kernel.org/r/20201125034655.27687-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 --
 mm/internal.h       |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-move-free_unref_page-to-mm-internalh
+++ a/include/linux/gfp.h
@@ -580,8 +580,6 @@ void * __meminit alloc_pages_exact_nid(i
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_unref_page(struct page *page);
-extern void free_unref_page_list(struct list_head *list);
 
 struct page_frag_cache;
 extern void __page_frag_cache_drain(struct page *page, unsigned int count);
--- a/mm/internal.h~mm-move-free_unref_page-to-mm-internalh
+++ a/mm/internal.h
@@ -199,6 +199,9 @@ extern void post_alloc_hook(struct page
 					gfp_t gfp_flags);
 extern int user_min_free_kbytes;
 
+extern void free_unref_page(struct page *page);
+extern void free_unref_page_list(struct list_head *list);
+
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch

