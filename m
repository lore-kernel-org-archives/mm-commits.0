Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2296BC54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 21:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbjALVtx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240994AbjALVsm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 16:48:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADE7B46
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 13:43:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B842062122
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 21:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198B1C433F2;
        Thu, 12 Jan 2023 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673559794;
        bh=3ZG8Kl37Z3K0/WVnVAIfx6HybjxTgIbsVK0MImlUHLI=;
        h=Date:To:From:Subject:From;
        b=aJ/qgAlUIhR+7+TTfqIo0wAzgvITeBP3sk671GGT9af0FuiAcOJqB893urhZU+biu
         wyJ4cBNPFU9ryb0sDvXfINyJjNTsNB+OScLwY0yPm6Goe6p3AASfHe5MK6OETC0jon
         0TNW2edEwkkL0izQXzIi8VWiKCp7tlLKZmd9Jo68=
Date:   Thu, 12 Jan 2023 13:43:13 -0800
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        hughd@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-convert-shmem_write_end-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20230112214314.198B1C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: convert shmem_write_end() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-convert-shmem_write_end-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-convert-shmem_write_end-to-use-a-folio.patch

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
Subject: shmem: convert shmem_write_end() to use a folio
Date: Thu, 12 Jan 2023 13:10:31 +0000

Use a folio internally to shmem_write_end() which saves a number of calls
to compound_head() and lets us get rid of the custom code to zero out the
rest of a THP and supports folios of arbitrary size.

Link: https://lkml.kernel.org/r/20230112131031.1209553-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

--- a/mm/shmem.c~shmem-convert-shmem_write_end-to-use-a-folio
+++ a/mm/shmem.c
@@ -2578,33 +2578,23 @@ shmem_write_end(struct file *file, struc
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
+	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
 
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
-	if (!PageUptodate(page)) {
-		struct page *head = compound_head(page);
-		if (PageTransCompound(page)) {
-			int i;
-
-			for (i = 0; i < HPAGE_PMD_NR; i++) {
-				if (head + i == page)
-					continue;
-				clear_highpage(head + i);
-				flush_dcache_page(head + i);
-			}
-		}
-		if (copied < PAGE_SIZE) {
-			unsigned from = pos & (PAGE_SIZE - 1);
-			zero_user_segments(page, 0, from,
-					from + copied, PAGE_SIZE);
+	if (!folio_test_uptodate(folio)) {
+		if (copied < folio_size(folio)) {
+			size_t from = offset_in_folio(folio, pos);
+			folio_zero_segments(folio, 0, from,
+					from + copied, folio_size(folio));
 		}
-		SetPageUptodate(head);
+		folio_mark_uptodate(folio);
 	}
-	set_page_dirty(page);
-	unlock_page(page);
-	put_page(page);
+	folio_mark_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return copied;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
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

