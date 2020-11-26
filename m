Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D96C56201
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A9020872
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ooKAWuwz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbgKZAFV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727315AbgKZAFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 19:05:21 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAADA206C0;
        Thu, 26 Nov 2020 00:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606349119;
        bh=4b5qsmg3PD/sOM3JZEsjaymhqh1JNwDBGyKquzSAeDM=;
        h=Date:From:To:Subject:From;
        b=ooKAWuwzHhUOGCyx6B0s+rdavmsbGvq/xlZhd18RVmkwqB9VBeyU8eDB7jN04j6Gs
         lwTpmIU3RspVRa3vcX3EQz6gFL7xX0nbJGzHKp9as2x8V0KBRwXiXFmxdN+p/SPvEF
         FDo8unl1wUuhNPyZ2jsHyXJsAnKPH3ODqMpkJ3qI=
Date:   Wed, 25 Nov 2020 16:05:18 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, jack@suse.cz, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-support-thps-in-zero_user_segments-fix.patch added
 to -mm tree
Message-ID: <20201126000518.UwwC6jSEH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject:  opcode: 0000 EIP: zero_user_segments]
has been added to the -mm tree.  Its filename is
     mm-support-thps-in-zero_user_segments-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-support-thps-in-zero_user_segments-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-support-thps-in-zero_user_segments-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject:  opcode: 0000 EIP: zero_user_segments]

I didn't realise start1 was allowed to be less than start2.

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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
mm-support-thps-in-zero_user_segments-fix.patch
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
mm-truncateshmem-handle-truncates-that-split-thps-fix.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

