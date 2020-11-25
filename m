Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE37C64E75
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14FC20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 22:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAasI0S8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgKYWie (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 17:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgKYWie (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 17:38:34 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04EE420872;
        Wed, 25 Nov 2020 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606343913;
        bh=n8VlcnHM4zckw5Rg7olP8Qcgzye0kWWmU8c3jgbiLxo=;
        h=Date:From:To:Subject:From;
        b=IAasI0S8MVKw9wcVabwBA6lC5igsyXGmFJ6+xxiGHrLV2hOeEyZVHUr34zjwItNG7
         RuoP0565FqyVvzK6dzOgTBRacOYDpzCtN5rtrc70WkYAJ37yqHEyCL8ssv1KTyBifT
         iNOhaOkU28KOA24an/jdrjJw2M+Gk25I2KfmXcrI=
Date:   Wed, 25 Nov 2020 14:38:32 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  + mm-move-free_unref_page-to-mm-internalh.patch added to
 -mm tree
Message-ID: <20201125223832.PGwCAqXhi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move free_unref_page to mm/internal.h
has been added to the -mm tree.  Its filename is
     mm-move-free_unref_page-to-mm-internalh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-free_unref_page-to-mm-internalh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-free_unref_page-to-mm-internalh.patch

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

sparc-fix-handling-of-page-table-constructor-failure.patch
mm-move-free_unref_page-to-mm-internalh.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
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
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

