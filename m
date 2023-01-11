Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EECC678D9
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 21:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbjAKVAd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 16:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbjAKU7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 15:59:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DD2C11
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 12:59:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF28BB81CD2
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 20:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86923C433D2;
        Wed, 11 Jan 2023 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673470743;
        bh=vvYhkHIvT8SRgwT9D6tFB1FnXVv/MCgc643etD6qWMc=;
        h=Date:To:From:Subject:From;
        b=p3KP2db4TEOWJNre8NNhrkvyO/NaV11AIyrituRJk+utklRqj9Pfp+Xp7lqM8U+Cq
         AuoOxw57P9yBocXIXL9beLb6IvAs2x+bvg+mjeiWhEZtBZECWlzFdBRboJDT2ZWl4h
         uA9pa9bIYJICnKUW4IFzY2IDiGod56Hi4PPoVCWI=
Date:   Wed, 11 Jan 2023 12:59:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-first-tail-page-members-from-struct-page.patch added to mm-unstable branch
Message-Id: <20230111205903.86923C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove 'First tail page' members from struct page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-first-tail-page-members-from-struct-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-first-tail-page-members-from-struct-page.patch

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
Subject: mm: remove 'First tail page' members from struct page
Date: Wed, 11 Jan 2023 14:29:08 +0000

All former users now use the folio equivalents, so remove them from the
definition of struct page.

Link: https://lkml.kernel.org/r/20230111142915.1001531-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   18 ------------------
 kernel/crash_core.c      |    4 ++--
 2 files changed, 2 insertions(+), 20 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-first-tail-page-members-from-struct-page
+++ a/include/linux/mm_types.h
@@ -140,16 +140,6 @@ struct page {
 		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
-
-			/* First tail page only */
-			unsigned char compound_dtor;
-			unsigned char compound_order;
-			atomic_t compound_mapcount;
-			atomic_t subpages_mapcount;
-			atomic_t compound_pincount;
-#ifdef CONFIG_64BIT
-			unsigned int compound_nr; /* 1 << compound_order */
-#endif
 		};
 		struct {	/* Second tail page of transparent huge page */
 			unsigned long _compound_pad_1;	/* compound_head */
@@ -401,14 +391,6 @@ FOLIO_MATCH(memcg_data, memcg_data);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_head, _head_1);
-FOLIO_MATCH(compound_dtor, _folio_dtor);
-FOLIO_MATCH(compound_order, _folio_order);
-FOLIO_MATCH(compound_mapcount, _entire_mapcount);
-FOLIO_MATCH(subpages_mapcount, _nr_pages_mapped);
-FOLIO_MATCH(compound_pincount, _pincount);
-#ifdef CONFIG_64BIT
-FOLIO_MATCH(compound_nr, _folio_nr_pages);
-#endif
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\
 	static_assert(offsetof(struct folio, fl) ==			\
--- a/kernel/crash_core.c~mm-remove-first-tail-page-members-from-struct-page
+++ a/kernel/crash_core.c
@@ -455,8 +455,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
-	VMCOREINFO_OFFSET(page, compound_dtor);
-	VMCOREINFO_OFFSET(page, compound_order);
+	VMCOREINFO_OFFSET(folio, _folio_dtor);
+	VMCOREINFO_OFFSET(folio, _folio_order);
 	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
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

