Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD93C4708D
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiLLCPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiLLCOc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F44DF15
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B1E7B80B69
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE92C433F0;
        Mon, 12 Dec 2022 02:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811250;
        bh=trLPDKWNThefqWm6xcIXk4R9LMTAsQoqLrtec/1E+GU=;
        h=Date:To:From:Subject:From;
        b=E9rfaK7U2h1Sn32bDFDDZanKonJijBLK/waPeUUroZL9Y0QSGhHh31V0LbBIj0lzv
         D1UP9W9S6/Qf/cvhiojLS1y45i9cpZ+hQrhCuqk3t94aDNBy0hs5xGxzf+82zMMrps
         arnmoFWjpDMRfS9h2wHQu82I47XWdKqXAz+M76Sk=
Date:   Sun, 11 Dec 2022 18:14:10 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mszeredi@redhat.com, mike.kravetz@oracle.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch removed from -mm tree
Message-Id: <20221212021410.CDE92C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: replace lru_cache functions with folio_add functions
has been removed from the -mm tree.  Its filename was
     userfualtfd-replace-lru_cache-functions-with-folio_add-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


