Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79437C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B3364F29
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBZAjP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhBZAjO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:39:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B747964F1B;
        Fri, 26 Feb 2021 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614299913;
        bh=OSs4CKHb/LMrl4w2NC521oHgF0HlS5kgYlFTNuOyNtU=;
        h=Date:From:To:Subject:From;
        b=eUSGqLQLtHVa3E8xF8W2dXlE8UKplBeFUfgQPMOvNrDSFNPvFbHCTMwxxSgf2aDXs
         qGS/KVsY85NaWAyxVwAQ0yqLBEWYTm/aIN4MaPMuqCqFMKtIpEieEeRkuLSkvCHqL2
         n7cFZAYgaiYmZ9mCasydddAGTWmI9AEVyGg97WyA=
Date:   Thu, 25 Feb 2021 16:38:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 mm-add-and-use-find_lock_entries-fix.patch removed from -mm tree
Message-ID: <20210226003833.QB-U3Hod8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix mm-add-and-use-find_lock_entries.patch
has been removed from the -mm tree.  Its filename was
     mm-add-and-use-find_lock_entries-fix.patch

This patch was dropped because it was folded into mm-add-and-use-find_lock_entries.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fix mm-add-and-use-find_lock_entries.patch

Link: https://lkml.kernel.org/r/20201124041507.28996-3-willy@infradead.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/filemap.c~mm-add-and-use-find_lock_entries-fix
+++ a/mm/filemap.c
@@ -1957,6 +1957,8 @@ unsigned find_lock_entries(struct addres
 				goto put;
 			if (page->mapping != mapping || PageWriteback(page))
 				goto unlock;
+			VM_BUG_ON_PAGE(!thp_contains(page, xas.xa_index),
+					page);
 		}
 		indices[pvec->nr] = xas.xa_index;
 		if (!pagevec_add(pvec, page))
_

Patches currently in -mm which might be from willy@infradead.org are

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

