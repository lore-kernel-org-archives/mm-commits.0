Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B228AC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D7E420791
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgLOCUX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgLOCUR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:20:17 -0500
Date:   Mon, 14 Dec 2020 18:19:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998776;
        bh=EAyBeMnyeyO4SCVuaxxyDsBeXMVPNWTz9vgPXa9IiCA=;
        h=From:To:Subject:From;
        b=uH1pHeHBh3dvRey8HrE/i+krCuYclCvnYd8lB/DoN7DshplFr+E5A8nVT9eITf2LP
         N/C/Vh/ylQBNh/A66s1MWFMUyF62OFwvTu5H7EHINWCxU0uIcBTJWCUpZRqvsP2o6+
         yROmwFDysTUmNfpG683w0bdZxD+uegLBzOtnDmR0=
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, jack@suse.cz, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  [folded-merged]
 mm-support-thps-in-zero_user_segments-fix.patch removed from -mm tree
Message-ID: <20201215021935.tolZbwJRf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-thps-in-zero_user_segments-fix
has been removed from the -mm tree.  Its filename was
     mm-support-thps-in-zero_user_segments-fix.patch

This patch was dropped because it was folded into mm-support-thps-in-zero_user_segments.patch

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-support-thps-in-zero_user_segments-fix

I didn't realise start1 was allowed to be less than start2.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/mm/highmem.c~mm-support-thps-in-zero_user_segments-fix
+++ a/mm/highmem.c
@@ -379,46 +379,39 @@ void zero_user_segments(struct page *pag
 	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
 
 	for (i = 0; i < compound_nr(page); i++) {
-		void *kaddr;
-		unsigned this_end;
+		void *kaddr = NULL;
 
-		if (end1 == 0 && start2 >= PAGE_SIZE) {
-			start2 -= PAGE_SIZE;
-			end2 -= PAGE_SIZE;
-			continue;
-		}
+		if (start1 < PAGE_SIZE || start2 < PAGE_SIZE)
+			kaddr = kmap_atomic(page + i);
 
 		if (start1 >= PAGE_SIZE) {
 			start1 -= PAGE_SIZE;
 			end1 -= PAGE_SIZE;
-			if (start2) {
-				start2 -= PAGE_SIZE;
-				end2 -= PAGE_SIZE;
-			}
-			continue;
-		}
-
-		kaddr = kmap_atomic(page + i);
+		} else {
+			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
 
-		this_end = min_t(unsigned, end1, PAGE_SIZE);
-		if (end1 > start1)
-			memset(kaddr + start1, 0, this_end - start1);
-		end1 -= this_end;
-		start1 = 0;
+			if (end1 > start1)
+				memset(kaddr + start1, 0, this_end - start1);
+			end1 -= this_end;
+			start1 = 0;
+		}
 
 		if (start2 >= PAGE_SIZE) {
 			start2 -= PAGE_SIZE;
 			end2 -= PAGE_SIZE;
 		} else {
-			this_end = min_t(unsigned, end2, PAGE_SIZE);
+			unsigned this_end = min_t(unsigned, end2, PAGE_SIZE);
+
 			if (end2 > start2)
 				memset(kaddr + start2, 0, this_end - start2);
 			end2 -= this_end;
 			start2 = 0;
 		}
 
-		kunmap_atomic(kaddr);
-		flush_dcache_page(page + i);
+		if (kaddr) {
+			kunmap_atomic(kaddr);
+			flush_dcache_page(page + i);
+		}
 
 		if (!end1 && !end2)
 			break;
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

