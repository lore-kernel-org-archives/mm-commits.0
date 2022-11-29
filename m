Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E213CC4321E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 21:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiK2V4d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbiK2V42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 16:56:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B69C6C733
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 13:56:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC85FB8191F
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 21:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834D8C433C1;
        Tue, 29 Nov 2022 21:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669758983;
        bh=n5kpGuEx9mfv7We69IWlGhfLOA/FyzXyaIGaPOUjsOg=;
        h=Date:To:From:Subject:From;
        b=qtljqwmXQgNqVCB37Azap1K6Oh/d/5HSd2O0K7Ank6UTH97FZA/9td9J3ZWPJCb6v
         Td21FN+cUJO0uaRF6WBJf3+Pq2z/xRXwZg9qb69u1LVI03TQ3dH5cgJ02P4EUg2YeS
         8ZjJEsZ4U3awv/vnWbRQ2N97oIMZhG1AinLW3LGI=
Date:   Tue, 29 Nov 2022 13:56:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch added to mm-unstable branch
Message-Id: <20221129215623.834D8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: replace lru_cache functions with folio_add functions
has been added to the -mm mm-unstable branch.  Its filename is
     userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: userfaultfd: replace lru_cache functions with folio_add functions
Date: Tue, 1 Nov 2022 10:53:24 -0700

Replaces lru_cache_add() and lru_cache_add_inactive_or_unevictable() with
folio_add_lru() and folio_add_lru_vma().  This is in preparation for the
removal of lru_cache_add().

Link: https://lkml.kernel.org/r/20221101175326.13265-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfualtfd-replace-lru_cache-functions-with-folio_add-functions
+++ a/mm/userfaultfd.c
@@ -66,6 +66,7 @@ int mfill_atomic_install_pte(struct mm_s
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
 	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
+	struct folio *folio;
 	struct inode *inode;
 	pgoff_t offset, max_off;
 
@@ -113,14 +114,15 @@ int mfill_atomic_install_pte(struct mm_s
 	if (!pte_none_mostly(*dst_pte))
 		goto out_unlock;
 
+	folio = page_folio(page);
 	if (page_in_cache) {
 		/* Usually, cache pages are already added to LRU */
 		if (newly_allocated)
-			lru_cache_add(page);
+			folio_add_lru(folio);
 		page_add_file_rmap(page, dst_vma, false);
 	} else {
 		page_add_new_anon_rmap(page, dst_vma, dst_addr);
-		lru_cache_add_inactive_or_unevictable(page, dst_vma);
+		folio_add_lru_vma(folio, dst_vma);
 	}
 
 	/*
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

ext4-convert-move_extent_per_page-to-use-folios.patch
khugepage-replace-try_to_release_page-with-filemap_release_folio.patch
memory-failure-convert-truncate_error_page-to-use-folio.patch
folio-compat-remove-try_to_release_page.patch
filemap-convert-replace_page_cache_page-to-replace_page_cache_folio.patch
fuse-convert-fuse_try_move_page-to-use-folios.patch
userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch
khugepage-replace-lru_cache_add-with-folio_add_lru.patch
folio-compat-remove-lru_cache_add.patch

