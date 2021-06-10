Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDC9C48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B259C613FF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFJWb1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 18:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFJWb1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 18:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCE0613F1;
        Thu, 10 Jun 2021 22:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623364160;
        bh=DkmTyutmQNFY6tXSsNkQgo6aMrLg1+kQQzewY+axLhA=;
        h=Date:From:To:Subject:From;
        b=dMgmB7IFTNsCPmO3q6EifAuCMQyp9TYxRsfoyOGvPGW8TvQktofcBXFD7iIlfM4oI
         oorGUpaTWKvFzjo4HuWeB3PzBqWQf+jLWH1G+aSOtOpd3p+jQgIo+YXTgPJcgtQ/uA
         CcH7wqmL0E4j+zeAf4TNOP0pgxqb2semwByTG7gM=
Date:   Thu, 10 Jun 2021 15:29:19 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, wangyugui@e16-tech.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  + mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
 added to -mm tree
Message-ID: <20210610222919.r7NYNbmDr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: remap_page() is only needed on anonymous THP
has been added to the -mm tree.  Its filename is
     mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: remap_page() is only needed on anonymous THP

THP splitting's unmap_page() only sets TTU_SPLIT_FREEZE when PageAnon, and
migration entries are only inserted when TTU_MIGRATION (unused here) or
TTU_SPLIT_FREEZE is set: so it's just a waste of time for remap_page() to
search for migration entries to remove when !PageAnon.

Link: https://lkml.kernel.org/r/f987bc44-f28e-688d-2424-b4722153ed8@google.com
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/huge_memory.c~mm-thp-remap_page-is-only-needed-on-anonymous-thp
+++ a/mm/huge_memory.c
@@ -2307,6 +2307,7 @@ static void unmap_page(struct page *page
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
+	/* If TTU_SPLIT_FREEZE is ever extended to file, update remap_page() */
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
@@ -2318,6 +2319,10 @@ static void unmap_page(struct page *page
 static void remap_page(struct page *page, unsigned int nr)
 {
 	int i;
+
+	/* If TTU_SPLIT_FREEZE is ever extended to file, remove this check */
+	if (!PageAnon(page))
+		return;
 	if (PageTransHuge(page)) {
 		remove_migration_ptes(page, page, true);
 	} else {
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmd_read_atomic.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

