Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED1AC433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E31864F38
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhBYTTo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhBYTRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8694F64F3F;
        Thu, 25 Feb 2021 19:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280337;
        bh=knwkXSXR3GX/rqsFOqIlxfLZm5Ye4/Hdq0KSKEE0nOU=;
        h=Date:From:To:Subject:From;
        b=xI5lHRLrFH+s/uD9lPVoK6nFJTsnJscdGRLXy2wntu36Pd3wRvSFgVTFvahbHO7K9
         9K0FJLZyj++fudkVhyLDbMcXC0SzTE+unoWik1BEfSEoMUaFccoh7KOAbv+Qmew5lt
         LNnPPCWj0BioT1aQ7+87bEAZ24L+/Xx49fQiMqHg=
Date:   Thu, 25 Feb 2021 11:12:17 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-debug-improve-memcg-debugging.patch removed
 from -mm tree
Message-ID: <20210225191217.epklGcwbv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: improve memcg debugging
has been removed from the -mm tree.  Its filename was
     mm-debug-improve-memcg-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: improve memcg debugging

The memcg_data is only valid on the head page, not the tail pages.  Change
the format and location of the printout within the dump to match the other
parts of struct page better.

Link: https://lkml.kernel.org/r/20210114190200.1894484-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/debug.c~mm-debug-improve-memcg-debugging
+++ a/mm/debug.c
@@ -110,6 +110,11 @@ void __dump_page(struct page *page, cons
 					head_compound_mapcount(head));
 		}
 	}
+
+#ifdef CONFIG_MEMCG
+	if (head->memcg_data)
+		pr_warn("memcg:%lx\n", head->memcg_data);
+#endif
 	if (PageKsm(page))
 		type = "ksm ";
 	else if (PageAnon(page))
@@ -180,11 +185,6 @@ hex_only:
 
 	if (reason)
 		pr_warn("page dumped because: %s\n", reason);
-
-#ifdef CONFIG_MEMCG
-	if (!page_poisoned && page->memcg_data)
-		pr_warn("pages's memcg:%lx\n", page->memcg_data);
-#endif
 }
 
 void dump_page(struct page *page, const char *reason)
_

Patches currently in -mm which might be from willy@infradead.org are

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

