Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F74EC54EBE
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 22:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjALWLG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240562AbjALWKp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2023 17:10:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3802B3D1C1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 14:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7602B82032
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 22:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5D8C433D2;
        Thu, 12 Jan 2023 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673560916;
        bh=zBYMup272IoWfcDGAXR987seJO4p6Q4kdqlIb6SRNXg=;
        h=Date:To:From:Subject:From;
        b=ze8SdbjMdI6qa1h60dTDWB874q7dmHWiRiNns10zGunDXyQpMW1fbx1Ki0KkcJNrV
         phP6LYaSH3eUZ+tu7R9ARcDnIfj8eI/v9c/U5K/s1MUbUGEv3vrye6NP4r9hZzYkzk
         TxlVAmeiq33/j8iDjNRXbFOh7vpbqaR7eJlg1cRg=
Date:   Thu, 12 Jan 2023 14:01:55 -0800
To:     mm-commits@vger.kernel.org,
        syzbot+fa6f2ee9039b87ef86c4@syzkaller.appspotmail.com,
        hughd@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reimplement-compound_nr-fix.patch added to mm-unstable branch
Message-Id: <20230112220156.8F5D8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-reimplement-compound_nr-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reimplement-compound_nr-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reimplement-compound_nr-fix.patch

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
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-reimplement-compound_nr-fix
+++ a/include/linux/mm.h
@@ -1736,10 +1736,22 @@ static inline long folio_nr_pages(struct
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
@@ -1748,8 +1760,7 @@ static inline unsigned long compound_nr(
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
mm-reimplement-compound_nr-fix.patch
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

