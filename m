Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B3CC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjBCFik (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFij (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:38:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E441087D18
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:38:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE85B828B3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430EFC433EF;
        Fri,  3 Feb 2023 05:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402715;
        bh=0I/d+nAuN6zye1LzQQPH2cp5TihxqpYkITl0fshLBGs=;
        h=Date:To:From:Subject:From;
        b=jKdVHxrfuemRIfaG7XlTfp3cdw1FN1mHfjatTUu6aSQfV/aDJaJp/bilEGVrrH4pB
         M+LOh4q0K+OnRIsFtBTf+jff0N99pwglY23cJBTqXpT6ZaTU2X8OAzV/D/5qwbSqDg
         Zuori8izyUIObgBCVLGnsVNxJcdA1BKjmrti3IEQ=
Date:   Thu, 02 Feb 2023 21:38:34 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+fa6f2ee9039b87ef86c4@syzkaller.appspotmail.com,
        hughd@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-reimplement-compound_nr-fix.patch removed from -mm tree
Message-Id: <20230203053835.430EFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-reimplement-compound_nr-fix
has been removed from the -mm tree.  Its filename was
     mm-reimplement-compound_nr-fix.patch

This patch was dropped because it was folded into mm-reimplement-compound_nr.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-reimplement-compound_nr-fix
Date: Thu, 12 Jan 2023 13:05:05 +0000

shmem is deliberately calling zero_user_segments() on a tail page. 
zero_user_segments() calls compound_nr() which used to return 1 when
called on a tail page but now trips this assert.  I didn't intend this
change of behaviour, so let's start by fixing that.

Link: https://lkml.kernel.org/r/Y8AFgZEEjnUIaCbf@casper.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: <syzbot+fa6f2ee9039b87ef86c4@syzkaller.appspotmail.com>
  Link: https://lkml.kernel.org/r/000000000000d9ae1305f20e89bd@google.com
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-reimplement-compound_nr-fix
+++ a/include/linux/mm.h
@@ -1742,10 +1742,22 @@ static inline long folio_nr_pages(struct
 #endif
 }
 
-/* Returns the number of pages in this potentially compound page. */
+/*
+ * compound_nr() returns the number of pages in this potentially compound
+ * page.  compound_nr() can be called on a tail page, and is defined to
+ * return 1 in that case.
+ */
 static inline unsigned long compound_nr(struct page *page)
 {
-	return folio_nr_pages((struct folio *)page);
+	struct folio *folio = (struct folio *)page;
+
+	if (!test_bit(PG_head, &folio->flags))
+		return 1;
+#ifdef CONFIG_64BIT
+	return folio->_folio_nr_pages;
+#else
+	return 1L << folio->_folio_order;
+#endif
 }
 
 /**
@@ -1754,8 +1766,7 @@ static inline unsigned long compound_nr(
  */
 static inline int thp_nr_pages(struct page *page)
 {
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_nr(page);
+	return folio_nr_pages((struct folio *)page);
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch
mm-add-memcpy_from_file_folio.patch
fs-convert-writepage_t-callback-to-pass-a-folio.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully.patch
mpage-convert-__mpage_writepage-to-use-a-folio-more-fully-fix.patch

